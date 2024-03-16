{ zsh, xsel, wl-clipboard, isDarwin, concatStrings }:

let
  copyCmd = if isDarwin then
    "pbcopy"
  else
    concatStrings [
      ''if [ -n "''${WAYLAND_DISPLAY:-}" ]; then''
      "  ${wl-clipboard}/bin/wl-copy"
      "else"
      "  ${xsel}/bin/xsel --clipboard --input"
      "fi"
    ];
in {
  enable = true;
  shell = "${zsh}/bin/zsh";
  terminal = "tmux-256color";
  shortcut = "w";
  keyMode = "vi";
  baseIndex = 1;
  mouse = true;
  newSession = true;
  secureSocket = true;
  sensibleOnTop = false;
  historyLimit = 5000;
  extraConfig = ''
    set-option -sa terminal-overrides ",xterm*:Tc"

    # Graciously taken from christoomey/vim-tmux-navigator
    is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?(g?(view|l?n?vim?x?)(diff)?)|vim-wrapped$'"
    bind-key   -r h if-shell "$is_vim" "send-keys C-w h" "select-pane -L"
    bind-key   -r j if-shell "$is_vim" "send-keys C-w j" "select-pane -D"
    bind-key   -r k if-shell "$is_vim" "send-keys C-w k" "select-pane -U"
    unbind-key    l
    bind-key   -r l if-shell "$is_vim" "send-keys C-w l" "select-pane -R"

    bind-key -r H resize-pane -L
    bind-key -r J resize-pane -D
    bind-key -r K resize-pane -U
    bind-key -r L resize-pane -R

    bind-key -T copy-mode-vi v send-keys -X begin-selection
    bind-key -T copy-mode-vi V send-keys -X select-line
    bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel '${copyCmd}'
    bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel '${copyCmd}'

    unbind-key c
    bind-key   c new-window -c "#{pane_current_path}"

    set-option -g renumber-windows on

    bind-key v split-window -h -c "#{pane_current_path}"
    bind-key g split-window -v -c "#{pane_current_path}"
    bind-key V select-layout even-horizontal
    bind-key G select-layout even-vertical

    bind-key -T copy-mode-vi WheelUpPane   send-keys -N 1 -X scroll-up
    bind-key -T copy-mode-vi WheelDownPane send-keys -N 1 -X scroll-down

    set-option -g status-right "\"#{pane_title}\" %a %b %d %I:%M %p"
  '';
}
