{ modulesPath, config, pkgs, ... }:
 
  let
  hostname = "lxc-shiori";
  user = "admin";

  timeZone = "Europe/Amsterdam";
  defaultLocale = "en_US.UTF-8";

in {
  imports = [
    # Include the default lxc/lxd configuration.
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = hostname;
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
    };
  };

  environment.systemPackages = with pkgs; [
    shiori
  ];

  services.openssh.enable = true;

  time.timeZone = timeZone;

  i18n = {
    defaultLocale = defaultLocale;
    extraLocaleSettings = {
      LC_ADDRESS = defaultLocale;
      LC_IDENTIFICATION = defaultLocale;
      LC_MEASUREMENT = defaultLocale;
      LC_MONETARY = defaultLocale;
      LC_NAME = defaultLocale;
      LC_NUMERIC = defaultLocale;
      LC_PAPER = defaultLocale;
      LC_TELEPHONE = defaultLocale;
      LC_TIME = defaultLocale;
    };
  };

  users.users."${user}" = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "wheel" "networkmanager"];
    home = "/home/admin";
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
  };

  services.shiori = {
    enable = true;
    port = 8080;
    address = "127.0.0.1";
  };

  # Enable passwordless sudo.
  security.sudo.extraRules = [
    {
      users = [user];
      commands = [
        {
          command = "ALL";
          options = ["NOPASSWD"];
        }
      ];
    }
  ];

  # Supress systemd units that don't work because of LXC.
  # https://blog.xirion.net/posts/nixos-proxmox-lxc/#configurationnix-tweak
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "24.05";
}