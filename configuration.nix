{ config, lib, pkgs, pkgs-unstable, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Melchior";
  networking.networkmanager.enable = true;
  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  services.keyd.enable = true;
  environment.etc."keyd/default.conf".source = ./cfg/keyd.conf;

  boot.kernelParams = [ "nvidia-drm.modeset=1" ];
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    LIBVA_DRIVER_NAME = "nvidia";
  };

  services.openssh.enable = true;

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        mesa
        libglvnd
      ];
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;

      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true; # Lets you use `nvidia-offload %command%` in steam
        };
        # sync.enable = true;
        intelBusId = "PCI:0:2:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
  };

  # Enable RealtimeKit for audio purposes
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # Uncomment the following line if you want to use JACK applications
    # jack.enable = true;
  };

  services.blueman.enable = true;
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = false;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
  };

  networking.firewall.allowedUDPPorts = [ 53 67 ];


  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  services.dbus.enable = true;
  security.polkit.enable = true;
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true; # Allows resolving .local addresses
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  services.libinput.enable = true;
  services.xserver = {
    enable = true;

    xkb.layout = "us";

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    windowManager.qtile.enable = true;
    videoDrivers = [ "nvidia" ];
  };

  users.users.dev = {
    isNormalUser = true;
    extraGroups = [ "wheel" "dialout" "tty" ];
    shell = pkgs.zsh;
  };

  programs.hyprland = {
    enable = true;
    package = pkgs-unstable.hyprland;
  };
  services.greetd = {
    enable = true;

    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet \
          --time \
          --remember \
          --cmd Hyprland";
        user = "greeter";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;
  programs.zsh.enable = true;
  programs.firefox.enable = true;


  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.gamemode.enable = true;

  programs.nix-ld.enable = true;

  # Enable GVFS for mounting support
  services.gvfs.enable = true;

  # Enable Thunar and required plugins
  programs.thunar.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
    thunar-volman
    thunar-archive-plugin
    tumbler
  ];

  # Ensure settings can be saved
  programs.xfconf.enable = true;

  # Thumbnails
  services.tumbler.enable = true;


  environment.systemPackages = with pkgs; [

    # caelestia
    brightnessctl
    ddcutil
    playerctl
    lm_sensors
    fish
    inotify-tools
    jq
    bash
    swappy
    libqalculate
    cava
    wl-clipboard
    grim
    slurp
    fuzzel
    app2unit
    hyprpicker

    # applications
    vivaldi
    libreoffice
    google-chrome
    pkgs-unstable.vscode
    ffmpeg-full
    spotify
    calibre
    tor-browser
    gnome-autoar # Helps with automatic archive extraction
    file-roller  # Highly recommended for Thunar integration
    p7zip
    unzip
    zip
    obsidian
    uv
    pkgs-unstable.code-cursor-fhs
    popsicle
    discord

    dolphin-emu

    rpi-imager
    polkit_gnome
    nmap
    unixtools.ifconfig

    pavucontrol
    arduino-cli

    # zsh
    kitty
    oh-my-posh
    fzf
    zoxide
    xclip
    tree
    git
    wget

    # steam
    mangohud
    protonup-qt
    lutris
    bottles

    libGL
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    xorg.libxcb
    xorg.libXcursor
    xorg.libXi
    xorg.libXfixes

    alsa-lib
    libpulseaudio
    glib
  ];

  fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      material-symbols
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "25.11";

}

