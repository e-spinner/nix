
# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[[ ! -d "$ZINIT_HOME" ]] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

eval "$(oh-my-posh init zsh --config $HOME/.config/ohmyposh/omp.toml)"

# plugins
zinit wait"0" lucid light-mode for \
    zsh-users/zsh-syntax-highlighting \
    zsh-users/zsh-completions \
    zsh-users/zsh-autosuggestions \
    Aloxaf/fzf-tab \
    OMZP::sudo

# load completions
autoload -Uz compinit
for dump in "${ZDOTDIR:-$HOME}/.zcompdump"(N.mh+24); do
  compinit
done
compinit -C
zinit cdreplay -q

if [[ -z "$_FZF_LOADED" ]]; then
    eval "$(fzf --zsh)"
    eval "$(zoxide init --cmd cd zsh)"
    export _FZF_LOADED=1
fi

bindkey -e
bindkey ' ' magic-space

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias c='clear'
alias -s md='bat'
# Redirect stderr to /dev/null
alias -g NE='2>/dev/null'
# Redirect stdout to /dev/null
alias -g NO='>/dev/null'
# Redirect both stdout and stderr to /dev/null
alias -g NUL='>/dev/null 2>&1'
# Copy output to clipboard (Linux with xclip)
alias -g C='| xclip -selection clipboard'

# hooks
autoload -Uz add-zsh-hook

function auto_venv() {
  # If already in a virtualenv, do nothing
  if [[ -n "$VIRTUAL_ENV" && "$PWD" != *"${VIRTUAL_ENV:h}"* ]]; then
    deactivate
    return
  fi

  [[ -n "$VIRTUAL_ENV" ]] && return

  local dir="$PWD"
  while [[ "$dir" != "/" ]]; do
    if [[ -f "$dir/.venv/bin/activate" ]]; then
      source "$dir/.venv/bin/activate"

      return
    fi
    dir="${dir:h}"
  done
}

function chpwd_ls() {
  command ls --color
}

add-zsh-hook chpwd auto_venv
add-zsh-hook chpwd chpwd_ls