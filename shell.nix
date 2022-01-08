{ pkgs ? import <nixpkgs> {} }:

with pkgs;

stdenv.mkDerivation {
  name = "vm-pool-env";
  buildInputs = [
    curl unzip
    git
    cdrkit cloud-utils
  ];
}
