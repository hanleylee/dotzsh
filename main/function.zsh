# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# set -e # 有一个未通过立刻终止脚本
# set -x # 显示所有步骤

function zsh_stats() {
    fc -l 1 | awk '{ CMD[$2]++; count++; } END { for (a in CMD) print CMD[a] " " CMD[a]*100/count "% " a }' | grep -v "./" | sort -nr | head -n 20 | column -c3 -s " " -t | nl
}

function open_command() {
    local open_cmd

  # define the open command
  case "$OSTYPE" in
      darwin*)
          open_cmd='open'
          ;;
      cygwin*)
          open_cmd='cygstart'
          ;;
      linux*)
          open_cmd='nohup xdg-open'
          ;;
      msys*)
          open_cmd='start ""' ;;
      *)
          echo "Platform $OSTYPE not supported"
          return 1
          ;;
  esac

  # If a URL is passed, $BROWSER might be set to a local browser within SSH.
  # See https://github.com/ohmyzsh/ohmyzsh/issues/11098
  if [[ -n "$BROWSER" && "$1" = (http|https)://* ]]; then
      "$BROWSER" "$@"
      return
  fi

  ${=open_cmd} "$@" &>/dev/null
}

# take functions

# mkcd is equivalent to takedir
function mkcd takedir() {
    mkdir -p $@ && cd ${@:$#}
}

function takeurl() {
    local data thedir
    data="$(mktemp)"
    curl -L "$1" > "$data"
    tar xf "$data"
    thedir="$(tar tf "$data" | head -n 1)"
    rm "$data"
    cd "$thedir"
}

function takegit() {
    git clone "$1"
    cd "$(basename ${1%%.git})"
}

function take() {
    if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
        takeurl "$1"
    elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
        takegit "$1"
    else
        takedir "$@"
    fi
}

#
# Get the value of an alias.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1 (if it has one).
# Return value:
#    0 if the alias was found,
#    1 if it does not exist
#
function alias_value() {
    (( $+aliases[$1] )) && echo $aliases[$1]
}

#
# Try to get the value of an alias,
# otherwise return the input.
#
# Arguments:
#    1. alias - The alias to get its value from
# STDOUT:
#    The value of alias $1, or $1 if there is no alias $1.
# Return value:
#    Always 0
#
function try_alias_value() {
    alias_value "$1" || echo "$1"
}

#
# Set variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The variable to set
#    2. val  - The default value
# Return value:
#    0 if the variable exists, 3 if it was set
#
function default() {
    (( $+parameters[$1] )) && return 0
    typeset -g "$1"="$2"   && return 3
}

#
# Set environment variable "$1" to default value "$2" if "$1" is not yet defined.
#
# Arguments:
#    1. name - The env variable to set
#    2. val  - The default value
# Return value:
#    0 if the env variable exists, 3 if it was set
#
function env_default() {
    [[ ${parameters[$1]} = *-export* ]] && return 0
    export "$1=$2" && return 3
}


# Ensure precmds are run after cd
function redraw-prompt {
    local precmd
    for precmd in $precmd_functions; do
        $precmd
    done
    zle reset-prompt
}
zle -N redraw-prompt

# Required for $langinfo
zmodload zsh/langinfo

# URL-encode a string
#
# Encodes a string using RFC 2396 URL-encoding (%-escaped).
# See: https://www.ietf.org/rfc/rfc2396.txt
#
# By default, reserved characters and unreserved "mark" characters are
# not escaped by this function. This allows the common usage of passing
# an entire URL in, and encoding just special characters in it, with
# the expectation that reserved and mark characters are used appropriately.
# The -r and -m options turn on escaping of the reserved and mark characters,
# respectively, which allows arbitrary strings to be fully escaped for
# embedding inside URLs, where reserved characters might be misinterpreted.
#
# Prints the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#  omz_urlencode [-r] [-m] [-P] <string> [<string> ...]
#
#    -r causes reserved characters (;/?:@&=+$,) to be escaped
#
#    -m causes "mark" characters (_.!~*''()-) to be escaped
#
#    -P causes spaces to be encoded as '%20' instead of '+'
function omz_urlencode() {
    emulate -L zsh
    local -a opts
    zparseopts -D -E -a opts r m P

    local in_str="$@"
    local url_str=""
    local spaces_as_plus
    if [[ -z $opts[(r)-P] ]]; then spaces_as_plus=1; fi
    local str="$in_str"
    # URLs must use UTF-8 encoding; convert str to UTF-8 if required
    local encoding=$langinfo[CODESET]
    local safe_encodings
    safe_encodings=(UTF-8 utf8 US-ASCII)
    if [[ -z ${safe_encodings[(r)$encoding]} ]]; then
        str=$(echo -E "$str" | iconv -f $encoding -t UTF-8)
        if [[ $? != 0 ]]; then
            echo "Error converting string from $encoding to UTF-8" >&2
            return 1
        fi
    fi

  # Use LC_CTYPE=C to process text byte-by-byte
  local i byte ord LC_ALL=C
  export LC_ALL
  local reserved=';/?:@&=+$,'
  local mark='_.!~*''()-'
  local dont_escape="[A-Za-z0-9"
  if [[ -z $opts[(r)-r] ]]; then
      dont_escape+=$reserved
  fi
  # $mark must be last because of the "-"
  if [[ -z $opts[(r)-m] ]]; then
      dont_escape+=$mark
  fi
  dont_escape+="]"

  # Implemented to use a single printf call and avoid subshells in the loop,
  # for performance (primarily on Windows).
  local url_str=""
  for (( i = 1; i <= ${#str}; ++i )); do
      byte="$str[i]"
      if [[ "$byte" =~ "$dont_escape" ]]; then
          url_str+="$byte"
      else
          if [[ "$byte" == " " && -n $spaces_as_plus ]]; then
              url_str+="+"
          else
              ord=$(( [##16] #byte ))
              url_str+="%$ord"
          fi
      fi
  done
  echo -E "$url_str"
}

# URL-decode a string
#
# Decodes a RFC 2396 URL-encoded (%-escaped) string.
# This decodes the '+' and '%' escapes in the input string, and leaves
# other characters unchanged. Does not enforce that the input is a
# valid URL-encoded string. This is a convenience to allow callers to
# pass in a full URL or similar strings and decode them for human
# presentation.
#
# Outputs the encoded string on stdout.
# Returns nonzero if encoding failed.
#
# Usage:
#   omz_urldecode <urlstring>  - prints decoded string followed by a newline
function omz_urldecode {
    emulate -L zsh
    local encoded_url=$1

  # Work bytewise, since URLs escape UTF-8 octets
  local caller_encoding=$langinfo[CODESET]
  local LC_ALL=C
  export LC_ALL

  # Change + back to ' '
  local tmp=${encoded_url:gs/+/ /}
  # Protect other escapes to pass through the printf unchanged
  tmp=${tmp:gs/\\/\\\\/}
  # Handle %-escapes by turning them into `\xXX` printf escapes
  tmp=${tmp:gs/%/\\x/}
  local decoded="$(printf -- "$tmp")"

  # Now we have a UTF-8 encoded string in the variable. We need to re-encode
  # it if caller is in a non-UTF-8 locale.
  local -a safe_encodings
  safe_encodings=(UTF-8 utf8 US-ASCII)
  if [[ -z ${safe_encodings[(r)$caller_encoding]} ]]; then
      decoded=$(echo -E "$decoded" | iconv -f UTF-8 -t $caller_encoding)
      if [[ $? != 0 ]]; then
          echo "Error converting string from UTF-8 to $caller_encoding" >&2
          return 1
      fi
  fi

  echo -E "$decoded"
}

# Quick change directories, Expands .... -> ../../../
function smartdots() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}

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

# 快速查找当前目录下的文件
function s () {
    find . -name "*$1*"
}

# 在 xcode 中打开当前目录下的工程
function ofx() {
    open ./*.xcworkspace || open ./*.xcodeproj || open ./Package.swift
} 2> /dev/null

# print the path of current file of MacVim's front window
function pfmv() {
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
function mvxc() {
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

function copy_ios_screenshot() {
    # temp_png="/tmp/screenshot/${RANDOM}.png"
    # temp_png="$(mktemp /tmp/ios_screen_shot_XXXXXX.png)"
    # temp_png="$(mktemp /tmp/screenshot/XXXXXX.png)"
    # temp_png="$(gmktemp --suffix=.png)"
    temp_png="${TMPDIR}screenshot_${RANDOM}.png"

    tidevice screenshot "${temp_png}"
    img_copy "${temp_png}"
    # file-to-clipboard "${temp_png}"
}

function repeat() {
    local i max
    max=$1
    shift
    for ((i = 1; i <= max; i++)); do # --> C-like syntax
        eval "$@"
    done
}

# Go back up N directories
function up() {
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

function benchmark_zsh() {
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
    eval "$src" | highlight -O rtf --syntax="$1" -k "Fira Code" --style=base16/onedark --font-size 32 | pbcopy
}

function nocolor () {
    sed -r 's:\x1b\[[0-9;]*[mK]::g;s:[\r\x0f]::g'
}

# 删除空文件
function rmempty () {
    for i; do
        [[ -f $i && ! -s $i ]] && rm $i
    done
    return 0
}

# 断掉软链接
function breakln () {
    for f in $*; do
        tgt=$(readlink "$f")
        unlink "$f"
        cp -rL "$tgt" "$f"
    done
}

# 使用伪终端代替管道，对 ls 这种“顽固分子”有效 {{{2
function ptyrun () {
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

function ptyless () {
    ptyrun "$@" | tr -d $'\x0f' | less
}

# 文件名从 GB 转码, 带确认
function mvgb () {
    for i in $*; do
        new="$(echo $i|iconv -f utf8 -t latin1|iconv -f gbk)"
        echo $new
        echo -n 'Sure? '
        read -q ans && mv -i $i $new
        echo
    done
}

function pid () {
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

# query XMPP SRV records
function xmpphost () {
    host -t SRV _xmpp-client._tcp.$1
    host -t SRV _xmpp-server._tcp.$1
}

# 反复重试, 直到成功
function try_until_success () {
    local i=1
    while true; do
        echo "Try $i at $(date)."
        $* && break
        (( i+=1 ))
        echo
    done
}
compdef try_until_success=command

function wait_pid () {
    local pid=$1
    while true; do
        if [[ -d /proc/$pid ]]; then
            sleep 3
        else
            break
        fi
    done
}

function uName() {
    declare -A unameInfo
    unameInfo=( [kernel]=-s [kernel_release]=-r [os]=-o [cpu]=-p )
    for name com in ${(kv)unameInfo}; do
        res=$(uname $com)
        echo "$name -> $res"
    done
}

if is_darwin; then
    function show_current_wifi_ssid() {
        /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'
    }

    function show_wifi_password() {
        ssid=$1
        security find-generic-password -D "AirPort network password" -a $ssid -gw
    }

    function show_current_wifi_password() {
        ssid=$(show_current_wifi_ssid)

        show_wifi_password $ssid
    }
fi

if command_exists code; then
    # 在 vscode 中打开当前 finder 的文件夹
    function codef() {
        code "$(pfd)"
    }
fi

if command_exists lazygit; then
    function lgf() {
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
    function ta() {
        test -z "$TMUX" && (tmux attach || tmux new-session)
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

if command_exists apt; then
    # Update and upgrade packages
    function apt-update() {
    sudo apt update
    sudo apt -y upgrade
}

    # Clean packages
    function apt-clean() {
    sudo apt -y autoremove
    sudo apt-get -y autoclean
    sudo apt-get -y clean
}

    # List intentionally installed packages
    function apt-list() {
    (
    zcat "$(ls -tr /var/log/apt/history.log*.gz)"
    cat /var/log/apt/history.log
    ) 2>/dev/null |
        grep -E '^Commandline' |
        sed -e 's/Commandline: \(.*\)/\1/' |
        grep -E -v '^/usr/bin/unattended-upgrade$'
    }
fi

# *************** zoxide *****************
function _zi_keymap {
    if command_exists zi; then
        zi
        if [[ -z "$lines" ]]; then
            # zle && zle reset-prompt
            zle && zle redraw-prompt
        fi
    else
        echo "zoxide is not installed!"

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
