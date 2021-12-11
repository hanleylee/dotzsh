# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# set -e # 有一个未通过立刻终止脚本
# set -x # 显示所有步骤

# 在 xcode 中打开当前目录下的 xcworkspace 文件
ofx() {
    open ./*.xcworkspace || open ./*.xcodeproj
} 2> /dev/null

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
    lg() {
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

# ***************   zlua   *****************
function _zfzf {
    _zlua -I -t .

    if [[ -z "$lines" ]]; then

        zle && zle reset-prompt
        # zle && zle redraw-prompt
        return 1
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
