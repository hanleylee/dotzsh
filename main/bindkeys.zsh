# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

bindkey -e # 使用 Emacs 键位
# bindkey -v # 使用 Vim 键位

zle -N smartdots
bindkey . smartdots

# Edit the current command line in $EDITOR
zle -N edit-command-line
bindkey '^X^E' edit-command-line
# bindkey '\C-x\C-e' edit-command-line

bindkey ',' autosuggest-accept
bindkey "^u" backward-kill-line
bindkey -M emacs '^?' backward-delete-char # [Backspace] - delete backward
bindkey -M emacs "^[[3~" delete-char # [Delete] - delete forward
bindkey -M emacs "^[3;5~" delete-char
bindkey -M emacs '^[[3;5~' kill-word # [Ctrl-Delete] - delete whole forward-word
bindkey -M emacs '^[[1;5C' forward-word # [Ctrl-RightArrow] - move forward one word
bindkey -M emacs '^[[1;5D' backward-word # [Ctrl-LeftArrow] - move backward one word
bindkey '\ew' kill-region                             # [Esc-w] - Kill from the cursor to the mark
bindkey -s '\el' 'ls\n'                               # [Esc-l] - run command: ls
bindkey '^r' history-incremental-search-backward      # [Ctrl-r] - Search backward incrementally for a specified string. The string may begin with ^ to anchor the search to the beginning of the line.
bindkey ' ' magic-space                               # [Space] - don't do history expansion
bindkey "^[m" copy-prev-shell-word # file rename magick
bindkey -M menuselect '^o' accept-and-infer-next-history

# zle -N _lfcd_keymap
# bindkey '^l' _lfcd_keymap
zle -N _yazicd_keymap
bindkey '^l' _yazicd_keymap
# bindkey -s '^l' '_yazicd_keymap \n'

# Use z.lua
# zle -N _zfzf_keymap
# bindkey '^h' _zfzf_keymap
# Use autojump
# zle -N autojump_fzf_keymap
# bindkey '^h' autojump_fzf_keymap
# Use zoxide
zle -N _zi_keymap
bindkey '^h' _zi_keymap

# Make sure that the terminal is in application mode when zle is active, since
# only then values from $terminfo are valid
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
    function zle-line-init() {
        echoti smkx
    }
    function zle-line-finish() {
        echoti rmkx
    }
    zle -N zle-line-init
    zle -N zle-line-finish
fi

# Start typing + [Up-Arrow] - fuzzy find history forward
if [[ -n "${terminfo[kcuu1]}" ]]; then
    autoload -U up-line-or-beginning-search
    zle -N up-line-or-beginning-search

    bindkey -M emacs "${terminfo[kcuu1]}" up-line-or-beginning-search
    # bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
    # bindkey -M vicmd "${terminfo[kcuu1]}" up-line-or-beginning-search
fi

# Start typing + [Down-Arrow] - fuzzy find history backward
if [[ -n "${terminfo[kcud1]}" ]]; then
    autoload -U down-line-or-beginning-search
    zle -N down-line-or-beginning-search

    bindkey -M emacs "${terminfo[kcud1]}" down-line-or-beginning-search
fi

# [Home] - Go to beginning of line
if [[ -n "${terminfo[khome]}" ]]; then
    bindkey -M emacs "${terminfo[khome]}" beginning-of-line
fi
# [End] - Go to end of line
if [[ -n "${terminfo[kend]}" ]]; then
    bindkey -M emacs "${terminfo[kend]}"  end-of-line
fi

