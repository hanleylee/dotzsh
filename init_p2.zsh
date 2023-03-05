# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

_path_arr=(
    "$ZDOTDIR/main/config-dir.zsh"
    "$ZDOTDIR/main/option.zsh"
    "$ZDOTDIR/main/completion.zsh"
    "$ZDOTDIR/main/appearance.zsh"
    "$ZDOTDIR/main/zinit.zsh"
    "$ZDOTDIR/main/bindkeys.zsh"
    "$ZDOTDIR/main/function.zsh"
    "$ZDOTDIR/main/alias.zsh"
    "$ZDOTDIR/main/eval_tools.zsh"
)

# MARK: Tools
_path_arr+=(
    "$HOME/.cargo/env"
    "$XDG_CONFIG_HOME/broot/launcher/bash/br"
    "$HOMEBREW_PREFIX/etc/profile.d/autojump.sh"
)
if [[ $TERM_PROGRAM == "iTerm.app" ]] && [[ -d "$ZDOTDIR/.iterm2_shell_integration.zsh" ]]; then
    _path_arr+=("$ZDOTDIR/.iterm2_shell_integration.zsh")
fi

if is_work; then
    _path_arr+=("$HL_REPO/bnc-note/sh/main.zsh")
fi

for file in "${_path_arr[@]}"; do
    [[ -f "$file" ]] && source "$file"
done

unset _path_arr
