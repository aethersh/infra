{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib)
    mkEnableOption
    mkIf
    mkOption
    optionalString
    types
    ;

  cfg = config.services.pathvector;

  configFormat = pkgs.formats.yaml { };
  configFile = configFormat.generate "pathvector.yml" cfg.config;

  # This contains a shared type for configuring peers that can be used for templates and peers
  sharedPeerConfigType = types.submodule {

    # --- Filtering options ---

    filter-transit-asns = mkOption {
      description = "Reject AS-PATHs containing transit-free ASNs";
      type = types.bool;
      default = false;
    };

    filter-irr = mkOption {
      description = "Reject IRR invalid routes";
      type = types.bool;
      default = false;
    };

    allow-local-as = mkOption {
      description = "Allow local ASNs";
      type = types.bool;
      default = false;
    };

    # --- BGP Communities ---
    remove-all-communities = mkOption {
      description = "Remove all standard and large communities beginning with this value";
      type = types.nullOr types.ints.unsigned;
      default = null;
    };

    announce = mkOption {
      description = "Announce all routes matching these communities to the peer";
      type = types.listOf types.strings;
      default = [ ];
    };

    add-on-import = mkOption {
      description = "List of communities to add to all imported routes";
      type = types.listOf types.strings;
      default = [ ];
    };

    add-on-export = mkOption {
      description = "List of communities to add to all exported routes";
      type = types.listOf types.strings;
      default = [ ];
    };

    # --- Assorted options ---

    local-pref = mkOption {
      description = "BGP Local preference";
      type = types.ints.unsigned;
      default = 100;
    };

    auto-as-set = mkOption {
      description = "Get AS-SET automatically from PeeringDB";
      type = types.bool;
      default = true;
    };

    # --- Route limits ---
    import-limit4 = mkOption {
      description = "Maximum number of IPv4 prefixes to import after filtering";
      type = types.ints.unsigned;
      default = 1000000;
    };

    import-limit6 = mkOption {
      description = "Maximum number of IPv6 prefixes to import after filtering";
      type = types.ints.unsigned;
      default = 1000000;
    };

    auto-import-limits = mkOption {
      description = "Get import limits automatically from PeeringDB";
      type = types.bool;
      default = false;
    };

    # --- enforce rules ---
    enforce-peer-nexthop = mkOption {
      description = "Only accept routes with a next hop equal to the configured neighbor address";
      type = types.bool;
      default = true;
    };

    enforce-first-as = mkOption {
      description = "Only accept routes who's first AS is equal to the configured peer address";
      type = types.bool;
      default = true;
    };
  };

in
{
  environment.systemPackages = with pkgs; [
    bgpq4
    bird
    pathvector
  ];

  # ------ OPTIONS ------
  options = {
    services.pathvector = {
      enable = mkEnableOption "pathvector";

      config = mkOption {
        description = ''
          Pathvector Configuration
        '';

        type = types.submodule {
          freeformType = configFormat.type;

          asn = mkOption {
            description = "Router ASN";
            type = types.ints.u16;
          };

          router-id = mkOption {
            description = "Router ID in dotted-quad notation";
            type = types.strings;
          };

          source4 = mkOption {
            description = "IPv4 source address";
            type = types.strings;
          };

          source6 = mkOption {
            description = "IPv6 source address";
            type = types.strings;
          };

          templates = mkOption {
            description = "List of templates to use";
            type = types.attrsOf sharedPeerConfigType;
          };

          peers = mkOption {
            description = "List of peers to configure";
            type = types.attrsOf (
              sharedPeerConfigType
              ++ (types.submodule {
                asn = mkOption {
                  description = "Peer ASN";
                  type = types.ints.u16;
                };
                template = mkOption {
                  description = "Template to use for this peer";
                  type = types.str;
                };
                neighbors = mkOption {
                  description = "List of neighbor addresses";
                  type = types.listOf types.str;
                };
              })
            );
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      bgpq4
      bird
      pathvector
    ];

    services.bird2 = {
      enable = true;
    };

    environment.etc."pathvector.yml".source = configFile;

    services.pathvector = {
      description = "Run pathvector and regenerate on config change";
      wantedBy = [ "multi-user.target" ];
      reloadTriggers = [ config.environment.etc."pathvector.yml".source ];
      requires = [ "bird2.service" ];
      serviceConfig = {
        Type = "forking";
        ExecStart = "${pkgs.pathvector}/bin/pathvector generate";
        ExecReload = "${pkgs.pathvector}/bin/pathvector generate";
      };
    };
  };
}
