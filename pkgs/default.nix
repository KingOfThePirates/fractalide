let
  pkgs = import <nixpkgs>;
  rustOverlay = (pkgs {}).fetchFromGitHub {
    owner  = "mozilla";
    repo   = "nixpkgs-mozilla";
    rev    = "7e54fb37cd177e6d83e4e2b7d3e3b03bd6de0e0f";
    sha256 = "1shz56l19kgk05p2xvhb7jg1whhfjix6njx1q4rvrc5p1lvyvizd";
  };
in (pkgs {
  overlays = [
    (import (builtins.toPath "${rustOverlay}/rust-overlay.nix"))
    (self: super: rec {
      rust = with super.rustChannels; {
        rustc = nightly.rust;
        inherit (nightly) cargo;
      };
      rustPlatform = super.recurseIntoAttrs (super.makeRustPlatform rust);
    })
  ];
})
