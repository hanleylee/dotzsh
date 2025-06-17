function yazicd() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    IFS= read -r -d '' cwd <"$tmp"
    [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
    rm -f -- "$tmp"
}

function _yazicd_keymap() {
    if command_exists yazi; then
        yazicd

        if [[ -z "$lines" ]]; then
            # zle && zle reset-prompt
            zle && zle redraw-prompt
        fi
    else
        echo "yazi is not installed!"
    fi
}
