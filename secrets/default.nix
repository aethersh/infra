{ ... }:
{
  # All machines should be able to access each other's public keys (and admin pubkeys)
  age.secrets = {
    wgautomeshGossipKey.file = ./wgautomeshGossipKey.age;

    bayWgPubkey.file = ./bayWgPubkey.age;
    peteWgPubkey.file = ./peteWgPubkey.age;
    # novaWgPubkey.file = ./novaWgPubkey.age;
    falaiseWgPubkey.file = ./falaiseWgPubkey.age;
    mapleWgPubkey.file = ./mapleWgPubkey.age;
    strudelWgPubkey.file = ./strudelWgPubkey.age;
    tulipWgPubkey.file = ./tulipWgPubkey.age;
    yeehawWgPubkey.file = ./yeehawWgPubkey.age;

    henrikWgPubkey.file = ./henrikWgPubkey.age;
    # tibsWgPubkey.file = ./tibsWgPubkey.age;
  };
}
