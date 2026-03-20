{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nix/config";
  create_symlnk = path: config.lib.file.mkOutOfStoreSymlink path;
  configs = {
    alacritty = "alacritty";
    ohmyposh = "ohmyposh";
  };
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

  home.packages = with pkgs; [

  ];

  xdg.configFile = builtins.mapAttrs 
    (name: subpath: {
      source = create_symlnk "${dotfiles}/${subpath}/";
      recursive = true;
    }) 
    configs;

  home.file.".zshrc".source = create_symlnk "${dotfiles}/.zshrc";
}
