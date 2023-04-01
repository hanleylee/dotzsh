# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

if [ -z "$_INIT_ZSH_PHASE2" ]; then
    _INIT_ZSH_PHASE2=1
else
    return
fi

_path_arr=(
    "$ZDOTDIR/main/autoload.zsh"
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
    "$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    "$HOME/.orbstack/shell/init.zsh"
)
if [[ $TERM_PROGRAM == "iTerm.app" ]] && [[ -d "$ZDOTDIR/.iterm2_shell_integration.zsh" ]]; then
    _path_arr+=("$ZDOTDIR/.iterm2_shell_integration.zsh")
fi

if is_work; then
    _path_arr+=("$HL_REPO/bnc-note/sh/main.zsh")
fi

_path_arr+=("$HL_REPO/reverse/sh/main.zsh")

source_if_exists "${_path_arr[@]}"

unset _path_arr
