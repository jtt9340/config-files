# [Vim][vim]
This is my `.vimrc`. I've commented each section of commands explaining what they do, so hopefully
the file is self-explanatory enough to see what each command does.

I have an obsession with [minimizing the amount of config files directly in my home directory][xdg-base-directory].
Unfortunately, Vim places its files all over the place by default and does not make it easy to change that. What I ended up having to do was:
- export the `VIMINIT` environment variable in [my Zsh configuration][zshconfig].
  The value of this variable is a Vim command to run on startup, which you can use to direct Vim
  to an alternate location for your `.vimrc`
- set different parameters in my `.vimrc` to further tell Vim where to put, e.g. swap files and the like.

## Plugins
Vim is another program that many people use without being intimately familar (enough) with
its inner workings to be able to add in the functionality they want, thus relying on other
Vim wizards' knowledge to package up cool features into self-contained plugins, which of course
can be managed by one out of the plethora of Vim package managers out there. I used to use Vim's
built-in plugin manager (see `:help packages` in Vim) but recently I wanted to try out [Dein][dein].
With a plugin manager like Dein, the plugins I use are declaratively specified in my `.vimrc` rather
than as Git submodules. This means that plugins are not pinned to specific commits, which requires separate
commits just to update each plugin to its latest version. A plugin manager like Dein also makes
it easier to implement more sophisticated logic for lazy-loading plugins, such as "don't load this plugin
until this ex command is run".

[vim]: https://www.vim.org
[xdg-base-directory]: https://wiki.archlinux.org/title/XDG_Base_Directory
[zshconfig]: ../net.sourceforge.Zsh/README.md
[dein]: https://github.com/Shougo/dein.vim
