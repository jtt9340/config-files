{ lib, pkgs, config, flakeInputs, ... }:

let
  xdgConfigHome = config.xdg.configHome;
  xdgDataHome = config.xdg.dataHome;
  xdgCacheHome = config.xdg.cacheHome;
in {
  imports = [ flakeInputs.lollypops.homeModules.default ];

  home.stateVersion = "23.11";

  lollypops.secrets = {
    default-dir = "${xdgDataHome}/lollypops";
    files."git_email" = {
      cmd =
        "${pkgs.age}/bin/age -d -i ${config.home.homeDirectory}/.ssh/id_ed25519 ${
          ../../secrets/git_email.age
        }";
      mode = "0644";
    };
  };

  xdg = {
    # Enable management of XDG Base Directories
    enable = true;

    # Home manager will manage these dotfiles
    configFile = {
      "nixpkgs/config.nix".source = ./config.nix;
      "npm/npmrc".source = ../../../com.npmjs.Npm/npmrc;
      "ripgrep/ripgreprc".source =
        ../../../com.github.burntsushi.Ripgrep/ripgreprc;
      "coc/coc-settings.json".source =
        (import ./coc-settings.nix) (pkgs.formats.json { }).generate;
      "zsh/bookmark.zsh".source = ../../../net.sourceforge.Zsh/bookmark.zsh;
    };
  } // lib.optionalAttrs pkgs.stdenv.isDarwin
    ( # Janky syntax since apparently path literals don't support spaces
      let
        applicationSupport =
          "${config.home.homeDirectory}/Library/Application Support";
      in {
        configHome = applicationSupport;
        dataHome = applicationSupport;
        stateHome = applicationSupport;
        cacheHome = "${config.home.homeDirectory}/Library/Caches";
      });

  programs = {
    # Let Home Manager install and manage things
    home-manager.enable = true;

    # Configure Zsh
    zsh = (import ./zsh.nix) {
      inherit pkgs lib xdgConfigHome xdgDataHome;
      home = config.home.homeDirectory;
      gitEmailPath = config.lollypops.secrets.files."git_email".path;
    };

    # Use z-lua, a program that remembers your most frequently cd-ed to directories to make
    # it easier to cd to them
    z-lua = {
      enable = true;
      enableFishIntegration = false;
      enableAliases = true;
    };

    bat = {
      enable = true;
      config = {
        theme = "OneHalfDark";
        map-syntax = [
          "*.plugin.zsh:Bourne Again Shell (bash)"
          "*.zsh:Bourne Again Shell (bash)"
          "*.sh:Bourne Again Shell (bash)"
          "*.zsh-theme:Bourne Again Shell (bash)"
          "*.csproj:XML"
          "flake.lock:JSON"
        ];
        pager = "less --mouse -RF";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batgrep
        batman
        prettybat
      ];
    };

    # Tree-based file manager and fuzzy finder
    broot = {
      enable = true;
      enableFishIntegration = false;
      settings = {
        default_flags = "g";
        icon_theme = "nerdfont";
        verbs = [{
          name = "bat";
          invocation = "bat";
          execution = "${pkgs.bat}/bin/bat {file}";
        }];
      };
    };

    # Git config
    git = (import ./git.nix) {
      inherit (pkgs.bat-extras) batman;
      isLinux = lib.optionals pkgs.stdenv.isLinux;
      isDarwin = lib.optionals pkgs.stdenv.isDarwin;
      home = config.home.homeDirectory;
    };

    # Use Delta, a diff tool that makes diffs look like they do on GitHub
    delta = {
      enable = true;
      enableGitIntegration = true;
      options = {
        syntax-theme = "OneHalfDark";
        whitespace-error-style = "22 reverse";
        file-style = "bold cyan ul";
        file-decoration-style = "cyan ul";
        line-numbers = true;
        line-numbers-left-style = "cyan";
        line-numbers-right-style = "cyan";
        hunk-header-decoration-style = "cyan box";
      };
    };

    # Use lsd, an ls clone with more colors and icons
    lsd = {
      enable = true;
      settings = {
        date = "relative";
        # Add indicator characters to certain listed files
        indicators = true;
      };
    };

    # Use Vim with custom configuration and plugins
    vim = (import ./vim.nix) {
      inherit (pkgs) vimPlugins fetchFromGitHub;
      inherit (pkgs.vimUtils) buildVimPlugin;
      inherit (lib.strings) stringAsChars;
      inherit xdgConfigHome xdgDataHome xdgCacheHome;
    };

    # Use nix-index, a files database for nixpkgs
    nix-index = {
      enable = true;
      # Everything, including Bash and Zsh, are true by default
      enableFishIntegration = false;
    };

    wezterm = (import ./wezterm.nix) {
      inherit (pkgs) wezterm;
      inherit (pkgs.stdenv) isDarwin;
      inherit (lib) optionalString;
    };
  };

  home.packages = with pkgs;
    [
      # Chat app
      discord
      # Plaintext accounting software
      hledger
      # Web UI for Hlegder
      hledger-web
      # JavaScript runtime - needed for coc.nvim
      nodejs_22
      # Conversion between documentation formats
      pandoc
      # LaTeX
      texliveSmall
      # We really do live in a society
      zoom-us
    ] ++ lib.optionals stdenv.isLinux [
      # Password manager
      bitwarden-desktop
      # Sync mobile device with Gnome Desktop
      gnomeExtensions.gsconnect
      # Install new firmware on iOS devices
      idevicerestore
      # Talk to iOS devices
      libimobiledevice
      # Free and open-source office suite
      libreoffice
      # Makes it easier to run games/Windows-only applications on GNU/Linux
      lutris
      # Merge or split pdf documents and rotate, crop and rearrange their pages using a graphical interface
      pdfarranger
      # Another chat app
      slack
      # Allows you to mount remote drives via ssh
      sshfs
      # Email client
      thunderbird
      # FOSS filesystem encryption on-the-fly
      veracrypt
      # Keyboard configurator
      via
    ] ++ lib.optionals stdenv.isDarwin [
      # Application uninstaller
      appcleaner
    ];

  systemd.user.services = {
    # Highly adapted from https://github.com/NixOS/nixpkgs/blob/nixos-25.05/nixos/modules/services/web-apps/hledger-web.nix#L130
    hledger-web = {
      Unit = {
        Description = "hledger-web";
        Documentation =
          [ "man:hledger-web(1)" "https://hledger.org/hledger-web.html" ];
      };

      Service = {
        ExecStart = "${pkgs.hledger}/bin/hledger web -- --serve";
        Restart = "always";
        PrivateTmp = true;
        KillSignal = "SIGINT";
      };

      Install = { WantedBy = [ "default.target" ]; };
    };
  };
}
