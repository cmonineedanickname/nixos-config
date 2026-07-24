{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "quiet" "loglevel=3" "udev.log_level=3" "rd.udev.log_level=3" ];
  boot.consoleLogLevel = 3; 

  networking.hostName = "nixoslaptop"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

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

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  hardware.graphics.enable = true;
  hardware.amdgpu.initrd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.fstrim.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true;
  services.libinput.enable = true;
  services.printing.enable = true;
  services.power-profiles-daemon.enable = true;
  services.thermald.enable = true;

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

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.koma = import ./home.nix;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  xdg.mime.enable = true;

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
  programs.waybar.enable = true;

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
    overskride
    mako
  ];

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    nerd-fonts.hack
  ];

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = true;

  system.stateVersion = "26.05";
}

