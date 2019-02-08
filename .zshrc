# Environment variable
export LANG=ja_JP.UTF-8

#User configuration
setopt nonomatch
 
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# php
export PATH=$PATH:"~/.composer/vendor/bin"
export PATH=$PATH:"$HOME/pear/bin"

# added by Anaconda3 5.1.0 
export PATH="$HOME/anaconda3/bin:$PATH"

# Vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
export PATH=$PATH:$HOME/.nodebrew/current/bin

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
      source "$HOME/google-cloud-sdk/path.zsh.inc";
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
      source "$HOME/google-cloud-sdk/completion.zsh.inc";
fi

export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

# disable in future release
export PYENV_VIRTUALENV_DISABLE_PROMPT=1
export PATH="$HOME/.anyenv/bin:$PATH"

# ヒストリの設定
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# 直前のコマンドの重複を削除
setopt hist_ignore_dups
# 同じコマンドをヒストリに残さない
setopt hist_ignore_all_dups
# 同時に起動したzshの間でヒストリを共有
setopt share_history

# 補完機能を有効にする
autoload -Uz compinit
compinit -u
if [ -e /usr/local/share/zsh-completions ]; then
    fpath=(/usr/local/share/zsh-completions $fpath)
    fi
# 補完で小文字でも大文字にマッチさせる
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補を詰めて表示
    setopt list_packed
# 補完候補一覧をカラー表示
    zstyle ':completion:*' list-colors ''

# cdコマンド省略
setopt auto_cd

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups

# cdの後にlsを実行
chpwd() { ls -lha }

# コマンドのスペルを訂正
setopt correct
# ビープ音を鳴らさない
setopt no_beep

# prompt
autoload -Uz vcs_info
setopt prompt_subst
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%F{magenta}!"
zstyle ':vcs_info:git:*' unstagedstr "%F{yellow}+"
zstyle ':vcs_info:*' formats "%F{cyan}%c%u[%b]%f"
zstyle ':vcs_info:*' actionformats '[%b|%a]'
precmd() { vcs_info }
PROMPT='%m:%F{green}%~%f %n %F{yellow}$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ls='ls -aF'
alias ll='ls -l'
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'
alias vi='vim'
alias cat='cat -n'
alias less='less -NM'
alias bat="nocorrect bat"
alias npm="nocorrect npm"
alias tree="nocorrect tree"
alias tree="pwd;find . | sort | sed '1d;s/^\.//;s/\/\([^/]*\)$/|--\1/;s/\/[^/|]*/| /g'"
alias bat="nocorrect bat"
alias compose=docker-compose

source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

# For kubectl_aliases
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

