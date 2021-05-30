# MARK: 仅用于添加一些需要在初始化开始时就需要的公共变量或方法

arch_name="$(uname -m)"

if [ "${arch_name}" = "x86_64" ]; then
    export HOMEBREW_PREFIX='/usr/local'
    if [ "$(sysctl -in sysctl.proc_translated)" = "1" ]; then
        echo "Running on Rosetta 2"
    else
        echo "Running on native Intel"
    fi 
elif [ "${arch_name}" = "arm64" ]; then
    export HOMEBREW_PREFIX='/opt/homebrew'
    echo "Running on ARM"
else
    echo "Unknown architecture: ${arch_name}"
fi

# one command exist or not
# -> Bool
function command_exists() {
    # command -v $1 &> /dev/null
    [[ -x "$(command -v $1)" ]]
}

# source if file exists, can pass many file
# -> Void
function source_if_exists() {
    for file in "$@"; do
        [[ -f $file ]] && source $file
    done
}
