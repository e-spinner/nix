{ config, pkgs, ... }:


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

  home.file.".zshrc".source = config.lib.file.mkOutOfStoreSymlink "/home/dev/nix/config/.zshrc";
}
