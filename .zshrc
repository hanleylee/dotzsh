# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

_path_arr=(
    "$ZDOTDIR/init.zsh"
    "$ZDOTDIR/main/main.zsh"
    "$ZDOTDIR/main/completion.zsh"
    "$ZDOTDIR/main/zinit.zsh"
    "$ZDOTDIR/main/eval_tools.zsh"
    "$ZDOTDIR/base/lficons.zsh"
    "$HOME/.cargo/env"
    "$XDG_CONFIG_HOME/lf/lfcd.sh"
    "$XDG_CONFIG_HOME/broot/launcher/bash/br"
)
[[ $TERM_PROGRAM == "iTerm.app" ]] && _path_arr+=("$ZDOTDIR/.iterm2_shell_integration.zsh")
source_if_exists "${_path_arr[@]}"

unset _path_arr
