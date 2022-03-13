# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

[[ -f "$ZDOTDIR/init.zsh" ]] && source "$ZDOTDIR/init.zsh"

_path_arr=(
    "$ZDOTDIR/main/main.zsh"
    "$ZDOTDIR/main/completion.zsh"
    "$ZDOTDIR/main/zinit.zsh"
    "$ZDOTDIR/main/eval_tools.zsh"
    "$HOME/.cargo/env"
    "$XDG_CONFIG_HOME/lf/lfcd.sh"
    "$XDG_CONFIG_HOME/broot/launcher/bash/br"
    "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"
)
[[ $TERM_PROGRAM == "iTerm.app" ]] && _path_arr+=("$ZDOTDIR/.iterm2_shell_integration.zsh")
source_if_exists "${_path_arr[@]}"

unset _path_arr
