# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

## Setup Zim
ZIM_HOME=~/.zim

## Download zimfw plugin manager if missing.
if [[ ! -e ${ZIM_HOME}/zimfw.zsh ]]; then
  if (( ${+commands[curl]} )); then
    curl -fsSL --create-dirs -o ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  else
    mkdir -p ${ZIM_HOME} && wget -nv -O ${ZIM_HOME}/zimfw.zsh \
        https://github.com/zimfw/zimfw/releases/latest/download/zimfw.zsh
  fi
fi

## Install missing modules, and update ${ZIM_HOME}/init.zsh if missing or outdated.
if [[ ! ${ZIM_HOME}/init.zsh -nt ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  source ${ZIM_HOME}/zimfw.zsh init -q
fi

## Initialize modules.
source ${ZIM_HOME}/init.zsh

# Config fzf-tab
zstyle -d ':completion:*' format # rm old format
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# set list-colors to enable filename colorizing
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
# preview directory's content with exa when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

## Prompt
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH flags
setopt auto_cd
setopt multios
setopt prompt_subst

# Set locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Update $PATH.
export PATH=$HOME/src/scripts:/opt/homebrew/bin:/opt/homebrew/sbin:/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/bin:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/opt/python/libexec/bin:$PATH
export SRCPATH=/Users/david/src

# Python config
alias python='python3'
export PYTHONPATH=$SRCPATH/github

# Go config
export PATH="$PATH:$(go env GOPATH)/bin"

# Android, Flutter config
export PATH=$PATH:$SRCPATH/github/flutter/bin

# Set misc env variables
export PBCAT_PROTO_ROOT=/Users/david/src/github/deal-radar
export CARGO_TARGET_DIR=/Users/david/.cargo-target

## Misc configs
# colored man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
HIST_STAMPS="yyyy-mm-dd"         # Change the command execution timestamp shown in te history command output
setopt bang_hist                 # Treat the '!' character specially during expansion.
setopt extended_history          # Write the history file in the ":start:elapsed;command" format.
setopt inc_append_history        # Write to the history file immediately, not when the shell exits.
setopt share_history             # Share history between all sessions.
setopt hist_expire_dups_first    # Expire duplicate entries first when trimming history.
setopt hist_ignore_dups          # Don't record an entry that was just recorded again.
setopt hist_ignore_all_dups      # Delete old recorded entry if new entry is a duplicate.
setopt hist_find_no_dups         # Do not display a line previously found.
setopt hist_ignore_space         # Don't record an entry starting with a space.
setopt hist_save_no_dups         # Don't write duplicate entries in the history file.
setopt hist_reduce_blanks        # Remove superfluous blanks before recording entry.
setopt hist_verify               # Don't execute immediately upon history expansion.
setopt hist_beep                 # Beep when accessing nonexistent history.

# Key-bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[OA' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[OB' history-substring-search-down

# Helper
command_exists () {
     command -v $1 >/dev/null 2>&1; 
}

# Aliases

## Aliases for cli-utils
if command_exists exa; then
    alias la='exa -abghl --git --color=automatic'
fi

if command_exists bat; then
    alias preview="fzf --preview 'bat --color \"always\" {}'"
    alias cat='bat'
    alias less='bat --style=snip,header --color=always'
fi
if command_exists dua; then
    alias du="dua interactive"
fi
alias wcl='rg ".*" --count'
alias rm='safe-rm'
alias unsafe-rm='\rm'
### Log file highlighting in `tail`
_tail() { tail "$@" | bat --paging=never -l log }
alias tail='\_tail' # \ to avoid recursion
##

## Misc aliases
alias tedit="code"
alias brewit='brew update && brew upgrade && brew cleanup; brew doctor'
alias gst='git status --short --untracked-files=no'
#__json_cmp(){
#jq --argfile a $1 --argfile b $2 -n '($a | walk(if type == "array" then sort else . end)) as $a | ($b | walk(if type == "array" then sort else . end)) as $b | $a == $b'
#}
#alias json_cmp='__json_cmp'
alias vdj='vd -f=jsonl'
alias zshrc='vim ~/.zshrc'

# Init jenv
export PATH="$HOME/.jenv/bin:$PATH"
if which jenv > /dev/null; then eval "$(jenv init -)"; fi

# Init pyenv-virtualenv
if which pyenv > /dev/null; then eval "$(pyenv init --path)"; eval "$(pyenv init - --no-rehash)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init - | sed s/precmd/chpwd/g)"; fi

export PATH=/Users/david/.local/bin:$PATH

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# Misc Kubectl cfg
export USE_GKE_GCLOUD_AUTH_PLUGIN=True

# Init Zoxide
eval "$(zoxide init zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
