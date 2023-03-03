{ pkgs, ... }: {
  programs.home-manager.enable = true;
  programs.neovim = {
    enable = true;
    vimAlias = true;
    viAlias = true;
    vimdiffAlias = true;
  };
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # C++
    cmake
    lldb
    lld
    gcc
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
    git
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
  # programs.plasma = {
  #   enable = true;
  #
  #   # Some high-level settings:
  #   workspace.clickItemTo = "select";
  #
  #   hotkeys.commands."Launch Konsole" = {
  #     key = "Meta+Alt+K";
  #     command = "konsole";
  #   };
  #
  #   # Some mid-level settings:
  #   shortcuts = {
  #     ksmserver = {
  #       "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
  #     };
  #
  #     kwin = {
  #       "Expose" = "Meta+,";
  #       "Switch Window Down" = "Meta+J";
  #       "Switch Window Left" = "Meta+H";
  #       "Switch Window Right" = "Meta+L";
  #       "Switch Window Up" = "Meta+K";
  #     };
  #   };
  #
  #   # A low-level setting:
  #   files."baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  # };
}
