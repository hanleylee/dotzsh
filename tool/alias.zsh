#███████████████████████   ALIAS   ██████████████████████████
alias reignore='git rm -r --cached . && git add .'
alias whyignore='git check-ignore -v'
command_exists trash              && alias rm='trash'
command_exists nvim               && alias nv="nvim"
command_exists exa                && alias l='exa -laghHimU --git --group-directories-first --icons -F' || alias l='ls -lhia'
[[ -d "$HOME/.hlconfig.git" ]]    && alias hlconfig="git --git-dir=$HOME/.hlconfig.git/ --work-tree=$HOME"
[[ -f "/opt/homebrew/bin/brew" ]] && alias abrew='arch -arm64 /opt/homebrew/bin/brew'
[[ -f "/usr/local/bin/brew" ]]    && alias ibrew='arch -x86_64 /usr/local/bin/brew'

if command_exists vim; then
    alias v0='vim -u NONE -U NONE -N -i NONE'
    alias v1='vim --cmd "let g:vim_weight=1"'
    alias v2='vim --cmd "let g:vim_weight=2"'
    alias v3='vim --cmd "let g:vim_weight=3"'
    alias v4='vim --cmd "let g:vim_weight=4"'
fi

if command_exists vim; then
    alias iproxy_iphone7='iproxy 2222 22'
    alias iproxy_ipadpro='iproxy 2223 22'
    alias iproxy_iphone12='iproxy 2224 22'
fi

# Go to the /home/$USER (~) directory and clears window of your terminal
alias q="~ && clear"
# alias Z='z -I .'
# Show $PATH in readable view
alias path='echo -e ${PATH//:/\\n}'
# My IP
alias myip='ifconfig | sed -En "s/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p"'
# Password generator
# Gemnerate random password, copies it into clipboard and outputs it to terminal
if command_exists pbcopy; then
  alias password='openssl rand -base64 ${1:-9} | pbcopy ; echo "$(pbpaste)"'
fi

# Download web page with all assets
alias getpage='wget --no-clobber --page-requisites --html-extension --convert-links --no-host-directories'

# Download file with original filename
alias get="curl -O -L"

alias git-root='cd $(git rev-parse --show-toplevel)'