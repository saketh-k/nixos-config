{config, pkgs,lib,...}:

{
  services.minecraft-servers = {
    enable = lib.mkDefault false;
    eula = true;
    servers.vanilla = {
      enable = true;
    };
  };
}

