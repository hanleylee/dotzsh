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
            # zle -I
            # zle redisplay
        fi
    else
        echo "yazi is not installed!"
    fi
}

# Change Yazi's CWD to PWD on subshell exit
if [[ -n "$YAZI_ID" ]]; then
	function _yazi_cd() {
		ya emit cd "$PWD"
	}
	add-zsh-hook zshexit _yazi_cd
fi
