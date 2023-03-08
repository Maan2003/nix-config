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
  programs.firefox = {
    enable = false; # TODO: figure out legacy fox
  };
  home.packages = with pkgs; [
    # gui
    feh
    (nixGlWrap alacritty)
    (nixGlWrap sioyek)
    (nixGlWrap chromium)
    (nixGlWrap mpv)

    # fonts
    agave
    roboto-mono
  ];
}
