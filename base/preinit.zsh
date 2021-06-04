# MARK: 仅用于添加一些需要在初始化开始时就需要的公共变量或方法

arch_name=$(uname -m)

if [[ ${arch_name} = "x86_64" ]]; then
    export HOMEBREW_PREFIX='/usr/local'
    if [ $(sysctl -in sysctl.proc_translated) = "1" ]; then
        ARCH_MSG="Running on Rosetta 2"
    else
        ARCH_MSG="Running on native Intel"
    fi 
elif [[ ${arch_name} = "arm64" ]]; then
    export HOMEBREW_PREFIX='/opt/homebrew'
    ARCH_MSG="Running on ARM"
# elif [[ $arch_name =~ "iPhone" ]]; then
#     export HOMEBREW_PREFIX='/usr/local'
#     echo "Running on iPhone"
# elif [[ $arch_name =~ "iPad" ]]; then
#     export HOMEBREW_PREFIX='/usr/local'
#     echo "Running on iPad"
else
    ARCH_MSG="Unknown architecture: ${arch_name}"
fi
export ARCH_MSG

# all command passed exist or not
# -> Bool
function command_exists() {
    for cmd in $@; do
        command -v $cmd &> /dev/null || return 1
    done
    # command -v $1 &> /dev/null
    # [[ -x "$(command -v $1)" ]]
}

# source if file exists, can pass many file
# -> Void
function source_if_exists() {
    for file in "$@"; do
        [[ -f $file ]] && source $file
    done
}

# Extend $PATH without duplicates
function insert_path_if_exists() {
    [[ -d $1 ]] || return # detect if it is a directory, return if not
    if ! $( echo "$PATH" | tr ":" "\n" | grep -qx "$1" ) ; then
        export PATH="$1:$PATH"
    fi
}
