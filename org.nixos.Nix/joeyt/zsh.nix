{ fetchFromGitHub # Function for cloning GitHub repositories
, configFiles     # The path to my "config-files" repo
, xdgConfigHome   # The path to $XDG_CONFIG_HOME
, xdgDataHome     # The path to $XDG_DATA_HOME
}:

# Configuration settings for Zsh
{
  # I guess I have to tell Home Manager again to enable Zsh?
  enable = true;

  # Automatically enter into a directory if typed directly into the shell
  autocd = true;

  # Fish-like autosuggestions
  enableAutosuggestions = true;

  # Enable completions is set at the global level when you do programs.zsh.enable, so we
  # need to diable it on a per-user level to prevent slow shell startup
  # (See this GitHub issue: https://github.com/rycee/home-manager/issues/108)
  enableCompletion = false;

  # Where Zsh's dotfiles shall be located, relative to $HOME
  dotDir = ".config/zsh";

  # Where the .zsh_history file is saved, again relative to $HOME
  history.path = ".local/share/zsh/zsh_history";

  # Environment variables that will be set for Zsh session
  sessionVariables = {
    EDITOR = "vim";    

    SPROMPT = "Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?\n\t[Yes, No, Abort, Edit] ";

    ZSH_PLUGINS_ALIAS_TIPS_TEXT = "Found existing alias: ";
    ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES = "_";

    # Specify GnuPG's configuration file despite the fact that I have not yet
    # installed GnuPG on NixOS
    GNUPGHOME = "${xdgDataHome}/gnupg";

    # Tell z.lua where to store its data file    
    _ZL_DATA = "${xdgDataHome}/z.txt";

    # Tell z.lua which command-line fuzzy finder to use
    _ZL_FZF = "sk";
    _ZL_FZF_FLAG = "--no-sort";

    # I'm confused why there's a ~/.gtkrc-2.0 and a ~/.config/gtkrc-2.0
    GTK2_RC_FILES = "${xdgConfigHome}/gtk-2.0/gtkrc";

    # Move less' history file
    LESSKEY = "${xdgConfigHome}/less/lesskey";
    LESSHISTFILE = "${xdgDataHome}/less/history";

    # Tell Cargo where its files are
    CARGO_HOME = "${xdgDataHome}/cargo";

    # This is where ripgrep's configuration file is
    RIPGREP_CONFIG_PATH = "${xdgConfigHome}/ripgreprc";
  };

  # Extra local variables defined at the top of .zshrc
  localVariables = {
    COMPLETION_WAITING_DOTS = true;
    DISABLE_UNTRACKED_FILES_DIRTY = true;
    HYPHEN_INSENSITIVE = true;
    ZSH_THEME_VIRTUALENV_PREFIX = "⟨";
    ZSH_THEME_VIRTUALENV_SUFFIX = "⟩";
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
  '';

  # Extra commands that should be added to .zshrc
  initExtra = ''
    # Autoload functions
    fpath+=$ZDOTDIR/zfunc

    # I cannot just write a "for fn in `ls $ZDOTDIR/zfunc`" loop here like I
    # normally can on other systems since those systems expect the functions
    # defined in $ZDOTDIR/zfunc to have already had the templates processed,
    # since zfunc is a symlink. On NixOS, zfunc is not a symlink but the entires
    # inside of it are, and those functions have not been templated. So I can
    # only manually autoload the function definitions that do not rely on Jinja
    # templating.
    autoload _python-workon-cwd
    autoload j
    autoload mkcd
    autoload print_array
    autoload rmmetadata

    # A function that allows ripgrep-all (rga) with skim (sk)
    function rga-sk {
      RG_PREFIX='rga --files-with-matches' 
    	local file
    	file="$(
        SKIM_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
          sk --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
            -q "$1" \
            --bind "change:reload:$RG_PREFIX {q}" \
            --preview-window="70%:wrap"
      )" &&
      echo "opening $file" &&
      xdg-open "$file"
    }

    # Cannot use lsGF defined in $ZDOTDIR/zfunc since that uses Jinja templating
    function lsGF {
      command ls --color --classify
    }

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _python-workon-cwd
    add-zsh-hook chpwd lsGF

    setopt NO_CASE_GLOB # Case-insensitive globbing
    setopt correct # Spell check

    source ${xdgDataHome}/broot/launcher/bash/1
    source ${configFiles}/net.sourceforge.Zsh/bookmark.zsh
  '';

  # Plugins not available in Oh-My-Zsh
  plugins = [
    rec {
      name = "zsh-syntax-highlighting";
      src = fetchFromGitHub {
        owner = "zsh-users";
        repo = name;
        rev = "0.7.1";
        sha256 = "039g3n59drk818ylcyvkciv8k9mf739cv6v4vis1h9fv9whbcmwl";
      };
    }

    rec {
      name = "zsh-history-substring-search";
      src = fetchFromGitHub {
        owner = "zsh-users";
        repo = name;
        rev = "v1.0.2";
        sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
      };
    }

    rec {
      name = "alias-tips";
      src = fetchFromGitHub {
        owner = "djui";
        repo = name;
        rev = "45e4e97ba4ec30c7e23296a75427964fc27fb029";
        sha256 = "1br0gl5jishbgi7whq4kachlcw6gjqwrvdwgk8l39hcg6gwkh4ji";
      };
    }

    rec {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = fetchFromGitHub {
        owner = "chisui";
        repo = name;
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }
  ];

  shellAliases = {
    # ls aliases
    lsdl = "lsd -lF --date relative";
    lsda = "lsd -aF";
    lsdla = "lsd -laF --date relative";
    lbr = "br -sdp";
    tree = "br --cmd :pt";
    ltree = "lsd --tree";
    ldot = "ls -ld .*";
    lab = "ls -AbFG";

    # For quickly editing configuration files
    nixconfig = "sudo nixos-rebuild edit";
    brootconfig = "\${EDITOR:-vim} ${xdgConfigHome}/broot/conf.toml";

    # Make some commands more verbose
    diff = "diff --color --report-identical-files";
    rm = "rm -v";
    mv = "mv -v";
    cp = "cp -v";
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
    plugins = [
      "git" "cp" "virtualenv"
    ];
    
    theme = "joeys-avit";
  };
}
