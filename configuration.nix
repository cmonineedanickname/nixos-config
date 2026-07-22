{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" "udev.log_level=3" "rd.udev.log_level=3" ];
  boot.consoleLogLevel = 3; 

  networking.hostName = "nixoslaptop"; # Define your hostname.
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Vienna";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "de";

  security.polkit = {
    enable = true;
    extraConfig = ''
      polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.login1.reboot" ||
            action.id == "org.freedesktop.login1.power-off" ||
            action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
            action.id == "org.freedesktop.login1.power-off-multiple-sessions") &&
	    subject.isInGroup("wheel")) {
          return polkit.Result.YES;
        }
      });
    '';
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.libinput.enable = true;
  
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --cmd start-hyprland --time";
        user = "greeter";
      };
    };
  };

  users.users.koma = {
    isNormalUser = true;
    description = "Max";
    extraGroups = [ "wheel" ];
    shell = pkgs.bash;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.firefox.enable = true;
  programs.neovim.enable = true;
  programs.git.enable = true;
  programs.xfconf.enable = true;
  programs.starship.enable = true;
  programs.tmux.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  environment.systemPackages = with pkgs; [
    yazi
    rofi
    kitty
    cmake
    go
    gradle
    jdk
    rustup
    python3
    btop
    wget
    netcat
    nmap
    tree
    ripgrep
    bat
    fzf
    github-cli
    eza
    fd
    p7zip
    unzip
    zip
    mpv
  ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  system.stateVersion = "26.05";
}

