{ config, pkgs, inputs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/Nix/cfg";
  create_symlnk = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    ohmyposh = "ohmyposh";
    hypr = "hypr";
    kitty = "kitty";
    spicetify = "spicetify";
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

  home.packages = with pkgs; [
  ];

  programs.caelestia = {
    enable = true;
    systemd.enable = false;

    settings = {
      bar.status = {
        showBattery = true;
      };
      paths.wallpaperDir = "~/.Wallpapers";
    };
    cli = {
      enable = true; # Also add caelestia-cli to path
      settings = {
        theme.enableGtk = true;
      };
    };
  };

  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
      enable = true;

      enabledCustomApps = with spicePkgs.apps; [
        marketplace
      ];

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];

      theme = {
        name = "caelestia";
        src = .cfg/spicetify/Themes/caelestia;
        appendName = false;
      };
      colorScheme = "caelestia";

    };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlnk "${dotfiles}/${subpath}/";
      recursive = true;
    })
    configs;

  home.file.".zshrc".source = create_symlnk "${dotfiles}/.zshrc";
  home.file.".cfg/vscode/flags.conf".source = create_symlnk "${dotfiles}/vscode/flags.conf";
}
