{ zsh-nix-shell, fetchFromGitHub # Function for cloning GitHub repositories
, optionalAttrs # If the first argument is true return the second argument, else return {}
, optionalString # If the first argument is true return the second argument, else return ""
, removePrefix, isLinux, isDarwin, home # $HOME
, configFiles # The path to my "config-files" repo
, xdgConfigHome # The path to $XDG_CONFIG_HOME
, xdgDataHome # The path to $XDG_DATA_HOME
}:

# Configuration settings for Zsh
{
  enable = true;

  # Automatically enter into a directory if typed directly into the shell
  autocd = true;

  # Fish-like autosuggestions
  enableAutosuggestions = true;

  historySubstringSearch.enable = true;

  syntaxHighlighting.enable = true;

  # Where Zsh's dotfiles shall be located, relative to $HOME
  dotDir = removePrefix home "${xdgConfigHome}/zsh";

  # Where the .zsh_history file is saved
  history.path = "${xdgDataHome}/zsh/zsh_history";

  # Environment variables that will be set for Zsh session
  sessionVariables = {
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
  } // optionalAttrs isLinux {
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
  '' + optionalString isDarwin ''
    if [ -z "''${path[(r)/usr/local/sbin]}" ]; then
      path+=/usr/local/sbin
    fi
  '';

  # Extra commands that should be added to .zprofile
  profileExtra = ''
    [ -x "$ZDOTDIR/.zprofile.local" ] && source "$ZDOTDIR/.zprofile.local"
  '' + optionalString isDarwin ''
    whence brew &>/dev/null && eval "''${(@M)''${(f)"$(brew shellenv 2> /dev/null)"}:#export HOMEBREW*}"
    export HOMEBREW_NO_ENV_HINTS=1
    export HOMEBREW_BAT=1
    export HOMEBREW_BAT_CONFIG_PATH="$BAT_CONFIG_PATH"
  '';

  # Extra local variables defined at the top of .zshrc
  localVariables = {
    SPROMPT = ''
      Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?
      	[Yes, No, Abort, Edit] '';
    COMPLETION_WAITING_DOTS = true;
    DISABLE_UNTRACKED_FILES_DIRTY = true;
    HYPHEN_INSENSITIVE = true;
    ZSH_THEME_VIRTUALENV_PREFIX = "⟨";
    ZSH_THEME_VIRTUALENV_SUFFIX = "⟩";
  };

  # Extra commands that should be added to .zshrc before compinit
  initExtraBeforeCompInit = ''
    fpath+="$ZDOTDIR/zfunc"
  '' + optionalString isDarwin ''
    whence brew &>/dev/null && fpath+=$(brew --prefix)/share/zsh/site-functions
  '';

  # Extra commands that should be added to .zshrc
  initExtra = ''
    export ZSH_PLUGINS_ALIAS_TIPS_TEXT='Found existing alias: '
    export ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES='_'
    # Tell z.lua where to store its data file    
    export _ZL_DATA="''${ZDOTDIR:-$XDG_CONFIG_HOME/zsh}/z.txt"
    # Tell z.lua which command-line fuzzy finder to use
    export _ZL_FZF='sk'
    export _ZL_FZF_FLAG='--no-sort'

    for fn in "$ZDOTDIR/zfunc"/*; do
      autoload $fn
    done

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _python-workon-cwd
    add-zsh-hook chpwd lsGF

    setopt NO_CASE_GLOB # Case-insensitive globbing
    setopt correct # Spell check

    source "${xdgDataHome}/broot/launcher/bash/1"
    source "${configFiles}/net.sourceforge.Zsh/omz/bookmark.zsh"
    [ -x "$ZDOTDIR/.zshrc.local" ] && source "$ZDOTDIR/.zshrc.local"
  '';

  # Plugins not available in Oh-My-Zsh
  plugins = [
    rec {
      name = "alias-tips";
      src = fetchFromGitHub {
        owner = "djui";
        repo = name;
        rev = "41cb143ccc3b8cc444bf20257276cb43275f65c4";
        hash = "sha256-ZFWrwcwwwSYP5d8k7Lr/hL3WKAZmgn51Q9hYL3bq9vE=";
      };
    }

    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = zsh-nix-shell;
    }
  ];

  shellAliases = {
    # Git aliases
    grm = "git rm";
    gmv = "git mv";

    # ls aliases
    lsdl = "lsd -lF --date relative";
    lsda = "lsd -aF";
    lsdla = "lsd -laF --date relative";
    lbr = "br -sdp";
    tree = "br --cmd :pt";
    ltree = "lsd --tree";
    ldot = "ls -ld .*";
    lab = "ls -AbFG";

    # Make some commands more verbose
    rm = "rm -v";
    mv = "mv -v";
    cp = "cp -v";
  } // optionalAttrs isLinux { diff = "diff --color --report-identical-files"; }
    // optionalAttrs isDarwin {
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
    "'TRUE?'" = "&& echo true || echo false";
  };

  # Configure Oh-My-Zsh
  oh-my-zsh = {
    # We want to use Oh-My-Zsh
    enable = true;

    # Needed for my custom "joeys-avit" theme below
    custom = "${xdgConfigHome}/zsh";

    # Which Oh-My-Zsh plugins to use
    plugins = [ "git" "gitignore" "cp" "virtualenv" ];

    theme = "joeys-avit";
  };
}
