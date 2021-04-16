{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.bosh
    pkgs.credhub
    pkgs.jq
  ];
}
