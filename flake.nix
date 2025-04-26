{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.92.0-3.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, lix-module, ... }@inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { 
          inherit nixpkgs;
          inherit system;
        };
        modules = [
          ./configuration.nix
          #lix-module.nixosModules.default
          nixos-hardware.nixosModules.dell-xps-13-9380
        ];
      };
    };
  };
}
