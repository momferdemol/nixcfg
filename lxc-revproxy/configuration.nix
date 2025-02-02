{ modulesPath, config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lxc-revproxy";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ 80 443 ];
      allowedTCPPorts = [ 80 443 ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    users = {
      nginxProxy = {
        home = "/var/lib/nginxProxy";
        createHome = true;
        isSystemUser = true;
        group = "nginxProxy";
      };
    };

    groups = {
      nginxProxy = {
        members = [ "nginxProxy" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    nginx
    certbot
  ];

  services.nginx = {
    enable = true;
    user = "nginxProxy";
    group = "nginxProxy";
    recommendedProxySettings = true;
    virtualHosts."media" = {
      listen = [
        {
          addr = "media.lan.d35c.net";
        }
      ];
      locations."/" = {
        proxyPass = "http://192.168.10.23:8096";
      };
    };
  };

  # supress systemd units that don't work because of LXC
  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  system.stateVersion = "24.05";
}