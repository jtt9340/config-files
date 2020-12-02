{ fetchFromGitHub
, configFiles
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

  # Where Zsh's dotfiles shall be located (this is to declutter the home directory)
  dotDir = ".config/zsh";

  # Where the .zsh_history file is saved
  history.path = ".local/share/zsh/zsh_history";

  # Environment variables that will be set for Zsh session
  sessionVariables = {
    EDITOR = "micro";    

    SPROMPT = "Correct $fg[red]%R$reset_color to $fg[green]%r$reset_color?\n\t[Yes, No, Abort, Edit] ";

    ZSH_PLUGINS_ALIAS_TIPS_TEXT = "Found existing alias: ";
    ZSH_PLUGINS_ALIAS_TIPS_EXCLUDES = "_";

    # Tell z.lua where to store its data file    
    _ZL_DATA = "$XDG_DATA_HOME/z.txt";

    # Tell z.lua which command-line fuzzy finder to use
    _ZL_FZF = "sk";
    _ZL_FZF_FLAG = "--no-sort";

    # I'm confused why there's a ~/.gtkrc-2.0 and a ~/.config/gtkrc-2.0
    GTK2_RC_FILES = "$XDG_CONFIG_HOME/gtk-2.0/gtkrc";

    # Move less' history file
    LESSKEY = "$XDG_CONFIG_HOME/less/lesskey";
    LESSHISTFILE = "$XDG_CACHE_HOME/less/history";

    # Tell Cargo where its files are
    CARGO_HOME = "$XDG_DATA_HOME/cargo";

    # This is where ripgrep's configuration file is
    RIPGREP_CONFIG_PATH = "$XDG_CONFIG_HOME/ripgreprc";
  };

  # Extra local variables defined at the top of .zshrc
  localVariables = {
    COMPLETION_WAITING_DOTS = true;
    DISABLE_UNTRACKED_FILES_DIRTY = true;
    HYPHEN_INSENSITIVE = true;
    ZSH_THEME_VIRTUALENV_PREFIX = "⟨";
    ZSH_THEME_VIRTUALENV_SUFFIX = "⟩";
  };

  # Extra commands that should be added to .zshrc
  initExtra = ''
    # Autoload functions
    fpath+=$ZDOTDIR/zfunc

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

    autoload -Uz add-zsh-hook
    add-zsh-hook chpwd _python-workon-cwd

    setopt NO_CASE_GLOB # Case-insensitive globbing
    setopt correct # Spell check

    # As far as I know you cannot set global aliases with home-manager so I
    # guess I gotta do it myself!
    alias -g C='| wc -l'
    alias -g H='| head'
    alias -g T='| tail'
    alias -g L='| less'
    alias -g G='| grep -n'
    alias -g NUL='> /dev/null 2>&1'
    alias -g 'TRUE?'='&& echo true || echo false'
    
    source $XDG_DATA_HOME/broot/launcher/bash/1
    source ${configFiles}/net.sourceforge.Zsh/bookmark.zsh
  '';

  # Plugins not available in Oh-My-Zsh
  plugins = [
    {
      name = "zsh-syntax-highlighting";
      src = fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "1715f39a4680a27abd57fc30c98a95fdf191be45";
        sha256 = "1kpxima0fnypl7fak4snxnf6nj36nvp1gqwpx1ailyrgxa8641j0";
      };
    }

    {
      name = "zsh-history-substring-search";
      src = fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-history-substring-search";
        rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
        sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
      };
    }

    {
      name = "alias-tips";
      src = fetchFromGitHub {
        owner = "djui";
        repo = "alias-tps";
        rev = "40d8e206c6d6e41e039397eb455bedca578d2ef8";
        sha256 = "17cifxi4zbzjh1damrwi2fyhj8x0y2m2qcnwgh4i62m1vysgv9xb";
      };
    }

    {
      name = "zsh-nix-shell";
      file = "nix-shell.plugin.zsh";
      src = fetchFromGitHub {
        owner = "chisui";
        repo = "zsh-nix-shell";
        rev = "v0.1.0";
        sha256 = "0snhch9hfy83d4amkyxx33izvkhbwmindy0zjjk28hih1a9l2jmx";
      };
    }
  ];

  shellAliases = {
    pbcopy = "xclip -sel clip";
    pbpaste = "xclip -o -sel clip";
    
    # ls aliases
    lsdl = "lsd -lF --date relative";
    lsda = "lsd -aF";
    lsdla = "lsd -laF --date relative";
    lbr = "br -sdp";
    tree = "br --cmd :pt";
    ltree = "lsd --tree";
    ldot = "ls -ld .*";

    # For quickly editing configuration files
    nixconfig = "sudo nixos-rebuild edit";
    vimconfig = "\${EDITOR:-vim} $HOME/.vimrc";
    brootconfig = "\${EDITOR:-vim} $XDG_CONFIG_HOME/broot/conf.toml";

    # Make some commands more verbose
    diff = "diff --color --report-identical-files";
    rm = "rm -v";
    mv = "mv -v";
    cp = "cp -v";
  };

  # Configure Oh-My-Zsh
  oh-my-zsh = {
    # We want to use Oh-My-Zsh
    enable = true;

    # Needed for my custom "joeys-avit" theme below
    custom = "\$XDG_CONFIG_HOME/zsh";

    # Which Oh-My-Zsh plugins to use
    plugins = [
      "git" "cargo" "virtualenv"
    ];
    
    theme = "joeys-avit";
  };
}
