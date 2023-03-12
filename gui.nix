{ config, pkgs, lib, ... }:
let
  system = "x86_64-linux";
  ff-addons = pkgs.ff-addons.packages.${system};
  buildFirefoxXpiAddon = pkgs.ff-addons.lib.${system}.buildFirefoxXpiAddon;
  nixgl = pkgs.nixgl.packages."x86_64-linux";
  nixGlWrap = wrappers: pkg:
    let
      wrapper = with builtins;
        concatStringsSep " "
        (map (wrapper: (lib.getExe nixgl.${wrapper})) wrappers);
    in pkgs.runCommand "${pkg.name}-nixgl-wrapper" { } ''
      mkdir $out
      ln -s ${pkg}/* $out
      rm $out/bin
      mkdir $out/bin
      for bin in ${pkg}/bin/*; do
       wrapped_bin=$out/bin/$(basename $bin)
       echo "exec ${wrapper} $bin \$@" > $wrapped_bin
       chmod +x $wrapped_bin
      done
    '';
  glWrap = nixGlWrap [ "nixGLIntel" ];
  glVkWrap = nixGlWrap [ "nixGLIntel" "nixVulkanIntel" ];
in {
  nixpkgs.overlays = [
    (self: super: {
      firefox = let
        legacyFox = pkgs.fetchFromGitHub {
          owner = "girst";
          repo = "LegacyFox-mirror-of-git.gir.st";
          rev = "c2ebaa3a942180370e9318661ceacf4bae55560c";
          sha256 = "sha256-b6tl0z4wJCtYPUHxDz7F3jX97TpdHt6dcKzMKP6O1A8=";
          sparseCheckout = [
            "config.js"
            "defaults/pref/config-prefs.js"
            "legacy.manifest"
            "legacy"
          ];
        };
      in super.firefox.overrideDerivation (oldAttrs: {
        buildCommand = oldAttrs.buildCommand + "\n" + ''
          cat "${legacyFox}/config.js" >> "$out/lib/firefox/mozilla.cfg"
          echo "pref("general.config.sandbox_enabled", false);" >> "$out/lib/firefox/defaults/autoconfig.js"
          cp "${legacyFox}/legacy.manifest" "$out/lib/firefox"
          cp -r "${legacyFox}/legacy" "$out/lib/firefox"
        '';
      });
    })
  ];
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    nixgl.nixVulkanIntel
    # gui
    feh
    (glVkWrap firefox)
    (glVkWrap sioyek)
    (glVkWrap chromium)
    (glVkWrap mpv)
    (glVkWrap signal-desktop)

    # fonts
    agave
    roboto-mono
    lato # sans serif
  ];
  programs.firefox = {
    enable = true;
    # package = (nixGlWrap pkgs.firefox);
    profiles.main = {
      # isDefault = true;
      search = {
        default = "DuckDuckGo";
        force = true;
      };
      extensions = with ff-addons; [
        bitwarden
        darkreader
        libredirect
        # google-container
        ublock-origin
        (buildFirefoxXpiAddon {
          pname = "vimfx";
          addonId = "VimFx-unlisted@akhodakivskiy.github.com";
          url =
            "https://github.com/akhodakivskiy/VimFx/releases/download/v0.25.0/VimFx.xpi";
          sha256 = "sha256-W9rdG2J+esMnH318WcrhGplzC2zYfCbaB84nELHF9+8=";
          version = "0.25.0";
          meta = { };
        })
        (buildFirefoxXpiAddon {
          pname = "sideberry";
          addonId = "{3c078156-979c-498b-8990-85f7987dd929}";
          url =
            "https://github.com/mbnuqw/sidebery/releases/download/v5.0.0b31/sidebery-5.0.0b31.xpi";
          sha256 = "sha256-J7N1w7T421c0B/oZJjpJJ4AsL1YpqUYaAkJsY5IhI+Y=";
          version = "5.0.0b30";
          meta = { };
        })
        (buildFirefoxXpiAddon {
          pname = "sponsor-block";
          addonId = "sponsorBlocker@ajay.app";
          url =
            "https://github.com/ajayyy/SponsorBlock/releases/download/5.2.1/FirefoxSignedInstaller.xpi";
          sha256 = "sha256-11nJpitvXEknXSkgc8vQ9wkojJMDWsp197Cak1d0J6w=";
          version = "5.2.1";
          meta = { };
        })
      ];
      settings = {
        "browser.display.use_document_fonts" =
          0; # disable custom fonts for websites
        "font.name.sans-serif.x-western" = "Lato";
        "font.name.serif.x-western" = "Lato";
        "font.name.monospace.x-western" = "Roboto Mono";
        "font.name.monospace.font" = 14;
        "browser.download.dir" = "/tmp";
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "extensions.VimFx.config_file_directory" =
          "${./firefox}"; # force conversion to string
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "sidebar.position_start" = false; # sidebar on right side
      };
      userChrome = builtins.readFile ./firefox/userChrome.css;
    };
  };
  programs.alacritty = {
    enable = true;
    package = (glVkWrap pkgs.alacritty);
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
