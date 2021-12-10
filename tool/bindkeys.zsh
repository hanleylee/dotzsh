# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Quick change directories
# Expands .... -> ../../../

smartdots() {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N smartdots
bindkey . smartdots

zle -N _zfzf
bindkey -e # 使用 Emacs 键位
bindkey ',' autosuggest-accept
bindkey "^u" backward-kill-line

if command_exists lf; then
    bindkey -s "^o" 'lfcd^M'
fi

if command_exists lazygit; then
    bindkey -s "^g" 'lg^M'
fi

if command_exists fzf; then
    bindkey '^h' _zfzf
fi
