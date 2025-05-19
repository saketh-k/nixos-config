{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      fw-laptop = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = { 
          inherit nixpkgs;
          inherit system;
        };
        modules = [
          ./configuration.nix
          nixos-hardware.nixosModules.dell-xps-13-9380
          nixos-hardware.nixosModules.framework-amd-ai-300-series
        ];
      };
    };
  };
}
