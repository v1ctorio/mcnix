{ config, pkgs, ... }:

{
  home.username = username;
  home.homeDirectory = username;

  # link the configuration file in current directory to the specified location in home directory
  home.file."wallpapers/wallpaper.jpg".source = ../assets/wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  #: '';

  
  home.activation = {
    writePrismConfig = let
      prismLauncherDir = "${config.home.homeDirectory}/.local/share/PrismLauncher";
      #prismAccounts = (builtins.readFile ../assets/prism/accounts.json);
      prismAccounts = substituteAll {
        src=../assets/prism/accounts.json;
        inherit username;
        id = mcuid;
        inherit iat;
        inherit clientToken;
      };
    in ''
      rm -f ${prismLauncherDir}/accounts.json
      echo "Copying prism/accounts.json to ${prismLauncherDir}/accounts.json"
      echo ${prismAccounts} > ${prismLauncherDir}/accounts.json
    ''
  }


  home.packages = with pkgs; [

    neofetch
    nnn 

    zip
    xz
    unzip

    file
    which

    glow 
    btop
    usbutils

    feh 
    prismlauncher
  ];

  programs.git = {
    enable = true;
  };


  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
    '';

  };

  # This value determines the home Manager release that your
  home.stateVersion = "24.05";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
