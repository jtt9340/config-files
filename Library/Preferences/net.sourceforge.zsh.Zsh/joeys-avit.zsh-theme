# Joey's AVIT ZSH Theme

# settings
typeset +H _current_dir="%{$fg_bold[cyan]%}%~%{$reset_color%} "
typeset +H _return_status="%{$fg_bold[red]%}%(?..⍉ (%?%))%{$reset_color%}"
typeset +H _hist_no="%{$fg[grey]%}%h%{$reset_color%}"

PROMPT='
$(_user_host)${_current_dir} $(git_prompt_info) $(ruby_prompt_info)
{%@@ if profile == "nixos" @@%}
$(prompt_nix_shell)%{%(!.%F{red}.%F{white})%}▶%{$resetcolor%} '
{%@@ else @@%}
%{%(!.%F{red}.%F{white})%}▶%{$resetcolor%} ' 
{%@@ endif @@%}

PROMPT2='%{%(!.%F{red}.%F{white})%}%_ ◀%{$reset_color%} '

RPROMPT='$(vi_mode_prompt_info)%{$(echotc UP 1)%}$(_git_time_since_commit) $(git_prompt_status) ${_return_status}%{$(echotc DO 1)%}'

{%@@ if profile == "nixos" @@%}
# Graciously taken from this custom agnoster theme: https://gist.github.com/chisui/0d12bd51a5fd8e6bb52e6e6a43d31d5e
function prompt_nix_shell() {
  if [[ -n "$IN_NIX_SHELL" ]]; then
    if [[ -n "$NIX_SHELL_PACKAGES" ]]; then
      local package_names=""
      local packages=($NIX_SHELL_PACKAGES)
      for package in $packages; do
        package_names+=" ${package##*.}"
      done
      echo "⟨$package_names ⟩ "
    elif [[ -n $name ]]; then
      local cleanName=${name#interactive-}
      cleanName=${cleanName%-environment}
      echo "⟨ $cleanName ⟩ "
    else # This case is only reached if the nix-shell plugin isn't installed or failed in some way
      echo "nix-shell ⟨⟩ "
    fi
  fi
}
{%@@ endif @@%}

function _user_host() {
  local me
  if [[ -n $SSH_CONNECTION ]]; then
    me="%n@%m"
  elif [[ $LOGNAME != $USER ]]; then
    me="%n"
  fi
  if [[ -n $me ]]; then
    echo "%{$fg[cyan]%}$me%{$reset_color%}:"
  fi
}

# Determine the time since last commit. If branch is clean,
# use a neutral color, otherwise colors will vary according to time.
function _git_time_since_commit() {
  local last_commit now seconds_since_last_commit
  local minutes hours days years commit_age
  # Only proceed if there is actually a commit.
  if last_commit=$(git log --pretty=format:'%at' -1 2> /dev/null); then
    now=$(date +%s)
    seconds_since_last_commit=$((now-last_commit))

    # Totals
    minutes=$((seconds_since_last_commit / 60))
    hours=$((minutes / 60))
    days=$((hours / 24))
    years=$((days / 365))

    if [[ $years -gt 0 ]]; then
      commit_age="${years}y$((days % 365 ))d"
    elif [[ $days -gt 0 ]]; then
      commit_age="${days}d$((hours % 24))h"
    elif [[ $hours -gt 0 ]]; then
      commit_age+="${hours}h$(( minutes % 60 ))m"
    else
      commit_age="${minutes}m"
    fi

    echo "${ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL}${commit_age}%{$reset_color%}"
  fi
}

MODE_INDICATOR="%{$fg_bold[yellow]%}❮%{$reset_color%}%{$fg[yellow]%}❮❮%{$reset_color%}"

# Git prompt settings
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%}✚ "
ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[yellow]%}⚑ "
ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%}✖ "
ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[blue]%}▴ "
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[cyan]%}§ "
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[white]%}◒ "

# Ruby prompt settings
ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[grey]%}"
ZSH_THEME_RUBY_PROMPT_SUFFIX="%{$reset_color%}"

# Colors vary depending on time lapsed.
ZSH_THEME_GIT_TIME_SINCE_COMMIT_SHORT="%{$fg[green]%}"
ZSH_THEME_GIT_TIME_SHORT_COMMIT_MEDIUM="%{$fg[yellow]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_LONG="%{$fg[red]%}"
ZSH_THEME_GIT_TIME_SINCE_COMMIT_NEUTRAL="%{$fg[white]%}"

# LS colors, made with https://geoff.greer.fm/lscolors/
export LSCOLORS='gxfxcxdxbxegedabagacad'
export LS_COLORS='di=36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
export GREP_COLOR='1;33'
