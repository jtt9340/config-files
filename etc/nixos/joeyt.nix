{ lib, pkgs, ... }:

{
  programs = {
    # Let Home Manager install and manage things
    home-manager.enable = true;

    # Configure Zsh
    zsh = {
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

      # Environment variables that will be set for zsh session
      sessionVariables = {
        EDITOR = "vim";
        # Tell z.lua where to store its data file
        _ZL_DATA = "\$HOME/.local/share/z.txt";
        # Tell Vim where its config file is
        VIMINIT = "source \$HOME/.config/vim/vimrc";
      };

      # Extra local variables defined at the top of .zshrc
      # localVariables = {};

      # Extra commands that should be added to .zshrc
      initExtra = ''
        RPS1=%(?.%F{green}%?%f.%F{red}%?%f)

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
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-syntax-highlighting";
            rev = "v0.7.1";
            sha256 = "0zmq66dzasmr5pwribyh4kbkk23jxbpdw4rjxx0i7dx8jjp2lzl4";
          };
        }

        {
          name = "zsh-history-substring-search";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-history-substring-search";
            rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
            sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
          };
        }

        {
          name = "you-should-use";
          src = pkgs.fetchFromGitHub {
            owner = "MichaelAquilina";
            repo = "zsh-you-should-use";
            rev = "v1.7.0";
            sha256 = "1gcxm08ragwrh242ahlq3bpfg5yma2cshwdlj8nrwnd4qwrsflgq";
          };
        }
      ];

      shellAliases = {
        rm = "rm -v";
        mv = "mv -v";
        nixconfig = "sudo nixos-rebuild edit";
      };

      # Configure Oh-My-Zsh
      oh-my-zsh = {
        # We want to use Oh-My-Zsh
        enable = true;

        # Which Oh-My-Zsh plugins to use
        plugins = [
          "git" "cargo"
        ];
        theme = "pygmalion";
      };
    };

    # Git config
    git = import ./joey-git.nix;

    # Use z-lua, a program that remembers your most frequently cd-ed to directories to make
    # it easier to cd to them
    z-lua = {
      enable = true;
      enableFishIntegration = false;
      enableAliases = true;
    };
  };

  home.packages = with pkgs; [
    broot thunderbird bitwarden lua
  ];
}
