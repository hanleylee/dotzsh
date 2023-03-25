# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Sets color variable such as $fg, $bg, $color and $reset_color
colors

# Default coloring for BSD-based ls
export LSCOLORS="Gxfxcxdxbxegedabagacad"
if command_exists dircolors; then
    if [[ -f "${ZDOTDIR}/.dircolors" ]]; then
        eval "$(dircolors -b "${ZDOTDIR}/.dircolors")"
    else
        eval "$(dircolors -b)"
    fi
else
    export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"
fi

# Prompt function theming defaults
ZSH_THEME_GIT_PROMPT_PREFIX="git:("   # Beginning of the git prompt, before the branch name
ZSH_THEME_GIT_PROMPT_SUFFIX=")"       # End of the git prompt
ZSH_THEME_GIT_PROMPT_DIRTY="*"        # Text to display if the branch is dirty
ZSH_THEME_GIT_PROMPT_CLEAN=""         # Text to display if the branch is clean
ZSH_THEME_RUBY_PROMPT_PREFIX="("
ZSH_THEME_RUBY_PROMPT_SUFFIX=")"

# Use diff --color if available
if command diff --color /dev/null{,} &>/dev/null; then
    function diff {
        command diff --color "$@"
    }
fi

function test-ls-args {
    local cmd="$1"          # ls, gls, colorls, ...
    local args="${@[2,-1]}" # arguments except the first one
    command "$cmd" "$args" /dev/null &>/dev/null
}

# Find the option for using colors in ls, depending on the version
case "$OSTYPE" in
    netbsd*)
        # On NetBSD, test if `gls` (GNU ls) is installed (this one supports colors); otherwise, leave ls as is, because NetBSD's ls doesn't support -G
        test-ls-args gls --color && alias ls='gls --color=tty'
        ;;
    openbsd*)
        # On OpenBSD, `gls` (ls from GNU coreutils) and `colorls` (ls from base, with color and multibyte support) are available from ports.
        # `colorls` will be installed on purpose and can't be pulled in by installing coreutils (which might be installed for ), so prefer it to `gls`.
        test-ls-args gls --color && alias ls='gls --color=tty'
        test-ls-args colorls -G && alias ls='colorls -G'
        ;;
    (darwin|freebsd)*)
        # This alias works by default just using $LSCOLORS
        test-ls-args ls -G && alias ls='ls -G'
        # Only use GNU ls if installed and there are user defaults for $LS_COLORS, as the default coloring scheme is not very pretty
        [[ -n "$LS_COLORS" || -f "$HOME/.dircolors" ]] && test-ls-args gls --color && alias ls='gls --color=tty'
        ;;
    *)
        if test-ls-args ls --color; then
            alias ls='ls --color=tty'
        elif test-ls-args ls -G; then
            alias ls='ls -G'
        fi
        ;;
    esac

unfunction test-ls-args
