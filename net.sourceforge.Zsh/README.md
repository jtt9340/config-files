# Zsh

[Zsh][zsh] is a UNIX shell with syntax similar to and compatible with Bash. It has lots of features that
let you do all sorts of crazy things. Most people aren't intimately familiar with the inner workings of Zsh.
However, some Zsh wizards have leveraged Zsh's features to add syntax highlighting at the command line,
interactive fuzzy search in history, autosuggestions for commands, and more. This is what everyone uses
when they use Zsh, and it's gotten so out of control Zsh users started writing programs to download and
install Zsh scripts that add this functionality for you and call them "plugin managers". Then we started
writing more plugin managers because the already existing ones weren't sufficient, and now
[there is a whole discussion on Reddit](https://www.reddit.com/r/zsh/comments/ak0vgi/a_comparison_of_all_the_zsh_plugin_mangers_i_used)
about which plugin manager to use: which is the easiest, which is the most featureful, which is the fastest, etc.

Zsh is definitely the C++ of UNIX shells: complicated to get started with, but once you get used to it and
leverage its features, it becomes very powerful.

## Decisions, decisions
For a long time I used [Oh My Zsh][omz], a framework that makes it easy to get started with. Oh My Zsh comes with
its own suite of plugins that you can choose from, but installing plugins not included in Oh My Zsh is a little
tricky if you want a reproducible, declarative Zsh configuration. This is because installing such plugins involves cloning
the repos of the plugins into a custom plugins directory. Thus, if you want to make your Zsh configuration easily
deployable to new machines, you either have to add the repos you clone as Git submodules or write a script that
will clone them for you...which sounds a lot like what a plugin manager does! So I switched to Zgen which has now
become [Zgenom][zgenom] since it still included support for Oh My Zsh but also made it easy to delcare plugins
external to Oh My Zsh. It takes care of the cloning and updating for you -- all you have to do is specify what
plugins you want installed.

There have been some complaints that Oh My Zsh is "bloated": it slows down your shell initialization time and hides
Zsh's internals behind a bunch of abstractions. It's easier to know what options are enabled and what gets sourced
when you roll your own configuration, so for a while I have been trying to move to my own, minimal, configuration.
I'm still in the transitionary phase and so both versions of my Zsh configuration here. I still use Zgenom for both.
Look in the [omz](omz) directory for my Oh My Zsh configuration and in the [minimal](minimal) directory for my
Zsh confguration that does __not__ use Oh My Zsh.

What follows in this README is a description of each file common to both versions of the Zsh configuration.
Look in the READMEs in the subdirectories for what's specific to each one.

## [`.zshenv`](omz/.zshenv)
This file is always sourced, so it is best to keep it minimal. Mine just sets some environment variables.

## [`.zprofile`](omz/.zprofile)
This file is sourced when Zsh is started as a login shell. Mine just sets some more environment variables
that I felt didn't need to be set in `.zshenv`.

## [`.zshrc`](omz/.zprofile)
This is the meat and potatoes of my Zsh configuration. `.zshrc` is sourced on every interactive shell. See
the READMEs in the subdirectories for more detail on what exactly this file does.

## [`aliases.zsh`](omz/aliases.zsh)
Shell aliases go here, to keep them all organized into a single file.

## [`bookmark.zsh`](omz/bookmark.zsh)
This file is sourced by `.zshrc` and adds a directory bookmark mechanism. When in a directory you want to bookmark, run

```zsh
bookmark .
```

to use the current directory's name as the bookmark name, or

```zsh
bookmark <name>
```

to bookmark the current directory under the name `<name>`.

To view all current bookmarks, just run the `bookmark` command without any command line options.

To go to a bookmarked directory, type `~` and then the name of the bookmark. For example, I often create
a bookmark called `config-files` pointing to where I clone my config-files repo. Then, to go to it I simply type

```zsh
~config-files
```

and hit enter.

### [`zfunc`](omz/zfunc)
Zsh has the notion of [autoloaded functions](https://zsh.sourceforge.io/Doc/Release/Functions.html#Autoloading-Functions).
Instead of defining a function directly in, say, your `.zshrc`, you place your function in a file
in a directory listed in the `$fpath` variable (note that you can add directories to this variable
with the `$fpath+=` syntax). The name of the file is the name of themfunction you are defining with
no extension. Then, in your `.zshrc` add

```zsh
autoload <function-name>
```

The benefit to autoloading functions rather than defining them directly in your `.zshrc` is that they are lazy
loaded &#x2014; the function code will not be read and compiled to bytecode until the first time you call it.
The only downside to this method is that you cannot see the source code of a function with the `functions` command
until after you call it at least once.

The [`zfunc`](omz/zfunc) directory contains many functions I autoload that I find useful. I think the most important one
to point out is `_python-workon-cwd`. In addition to lazy loading, Zsh uses function autoloading for command completions
and shell hooks &#x2014; functions that are invoked on a certain event. One such event is when the current directory changes.
This function looks for a `.venv` file and, if present, activates the Python virtual environment named in that file. The
virtual environment is automatically deactivated upon leaving the directory.

[zsh]: https://zsh.sourceforge.io/
[omz]: https://ohmyz.sh
[zgenom]: https://github.com/jandamm/zgenom
