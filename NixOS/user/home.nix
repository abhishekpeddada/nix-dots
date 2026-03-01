{ config, lib, pkgs, userConfig, ... }:

{

  imports = [
    ./modules/nvim.nix
    ./modules/shell.nix
    ./modules/term.nix
    ./modules/theme.nix
    ./modules/tmux.nix
    ./modules/hypr/hyprland.nix
  ];

  # Home Manager needs a bit of info about paths it should manage.
  home = {
    username = userConfig.username;
    homeDirectory = "/home/"+userConfig.username;
    file.".config/sounds/error.mp3".source = ./sounds/error.mp3;
  };

  programs.fish.interactiveShellInit = ''
    function play_error_sound --on-event fish_postexec
      if test $status -ne 0
        mpv --no-video --really-quiet ~/.config/sounds/error.mp3 &
        disown
      end
    end
  '';
  
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
