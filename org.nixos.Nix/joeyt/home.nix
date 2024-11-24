{ lib, pkgs, config, ... }:

let
  # Path to my repository for storing config/dot files
  configFiles = "${config.home.homeDirectory}/Projects/config-files";
  # nixos-unstable (for more recent version of some packages, need to subscribe to nixpkgs-unstable first)
  # pkgsUnstable = import <nixpkgs-unstable> {
  #   config = { allowUnfree = true; };
  # };
  xdgConfigHome = config.xdg.configHome;
  xdgDataHome = config.xdg.dataHome;
  xdgCacheHome = config.xdg.cacheHome;
  zfunc = file: /${configFiles}/net.sourceforge.Zsh/omz/zfunc/${file};
in {
  home.stateVersion = "{{@@ state_version @@}}";

  xdg = {
    # Enable management of XDG Base Directories
    enable = true;

    # Home manager will manage these dotfiles
    configFile = {
      "nixpkgs/config.nix".source = /${configFiles}/org.nixos.Nix/config.nix;
      "npm/npmrc".source = /${configFiles}/com.npmjs.Npm/npmrc;
      "ripgrep/ripgreprc".source =
        /${configFiles}/com.github.burntsushi.Ripgrep/ripgreprc;
      "coc/coc-settings.json".source =
        (import ./coc-settings.nix) (pkgs.formats.json { }).generate;
      # Instead of just symlinking the entire zsh/zfunc directory we have to do it file
      # by file since some files expect a Jinja template engine to be run first
      "zsh/zfunc/_python-workon-cwd".source = zfunc "_python-workon-cwd";
      "zsh/zfunc/j".source = zfunc "j";
      "zsh/zfunc/lsGF".text = if pkgs.stdenv.isLinux then
        "command ls --color --classify"
      else
        "command ls -GF";
      "zsh/zfunc/mkcd".source = zfunc "mkcd";
      "zsh/zfunc/print_array".source = zfunc "print_array";
      "zsh/zfunc/rmmetadata".source = zfunc "rmmetadata";
      "zsh/zfunc/rga-sk".text = ''
        # A function that allows ripgrep-all (rga) with skim (sk)
        function rga-sk {
          RG_PREFIX='rga --files-with-matches' 
          local open_cmd
          local file
          if [ $(uname) = Darwin ]; then
            open_cmd=open
          else
            open_cmd=xdg-open
          fi
          file="$(
            SKIM_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
              sk --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                -q "$1" \
                --bind "change:reload:$RG_PREFIX {q}" \
                --preview-window="70%:wrap"
          )" &&
          echo "opening $file" &&
          $open_cmd "$file"
        }
      '';
    } // lib.optionalAttrs pkgs.stdenv.isDarwin {
      "zsh/zfunc/help".text = ''
        # Open a man page in a separate terminal window
        function help {
          open x-man-page://$@
        }
      '';
      "zsh/zfunc/lsdownloads".text = ''
        # List files you've downloaded
        function lsdownloads {
          local db
          for db in ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV*; do
            grep -q 'LSQuarantineEvent' < <(sqlite3 "$db" .tables) &&
            sqlite3 "$db" 'SELECT LSQuarantineDataURLString FROM LSQuarantineEvent'
          done | sed '/^$/d'
        }
      '';
      "zsh/zfunc/pfd".text = ''
        # Prints the current directory that Finder is focused on
        function pfd {
          osascript 2>/dev/null <<EOF
            tell application "Finder"
              return POSIX path of (target of first window as text)
            end tell
        EOF
        }
      '';
      "zsh/zfunc/pfs".text = ''
        # Prints all the files that are currently selected in Finder
        function pfs {
          osascript 2>&1 <<EOF
            tell application "Finder" to set the_selection to selection
            if the_selection is not {}
              repeat with an_item in the_selection
                log POSIX path of (an_item as text)
              end repeat
            end if
        EOF
        }
      '';
      "zsh/zfunc/rmdownloads".text = ''
        # Clear the macOS download history
        function rmdownloads {
          local db
          for db in ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV*; do
            grep -q 'LSQuarantineEvent' < <(sqlite3 "$db" .tables) &&
            sqlite3 "$db" 'DELETE FROM LSQuarantineEvent; VACUUM'
          done
        }
      '';
    };
  } // lib.optionalAttrs pkgs.stdenv.isDarwin
    ( # Janky syntax since apparently path literals don't support spaces
      let applicationSupport = ~/Library + "/Application Support";
      in {
        configHome = applicationSupport;
        dataHome = applicationSupport;
        stateHome = applicationSupport;
        cacheHome = ~/Library/Caches;
      });

  programs = {
    # Let Home Manager install and manage things
    home-manager.enable = true;

    # Configure Zsh
    zsh = (import ./zsh.nix) {
      inherit (pkgs) zsh-nix-shell fetchFromGitHub python3;
      inherit (lib) optionalAttrs optionalString escapeShellArg;
      inherit (pkgs.stdenv) mkDerivation isLinux isDarwin;
      inherit (lib.strings) removePrefix;
      inherit configFiles xdgConfigHome xdgDataHome;
      home = config.home.homeDirectory;
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
    };

    # Use skim, a command-line fuzzy finder written in Rust
    skim = {
      enable = true;
      # Everything, including Bash and Zsh, are true by default
      enableFishIntegration = false;
    };

    # Use lsd, an ls clone with more colors and icons
    lsd.enable = true;

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

    wezterm = (import ./wezterm.nix) { inherit (pkgs) wezterm; };
  };

  home.packages = with pkgs;
    [
      # Chat app
      discord
      # Java IDE
      jetbrains.idea-ultimate
      # Python IDE
      jetbrains.pycharm-professional
      # Rust IDE
      jetbrains.rust-rover
      # JavaScript runtime - needed for coc.nvim
      nodejs_18
      # Conversion between documentation formats
      pandoc
      # LaTeX
      texliveSmall
      # We really do live in a society
      zoom-us
    ] ++ lib.optionals stdenv.isLinux [
      # Password manager
      bitwarden
      # Sync mobile device with Gnome Desktop
      gnomeExtensions.gsconnect
      # Free and open-source office suite
      libreoffice
      # Makes it easier to run games/Windows-only applications on GNU/Linux
      lutris
      # Another chat app
      slack
      # Allows you to mount remote drives via ssh
      sshfs
      # Email client
      thunderbird
      # Keyboard configurator
      via
    ] ++ lib.optionals stdenv.isDarwin [
      # Application uninstaller
      appcleaner
    ];

  # How many times do I have to say that I am okay with non-free software?! I guess when
  # you specify packages with home.packages you also need to specify it here?
  # (Me from the future: yes that is the case - the following line applies only to packages
  # listed above)
  nixpkgs.config.allowUnfree = true;
}
