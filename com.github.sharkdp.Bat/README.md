# bat

[bat] is a combination of `cat` and `less` with support for syntax highlighting and gutter icons for showing line-by-line git statuses.
You wouldn't think it's as useful as it is until you realize there is no other way to get good syntax highlighting from the command
line. There is `view`, an alias for `vim` in read-only mode, but I have to first scroll the cursor to the bottom of my screen before
it starts scrolling the file, whereas with bat, and thus less, it starts scrolling the minute I press `j`.

Moreover, the utility of bat comes when you use [eth-p]'s collection of Bash scripts called [bat-extas] that integrate bat with
various other command line tools. Use bat to view man pages (`batman`), git diffs (`batdiff`), and pretty
[ripgrep](../com.github.burntsushi/Ripgrep/README.md) output (`batgrep`).

The config file in this directory just specifies some default command line flags to pass to bat.

[bat]: https://github.com/sharkdp/bat
[eth-p]: https://github.com/eth-p
[bat-extras]: https://github.com/eth-p/bat-extras
