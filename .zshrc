#User configuration
setopt nonomatch
 
export PATH="/usr/bin:/bin:/usr/sbin:/sbin"
export PATH="/usr/local/bin:/usr/local/sbin:$PATH"

# php
export PATH=$PATH:"~/.composer/vendor/bin"
export PATH=$PATH:"/Users/szk416/pear/bin"

# added by Anaconda3 5.1.0 
export PATH="/Users/szk416/anaconda3/bin:$PATH"

# Vim
export EDITOR=/Applications/MacVim.app/Contents/MacOS/Vim
alias vi='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
alias vim='env LANG=ja_JP.UTF-8 /Applications/MacVim.app/Contents/MacOS/Vim "$@"'
export PATH=$PATH:$HOME/.nodebrew/current/bin

eval "$(rbenv init -)"

alias bat="nocorrect bat"
alias npm="nocorrect npm"
alias tree="nocorrect tree"

# Golang
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH:/bin
export PATH=$PATH:/usr/local/go/bin

# The next line updates PATH for the Google Cloud SDK.
source '/Users/szk416/google-cloud-sdk/path.zsh.inc'

# The next line enables bash completion for gcloud.
source '/Users/szk416/google-cloud-sdk/completion.zsh.inc'

source <(kubectl completion zsh)
alias k=kubectl
complete -o default -F __start_kubectl k

# For kubectl_aliases
[ -f ~/.kubectl_aliases ] && source ~/.kubectl_aliases
