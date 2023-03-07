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
  nixpkgs.overlays = [
    (self: super: {
      clang = super.clang.overrideAttrs
        (oldAttrs: rec { meta = oldAttrs.meta // { priority = 15; }; });
    })
  ];
  xresources.properties = { "Xft.dpi" = 125; };
  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    package = pkgs.nordzy-cursor-theme;
    name = "Nordzy-cursors";
    size = 48;
  };
  xsession = {
    enable = true;
    scriptPath = ".xsession-hm";
    windowManager.command = "i3";
    importedVariables = [ "XCURSOR_PATH" ];
  };
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
  };
  programs.firefox = {
    enable = false; # TODO: figure out legacy fox
  };
  services.redshift = {
    enable = true;
    temperature.day = 4500;
    temperature.night = 4500;
    duskTime = "18:35-20:15";
    dawnTime = "6:00-7:45";
  };
  programs.git = {
    enable = true;
    userName = "Maan2003";
    userEmail = "manmeetmann2003@gmail.com";

    # signing
    extraConfig = {
      gpg.format = "ssh";
      user.signingKey = "~/.ssh/id_ed25519.pub";
      commit.gpgsign = true;
    };
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # C++
    cmake
    lldb
    lld
    gcc
    clang
    ninja

    # js
    deno
    nodejs
    nodePackages.prettier

    # cli
    bat
    direnv
    fd
    fzf
    jq
    github-cli
    glow
    htop
    httpie
    nmap
    netcat-gnu
    ranger
    ripgrep
    tmux

    # apps
    aria2
    p7zip
    youtube-dl
    zig

    # rust
    rustup
    wasm-bindgen-cli
    wasm-pack

    # utils
    ryzenadj

    # gui
    (nixGlWrap alacritty)
    (nixGlWrap sioyek)
    (nixGlWrap chromium)
    (nixGlWrap mpv)

    # font
    agave
    roboto-mono
  ];
}
