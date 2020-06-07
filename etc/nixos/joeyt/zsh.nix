fetchFromGitHub:

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

  # Extra commands that should be added to .zshenv
  envExtra = ''
    # Tell z.lua where to store its data file
    export _ZL_DATA="$HOME/.local/share/z.txt"
    # Tell Vim where its config file is
    export VIMINIT="source $HOME/.config/vim/vimrc"
    # Move KDE from ~/.kde to ~/.config/kde
    export KDEHOME="$HOME/.config/kde"
    # I'm confused why there's a ~/.gtkrc-2.0 and a ~/config/gtkrc-2.0
    export GTK2_RC_FILES="$HOME/.config/gtk-2.0/gtkrc"
    # Move less' history file
    export LESSKEY="$HOME/.cache/less/lesskey"
    export LESSHISTFILE="$HOME/.cache/less/history"
    # Move ~/.compose-cache to ~/.cache/X11/xcompose
    export XCOMPOSECACHE="$HOME/.cache/X11/xcompose"
    # Tell Cargo where its files are
    export CARGO_HOME="$HOME/.local/share/cargo"
  '';

  # Extra local variables defined at the top of .zshrc
  # localVariables = {};

  # Extra commands that should be added to .zshrc
  initExtra = ''
    # Run ls every time you cd
    function cd {
	builtin cd "$@" && ls
    }

    # This function will first try cd, and if cd fails then it will invoke z.lua
    function j {
	if [[ "$argv[1]" == "-"* ]]; then
	    x "$@"
	else
	    cd "$@" 2> /dev/null || z "$@"
	fi
    }

    source /home/joeyt/.local/share/broot/launcher/bash/1
  '';

  # Plugins not available in Oh-My-Zsh
  plugins = [
    {
      name = "zsh-syntax-highlighting";
      src = fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-syntax-highlighting";
        rev = "v0.7.1";
        sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
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
      name = "you-should-use";
      src = fetchFromGitHub {
        owner = "MichaelAquilina";
        repo = "zsh-you-should-use";
        rev = "v1.7.0";
        sha256 = "1gcxm08ragwrh242ahlq3bpfg5yma2cshwdlj8nrwnd4qwrsflgq";
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
    rm = "rm -v";
    mv = "mv -v";
    cp = "cp -v";
    nixconfig = "sudo nixos-rebuild edit";
    diff = "diff --color --report-identical-files";
    tree = "br --cmd :pt";
    ldot = "ls -ld .*";
  };

  # Configure Oh-My-Zsh
  oh-my-zsh = {
    # We want to use Oh-My-Zsh
    enable = true;

    # Needed for my custom "joeys-avit" theme below
    custom = "\$HOME/.config/zsh";

    # Which Oh-My-Zsh plugins to use
    plugins = [
      "git" "cargo"
    ];
    theme = "joeys-avit";
  };
}
