{ config, lib, pkgs, systemConfig, ... }:

{
  # kernel
  boot.kernelPackages = pkgs.linuxPackages;

  # magic-key
  boot.kernel.sysctl = {
    "kernel.sysrq" = 176;
  };

  # bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    timeout = 3;
  };

  # bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  # networking
  networking = {
    hostName = systemConfig.hostname;
    networkmanager = {
      enable = true;
      wifi.macAddress = "random";
      wifi.backend = "iwd";
      dns = lib.mkForce "none"; # Let systemd-resolved handle DNS
    };

    # network firewall
    firewall = {
      enable = true;
      # Open ports in the firewall.
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };

    # manual config
    extraHosts = ''
      185.199.111.133 raw.githubusercontent.com
    '';
    
  };

  services.resolved = {
    enable = true;
    settings = lib.mkForce {
      Resolve = {
        DNS = "94.140.14.14#dns.adguard.com 94.140.15.15#dns.adguard.com";
        DNSSEC = "true";
        DNSOverTLS = "yes";
        Domains = "~.";
        UseDomains = "no";
      };
    };
  };

  # timezone.
  time = {
    timeZone = systemConfig.timezone;
    hardwareClockInLocalTime = true;
  };

  # locale
  i18n.defaultLocale = systemConfig.locale;

  # configure keymap
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # zram
  zramSwap = {
    enable = true;
    memoryPercent = 50;
    priority = 100;
    algorithm = "lz4";
  };

  # pkgs
  environment.systemPackages = with pkgs; [ util-linux ];
}
