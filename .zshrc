export LANG=ja_JP.UTF-8

# User configuration
setopt nonomatch

export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

eval "$(/opt/homebrew/bin/brew shellenv)"

# mise configuration - a Rust-based polyglot runtime version manager for efficient language version management
eval "$(mise activate zsh)"
export PATH="$HOME/.local/share/mise/shims:$PATH"

# Tool that wraps git
eval "$(hub alias -s)"

# IntelliJ IDEA Launcher
export PATH="/usr/local/bin/idea:$PATH"

# Vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'

# php
export PATH="/opt/homebrew/opt/php@8.2/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.2/sbin:$PATH"
export PATH=$PATH:/opt/homebrew/opt/php/bin
export PATH=$PATH:"~/.composer/vendor/bin"
export PATH=$PATH:"$HOME/pear/bin"

# Rust lang's compiler and pkg manager
export PATH="$HOME/.cargo/bin:$PATH"
source "$HOME/.cargo/env"

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/usr/local/go/bin

# Protobuf
export PATH=$PATH:/usr/local/bin/protoc

# Terraform
export PATH="${HOME}/.local/share/mise/installs/terraform/1.8.4/bin:$PATH"

# Flutter
export PATH="$PATH:$HOME/development/flutter/bin"

# direnv
eval "$(direnv hook zsh)"

# jump
eval "$(jump shell zsh)"

# Google Cloud SDK.
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
      source "$HOME/google-cloud-sdk/path.zsh.inc";
fi

if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
      source "$HOME/google-cloud-sdk/completion.zsh.inc";
fi

export CLICOLOR=1
export LSCOLORS=DxGxcxdxCxegedabagacad

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

# 履歴から自動補完
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# cdコマンド省略
setopt auto_cd

# 自動でpushdを実行
setopt auto_pushd

# pushdから重複を削除
setopt pushd_ignore_dups

# cdの後にexaを実行
chpwd() { exa --color-scale --git --git-ignore --time-style=iso -@ -a -B -T -F -h -l -L=1 }

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
PROMPT='%m:%F{green}%~%f %n %F{yellow}
$%f '
RPROMPT='${vcs_info_msg_0_}'

# alias
alias md="mkdir"
alias cls="clear"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ls='exa --color-scale --git --git-ignore --time-style=iso -@ -a -B -T -F -h -l -L=1'
alias ll='exa --color-scale --git --git-ignore --time-style=iso -@ -a -B -T -F -h -l -L=1'
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
alias dps="docker ps"
alias compose="docker compose"
alias cps="docker compose ps"
alias cu="docker compose up"
alias cud="docker compose up -d"
alias cdk="nocorrect cdk"
alias cdn="docker compose down"
alias pl="git pull"
alias push="git push"
alias commit="git commit"
alias diff="git diff"
alias gco="git checkout"
alias ga="git add"
alias gl="git log"
alias gpl="git log --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s %C(red)%d %C(cyan)[%an]' --date=iso"
alias gb="git branch"
alias gf="git fetch"
alias gs="git switch"
alias gr="git restore"
alias gcp="git cherry-pick"
alias gbd="git branch | grep -v 'master\|staging\|develop' | xargs git branch -D"

# Modern GUI for Redis
alias medis="cd /Applications/medis && nohup npm start &>/dev/null &"

# For kubectl_aliases
source <(kubectl completion zsh)
alias k=kubectl
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases

# Search in zshell history
function select-history() {
  BUFFER=$(history -n 1 | awk '!a[$0]++' | fzf --exact --no-sort +m --query "$LBUFFER" --prompt="History > ")
  CURSOR=$#BUFFER
}
zle -N select-history
bindkey '^r' select-history

# tabtab source for serverless package
# uninstall by removing these lines or running `tabtab uninstall serverless`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/serverless.zsh
# tabtab source for sls package
# uninstall by removing these lines or running `tabtab uninstall sls`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/sls.zsh
# tabtab source for slss package
# uninstall by removing these lines or running `tabtab uninstall slss`
[[ -f /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh ]] && . /usr/local/lib/node_modules/serverless/node_modules/tabtab/.completions/slss.zsh

function ghqcd {
  args=()
  if [ $# -ne 0 ]; then
    match=`ghq list | grep $1`
    if [ `echo $match | wc -l` -eq "1" ]; then
      cd $(ghq root)/${match}
      return
    fi
    args=("--query" "$1")
  fi
  cd $(ghq root)/$(ghq list | peco ${args[@]})
}
function _ghqcd {
  arr=($(ghq list | grep -o -e "${words[CURRENT]}.*$"))
  _values Directories ${arr[@]}
}
compdef _ghqcd ghqcd

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh" || true

set-awssession-token() {
    profile_name=$1
    code=$2

    mfa_device=$(awk '/'$profile_name'/{flag=1;next}/\[/{flag=0}flag' ~/.aws/config | grep mfa-device | cut -f 3 -d " ")
    session_token=$(aws sts get-session-token --serial-number $mfa_device --token-code $code --profile $profile_name)
    export AWS_ACCESS_KEY_ID=$(echo $session_token | jq -r .Credentials.AccessKeyId)
    export AWS_SECRET_ACCESS_KEY=$(echo $session_token | jq -r .Credentials.SecretAccessKey)
    export AWS_SESSION_TOKEN=$(echo $session_token | jq -r .Credentials.SessionToken)
}

# pnpm
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
