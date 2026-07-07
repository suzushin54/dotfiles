set -x LANG ja_JP.UTF-8

# fzf settings
fzf --fish | source
set -g FZF_COMPLETE 1
set -x FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --inline-info --preview 'echo {}' --preview-window=right:50%:wrap"
set fish_color_command blue

fzf_configure_bindings --directory=\cf --git_status=\cs --variables=\cv

function fzf_search_history
    history merge
    history --null --show-time="%Y-%m-%d %H:%M:%S | " |
        fzf --read0 --print0 --tiebreak=index --query=(commandline) \
            --preview 'echo {}' \
            --preview-window=right:50%:wrap \
            --prompt='History > ' \
            --height=50% \
            --layout=reverse \
            --border rounded \
            --info=inline \
            --color='header:italic:underline' |
        read -lz result
    and commandline -- (string replace -r '^[0-9 :-]+ \| ' '' -- $result)
    commandline -f repaint
end

function fzf-cd-widget
    set -l dir (fd --type d | fzf --preview 'tree -L 1 {}')
    if test $status -eq 0
        cd $dir
        commandline -f repaint
    end
end

function __auto_cd_or_execute
    set input (commandline)

    # If input contains spaces, treat it as a command
    if test (count (string split " " -- $input)) -gt 1
        commandline -f execute
        return
    end

    # If input is a valid command, execute it 
    if type -q $input
        commandline -f execute
        return
    end

    # If input is a single word and a directory, execute `cd` to change directory
    if test -d $input
        commandline ""
        printf "\n"
        cd $input
        printf "\n\n"
        commandline -f repaint
        return
    end

    # Otherwise, execute the input as a command
    commandline -f execute
end

# vi mode: normal モードで w/b/e(大文字は空白区切り)・dw/db 等の単語移動が
# そのまま使える。行内の長いコマンドを vim と同じ操作感で編集するのが狙い。
# 各モードでカーソル形状を変えて、今どのモードか一目で分かるようにする。
set -g fish_cursor_default block      # normal / visual: ブロック(■)
set -g fish_cursor_insert line        # insert: 縦線(|)
set -g fish_cursor_replace_one underscore
set -g fish_cursor_visual block

function fish_user_key_bindings
    # まず vi キーバインドを土台として読み込む。
    # これ以降の bind は、この上に重ねる形になる。
    fish_vi_key_bindings

    # --- muscle memory 維持: emacs 系ショートカットを insert モードに温存 ---
    # Ctrl+A/E は行頭/行末(既に手に馴染んでいるやつ)。
    # Ctrl+W は fzf の履歴検索ではなく従来通り「直前の単語を削除」に残す。
    bind --mode insert ctrl-a beginning-of-line
    bind --mode insert ctrl-e end-of-line
    bind --mode insert ctrl-w backward-kill-word

    # --- 既存のカスタム/ fzf 連携を再適用 ---
    # 重要: vi mode ではモード無指定の bind は normal モード側に入るため、
    # insert 入力中に効かせたいものは --mode insert を明示する必要がある。
    # Enter(\r) はまさにこれで、明示しないと入力中に実行できなくなる。
    bind --mode insert \r __auto_cd_or_execute
    bind --mode default \r __auto_cd_or_execute

    # junegunn/fzf の fish 連携(Ctrl+T によるファイル挿入など)
    fzf_key_bindings

    # 自前 / fzf.fish 由来のウィジェット(insert・normal 両モードに登録)
    for mode in insert default
        bind --mode $mode \cr fzf_search_history
        bind --mode $mode \cf fzf-cd-widget
        bind --mode $mode \cg fzf-cd-and-open
    end
end

fish_add_path --move --prepend $HOME/.cargo/bin
fish_add_path --move --prepend /opt/homebrew/opt/ruby/bin
fish_add_path --move --prepend /opt/homebrew/lib/ruby/gems/3.3.0/bin
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
fish_add_path $HOME/go/bin
fish_add_path $GOPATH/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/bin/protoc
fish_add_path $HOME/.local/share/mise/installs/terraform/1.8.4/bin
fish_add_path $HOME/development/flutter/bin
fish_add_path $HOME/google-cloud-sdk/bin
fish_add_path $HOME/.pub-cache/bin
fish_add_path $HOME/.lmstudio/bin

# Homebrew
eval (/opt/homebrew/bin/brew shellenv)

# mise
mise activate fish | source

# git-wt
type -q git-wt; and git wt --init fish | source

# hub
eval (hub alias -s)

# jump
status --is-interactive; and source (jump shell fish | psub)

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

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
#alias vi "nvim"
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

alias log="tig"
alias log-all="tig --all"
alias stat="tig status"
alias branch="tig refs"

# docker aliases
alias dps "docker ps"
alias compose "docker compose"
alias cps "docker compose ps"
alias cu "docker compose up"
alias cud "docker compose up -d"
alias cdn "docker compose down"

alias chrome-dev="open -a \"Google Chrome\" --args --auto-open-devtools-for-tabs"

abbr v "nvim"
abbr vi "nvim"
abbr vimdiff "nvim -d"

type -q rg; or echo "Install ripgrep for faster search: brew install ripgrep"
type -q fd; or echo "Install fd for faster file discovery: brew install fd"

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

# Disabled: Auto-executing eza after cd causes noise when AI tools run cd commands
# exec eza after cd
#function cd
#    builtin cd $argv
#    eza --color-scale --git --git-ignore --time-style=iso -a -T -F -h -l -L=1
#end

function fzf-cd-and-open
    set -l dir (fd --type d | fzf --preview 'tree -L 1 {}')
    if test $status -eq 0
        cd $dir
        eza --color-scale --git --git-ignore --time-style=iso -a -T -F -h -l -L=1
    end
end

starship init fish | source

direnv hook fish | source

function aws-token
    set profile_name $argv[1]
    set code $argv[2]
    set mfa_device (awk '/'$profile_name'/{flag=1;next}/\[/{flag=0}flag' ~/.aws/config | grep mfa-device | cut -f 3 -d " ")
    set session_token (aws sts get-session-token --serial-number $mfa_device --token-code $code --profile $profile_name)
    set -gx AWS_ACCESS_KEY_ID (echo $session_token | jq -r .Credentials.AccessKeyId)
    set -gx AWS_SECRET_ACCESS_KEY (echo $session_token | jq -r .Credentials.SecretAccessKey)
    set -gx AWS_SESSION_TOKEN (echo $session_token | jq -r .Credentials.SessionToken)
end

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init2.fish 2>/dev/null || :

