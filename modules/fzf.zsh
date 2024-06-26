# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# MARK: fzf 必须通过源码安装

# Auto-completion↩
# ---------------↩
[[ $- == *i* ]] && ([[ -f "$HOME/.fzf/shell/completion.zsh" ]] && source "$HOME/.fzf/shell/completion.zsh") 2>/dev/null

# Key bindings↩
# ------------↩
[[ -f "$HOME/.fzf/shell/key-bindings.zsh" ]] && source "$HOME/.fzf/shell/key-bindings.zsh"

fzf-history-widget-accept() {
    fzf-history-widget
    zle accept-line
}
zle -N fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# z extension
unalias z 2>/dev/null

# z() {
#     [ $# -gt 0 ] && _z "$*" && return
#     cd "$(_z -l 2>&1 | fzf --height 60% --nth 2.. --preview-window hidden --reverse --inline-info +s --tac --query "${*##-* }" | sed 's/^[0-9,.]* *//')"
# }

if command_exists fd; then
    # command for listing path candidates.
    _fzf_compgen_path() {
        fd --hidden --follow -I --exclude ".git" . "$1"
    }

    # Use fd to generate the list for directory completion
    _fzf_compgen_dir() {
        fd --type d --hidden -I -follow --exclude ".git" . "$1"
    }

    # go into directory
    fdc() {
        local dir
        dir=$(
            fd "${1:-.}" \
                --hidden \
                --follow \
                -I \
                --exclude={Pods,.git,.idea,.sass-cache,node_modules,build} \
                --type d 2>/dev/null |
                fzf +m
        ) &&
            cd "$dir" ||
            return
        #dir=$(find ${1:-.} -type d 2> /dev/null | fzf +m) && cd "$dir"
    }

fi

# fdr - cd to selected parent directory
fdp() {
    local dirs=()
    get_parent_dirs() {
        if [[ -d "${1}" ]]; then dirs+=("$1"); else return; fi
        if [[ "${1}" == '/' ]]; then
            for _dir in "${dirs[@]}"; do echo "$_dir"; done
        else
            get_parent_dirs "$(dirname "$1")"
        fi
    }
    local DIR
    DIR="$(get_parent_dirs "$(realpath "${1:-$PWD}")" | fzf-tmux --tac)"
    cd "$DIR" || return
}

# kill process
fkill() {
    local pid
    pid=$(ps -ef | sed 1d | fzf -m | awk '{print $2}')
    if [ "x$pid" != "x" ]; then
        echo "$pid" | xargs kill -"${1:-9}"
    fi
}

if command_exists brew; then

    # Install or open the webpage for the selected application
    # using brew cask search as input source
    # and display a info quickview window for the currently marked application
    brewi() {
        local token
        token=$(brew search --casks "$1" | fzf-tmux --query="$1" +m --preview 'brew info {}')

        if [ "x$token" != "x" ]; then
            echo "(I)nstall or open the (h)omepage of $token"
            read -r input
            if [ "$input" = "i" ] || [ "$input" = "I" ]; then
                brew install "$token"
            fi
            if [ "$input" = "h" ] || [ "$input" = "H" ]; then
                brew home "$token"
            fi
        fi
    }

    # Uninstall or open the webpage for the selected application
    # using brew list as input source (all brew cask installed applications)
    # and display a info quickview window for the currently marked application
    brewu() {
        local token
        token=$(brew list --formula | fzf-tmux --query="$1" +m --preview 'brew info {}')

        if [ "x$token" != "x" ]; then
            echo "(U)ninstall or open the (h)omepage of $token"
            read -r input
            if [ "$input" = "u" ] || [ "$input" = "U" ]; then
                brew uninstall "$token"
            fi
            if [ "$input" = "h" ] || [ "$token" = "h" ]; then
                brew home "$token"
            fi
        fi
    }

fi

# ***************   z.lua   *****************
function _zfzf_keymap {
    if command_exists _zlua; then
        local dir=$(eval "_zlua -l -t | sed 's/^-[0-9,.]* *//' | ${_ZL_FZF} --tac")
        # _zlua -I -t .
        cd "${dir}" || return

        if [[ -z "$lines" ]]; then
            # zle && zle reset-prompt
            zle && zle redraw-prompt
        fi
    else
        echo "z.lua is not installed!"
    fi
}

# *************** zoxide *****************
function _zi_keymap {
    if command_exists zoxide; then
        local dir=$(zoxide query -i)
        # _zlua -I -t .
        cd "${dir}" || return

        if [[ -z "$lines" ]]; then
            # zle && zle reset-prompt
            zle && zle redraw-prompt
        fi
    else
        echo "zoxide is not installed!"
    fi
}

# *************** autojump *****************
# jump to history directories
function _autojump_fzf_keymap() {
    if command_exists autojump; then
        cd "$(autojump -s | sort -k1gr | awk '$1 ~ /[0-9]:/ && $2 ~ /^\// { for (i=2; i<=NF; i++) { print $(i) } }' | eval ${FZF_WITH_COMMAND_AND_ARGS})"

        if [[ -z "$lines" ]]; then
            # zle && zle reset-prompt
            zle && zle redraw-prompt
        fi
    else
        echo "autojump is not installed!"
    fi
}

if command_exists ag; then
    # fuzzy grep open via ag
    fa() {
        local file
        file="$(ag --nobreak --noheading "$@" | fzf -0 -1 | awk -F: '{print $1}')"
        if [[ -n $file ]]; then
            $EDITOR "$file"
        fi
    }
fi

if command_exists tmux; then
    # fs [FUZZY PATTERN] - Select selected tmux session
    #   - Bypass fuzzy finder if there's only one match (--select-1)
    #   - Exit if there's no match (--exit-0)
    fs() {
        local session
        session=$(tmux list-sessions -F "#{session_name}" |
            fzf --query="$1" --select-1 --exit-0) &&
            tmux switch-client -t "$session"
    }

    # tm - create new tmux session, or switch to existing one. Works from within tmux too
    # # `tm` will allow you to select your tmux session via fzf.
    # # `tm irc` will attach to the irc session (if it exists), else it will create it.
    tm() {
        [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
        if [ "$1" ]; then
            tmux "$change" -t "$1" 2>/dev/null || (tmux new-session -d -s "$1" && tmux "$change" -t "$1")
            return
        fi
        session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) && tmux "$change" -t "$session" || echo "No sessions found."
    }
fi
