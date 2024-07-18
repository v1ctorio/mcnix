{ config, pkgs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/${username}";
    shell = "${pkgs.zsh}/bin/zsh";
    };
  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
  };

  i18n = {
    consoleKeyMap = "${keyboardLayout}";
    defaultLocale = "${locale}";
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  services.pipewire = {
    enable = true;  
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  }
  
  services.xserver.libinput.enable = true;
  
  nix.settings.auto-optimize-store = true;
}
