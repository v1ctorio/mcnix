{ config, pkgs, ... }:
let 
  configs = ../configs.nix;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  users.users."${configs.username}" = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    home = "/home/${configs.username}";
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
    consoleKeyMap = "${configs.keyboardLayout}";
    defaultLocale = "${configs.locale}";
  };

  hardware.opengl.driSupport32Bit = true;
  hardware.pulseaudio.enable = true;
  services.  services = {
    xserver = {
      enable = true;
      libinput.enable = true;
      
      # only if nvidia is true
      videoDrivers = lib.mkIf configs.nvidia [ "nvidia" ];

      layout = "${configs.keyboardLayout}";

      displayManager.sddm = {
        enable = true;
      };

      # only if autologin is true
      displayManager.autologin = {
        enable = true;
        user = "${configs.username}";
      };

      windowManager.i3 = {
        enable = true;
        # i3 configuration is in home-manager
      }
    };


    pipewire = {
      enable = true;  
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    }; 


  };

  
  
  nix.settings.auto-optimize-store = true;
}
