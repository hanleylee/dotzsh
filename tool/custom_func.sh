# set -e # 有一个未通过立刻终止脚本
# set -x # 显示所有步骤

# 在 xcode 中打开当前目录下的 xcworkspace 文件
ofx() {
    open ./*.xcworkspace || open ./*.xcodeproj
}

# 在 vscode 中打开当前 finder 的文件夹
codef() {
    code $(pfd)
}

# tmux attach
ta() {
    if which tmux >/dev/null 2>&1; then
        test -z "$TMUX" && (tmux attach || tmux new-session)
    fi
}

function gdf() {
    params="$@"
    if brew ls --versions scmpuff > /dev/null; then
        params=`scmpuff expand "$@" 2>/dev/null`
    fi

    if [ $# -eq 0 ]; then
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" | less
    elif [ ${#params} -eq 0 ]; then
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$@" | less
    else
        git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$params" | less
    fi
}

function whichd() {
    if `type $1 | grep -q 'is a shell function'`; then
        type $1
        which $1
    elif `type $1 | grep -q 'is an alias'`; then
        PS4='+%x:%I>' zsh -i -x -c '' |& grep '>alias ' | grep "${1}="
    else
        type $1
    fi
}

# ***************   zlua   *****************
function _zfzf {
     _zlua -I .

     if [[ -z "$lines" ]]; then
         zle && zle redraw-prompt
         return 1
     fi
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
