# [tmux][tmux]

Tmux ("terminal multiplexer") implements window splitting and tabs and all that. I never really used Tmux because
most terminal emulators support tabs out of the box and windowing systems let you split windows and arrange them
on your dekstop in all sorts of arrangements, but Tmux has one more trick up its sleeve that you can't get with
windowing systems and terminal emulator tabs: it persists sessions between the creation and deletion of clients
due to a server running locally on a Unix socket. This is especially useful on servers, because if you lose your
SSH connection you can just log back in, reattach to a Tmux session, and none of your work is lost! Becuase of that
killer feature, I've begun curating a basix Tmux configuation.

[tmux]: https://tmux.github.io
