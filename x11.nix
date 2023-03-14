{ config, pkgs, lib, ... }: {
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
  };
  xsession.windowManager.i3 = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./i3/config;
  };
  home.file.".config/i3/ws-go.sh".source = ./i3/ws-go.sh;
  home.file.".config/i3/ws-save.sh".source = ./i3/ws-save.sh;

  services.redshift = {
    enable = true;
    temperature.day = 4500;
    temperature.night = 4500;
    duskTime = "18:35-20:15";
    dawnTime = "6:00-7:45";
  };

  home.packages = with pkgs; [
    # controllers
    brightnessctl
    wmctrl
  ];
}
