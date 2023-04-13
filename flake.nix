{
  description = "Run Windows Applications on Linux as if they are native, Use linux applications to launch files files located in windows vm without needing to install applications on vm.";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs [
      "x86_64-linux"
    ];
    pkgsFor = nixpkgs.legacyPackages;
  in {
    overlays.default = _: prev: rec {
      cassowary = let
        setup-cfg = builtins.readFile ./app-linux/setup.cfg;
      in prev.callPackage ./default.nix {
        version = "0.6.1";
        # version = builtins.match "version = (.+)" setup-cfg;
      };
    };
    packages = genSystems (system:
      (self.overlays.default null pkgsFor.${system})
      // {
        default = self.packages.${system}.cassowary;
      });
  };

  nixConfig = {
    extra-substituters = ["https://ataraxiadev-foss.cachix.org"];
    extra-trusted-public-keys = ["ataraxiadev-foss.cachix.org-1:ws/jmPRUF5R8TkirnV1b525lP9F/uTBsz2KraV61058="];
  };
}