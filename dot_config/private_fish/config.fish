set -x LANG ja_JP.UTF-8

fish_add_path /usr/local/bin
fish_add_path /usr/local/sbin
fish_add_path /opt/homebrew/bin
fish_add_path /opt/homebrew/sbin
fish_add_path $HOME/.local/share/mise/shims
fish_add_path /usr/local/bin/idea
fish_add_path /opt/homebrew/opt/php@8.2/bin
fish_add_path /opt/homebrew/opt/php@8.2/sbin
fish_add_path $HOME/.composer/vendor/bin
fish_add_path $HOME/pear/bin
fish_add_path $HOME/.cargo/bin
fish_add_path $HOME/go/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/bin/protoc
fish_add_path $HOME/.local/share/mise/installs/terraform/1.8.4/bin
fish_add_path $HOME/development/flutter/bin
fish_add_path $HOME/google-cloud-sdk/bin

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# mise
mise activate fish | source

# hub
eval (hub alias -s)

# jump
status --is-interactive; and source (jump shell fish | psub)

# Editor
set -x EDITOR /Applications/MacVim.app/Contents/MacOS/Vim

# Golang
set -x GOPATH $HOME/go

# direnv
direnv hook fish | source

# basic aliase
alias md "mkdir"
alias cls "clear"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias ..... "cd ../../../.."
alias ...... "cd ../../../../.."
alias ls "eza --color-scale --git --git-ignore --time-style=iso -a -T -F -h -l -L=1"
alias ll "eza --color-scale --git --git-ignore --time-style=iso -a -T -F -h -l -L=1"
alias rm "rm -i"
alias cp "cp -i"
alias mv "mv -i"
alias vi "vim"
alias cat "cat -n"
alias less "less -NM"

# git aliases
alias pl "git pull"
alias push "git push"
alias commit "git commit"
alias diff "git diff"
alias gco "git checkout"
alias ga "git add"
alias gl "git log"
alias gpl "git log --pretty='format:%C(yellow)%h %C(green)%cd %C(reset)%s %C(red)%d %C(cyan)[%an]' --date=iso"
alias gb "git branch"
alias gf "git fetch"
alias gs "git switch"
alias gr "git restore"
alias gcp "git cherry-pick"

# docker aliases
alias dps "docker ps"
alias compose "docker compose"
alias cps "docker compose ps"
alias cu "docker compose up"
alias cud "docker compose up -d"
alias cdn "docker compose down"

# Google Cloud SDK Completion
if test -f ~/google-cloud-sdk/path.fish.inc
    source ~/google-cloud-sdk/path.fish.inc
end

# ghq func
function ghqcd
    set -l query $argv
    set -l repo (ghq list | fzf --query=$query)
    if test -n "$repo"
        cd (ghq root)/$repo
    end
end

# fish history
function fish_user_key_bindings
    bind \cr 'peco_select_history (commandline -b)'
end

# exec eza after cd
function cd
    builtin cd $argv
    eza --color-scale --git --git-ignore --time-style=iso -a -T -F -h -l -L=1
end

# Peco key binding
function fish_user_key_bindings
    bind \cr peco_select_history
end

starship init fish | source

direnv hook fish | source

