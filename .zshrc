# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

## Load synchronously to avoid alias clash
zinit light-mode for \
    OMZL::git.zsh \
    OMZP::git

## Load Oh-My-Zsh plugins
zinit wait lucid light-mode for \
    zsh-users/zsh-history-substring-search \
    OMZP::fzf \
    OMZP::command-not-found \
    OMZP::colored-man-pages \
  as'command' pick'bin/git-fuzzy'	\
    bigH/git-fuzzy

export GIT_FUZZY_STATUS_ADD_KEY="Right"
export GIT_FUZZY_STATUS_RESET_KEY="Left"
export GIT_FUZZY_STATUS_RESET_KEY="Ctrl-X"

# Fast-syntax-highlighting & autosuggestions
zinit wait lucid for \
 atinit"ZINIT[COMPINIT_OPTS]=-C; zpcompinit; zpcdreplay" \
    zdharma/fast-syntax-highlighting \
 atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
 blockf \
    zsh-users/zsh-completions

zinit wait lucid light-mode as"completion" for \
    OMZP::brew \
    OMZP::pip \
    OMZP::python \
    OMZP::docker/_docker \
    OMZP::docker-compose
    
## Load programs/binaries
zinit wait lucid from"gh-r" as"null" for \
     sbin"fzf"          junegunn/fzf-bin \
     sbin"**/fd"        @sharkdp/fd \
     sbin"**/bat"       @sharkdp/bat \
     sbin"exa* -> exa"  ogham/exa \
     sbin"**/dua"       Byron/dua-cli \
     sbin"**/rg"        BurntSushi/ripgrep \
  atload'unalias zi; eval "$(zoxide init zsh)"' \
     sbin"zoxide* -> zoxide" ajeetdsouza/zoxide

## Prompt
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
zinit ice depth=1; zinit light romkatv/powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ZSH flags
setopt auto_cd
setopt multios
setopt prompt_subst

# Set locales
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Update $PATH.
export PATH=$PATH:$HOME/src/scripts:/usr/local/bin:/usr/local/sbin:~/bin:/usr/local/opt/python/libexec/bin
export SRCPATH=/Users/david/src

# Python config
alias python='python3'
export PYTHONPATH=$SRCPATH/github

# Go config
export GOPATH=$HOME/golang
export GOBIN=$GOPATH/bin
export GOROOT=/usr/local/opt/go/libexec
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:$GOROOT/bin

# Android, Flutter config
export PATH=$PATH:$SRCPATH/github/flutter/bin

# Set misc env variables
export PBCAT_PROTO_ROOT=/Users/david/src/github/deal-radar
export CARGO_TARGET_DIR=/Users/david/.cargo-target

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
bindkey '^[[B' history-substring-search-down

# Aliases
alias tedit="open -a Visual\ Studio\ Code"
alias brewit='brew update && brew upgrade && brew cleanup; brew doctor'
alias la='exa -abghl --git --color=automatic'
alias preview="fzf --preview 'bat --color \"always\" {}'"
# Requires `brew install bat`.
alias cat='bat'
alias less='bat --pager "$PAGER $LESS" --style=snip,header --color=always'
# Brew install dua
alias du="dua interactive" #"ncdu --color dark -rr -x --exclude .git --exclude node_modules"
__json_cmp(){
jq --argfile a $1 --argfile b $2 -n '($a | walk(if type == "array" then sort else . end)) as $a | ($b | walk(if type == "array" then sort else . end)) as $b | $a == $b'
}
alias gst='git status --short --untracked-files=no'
alias json_cmp='__json_cmp'
alias vdj='vd -f=jsonl'
alias wcl='rg ".*" --count'
alias zshrc='vim ~/.zshrc'
# Log file highlighting in `tail`
_tail() { tail "$@" | bat --paging=never -l log }
alias tail='\_tail' # \ to avoid recursion

# Init jenv
export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"

# Init pyenv-virtualenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

export PATH=/Users/david/.local/bin:$PATH
