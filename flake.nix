{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    copyparty = {
      url = "github:9001/copyparty";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
  };

  outputs = { self, nixpkgs, nixos-hardware, copyparty, nix-minecraft,... }@inputs: {
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
          copyparty.nixosModules.default
          nix-minecraft.nixosModules.minecraft-servers
          ({pkgs,...}:{
            nixpkgs.overlays = [ copyparty.overlays.default nix-minecraft.overlay];
            environment.systemPackages = [pkgs.copyparty];
            # services.copyparty.enable = false;
          })
        ];
      };
    };
  };
}
