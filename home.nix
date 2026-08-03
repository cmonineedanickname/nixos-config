{ pkgs, inputs, ... }:

{
  imports = [
    inputs.zen-browser.homeModules.default
  ];

  programs.zen-browser = {
    enable = true;
    setAsDefaultBrowser = true;
  };

  home.username = "koma";
  home.homeDirectory = "/home/koma";
  home.stateVersion = "26.05";

  # GTK theming (safe defaults)
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  # Qt theming with Kvantum (built-in themes only)
  qt = {
    enable = true;
    platformTheme.name = "kvantum";
    style.name = "kvantum";
    kvantum = {
      enable = true;
      settings.General.theme = "KvAnt-Dark";
    };
  };

  # Dark mode for GTK4/libadwaita apps
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  # Cursor for Hyprland/XDG
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
  };

  # copy configs
  home.file.".config/hypr/hyprland.lua".source = ./home/hypr/hyprland.lua;
  home.file.".config/waybar".source = ./home/waybar;
  home.file.".config/starship.toml".source = ./home/starship.toml;

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };
}
