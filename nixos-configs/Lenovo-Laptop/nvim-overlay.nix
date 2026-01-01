{
  nixpkgs.config = {
    packageOverrides = pkgs: let
      pkgs' = import <nixpkgs-unstable> {
        inherit (pkgs) system;
        overlays = [
          (import (builtins.fetchTarball {
            url = "https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz";
          }))
        ];
      };
    in {
      inherit (pkgs') neovim;
    };
  };
}
