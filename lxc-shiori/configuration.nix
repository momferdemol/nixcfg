{ modulesPath, config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lxc-shiori";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    shiori
  ];

  services.openssh.enable = true;

  users.users.admin = {
    isNormalUser = true;
    description = "Administrator";
    password = "nopassword";
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
    webRoot = "/home/admin/shiori";
  };

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