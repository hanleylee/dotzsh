# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

#███████████████████████   ALIAS   ██████████████████████████
# setopt aliases

alias -g ND='*(/om[1])'           # newest directory
alias -g NF='*(.om[1])'           # newest file
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

# for os X system {{{
alias chrome="open -a \"Google Chrome\""
# mount all connected Firewire disks
alias mountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil mountDisk $i; done)'
# unmount them all
alias unmountall='system_profiler SPFireWireDataType | grep "BSD Name: disk.$" | sed "s/^.*: //" | (while read i; do /usr/sbin/diskutil unmountDisk $i; done)'
# My IP
alias myip='ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'
# mute the system volume
alias stfu="osascript -e 'set volume output muted true'"
# }}}

# alias Z='z -I .'
# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'
# Go to the /home/$USER (~) directory and clears window of your terminal
alias q="~ && clear"

alias mv="mv -v"
alias cp="cp -v"

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
[[ -d "$HOME/.hlconfig.git" ]] && alias hlconfig='git --git-dir=$HOME/.hlconfig.git/ --work-tree=$HOME'

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

# for git {{{
alias reignore='git rm -r --cached . && git add .'
alias whyignore='git check-ignore -v'
alias git-root='cd $(git rev-parse --show-toplevel)'
alias gpm="git push origin master"
alias ungit="find . -name '.git' -exec rm -rf {} \;"
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
    alias vmore="vim -u ~/.vim/.vimrc_more -U NONE -i NONE -" # for pager
fi
# }}}

# for macvim {{{
if command_exists mvim; then
    alias mvimpod='mvim --remote-tab Podfile'
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

# for iproxy {{{
if command_exists vim; then
    alias iproxy_iphone7='iproxy 2222 22'
    alias iproxy_ipadpro='iproxy 2223 22'
    alias iproxy_iphone12='iproxy 2224 22'
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
