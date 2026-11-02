# nix home manager config

Install nix

```shell
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Enable flake:

```shell
mkdir -p ~/.config/nix; echo 'experimental-features = nix-command flakes' |tee -a ~/.config/nix/nix.conf
```

Bootstrap without checkout, replacing `user` with the configuration you need:
`ralf`, or `user`, `user-clojure` or `user-work` in a Qubes OS qube. This needs
an SSH key with read access to `git@github.com:schmir/fonts.git`. `-b backup`
renames existing files that would be replaced to `*.backup`:

```shell
nix run --no-write-lock-file github:nix-community/home-manager/ -- switch -b backup --flake "github:schmir/nix#user"
```

Log out and back in to load the new environment. `home-manager` is installed by
the configuration, so later updates only need:

```shell
home-manager switch --flake "github:schmir/nix#user"
```
