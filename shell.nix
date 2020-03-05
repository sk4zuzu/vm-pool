{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "vm-pool-env";
  buildInputs = [
    git
    libvirt libxslt
    gnumake
    go gcc
    cdrkit cloud-utils
  ];
}

# vim:ts=2:sw=2:et:syn=nix:
