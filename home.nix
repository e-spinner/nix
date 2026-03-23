{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/Nix/config";
  create_symlnk = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    alacritty = "alacritty";
    ohmyposh = "ohmyposh";
    hypr = "hypr";
    kitty = "kitty";
    waybar = "waybar";
    rofi = "rofi";
    dunst = "dunst";
    "pavucontrol.ini" = "pavucontrol.ini";
    networkmanager-dmenu = "networkmanager-dmenu";
  };

  gtkTheme = "catppuccin-mocha-green-standard";
  iconTheme = "Tela-circle-green";

in

{
  home.username = "dev";
  home.homeDirectory = "/home/dev";
  home.stateVersion = "25.11";

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "e-spinner";
        email = "e-spinner@onu.edu";
      };
    };
  };

  home.sessionVariables = {
    GTK_THEME = "${gtkTheme}+default";
    GTK_ICON_THEME = iconTheme;
  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  gtk = {
    enable = true;

    theme = {
      package = pkgs.catppuccin-gtk;
      name = gtkTheme;
    };

    iconTheme = {
      package = pkgs.tela-circle-icon-theme;
      name = iconTheme;
    };

    font = {
      name = "jetbrains-mono";
      size = 11;
    };
  };

  home.packages = with pkgs; [

  ];

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlnk "${dotfiles}/${subpath}/";
      recursive = true;
    })
    configs;

  home.file.".zshrc".source = create_symlnk "${dotfiles}/.zshrc";
  # home.file."pavucontrol.ini".source = create_symlnk "${dotfiles}/pavucontrol.ini";
}
