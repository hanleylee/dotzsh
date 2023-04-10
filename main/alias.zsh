# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

#███████████████████████   ALIAS   ██████████████████████████

alias -g ND='*(/om[1])' # newest directory
alias -g NF='*(.om[1])' # newest file
#alias -g NE='2>|/dev/null'
alias -g NO='&>|/dev/null'
alias -g VV='| vim -R -'
alias -g P='2>&1 | $PAGER'
alias -g L='| less'
alias -g M='| most'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g WC='| wc -l'
alias -g LL="2>&1 | less"
alias -g CA="2>&1 | cat -A"
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# <https://github.com/kovidgoyal/kitty/issues/268>
alias clearbuf="printf '\033[2J\033[3J\033[1;1H'"

# alias Z='z -I .'
# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'
alias fpath='echo -e ${FPATH//:/\\n}'
alias manpath='echo -e ${MANPATH//:/\\n}'
# Go to the /home/$USER (~) directory and clears window of your terminal
alias q="~ && clear"

alias mv="mv -v"
alias cp="cp -v"
alias py='python3'
alias :q="exit"
alias woman=man
alias copy="tr -d '\n' | pbcopy"

# for time {{{
alias d='date +%F'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%Y-%m-%d"'
alias nowdatetime='date +"%Y-%m-%d %T"'
# }}}

# Gemnerate random password, copies it into clipboard and outputs it to terminal
if command_exists pbcopy; then
    function password() {
        openssl rand -base64 "${1:-9}" | pbcopy
        pbpaste
    }
fi

# Download web page with all assets
alias getpage='wget --no-clobber --page-requisites --html-extension --convert-links --no-host-directories'

# Download file with original filename
alias get="curl -O -L"

command_exists trash && alias rm='trash'
command_exists gkill && alias kill='gkill'
command_exists gls && alias ls='gls --color=tty'
if command_exists exa; then alias l='exa -laghHimU --git --group-directories-first --icons -F'; else alias l='ls -lhia'; fi
# [[ -d "$HOME/.hlconfig.git" ]] && alias hlconfig='git --git-dir=$HOME/.hlconfig.git/ --work-tree=$HOME'

# for homebrew {{{
[[ -f "/opt/homebrew/bin/brew" ]] && alias abrew='arch -arm64 /opt/homebrew/bin/brew'
[[ -f "/usr/local/bin/brew" ]] && alias ibrew='arch -x86_64 /usr/local/bin/brew'
# }}}

# for ssh {{{
alias sshconfig="${EDITOR:-vim} ~/.ssh/config"
# }}}

# for z.lua {{{
alias zt='z -I -t .'
alias zr='z -I -r .'
alias zc='z -c'
alias zf='z -I'
alias zb='z -b'
alias zbi='z -b -i'
alias zbf='z -b -I'
alias zz='z -i'
alias zzc='zz -c'
# }}}

alias lg='lazygit'
# for proxy {{{
alias set_http_proxy='export http_proxy="http://127.0.0.1:1080"'
alias set_https_proxy='export https_proxy="http://127.0.0.1:1080"'
alias set_all_proxy='export all_proxy="http://127.0.0.1:1080"'
alias unset_http_proxy='unset http_proxy'
alias unset_https_proxy='unset https_proxy'
alias unset_all_proxy='unset all_proxy'
# }}}

# for pip {{{
command_exists pip && alias update_all_pip="pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U"
# }}}

# for vim {{{
if command_exists vim; then
    alias vn='vim -u NONE -U NONE -N -i NONE'      # no any config load, completely clean
    alias vc='vim --clean --cmd "set loadplugins"' # no any config load, completely clean
    alias vt='HOME=~/vim_test_home vim'
    alias v0='vim --cmd "let g:vim_weight=0"' # only load self config, no plugin
    alias v1='vim --cmd "let g:vim_weight=1"' # plugin to browsing
    alias v2='vim --cmd "let g:vim_weight=2"' # plugin to editing
    alias v3='vim --cmd "let g:vim_weight=3"' # plugin to enhanced editing
fi
# }}}

# for macvim {{{
if command_exists mvim; then
    # alias mvpod='mvim --remote-tab Podfile &>/dev/null'
    alias mvpod='[[ -f Podfile ]] && mvim --remote-tab-silent Podfile || mvim --remote-tab-silent Example/Podfile'
    alias mvflutter='mvim --remote-tab-silent lib/main.dart'
fi
# }}}

# for nvim {{{
if command_exists nvim; then
    alias nv="nvim"
    # alias nvn='nvim -u NONE -U NONE -N -i NONE'
    alias nvn='nvim --clean --cmd "set loadplugins"'
    alias nv0='nvim --cmd "let g:vim_weight=0"'
    alias nv1='nvim --cmd "let g:vim_weight=1"'
    alias nv2='nvim --cmd "let g:vim_weight=2"'
    alias nv3='nvim --cmd "let g:vim_weight=3"'
fi
# }}}

# for emacsclient {{{
if command_exists emacsclient; then
    # alias mvpod='mvim --remote-tab Podfile &>/dev/null'
    alias ecpod='[[ -f Podfile ]] && emacsclient -n Podfile || emacsclient -n Example/Podfile'
    alias ecflutter='emacsclient -n lib/main.dart'
fi
# }}}

# for ranger {{{
if command_exists ranger; then
    alias r='source ranger'
fi
# }}}

# for floaterm {{{
if command_exists floaterm; then
    alias f='floaterm'
fi
# }}}

# for dutree {{{
if command_exists dutree; then
    alias dt='dutree'
    alias ds='dutree --summary'
    alias d1='dutree --depth=1'
    alias d2='dutree --depth=2'
    alias d3='dutree --depth=3'
fi
# }}}

# grc aliases
if (($ + aliases[colourify])); then
    # default is better
    unalias gcc g++ 2>/dev/null || true
    # bug: https://github.com/garabik/grc/issues/72
    unalias mtr 2>/dev/null || true
    # buffering issues: https://github.com/garabik/grc/issues/25
    unalias ping 2>/dev/null || true
fi

# for flutter {{{
if command_exists flutter; then
    alias fua='flutter pub pub upgrade -C . && flutter pub pub upgrade -C ./example'
fi
# }}}

if is_darwin; then
    # alias show_external_ip='dig +short myip.opendns.com @resolver1.opendns.com'

    alias show_network_info='scutil --nwi'
    alias myip='ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'
    alias show_external_ip='curl -s https://api.ipify.org && echo'
    alias show_local_ip='ipconfig getifaddr en0'
    alias remove_dsstore="find . -type f -name '.DS_Store' -ls -delete"
    alias clipboard_convert_plain='pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy'
    alias clipboard_expand_tab='pbpaste | expand | pbcopy'
    alias clipboard_remove_duplicate='pbpaste | sort | uniq | pbcopy'
    alias chrome="open -a \"Google Chrome\""
    # mount all connected Firewire disks
    alias mountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil mountDisk $i; done)'
    # unmount them all
    alias unmountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil unmountDisk $i; done)'
    # mute the system volume
    alias stfu="osascript -e 'set volume output muted true'"

    if is-at-least 10.15 "$(sw_vers -productVersion)"; then
        alias displays='open /System/Library/PreferencePanes/Displays.prefPane'
    else
        alias displays='open /Library/PreferencePanes/Displays.prefPane'
    fi
fi
