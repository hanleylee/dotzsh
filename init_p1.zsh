# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

if [ -z "$_INIT_ZSH_PHASE1" ]; then
    _INIT_ZSH_PHASE1=1
else
    return
fi

source "$ZDOTDIR/basic/preinit.zsh"

# MARK: Source file
_path_arr=(
    "$ZDOTDIR/basic/export_var.zsh"
    "$ZDOTDIR/basic/lficons.zsh"
)

source_if_exists "${_path_arr[@]}"

unset _path_arr
