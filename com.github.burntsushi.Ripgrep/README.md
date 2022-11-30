# ripgrep

There is a whole family of "better grep" command line tools: [Ack][ack], [the Silver Searcher][ag], [Universal Code Grep][ucg],
[the Platinum Searcher][pt], [Sift][sift], and, of course, [ripgrep]. To be honest, I didn't see anything wrong with the O.G.
grep, or, if you are in a git repo, [git grep], but there are two things that convinced me to use ripgrep.

First, [GitHub user phiresky][phiresky] crated a wrapper around ripgrep called [ripgrep-all][rga] that extends ripgrep to also
grep through rich media types like e-books, PDFs, ZIPs, tarballs, Word documents, and MP4 files. I thought this was pretty neat
&#x2014; I ended up not really using this, but it's still cool nonetheless.

Second, [GitHub user eth-p][eth-p] created a collection of Bash scripts to integrate [bat](../com.github.sharkdp.Bat/README.md)
with various other command line tools, one of which, "batgrep", basically pipes the output of ripgrep into bat to get
syntax-highlighted search results with context. I like it a lot better than the simple line-by-line output of grep, git grep, or plain ripgrep.

The config file in this directory just specifies some default command line flags to pass to ripgrep.

[ack]: https://beyondgrep.com/
[ag]: https://geoff.greer.fm/ag/
[ucg]: https://gvansickle.github.io/ucg/
[pt]: https://github.com/monochromegane/the_platinum_searcher
[sift]: https://sift-tool.org/
[ripgrep]: https://github.com/BurntSushi/ripgrep
[git grep]: https://git-scm.com/docs/git-grep
[phiresky]: https://github.com/phiresky/
[rga]: https://github.com/phiresky/ripgrep-all
[eth-p]: https://github.com/eth-p
