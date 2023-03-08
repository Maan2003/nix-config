{ config, pkgs, lib, ... }:
let
  nixgl = pkgs.nixgl;
  nixGlWrap = pkg:
    pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "exec ${
         lib.getExe nixgl.packages."x86_64-linux".nixGLIntel
       } $bin \$@" > $wrapped_bin
       chmod +x $wrapped_bin
      done
    '';
in {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # gui
    feh
    (nixGlWrap sioyek)
    (nixGlWrap chromium)
    (nixGlWrap mpv)

    # fonts
    agave
    roboto-mono
  ];
  programs.firefox = {
    enable = false; # TODO: figure out legacy fox
  };
  programs.alacritty = {
    enable = true;
    package = (nixGlWrap pkgs.alacritty);
    settings = {
      font = {
        size = 12;
        normal.family = "Roboto Mono";
      };
      shell = "tmux";
      colors = {
        primary = {
          foreground = "#BBBBBB";
          background = "#191919";
        };
        cursor = {
          cursor = "#C9C9C9";
          text = "#191919";
        };
        normal = {
          black = "#191919";
          red = "#DE6E7C";
          green = "#819B69";
          yellow = "#B77E64";
          blue = "#6099C0";
          magenta = "#B279A7";
          cyan = "#66A5AD";
          white = "#BBBBBB";
        };
        bright = {
          black = "#3D3839";
          red = "#E8838F";
          green = "#8BAE68";
          yellow = "#D68C67";
          blue = "#61ABDA";
          magenta = "#CF86C1";
          cyan = "#65B8C1";
          white = "#8E8E8E";
        };
      };
    };
  };
}
