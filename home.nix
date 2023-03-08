{ config, pkgs, lib, ... }: {
  nixpkgs.overlays = [
    (self: super: {
      clang = super.clang.overrideAttrs
        (oldAttrs: rec { meta = oldAttrs.meta // { priority = 15; }; });
    })
  ];
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
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
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    mouse = true;
    historyLimit = 50000;
    sensibleOnTop = false;
    terminal = "alacritty";
    shell = "${pkgs.zsh}/bin/zsh";
    extraConfig = builtins.readFile ./tmux.conf;
  };
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    autocd = true;
    # historySubstringSearch.enable = true;
    oh-my-zsh.enable = true;
    history.expireDuplicatesFirst = true;
    initExtraFirst = builtins.readFile ./zshrc;
  };
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
    options = [ "--cmd cd" ];
  };
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
    htop
    httpie
    nmap
    netcat-gnu
    ripgrep

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
  ];
}
