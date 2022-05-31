# [Vim](https://www.vim.org)
This is my `.vimrc`. I've commented each section of commands explaining what they do, so hopefully
the file is self-explanatory enough to see what each command does.

I have an obsession with [minimizing the amount of config files directly in my home directory](https://wiki.archlinux.org/title/XDG_Base_Directory).
Unfortunately, Vim places its files all over the place by default and does not make it easy to change that. What I ended up having to do was:
- export the `VIMINIT` environment variable in [my zsh configuration](../net.sourceforge.Zsh/README.md).
  The value of this variable is a Vim command to run on startup, which you can use to direct Vim
  to an alternate location for your `.vimrc`
- set different parameters in my `.vimrc` to further tell Vim where to put, e.g. swap files and the like.

## Plugins
Vim is another program that many people use without being intimately familar (enough) with
Vim Script to add in the functionality they want, thus relying on other Vim wizards' knowledge
to package up their cool features into self-contained plugins, to be managed by a Vim plugin
manager, of which there is no shortage. I'm already tired of researching different Zsh plugin
managers and am not ready to commit to choosing a Vim plugin manager and porting my `.vimrc` over
to it. Fortunately, the latest versions of Vim have built-in support for plugin management through
the notion of "packages", which I have included in my config files repo in the form of
[git submodules]. They are not cloned by default. You can include them when cloning this
repository by passing the `--recursive` flag to `git clone`, or, if you have already cloned this
repostiory, by later running

```bash
git submodule update --init
```

Git submodules are pinned at a specific commit. To update them to the latest commit for
each respective repository, run

```bash
git submodule update --remote --merge
```

This will show as unstaged changed that can be commited as a commit that updates all the Vim
plugins to a specific version.

The plugins I currently use are:

- [**preservim/nerdtree**][nerdtree]: File browser right inside of Vim 
- [**Xuyuanp/nerdtree-git-plugin**][nerdtree-git-plugin]: Adds icons next to each of the files displayed in the NERDTree
  file browser according to their git statuses
- [**airblade/vim-gitgutter**][vim-gitgutter]: Shows ASCII icons in the gutter for lines that have been added, removed, or
  changed since the last git commit
- [**cespare/vim-toml**][vim-toml]: [TOML][toml] syntax highlighting for Vim
- [**LnL7/vim-nix**][vim-nix]: Nix expression syntax highlighting for Vim

[git submodules]: https://git-scm.com/docs/git-submodule
[nerdtree]: https://github.com/preservim/nerdtree
[nerdtree-git-plugin]: https://github.com/Xuyuanp/nerdtree-git-plugin
[vim-gitgutter]: https://github.com/airblade/vim-gitgutter
[vim-toml]: https://github.com/cespare/vim-toml
[toml]: https://toml.io
[vim-nix]: https://github.com/LnL7/vim-nix
