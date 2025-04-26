# Edit this configuration file to define what should be installed on 
# your system.  Help is available in the configuration.nix(5) man page 
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib,... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true; 
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "laptop"; # Define your hostname.
  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];
  # networking.wireless.enable = true; # Enables wireless support via 
  # wpa_supplicant.


  # Configure network proxy if necessary networking.proxy.default = 
  # "http://user:password@proxy:port/"; networking.proxy.noProxy = 
  # "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  systemd.network.wait-online.enable = false;
  boot.initrd.systemd.network.wait-online.enable = false;

  # Set your time zone.
  time.timeZone = "America/Los_Angeles";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = { LC_ADDRESS = "en_US.UTF-8"; 
    LC_IDENTIFICATION = "en_US.UTF-8"; LC_MEASUREMENT = "en_US.UTF-8"; 
    LC_MONETARY = "en_US.UTF-8"; LC_NAME = "en_US.UTF-8"; LC_NUMERIC = 
    "en_US.UTF-8"; LC_PAPER = "en_US.UTF-8"; LC_TELEPHONE = 
    "en_US.UTF-8"; LC_TIME = "en_US.UTF-8";
  };

  #Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes"];

  # Distributed Builds settings = true;
  nix.distributedBuilds = true;
  nix.extraOptions = ''
    builders-use-substitutes = true
    '';
  nix.buildMachines = [
    # {
    #   hostName = "durga.saketh.dev";
    #   system = "x86_64-linux";
    #   protocol = "ssh-ng";
    #   sshUser = "root";
    #   sshKey = "/home/saketh/.ssh/id_ed25519";
    #   maxJobs = 32;
    #   speedFactor = 2;
    #   supportedFeatures = [  "benchmark" "big-parallel" "kvm" "nixos-test" ];
    #   publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSVBkZ0VGYWxRUVBEd2Focy85bmlMVDlRRnpiQmVrMmsvQzc3NkY4bmpxUzAgcm9vdEBuaXhvcwo=";
    # }
    {
      hostName = "100.69.224.31";
      system = "x86_64-linux";
      protocol = "ssh-ng";
      sshUser = "remotebuild";
      sshKey = "/root/.ssh/remotebuild";
      maxJobs = 32;
      speedFactor = 2;
      supportedFeatures = [  "benchmark" "big-parallel" "kvm" "nixos-test" ];
      publicHostKey = "bIqsh3BoaFdNdizKcjlYbbz18S6mB5FdXw3gohXqcfI";
    }
  ];
  nix.settings = {
    builders-use-substitutes = true;
  };

  programs.ssh.extraConfig = ''
  Host durga
    HostName durga.saketh.dev
    User root
    Port 22
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519
  '';

  # enable resovled
  services.resolved = {
    enable = true;
    dnssec = "false";
    domains = [ "~." ];
    fallbackDns =  [ "1.1.1.1" "1.0.0.1" ];
    dnsovertls = "false";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true; 
  services.xserver.desktopManager.gnome.enable = true;

  #Enable gnome secrets vault
  services.gnome.gnome-keyring.enable = true;

  # fonts
  fonts.packages = with pkgs; [
    liberation_ttf
    fira-mono
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # Configure keymap in X11
  services.xserver.xkb = { 
    model = "dell"; 
    layout = "us";
    options = "ctrl:nocaps";
    #extraLayouts.hjkl_arr = {
    #  description = "hjkl as arrow keys";
    #  languages = [ "eng" ];
    #  symbolsFile = /etc/nixos/symbols/hjkl_arr;
  };

  # Set kmonad keymap with out of store symlink
  hardware.uinput.enable = true;
  systemd.services.kmonad = {
    description = "Kmonad";
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.kmonad}/bin/kmonad /etc/kmonad/config.kbd";
      Restart = "always";
    };
  };
  #services.kmonad = {
  #  enable = true;
  #  keyboards = {
  #      builtin = {
  #        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
  #        # Make config file /home/saketh/sys-config/builtin.kbd;
  #        config = "/etc/kmonad/config.kbd";
  #      };
  #  };
  #	
  #};

  # Enable virtualisation
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable=true;
      setSocketVariable=true;
    };
    daemon.settings = { 
      dns=["1.1.1.1" "8.8.8.8"];
    };
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  #enable thunderbolt
  services.hardware.bolt.enable=true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false; security.rtkit.enable = true; 
  services.pipewire = {
    enable = true; alsa.enable = true; alsa.support32Bit = true; 
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this jack.enable = 
    #true;

    # use the example session manager (no others are packaged yet so 
    # this is enabled by default, no need to redefine it in your config 
    # for now)
    #media-session.enable = true;
  };

  security.pam.services.swaylock = {};
  security.polkit.enable=true;
  services.blueman.enable = true;
  
  # enable redshift to manage screen color
  location = {
    provider = "manual";
    latitude = 33.684;
    longitude = -117.82;
  };
  services.redshift = {
    enable = true;
    brightness = {
      day = "1";
      night = "0.3";
    };
    temperature = {
      day = 5500;
      night = 3700;
    };
  };

  # Allow non-sudoers to edit light command
  # see this link to see if this is actually necessary https://github.com/NixOS/nixpkgs/commit/5e329241e8b5c25e17e3a852323890d25cd271d9
  #   services.udev.extraRules = ''
  #   KERNEL=="backlight", SUBSYSTEM=="backlight", ACTION=="add", \
  #   RUN+="${pkgs.coreutils}/bin/chgrp users /sys/class/backlight/intel_backlight/brightness", \
  #   RUN+="${pkgs.coreutils}/bin/chmod 666 /sys/class/backlight/intel_backlight/brightness"
  # '';
  # services.udev.extraRules = ''
  #	KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  #  '';

  # Enable Tailscale
  services.tailscale.enable=true;

  # Enable touchpad support (enabled default in most desktopManager). 
  # services.xserver.libinput.enable = true;

  # create video group for light
  users.groups.video = {};
  users.groups.input = {};
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.saketh = { isNormalUser = true; description = "Saketh k"; 
    extraGroups = [ "dialout" "networkmanager" "wheel" "video" "docker" "input" "uinput"]; packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Allow "wheel" group to be trusted-users:
  security.sudo.wheelNeedsPassword = false;
  nix.settings.trusted-users = [ "@wheel" ];

  # Install firefox.
  programs.firefox.enable = true;

  #enable backlight
  programs.light.enable=true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = _:true;

  # List packages installed in system profile. To search, run: $ nix 
  # search wget
  environment.systemPackages = with pkgs; [
  vim # Do not forget to add an editor to edit configuration.nix! The 
  #  Nano editor is also installed by default. wget
  grim
  slurp
  wget
  wl-clipboard
  pulseaudio
  libnotify
  light
  brightnessctl
  xorg.xmodmap
  fprintd
  wine
  (lutris.override {
    extraPkgs = pkgs: [
      wine
    ];
  })
  kmonad
  ];

  programs.steam.enable = true;

  # Some programs need SUID wrappers, can be configured further or are 
  # started in user sessions. programs.mtr.enable = true; 
  # programs.gnupg.agent = {
  #   enable = true; enableSSHSupport = true;
  # };

  # List services that you want to enable:
  

  # Enable fprintd service:
  services.fprintd = {
    enable = true;
  };
  # Enable swaywm
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  
  };
  # Enable the OpenSSH daemon. 
  services.openssh.enable = true;
  

  # Open ports in the firewall. networking.firewall.allowedTCPPorts = [ 
  # ... ]; networking.firewall.allowedUDPPorts = [ ... ]; Or disable the 
  # firewall altogether. networking.firewall.enable = false;

  # This value determines the NixOS release from which the default 
  # settings for stateful data, like file locations and database 
  # versions on your system were taken. It‘s perfectly fine and 
  # recommended to leave this value at the release version of the first 
  # install of this system. Before changing this value read the 
  # documentation for this option (e.g. man configuration.nix or on 
  # https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
