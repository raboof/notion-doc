{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  buildInputs = [
    pkgs.gnumake
    pkgs.lua
    pkgs.pkgconfig
    pkgs.rubber
    pkgs.tetex
    pkgs.latex2html
  ];
}
