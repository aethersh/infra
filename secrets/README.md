# Secrets

Secrets here are managed using agenix - or more accurately, an agenix clone in Rust.

### Prerequisites

Have the `agenix` command installed, [as supplied by ragenix](https://github.com/yaxitech/ragenix?tab=readme-ov-file#usage):

```sh
nix profile install github:yaxitech/ragenix
```

*Yeah i know using profiles like this is cringe but this is just how i did it so *🤷‍♂️

**ALSO!**

When adding/editing/rekeying secrets, make sure you're in this secrets directory.

## How To's

### Adding a secret

1. In `secrets.nix`: define a `.age` file with the pubkeys that are allowed to decrypt it:

```nix
   "mysecret.age" = pete ++ admins
```

2. Run `agenix -e mysecret.age` and add whatever should be in there
3. Reference the secret in the config of whatever system(s) are allowed to access it. In this case, pete:

```nix
  age.secrets.mysecret.file = ../../secrets/mysecret.age;
```

4. Use the secret!

```nix
{config, ...}:{
# .path is the path to the decrypted secret file. could be treated as a .env file, or read in as part of a command, or whatever
environmentFileExample = config.age.secrets.mysecret.path
}
```

### Editing a secret

1. Make sure your private key is present in your home .ssh directory as `id_ed25519` or pass the path to your key using the `-i` argument
2. Run `agenix -e mysecret.age`

### Rekeying secrets

1. Update the users/systems who are allowed to access the secret in `secrets.nix`
2. Make sure your private key is present in your home .ssh directory as `id_ed25519` or pass the path to your key using the `-i` argument
3. Run `agenix -r mysecret.age`
4. Add/remove references to the secret in system configs as needed
