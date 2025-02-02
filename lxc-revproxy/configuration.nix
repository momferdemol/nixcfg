{ modulesPath, config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lxc-revproxy";
    useDHCP = false;
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "192.168.10.11";
          prefixLength = 32;
        }
      ];
    };

    defaultGateway = {
      address = "192.168.10.1";
      interface = "eth0";
    };

    nameservers = [
      "192.168.10.10"
    ];

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
    dig
    nginx
  ];

  services.nginx = {
    enable = true;
    user = "nginxProxy";
    group = "nginxProxy";
    virtualHosts.localhost = {
      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
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