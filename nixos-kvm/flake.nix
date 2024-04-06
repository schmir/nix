{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-23.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixfmt.url = "github:NixOS/nixfmt";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixfmt,
      ...
    }@inputs:
    {
      # Please replace my-nixos with your hostname
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs.inputs = inputs;
        system = "x86_64-linux";
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./configuration.nix
        ];
      };
    };
}
