# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# set -e # 有一个未通过立刻终止脚本
# set -x # 显示所有步骤

# Quick change directories, Expands .... -> ../../../
smartdots() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}

# 在 xcode 中打开当前目录下的工程
ofx() {
    open ./*.xcworkspace || open ./*.xcodeproj || open ./Package.swift
} 2> /dev/null

# print the path of current file of MacVim's front window
pfmv() {
    osascript <<'EOF'
tell application "MacVim"
    set window_title to name of window 1
    set is_empty to offset of "[NO NAME]" in window_title
    if is_empty is 0 then
        set cwd to do shell script "echo '" & window_title & "' |sed 's/.* (\\(.*\\)).*/\\1/'" & " |sed \"s,^~,$HOME,\""
        return cwd
    end if
end tell
EOF
}

# use MacVim to edit the current file of Xcode
mvxc() {
    # either of the below method is acceptable
    # open -a MacVim `pfxc`
    osascript <<EOF
tell application "MacVim"
    activate
    set current_document_path to "$(pfxc)"
    if (current_document_path is not "") then
        open current_document_path
        return
    end if
end tell
EOF
}

# cd to the path of MacVim's current working directory
function cdmv() {
    cd "$(pfmv)"
}

# function cdit() {
#   cd "$(pfit)"
# }

function repeat() {
    local i max
    max=$1
    shift
    for ((i = 1; i <= max; i++)); do # --> C-like syntax
        eval "$@"
    done
}

if command_exists code; then
    # 在 vscode 中打开当前 finder 的文件夹
    codef() {
        code "$(pfd)"
    }
fi

if command_exists lazygit; then
    lgf() {
        export LAZYGIT_NEW_DIR_FILE=~/.lazygit/newdir

        lazygit "$@"

        if [ -f "$LAZYGIT_NEW_DIR_FILE" ]; then
            cd "$(cat "$LAZYGIT_NEW_DIR_FILE")"
            rm -f "$LAZYGIT_NEW_DIR_FILE" >/dev/null
        fi
    }
fi

if command_exists tmux; then
    # tmux attach
    ta() {
        if which tmux >/dev/null 2>&1; then
            test -z "$TMUX" && (tmux attach || tmux new-session)
        fi
    }
fi

if command_exists scmpuff; then
    function gdf() {
        params="$*"
        if brew ls --versions scmpuff >/dev/null; then
            params=$(scmpuff expand "$@" 2>/dev/null)
        fi

        if [ $# -eq 0 ]; then
            git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" | less
        elif [ ${#params} -eq 0 ]; then
            git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$@" | less
        else
            git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$params" | less
        fi
    }
fi

function whichd() {
    if type "$1" | grep -q 'is a shell function'; then
        type "$1"
        which "$1"
    elif type "$1" | grep -q 'is an alias'; then
        PS4='+%x:%I>' zsh -i -x -c '' |& grep '>alias ' | grep "${1}="
    else
        type "$1"
    fi
}

if command_exists apt; then
    # Update and upgrade packages
    apt-update() {
    sudo apt update
    sudo apt -y upgrade
}

    # Clean packages
    apt-clean() {
    sudo apt -y autoremove
    sudo apt-get -y autoclean
    sudo apt-get -y clean
}

    # List intentionally installed packages
    apt-list() {
    (
    zcat "$(ls -tr /var/log/apt/history.log*.gz)"
    cat /var/log/apt/history.log
    ) 2>/dev/null |
        grep -E '^Commandline' |
        sed -e 's/Commandline: \(.*\)/\1/' |
        grep -E -v '^/usr/bin/unattended-upgrade$'
    }
fi

# ***************   z.lua   *****************
function _zfzf {
    # _zlua -I -t .
    cd "$(zfzf)"

    if [[ -z "$lines" ]]; then
        zle && zle reset-prompt
        # zle && zle redraw-prompt
    fi
}

# *************** autojump *****************
# use fzf to jump to history directories
autojump_fzf() {
    cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' | eval ${FZF_WITH_COMMAND_AND_ARGS})"

    if [[ -z "$lines" ]]; then
        zle && zle reset-prompt
        # zle && zle redraw-prompt
    fi
}

# *************** zoxide *****************
function _zi {
    zi
    if [[ -z "$lines" ]]; then
        zle && zle reset-prompt
        # zle && zle redraw-prompt
    fi
}

# *************** fzf-git *****************
_fzf_git_fzf() {
    fzf-tmux -p80%,80% -- \
        --layout=reverse --multi --height=80% --min-height=20 --border \
        --color='header:italic:underline' \
        --preview-window='right,50%,border-left' \
        --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
    }
# Go back up N directories
up() {
    if [[ $# -eq 0 ]]; then
        cd "../"
    elif [[ $# -eq 1 ]] && [[ $1 -gt 0 ]]; then
        local up_dir=""
        for _ in $(seq 1 "$1"); do
            up_dir+="../"
        done
        cd "$up_dir" || return 1
    else
        echo "Usage: up [n]"
        return 1
    fi
}

# MARK: git related {{{

# Pretty log messages
function _git_log_prettily(){
    if ! [ -z $1 ]; then
        git log --pretty=$1
    fi
}
compdef _git _git_log_prettily=git-log

# Warn if the current branch is a WIP
function work_in_progress() {
    if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
        echo "WIP!!"
    fi
}

# Check if main exists and use instead of master
function git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
        if command git show-ref -q --verify $ref; then
            echo ${ref:t}
            return
        fi
    done
    echo master
}

function git_current_branch () {
    local ref
    ref=$(__git_prompt_git symbolic-ref --quiet HEAD 2> /dev/null)
    local ret=$?
    if [[ $ret != 0 ]]
    then
        [[ $ret == 128 ]] && return
        ref=$(__git_prompt_git rev-parse --short HEAD 2> /dev/null)  || return
    fi
    echo ${ref#refs/heads/}
}

# Check for develop and similarly named branches
function git_develop_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local branch
    for branch in dev devel development; do
        if command git show-ref -q --verify refs/heads/$branch; then
            echo $branch
            return
        fi
    done
    echo develop
}

function grename() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: $0 old_branch new_branch"
        return 1
    fi

  # Rename branch locally
  git branch -m "$1" "$2"
  # Rename branch in origin remote
  if git push origin :"$1"; then
      git push --set-upstream origin "$2"
  fi
}

# Pretty diff
function pdiff() {
    if [[ $# -ne 2 ]]; then
        echo "Usage: pdiff file1 file2"
        return 1
    fi

    if [[ -x $(command -v delta) ]]; then
        delta "$1" "$2"
    else
        diff -s -u --color=always "$1" "$2"
    fi
}

# Print command cheatsheet
# cheat() {
#     curl -s "cheat.sh/$1"
# }

# Browse git commits
glog() {
    local log_fmt="%C(yellow)%h%Cred%d %Creset%s %Cgreen(%ar)%Creset"
    local commit_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    local view_commit="$commit_hash | xargs -I hash sh -c \"git i --color=always hash | delta\""

    git log --color=always --format="$log_fmt" "$@" |
        fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
        --header="enter to view, alt-y to copy hash" --preview="$view_commit" \
        --bind="enter:execute:$view_commit | less -R" \
        --bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
    }

git_keep_one() {
    git pull --depth 1
    git reflog expire --expire=all --all
    git tag -l | xargs git tag -d
    git stash drop
    git gc --prune=all
}

function gstpush() {
    git stash push -m "hanley_$1"
}

function gstpop() {
    # MARK: Method 1
    # git stash apply stash^{/"hanley_$1"}

    # MARK: Method 2
    # stash_index like "stash@{0}"
    stash_index=$(git stash list | grep "hanley_$1$" | cut -d: -f1)
    if [[ -n "${stash_index}" ]]; then
        git stash pop "${stash_index}"
    else
        echo "There is no stash for name \"hanley_$1\""
        return
    fi
}

function git_copy_branch() {
    git rev-parse --abbrev-ref HEAD | tr -d '\n' | pbcopy
}
# }}}

test_zsh1() {
    for i in $(seq 1 20); do
        /usr/bin/time /bin/zsh --no-rcs -i -c exit
    done
}

function light() {
    if [ -z "$2" ]; then
        src="pbpaste"
    else
        src="cat $2"
    fi
    eval "$src" | highlight -O rtf --syntax="$1" -k "Fira Code" --style=solarized-dark --font-size 24 | pbcopy
}

nocolor () {
    sed -r 's:\x1b\[[0-9;]*[mK]::g;s:[\r\x0f]::g'
}

# 删除空文件
rmempty () {
    for i; do
        [[ -f $i && ! -s $i ]] && rm $i
    done
    return 0
}

# 断掉软链接
breakln () {
    for f in $*; do
        tgt=$(readlink "$f")
        unlink "$f"
        cp -rL "$tgt" "$f"
    done
}

# 设置标题
if [[ $TERM == screen* || $TERM == tmux* ]]; then
    # 注：不支持中文
    title () { echo -ne "\ek$*\e\\" }
else
    title () { echo -ne "\e]0;$*\a" }
fi
if [[ $TERM == xterm* || $TERM == *rxvt* ]]; then # {{{2 设置光标颜色
    cursorcolor () { echo -ne "\e]12;$*\007" }
elif [[ $TERM == screen* ]]; then
    if (( $+TMUX )); then
        cursorcolor () { echo -ne "\ePtmux;\e\e]12;$*\007\e\\" }
    else
        cursorcolor () { echo -ne "\eP\e]12;$*\007\e\\" }
    fi
elif [[ $TERM == tmux* ]]; then
    cursorcolor () { echo -ne "\ePtmux;\e\e]12;$*\007\e\\" }
fi

# 使用伪终端代替管道，对 ls 这种“顽固分子”有效 {{{2
ptyrun () {
    local ptyname=pty-$$
    zmodload zsh/zpty
    zpty $ptyname "${(q)@}"
    if [[ ! -t 1 ]]; then
        setopt local_traps
        trap '' INT
    fi
    zpty -r $ptyname
    zpty -d $ptyname
}

ptyless () {
    ptyrun "$@" | tr -d $'\x0f' | less
}

# 剪贴板数据到 QR 码
clipboard2qr () {
    data="$(xsel)"
    echo $data
    echo $data | qrencode -t UTF8
}

# 截图到剪贴板
screen2clipboard () {
    screenshot | xclip -i -selection clipboard -t image/png
}

# 将剪贴板中的图片从 bmp 转到 png。QQ 会使用 bmp
clipboard_bmp2png () {
    xclip -selection clipboard -o -t image/bmp | convert - png:- | xclip -i -selection clipboard -t image/png
}

# 将剪贴板中的图片从 png 转到 bmp。QQ 会使用 bmp
clipboard_png2bmp () {
    xclip -selection clipboard -o -t image/png | convert - bmp:- | xclip -i -selection clipboard -t image/bmp
}

# 文件名从 GB 转码，带确认
mvgb () {
    for i in $*; do
        new="$(echo $i|iconv -f utf8 -t latin1|iconv -f gbk)"
        echo $new
        echo -n 'Sure? '
        read -q ans && mv -i $i $new
        echo
    done
}

pid () { #{{{2
    s=0
    for i in $*; do
        i=${i/,/}
        echo -n "$i: "
        r=$(cat /proc/$i/cmdline|tr '\0' ' ' 2>/dev/null)
        if [[ $? -ne 0 ]]; then
            echo not found
            s=1
        else
            echo $r
        fi
    done
    return $s
}

# 快速查找当前目录下的文件
s () {
    find . -name "*$1*"
}

#{{{2 query XMPP SRV records
xmpphost () {
    host -t SRV _xmpp-client._tcp.$1
    host -t SRV _xmpp-server._tcp.$1
}

# 软件仓库中重复的软件包
duppkg4repo () {
    local repo=$1
    [[ -z $repo ]] && { echo >&2 'which repository to examine?'; return 1 }
    local pkgs
    pkgs=$(comm -12 \
        <(pacman -Sl $repo|awk '{print $2}'|sort) \
        <(pacman -Sl|awk -vrepo=$repo '$1 != repo {print $2}'|sort) \
    )
        [[ -z $pkgs ]] && return 0
        LANG=C pacman -Si ${=pkgs} | awk -vself=$repo '/^Repository/{ repo=$3; } /^Name/ && repo != self { printf("%s/%s\n", repo, $3); }'
    }

# 反复重试, 直到成功 {{{ 2
try_until_success () {
    local i=1
    while true; do
        echo "Try $i at $(date)."
        $* && break
        (( i+=1 ))
        echo
    done
}
compdef try_until_success=command

# autojump 快速安装
install_autojump () {
    mkdir -p ~/.local/bin ${_zdir}/.zsh/Completion
    pushd ~/.local/bin > /dev/null
    wget -N https://github.com/wting/autojump/raw/master/bin/autojump{,_{data,argparse,match,utils}.py}
    chmod +x autojump
    popd > /dev/null
    wget https://github.com/wting/autojump/raw/master/bin/autojump.zsh -O ${_zdir}/.zsh/autojump.zsh
    wget https://github.com/wting/autojump/raw/master/bin/_j -O ${_zdir}/.zsh/Completion/_j
}

wait_pid () {
    local pid=$1
    while true; do
        if [[ -d /proc/$pid ]]; then
            sleep 3
        else
            break
        fi
    done
}

uName() {
    declare -A unameInfo
    unameInfo=( [kernel]=-s [kernel_release]=-r [os]=-o [cpu]=-p )
    for name com in ${(kv)unameInfo}; do
        res=$(uname $com)
        echo "$name -> $res"
    done
}

if is_darwin; then
    show_current_wifi_ssid() {
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
    }

    show_wifi_password() {
        ssid=$1
        security find-generic-password -D "AirPort network password" -a $ssid -gw
    }

    show_current_wifi_password() {
        ssid=$(show_current_wifi_ssid)

        show_wifi_password $ssid
    }
fi
# function _fish_collapsed_pwd() {
#     local pwd="$1"
#     local home="$HOME"
#     local size=${#home}
#     [[ $# == 0 ]] && pwd="$PWD"
#     [[ -z "$pwd" ]] && return
#     if [[ "$pwd" == "/" ]]; then
#         echo "/"
#         return
#     elif [[ "$pwd" == "$home" ]]; then
#         echo "~"
#         return
#     fi
#     [[ "$pwd" == "$home/"* ]] && pwd="~${pwd:$size}"
#     if [[ -n "$BASH_VERSION" ]]; then
#         local IFS="/"
#         local elements=($pwd)
#         local length=${#elements[@]}
#         for ((i=0;i<length-1;i++)); do
#             local elem=${elements[$i]}
#             if [[ ${#elem} -gt 1 ]]; then
#                 elements[$i]=${elem:0:1}
#             fi
#         done
#     else
#         local elements=("${(s:/:)pwd}")
#         local length=${#elements}
#         for i in {1..$((length-1))}; do
#             local elem=${elements[$i]}
#             if [[ ${#elem} > 1 ]]; then
#                 elements[$i]=${elem[1]}
#             fi
#         done
#     fi
#     local IFS="/"
#     echo "${elements[*]}"
# }
