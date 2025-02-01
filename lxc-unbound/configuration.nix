{ modulesPath, config, pkgs, ... }:

{
  imports = [
    "${modulesPath}/virtualisation/lxc-container.nix"
  ];

  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;

  networking = {
    hostName = "lxc-unbound";
    networkmanager = {
      enable = true;
    };
    firewall = {
      enable = true;
      allowedUDPPorts = [ 53 853 ];
      allowedTCPPorts = [ 53 853 ];
    };
  };

  time.timeZone = "Europe/Amsterdam";

  i18n.defaultLocale = "en_US.UTF-8";

  environment.systemPackages = with pkgs; [
    dig
    unbound
  ];

  services.unbound = {
    enable = true;
    settings = {
      server = {
        auto-trust-anchor-file = "/var/lib/unbound/root.key";
        qname-minimisation = true;
        interface = "0.0.0.0";
        access-control = "192.168.0.0/16 allow";
      };

      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "1.1.1.1@853#cloudflare-dns.com"
          ];
        }
      ];

      remote-control = {
        control-enable = false;
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