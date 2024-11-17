# nix home manager config

Install nix

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Enable flake:

```shell
mkdir -p ~/.config/nix; echo 'experimental-features = nix-command flakes' |tee -a ~/.config/nix/nix.conf
```

Bootstrap without checkout:

```shell
nix run --no-write-lock-file github:nix-community/home-manager/ -- --flake "github:schmir/nix/#cirrus" switch
```
