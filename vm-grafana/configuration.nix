{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "vm-grafana";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = false;
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.admin = {
    isNormalUser = true;
    description = "Administrator";
    extraGroups = [ "wheel" "networkmanager"];
    home = "/home/admin";
    shell = pkgs.zsh;
  };

  programs = {
    zsh.enable = true;
  };

  environment.systemPackages = with pkgs; [
    cifs-utils
    grafana
    nginx
  ];

  services.openssh = {
    enable = true;
  };

  services.grafana = {
    enable = true;
    settings = {
      server = {
        http_addr = "127.0.0.1";
        http_port = 3000;
        domain = "grafana.local";
      };
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts.${config.services.grafana.settings.server.domain} = {
      locations."/" = {
        proxyPass = "http://${toString config.services.grafana.settings.server.http_addr}:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  system = {
    copySystemConfiguration = true;
    stateVersion = "24.05";
  };

}