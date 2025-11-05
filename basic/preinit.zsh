# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# shellcheck disable=2034
# check first, or the script will end wherever it fails
# zmodload zsh/regex 2>/dev/null && _has_re=1 || _has_re=0

# MARK: 仅用于添加一些需要在初始化开始时就需要的公共变量或方法

# System name
SYSTEM_NAME=$(uname)
ARCH_NAME=$(uname -m)

case "$SYSTEM_NAME" in
    Darwin)
        case "$ARCH_NAME" in
            x86_64)
                if [[ "$(sysctl -in sysctl.proc_translated)" == "1" ]]; then
                    ARCH_MSG="Running on Darwin(Rosetta 2)"
                else
                    ARCH_MSG="Running on Darwin(native Intel)"
                fi
                ;;
            arm64)
                ARCH_MSG="Running on Darwin(ARM)"
                ;;
            *)
                ARCH_MSG="Running on ${SYSTEM_NAME}(${ARCH_NAME})"
                ;;
        esac
        ;;
    Linux)
        ARCH_MSG="Running on ${SYSTEM_NAME}(${ARCH_NAME})"
        ;;
    *)
        ARCH_MSG="Running on ${SYSTEM_NAME}(${ARCH_NAME})"
        ;;
esac

export ARCH_MSG

# all command passed exist or not
# -> Bool
function command_exists() {
    for cmd in "$@"; do
        # command -v "$cmd" &>/dev/null || return 1             # path 中的工具, alias 与 function 都会返回 true
        (( $+commands[$cmd] )) && [[ -x "$(command -v "$cmd")" ]] # 只会在 path 中找到真正可用的命令(且可执行), alias 与 function 都不算
    done
    # command -v $1 &> /dev/null
    # 
}

function is_ios() {
    [[ -d "/Applications/Cydia.app" ]]
}

# contains(string, substring)
#
# Returns 0 if the specified string contains the specified substring, otherwise returns 1.
contains() {
    string="$1"
    substring="$2"
    if is_ios; then # inside iPhone
        [[ "${string#*"$substring"}" != "$string" ]]
    else
        [[ "$string" =~ $substring ]]
    fi
}

function is_darwin() {
    contains "$SYSTEM_NAME" "Darwin"
}

function is_home() {
    contains "${(L)HOST}" "home"
}

function is_work() {
    contains "${(L)HOST}" "work"
}

function is_hanley() {
    contains "${(L)HOST}" "hanley"
}

function is_tmux() {
    [[ -n "$TMUX" ]]
}

# source if file exists, can pass many files
function source_if_exists() {
    for file in "$@"; do
        [[ -f "$file" ]] && source "$file"
    done
}

# Extend $PATH without duplicates
function insert_path_if_exists() {
    [[ -d "$1" ]] || return # detect if it is a directory, return if not
    # if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
    export PATH="$1:$PATH"
    # fi
}

# insert path to variable, the first arg is variable name, the remain variable is path list
# -> Void
function insert_path_to_variable() {
    env_var_name="$1" # just the variable name, such as 'PATH'
    # env_var_content="${!env_var_name}" # real content under the variable name, such as '/Users/hanley/.pyenv/shims'
    eval "env_var_content=\"\${$env_var_name}\"" # zsh doesn't support indirect expansion, so we have to use eval!
    for local_path in "${@:2}"; do
        [ -d "$local_path" ] || continue   # exit if path isn't exist
        if [ -z "$env_var_content" ]; then # don't add ':' if this variable is empty
            env_var_content="$local_path"
        else
            env_var_content="${local_path}:${env_var_content}"
        fi
        eval "${env_var_name}=$env_var_content" # use eval to set value for variable, such as 'PATH=/Users/hanley/...'
    done
    export "${env_var_name?}" # export, such as 'export PATH'
}

function mkdir_if_not_exists() {
    for dir in "$@"; do
        [[ -d "$dir" ]] || mkdir -pv "$dir"
    done
}

# Remove element of given array when the referenced path by element is not existed
# Pass the name of the array to the function and then the function can read the array by interpreting the name as a variable name.
# https://stackoverflow.com/a/14693738/11884593
function remove_element_if_path_not_exist() {
    local arr_name=$1
    # echo "first array element is: " ${(P)${arr_name}[1]}
    path_arr=(${(P)${arr_name}[*]})

    # echo ${(t)path_arr}
    for ((i = $#path_arr; i >= 1; i--)); do
        if [[ ! -d ${path_arr[i]} ]]; then
            eval "${arr_name}[$i]=()" # array[1]=()
        fi
    done
    # for dir in ${path_arr[@]}; do
    # done
}

#***************   init primitive path   *****************
path=(
    "/opt/homebrew/bin"
    "/usr/local/bin"
    "${path[@]}"
)
remove_element_if_path_not_exist path
export PATH

#***************   Homebrew   *****************
if command_exists brew; then
    export HOMEBREW_NO_AUTO_UPDATE=true # 禁用 Homebrew 每次安装软件时的更新
    export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true
    export HOMEBREW_DOWNLOAD_CONCURRENCY=auto # 并发下载, upgrade 时非常有用
    # export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    eval "$(brew shellenv)" # this line will export some variable, such as below:
    # export HOMEBREW_PREFIX="/usr/local";
    # export HOMEBREW_CELLAR="/usr/local/Cellar";
    # export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
    # export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
    # export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
    # export INFOPATH="/usr/local/share/info:${INFOPATH:-}";

    # MARK: 恢复仓库上游
    # unset HOMEBREW_BREW_GIT_REMOTE
    # git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

    # unset HOMEBREW_API_DOMAIN
    # unset HOMEBREW_CORE_GIT_REMOTE
    # BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
    # for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
        # if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then  # 只复原已安装的 Tap
            # brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
        # fi
    # done
    # brew update
fi

