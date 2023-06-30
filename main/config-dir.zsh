# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

_dir_path_array=(
    "$HL_LOCAL/bin"
    "$HL_LOCAL/bin/sh"
    "$XDG_DATA_HOME"
    "$XDG_CONFIG_HOME"
    "$XDG_CACHE_HOME"
    "$XDG_CACHE_HOME/build/c"
    "$XDG_CACHE_HOME/build/cpp"
    "$XDG_CACHE_HOME/build/objc"
    "$XDG_CACHE_HOME/build/swift"
    "$XDG_CACHE_HOME/tags"
    "$XDG_CACHE_HOME/vim/backup"
    "$XDG_CACHE_HOME/vim/swp"
    "$XDG_CACHE_HOME/vim/undo"
    "$XDG_CACHE_HOME/emacs/backup"
    "$XDG_CACHE_HOME/zsh"
)
mkdir_if_not_exists  "${_dir_path_array[@]}"
unset _dir_path_array
