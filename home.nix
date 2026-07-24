{ pkgs, ... }:

{
  home.username = "koma";
  home.homeDirectory = "/home/koma";
  home.stateVersion = "26.05";
  
  # copy configs
  home.file.".config/hypr/hyprland.lua".source = ./home/hypr/hyprland.lua;
  home.file.".config/waybar".source = ./home/waybar;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
