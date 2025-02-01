{ modulesPath, config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lxc-blocky";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [53];
      allowedTCPPorts = [53];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    blocky
  ];

  services.blocky = {
    enable = true;
    settings = {
      ports.dns = 53;
      connectIPVersion = "v4";
      upstreams = {
        groups = {
          default = [
            "1.1.1.1"           # Cloudflare
            "208.67.222.222"    # OpenDNS
            "9.9.9.9"           # Quad9
            "8.8.8.8"           # Google
          ];
        };
        strategy = "parallel_best";
        timeout = "2s";
      };
      customDNS = {
        customTTL = "1h";
        filterUnmappedTypes = true;
        mapping = {
          "*.d35c.net " = "192.168.10.30";
        };
      };
      caching = {
        prefetching = true;
        prefetchExpires = "12h";
        prefetchThreshold = 2;
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