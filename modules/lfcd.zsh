# Change working dir in shell to last dir in lf on exit (adapted from ranger).
#
# You need to either copy the content of this file to your shell rc file
# (e.g. ~/.bashrc) or source this file directly:
#
#     LFCD="/path/to/lfcd.sh"
#     if [ -f "$LFCD" ]; then
#         source "$LFCD"
#     fi
#
# You may also like to assign a key to this command:
#
#     bind '"\C-o":"lfcd\C-m"'  # bash
#     bindkey -s '^o' 'lfcd\n'  # zsh
#

if ! command_exists lf; then
    return
fi

function lfcd() {
    tmp="$(mktemp)"
    # lf -last-dir-path="$tmp" "$@"
    lf -last-dir-path="$tmp"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        if [ -d "$dir" ]; then
            if [ "$dir" != "$(pwd)" ]; then
                cd "$dir" || return
            fi
        fi
    fi
}

function _lfcd() {
    lfcd

    if [[ -z "$lines" ]]; then
        # zle && zle reset-prompt
        zle && zle redraw-prompt
    fi
}
