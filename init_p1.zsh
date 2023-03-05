# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

if [ -z "$_INIT_ZSH_LOADED" ]; then
    _INIT_ZSH_LOADED=1
else
    return
fi

source "$ZDOTDIR/basic/preinit.zsh"
# source "$ZDOTDIR/basic/export_var.zsh"

# MARK: Source file
_path_arr=(
    "$ZDOTDIR/basic/export_var.zsh"
    "$ZDOTDIR/basic/lficons.zsh"
)

for file in "${_path_arr[@]}"; do
    [[ -f "$file" ]] && source "$file"
done

unset _path_arr
