{ pkgs, lib, home # $HOME
, xdgConfigHome # The path to $XDG_CONFIG_HOME
, xdgDataHome # The path to $XDG_DATA_HOME
, gitEmailPath # Path to a file containing email address to use for Git
}:

# Configuration settings for Zsh
{
  enable = true;

  # Automatically enter into a directory if typed directly into the shell
  autocd = true;

  # Fish-like autosuggestions
  autosuggestion.enable = true;

  # Where Zsh's dotfiles shall be located
  dotDir = "${xdgConfigHome}/zsh";

  history = {
    append = true;
    ignoreDups = true;
    findNoDups = true;
    ignoreSpace = true;
    share = true;
    path = "${xdgDataHome}/zsh/zsh_history";
  };

  # Environment variables that will be set for Zsh session
  sessionVariables = {
    # Configure Git email
    # (this can't be in the Git config file because it requires reading a secret.
    #  it is not so easy to template a file with a secret after it has been generated with Nix.)
    EMAIL = "$(cat ${gitEmailPath})";
    # Move less' history file
    LESSKEY = "${xdgConfigHome}/less/lesskey";
    LESSHISTFILE = "${xdgDataHome}/less/history";
    # Tell Cargo where its files are
    CARGO_HOME = "${xdgDataHome}/cargo";
    # This is where ripgrep's configuration file is
    RIPGREP_CONFIG_PATH = "${xdgConfigHome}/ripgrep/ripgreprc";
    # Tell npm where it should place files
    NPM_CONFIG_USERCONFIG = "${xdgConfigHome}/npm/npmrc";
    NODE_REPL_HISTORY = "${xdgDataHome}/npm/node_repl_history";
    # Specify GnuPG's configuration file despite the fact that I have not yet
    # installed GnuPG on NixOS
    GNUPGHOME = "${xdgDataHome}/gnupg";
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    # I'm confused why there's a ~/.gtkrc-2.0 and a ~/.config/gtkrc-2.0
    GTK2_RC_FILES = "${xdgConfigHome}/gtk-2.0/gtkrc";
  };

  # Extra commands that should be added to .zshenv
  envExtra = ''
    # set PATH so it includes user's private bin if it exists
    if [ -d "$HOME/bin" ]; then
      PATH="$HOME/bin:$PATH"
    fi

    if [ -d "$HOME/.local/bin" ]; then
      PATH="$HOME/.local/bin:$PATH"
    fi

    if [ -x "$ZDOTDIR/.zshenv.local" ]; then
      source "$ZDOTDIR/.zshenv.local"
    fi
  '' + lib.optionalString pkgs.stdenv.isDarwin ''
    if [ -z "''${path[(r)/usr/local/sbin]}" ]; then
      path+=/usr/local/sbin
    fi
  '';

  # Extra commands that should be added to .zprofile
  profileExtra = ''
    [ -x "$ZDOTDIR/.zprofile.local" ] && source "$ZDOTDIR/.zprofile.local"
  '' + lib.optionalString pkgs.stdenv.isDarwin ''
    whence brew &>/dev/null && eval "''${(@M)''${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_BAT=1
    export HOMEBREW_BAT_CONFIG_PATH="$BAT_CONFIG_PATH"
  '';

  # Extra local variables defined at the top of .zshrc
  localVariables = {
    LISTMAX = 100; # Automatically decide when to page a list of completions
    # From `man zshparam`: "A list of non-alphanumeric characters considered part of a word by the line editor."
    WORDCHARS =
      "*?_[]~=&;!#$%^(){}<>:.-"; # Borrowed from github.com/zpm-zsh/core-config
    ZSH_CACHE_DIR = "$ZDOTDIR";
  };

  initContent = let
    # Extra commands that should be added to .zshrc before compinit
    # (or before sourcing plugins, which hapens after compinit)
    initExtraBeforeCompinit = lib.mkOrder 550 ''
      fpath+="${pkgs.zsh-completions}/share/zsh/site-functions"

      ${lib.optionalString pkgs.stdenv.isDarwin ''
        whence brew &>/dev/null && fpath+=$(brew --prefix)/share/zsh/site-functions
      ''}
    '';

    # Extra commands that should be added to .zshrc
    # (see ../../../net.sourceforge.Zsh/.zshrc for detailed descriptions)
    initExtra = lib.mkOrder 1000 ''
      autoload -U colors
      colors

      zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}" 'ma=1;30;43'
      zstyle ':completion:*:processes' command 'NOCOLORS=1 ps -U $USER|sed "/ps/d"'
      zstyle ':completion:*:processes' insert-ids menu yes select
      zstyle ':completion:*:processes-names' command 'NOCOLORS=1 ps xho command|sed "s/://g"'
      zstyle ':completion:*:processes' sort false
      zstyle ':completion:*' completer _expand _complete _correct _approximate
      zstyle ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)'
      zstyle '*' single-ignored show
      zstyle ':completion:*:*:*:*:*' menu select
      bindkey '^[[Z' reverse-menu-complete
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*:messages' format '%d'
      zstyle ':completion:*:functions' ignored-patterns '_*'
      zstyle ':completion:*:*:zcompile:*' ignored-patterns '(*~|*.zwc)'
      zstyle ':completion:*:warnings' format "%{''${fg_bold[red]}%}No matches for:%{''${fg[yellow]}%} %d"
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=36=31'
      zstyle ':completion:*' accept-exact '*(N)'
      zstyle ':completion::complete:*' use-cache 1
      zstyle ':completion::complete:*' cache-path "''${ZSH_CACHE_DIR}"

      zmodload zsh/complist

      autoload -Uz promptinit && promptinit
      prompt redhat

      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=( precmd_vcs_info )
      setopt prompt_subst
      RPROMPT=\$vcs_info_msg_0_
      zstyle ':vcs_info:git:*' formats '%F{240}(%b)%r%f'
      zstyle ':vcs_info:*' enable git

      bindkey '^[[1;5D' backward-word
      bindkey '^[[1;5C' forward-word
      bindkey '^[^?' backward-kill-word
      bindkey '\eOA' history-substring-search-up
      bindkey '\eOB' history-substring-search-down

      export ZSH_PLUGINS_ALIAS_TIPS_TEXT='Found existing alias: '
      export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES='_'
      export _ZL_DATA="$ZDOTDIR/z.txt"
      export BROOT_CONFIG_DIR="$XDG_CONFIG_HOME/broot"

      SPROMPT="Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
        [Yes, No, Abort, Edit] "

      GCC_COLORS=""
      GCC_COLORS+="error=$color[bold];$color[red]"
      GCC_COLORS+=":warning=$color[bold];$color[yellow]"
      GCC_COLORS+=":note=$color[bold];$color[white]"
      GCC_COLORS+=":caret=$color[bold];$color[white]"
      GCC_COLORS+=":locus=$color[bg-black];$color[bold];$color[magenta]"
      GCC_COLORS+=":quote=$color[bold];$color[yellow]"
      export GCC_COLORS

      export LESS="-r -M $LESS"
      export LESS_TERMCAP_mb="$fg[green]"
      export LESS_TERMCAP_md="$fg_bold[green]"
      export LESS_TERMCAP_so="$bg_bold[black]$fg_bold[yellow]"
      export LESS_TERMCAP_us="$fg[blue]"
      export LESS_TERMCAP_ue="$reset_color"
      export LESS_TERMCAP_me="$reset_color"
      export LESS_TERMCAP_se="$reset_color"

      GREP_COLORS=""
      GREP_COLORS+=":mt=$color[bold];$color[cyan]"
      GREP_COLORS+=":ms=$color[bg-black];$color[bold];$color[yellow]"
      GREP_COLORS+=":mc=$color[bold];$color[bg-red]"
      GREP_COLORS+=":sl="
      GREP_COLORS+=":cx="
      GREP_COLORS+=":fn=$color[bold];$color[magenta]"
      GREP_COLORS+=":ln=32"
      GREP_COLORS+=":bn=32"
      GREP_COLORS+=":se=$color[bold];$color[cyan]"
      export GREP_COLORS

      autoload -Uz add-zsh-hook
      add-zsh-hook chpwd _python-workon-cwd
      add-zsh-hook chpwd lsGF

      source "$ZDOTDIR/bookmark.zsh"
      [ -x "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"

      alias 1='cd -'
      for (( i = 2; i <= 9; i++ ))
        alias "$i"="cd -$i"
      unset i

      git config --global --get-regex alias | while IFS=$'\n' read -r galias; do
        local i=$galias[(i)[[:space:]]]
        local galias_key=$galias[7,$i-1]
        local galias_value=$galias[$i+1,-1]
        if [[ $galias_key = i ]]; then
          function gi {
            curl -sL https://www.toptal.com/developers/gitignore/api/$@
          }
        elif [[ $galias_value == \!* ]]; then
          eval """
          function g$galias_key {
            $galias_value[2,-1]
          }
          """
        else
          alias "g$galias_key"="git $galias_value"
        fi
      done
    '';
  in lib.mkMerge [ initExtraBeforeCompinit initExtra ];

  siteFunctions = {
    _python-workon-cwd =
      builtins.readFile ../../../net.sourceforge.Zsh/zfunc/_python-workon-cwd;
    j = builtins.readFile ../../../net.sourceforge.Zsh/zfunc/j;
    lsGF = if pkgs.stdenv.isLinux then
      "command ls --color --classify"
    else
      "command ls -GF";
    mkcd = builtins.readFile ../../../net.sourceforge.Zsh/zfunc/mkcd;
    print_array =
      builtins.readFile ../../../net.sourceforge.Zsh/zfunc/print_array;
    rmmetadata =
      builtins.readFile ../../../net.sourceforge.Zsh/zfunc/rmmetadata;
    env = ''${pkgs.grc}/bin/grc --colour=auto env "$@"'';
    as = ''${pkgs.grc}/bin/grc --colour=auto as "$@"'';
    gcc = ''${pkgs.grc}/bin/grc --colour=auto gcc "$@"'';
    "g++" = ''${pkgs.grc}/bin/grc --colour=auto g++ "$@"'';
    last = ''${pkgs.grc}/bin/grc --colour=auto last "$@"'';
    ld = ''${pkgs.grc}/bin/grc --colour=auto ld "$@"'';
    ifconfig = ''${pkgs.grc}/bin/grc --colour=auto ifconfig "$@"'';
    mount = ''${pkgs.grc}/bin/grc --colour=auto mount "$@"'';
    netstat = ''${pkgs.grc}/bin/grc --colour=auto netstat "$@"'';
    ping = ''${pkgs.grc}/bin/grc --colour=auto ping "$@"'';
    ping6 = ''${pkgs.grc}/bin/grc --colour=auto ping6 "$@"'';
    ps = ''${pkgs.grc}/bin/grc --colour=auto ps "$@"'';
    df = ''${pkgs.grc}/bin/grc --colour=auto df -h "$@"'';
    du = ''${pkgs.grc}/bin/grc --colour=auto du -h "$@"'';
    free = ''${pkgs.grc}/bin/grc --colour=auto free -h "$@"'';
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    lsblk = ''${pkgs.grc}/bin/grc --colour=auto lsblk "$@"'';
    ss = ''${pkgs.grc}/bin/grc --colour=auto ss "$@"'';
    lsmod = ''${pkgs.grc}/bin/grc --colour=auto lsmod "$@"'';
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    # Can't use builtins.readFile for these are these are Jinja-templated in the repo
    help = ''
      # Open a man page in a separate terminal window
      function help {
        open x-man-page://$@
      }
    '';
    lsdownloads = ''
      # List files you've downloaded
      function lsdownloads {
        local db
        for db in ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV*; do
          grep -q 'LSQuarantineEvent' < <(sqlite3 "$db" .tables) &&
          sqlite3 "$db" 'SELECT LSQuarantineDataURLString FROM LSQuarantineEvent'
        done | sed '/^$/d'
      }
    '';
    pfd = ''
      # Prints the current directory that Finder is focused on
      function pfd {
        osascript 2>/dev/null <<EOF
          tell application "Finder"
            return POSIX path of (target of first window as text)
          end tell
      EOF
      }
    '';
    pfs = ''
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
    rmdownloads = ''
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

  setOptions = [
    "NO_BEEP"
    "NO_CASE_GLOB"
    "CORRECT"
    "COMPLETE_IN_WORD"
    "INC_APPEND_HISTORY"
    "HIST_REDUCE_BLANKS"
    "HIST_VERIFY"
    "AUTO_PUSHD"
    "PUSHD_IGNORE_DUPS"
    "PUSHD_MINUS"
    "PUSHD_SILENT"
    "PUSHD_TO_HOME"
    "INTERACTIVE_COMMENTS"
    "NO_CLOBBER"
    "NO_PROMPT_CR"
  ];

  plugins = let
    mkPlugin = { name, owner, repo, rev, hash, ... }@args:
      pkgs.stdenv.mkDerivation ({
        inherit name;
        src = pkgs.fetchFromGitHub { inherit owner repo rev hash; };

        dontConfigure = true;

        dontBuild = true;

        installPhase = ''
          mkdir -p $out
          mv * $out
        '';
      } // removeAttrs args [ "name" "src" "owner" "repo" "rev" "hash" ]);
  in [
    rec {
      name = "ssh";
      src = mkPlugin {
        inherit name;
        owner = "zpm-zsh";
        repo = name;
        rev = "f8b60bb61609aa20bc86286e5a68a7def5d962cd";
        hash = "sha256-aZ5NP1P4rXHEqQJudttnUSlkJm2+lXGTQEG7YQDaBzQ=";
      };
    }

    rec {
      name = "ignored-users";
      src = mkPlugin {
        inherit name;
        owner = "zpm-zsh";
        repo = name;
        rev = "83a38111b20e8ffa287c4978e183d42e46890382";
        hash = "sha256-9myjbHxo7LLDy5RHS5wgdfzU8z5h+Lqbjqbe9vO/i60=";
      };
    }

    rec {
      name = "dot";
      src = mkPlugin {
        inherit name;
        owner = "zpm-zsh";
        repo = name;
        rev = "a2b288373ae920207ed7b36258611acc5eb5dcf7";
        hash = "sha256-bAk59eAt8duC1xaM1/naLrTlGr5QEDLJXIYiWrtSASw=";
      };
    }

    rec {
      name = "alias-tips";
      src = mkPlugin {
        inherit name;
        owner = "djui";
        repo = name;
        rev = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
        hash = "sha256-ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
        prePatch = ''
          substituteInPlace alias-tips.plugin.zsh \
            --replace python3 ${pkgs.python3}/bin/python3
        '';
      };
    }

    rec {
      name = "clipboard";
      src = mkPlugin {
        inherit name;
        owner = "zpm-zsh";
        repo = name;
        rev = "c3a4a054cefe313d853dc9c32debb1b18aa7513c";
        hash = "sha256-XtS5HQ2HFYBoBZikuI82XT4MDcXsaPJioI7zNyBoIhs=";
      };
    }

    {
      name = "zsh-nix-shell";
      file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
      src = pkgs.zsh-nix-shell;
    }

    {
      name = "history-search-multi-word";
      file =
        "share/zsh/zsh-history-search-multi-word/history-search-multi-word.plugin.zsh";
      src = pkgs.zsh-history-search-multi-word;
    }

    {
      name = "zsh-history-substring-search";
      file =
        "share/zsh-history-substring-search/zsh-history-substring-search.plugin.zsh";
      src = pkgs.zsh-history-substring-search;
    }

    # This must be the last plugin
    {
      name = "fast-syntax-highlighting";
      file =
        "share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh";
      src = pkgs.zsh-fast-syntax-highlighting;
    }
  ];

  shellAliases = {
    # Git aliases
    g = "git";
    grm = "git rm";
    gmv = "git mv";

    # ls aliases
    lbr = "br -sdp";
    tree = "br --cmd :pt";
    ldot = "ls -ld .*";

    # Make some commands more verbose
    rm = "rm -v";
    mv = "mv -v";
    cp = "cp -v";
  } // lib.optionalAttrs pkgs.stdenv.isLinux {
    diff = "diff --color --report-identical-files";
    grep = "grep -n --color=always";
  } // lib.optionalAttrs pkgs.stdenv.isDarwin {
    diff = "diff -s";
    brewc = "brew cleanup";
    brewi = "brew install";
    brewL = "brew leaves";
    brewl = "brew list";
    brewo = "brew outdated";
    brews = "brew search";
    brewu = "brew upgrade";
    brewx = "brew uninstall";
    caski = "brew install --cask";
    caskl = "brew list --cask";
    casko = "brew outdated --cask";
    casks = "brew search --cask";
    caskx = "brew uninstall --cask";
  };

  shellGlobalAliases = {
    C = "| wc -l";
    H = "| head";
    T = "| tail";
    L = "| less";
    G = "| grep -n";
    NUL = "> /dev/null 2>&1";
    "TRUE?" = "&& echo true || echo false";
  };
}
