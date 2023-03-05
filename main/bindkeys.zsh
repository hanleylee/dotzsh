# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

zle -N smartdots
bindkey . smartdots

# ^Xe 用 $EDITOR 编辑命令
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

bindkey -e # 使用 Emacs 键位
bindkey ',' autosuggest-accept
bindkey "^u" backward-kill-line

# bindkey "\eB" zsh-backward-word
# bindkey "\eF" zsh-forward-word
# bindkey "\eW" zsh-backward-kill-word

if command_exists lf; then
    zle -N _lfcd
    bindkey '^l' _lfcd
fi

if command_exists fzf; then
    # Use z.lua
    zle -N _zfzf
    bindkey '^h' _zfzf
    # Use autojump
    # zle -N autojump_fzf
    # bindkey '^h' autojump_fzf
    # Use zoxide
    # zle -N _zi
    # bindkey '^h' _zi
fi
