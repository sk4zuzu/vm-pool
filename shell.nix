{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "vm-pool-env";
  buildInputs = [
    cdrkit cloud-utils curl
    git
    libxslt
    unzip
  ];
}
