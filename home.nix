{ config, pkgs, inputs, lib, ... }:
let
  dotfiles = "${config.home.homeDirectory}/Nix/cfg";
  create_symlnk = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    ohmyposh = "ohmyposh";
    hypr = "hypr";
    kitty = "kitty";
  };

  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "force_installed"; # This ensures it's always there
    };
  };
  prefs = {
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    "browser.tabs.drawInTitlebar" = true;
    "browser.uidensity" = 0;
    "extensions.autoDisableScopes" = 0;
  };
  extensions = [
    (extension "ublock-origin" "uBlock0@raymondhill.net")
    (extension "caelestiafox" "caelestiafox@caelestia.dev")
  ];
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

  };

  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  home.packages = [
    (pkgs.wrapFirefox inputs.zen-browser.packages.${pkgs.system}.zen-browser-unwrapped {
        extraPrefs = lib.concatLines (
          lib.mapAttrsToList (name: value: ''
            lockPref(${lib.strings.toJSON name}, ${lib.strings.toJSON value});
          '') prefs
        );

        extraPolicies = {
          DisableTelemetry = true;
          ExtensionSettings = builtins.listToAttrs extensions;

          SearchEngines = {
            Default = "Google";
            Add = [
              {
                Name = "Nix Packages";
                URLTemplate = "https://search.nixos.org/packages?query={searchTerms}";
                Alias = "@np";
              }
            ];
          };
        };
      })
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
        wallpaper.postHook = "kill -USR1 $(pgrep kitty)";
      };
    };
  };

  home.file.".config/caelestia/templates/kitty-colors.conf".source = create_symlnk "${dotfiles}/kitty/colors.conf";

  home.file.".mozilla/native-messaging-hosts/caelestiafox.json".text = builtins.toJSON {
    name = "caelestiafox";
    description = "Caelestia bridge";
    path = "${config.home.homeDirectory}/.local/lib/caelestia/caelestiafox";
    type = "stdio";
    allowed_extensions = [ "caelestiafox@caelestia.dev" ];
  };

  # 2. The Bridge Script (Symlink to your Nix config)
  home.file.".local/lib/caelestia/caelestiafox" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/Nix/cfg/zen/native_app/app.fish";
    executable = true;
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlnk "${dotfiles}/${subpath}/";
      recursive = true;
    })
    configs;

  programs.spicetify =
  let
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
      enable = true;

      enabledCustomApps = with spicePkgs.apps; [
      ];

      enabledExtensions = with spicePkgs.extensions; [
        adblock
        hidePodcasts
        shuffle
      ];

    };

  home.file.".zshrc".source = create_symlnk "${dotfiles}/.zshrc";
}
