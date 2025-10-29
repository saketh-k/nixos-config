{ config, pkgs, lib, inputs,... }:

{
  imports = [
    ./minecraft.nix
    ./spacenav-fix.nix
  ];
  services.copyparty = {
    enable = lib.mkDefault false;
    settings = {
      i = "100.84.167.64";
      volumes = {
        "/" = {
          path = "/home/saketh";
          access =  {
            r = "*";
          };
      };
      };
      };
    };

  services.jellyfin = {
    enable = lib.mkDefault false;
    openFirewall = true;
    user = "saketh";
  };

  services.immich = {
    enable = lib.mkDefault false;
    port = 2283; #make this some how a variable??
    accelerationDevices = null;

  };
  users.users.immich.extraGroups = ["video" "render"];

  services.mullvad-vpn = {
    enable = lib.mkDefault false;
  };

  services.ollama = {
    enable = lib.mkDefault false;
  };

  services.nginx = {
    enable = lib.mkDefault false;
    
  };
}
