# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

#███████████████████████   ALIAS   ██████████████████████████
# setopt aliases

autoload -Uz is-at-least
git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

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

# <https://github.com/kovidgoyal/kitty/issues/268>
alias clearbuf="printf '\033[2J\033[3J\033[1;1H'"

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
alias lg='lazygit'
alias g='git'
alias reignore='git rm -r --cached . && git add .'
alias whyignore='git check-ignore -v'
alias git-root='cd $(git rev-parse --show-toplevel)'
alias gpm="git push origin master"
alias ungit="find . -name '.git' -exec rm -rf {} \;"

alias ga='git add'
alias gaa='git add --all'
alias gapa='git add --patch'
alias gau='git add --update'
alias gav='git add --verbose'

# MARK: git apply
alias gap='git apply'
alias gapt='git apply --3way'

# MARK: git branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
alias gbD='git branch -D'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'


# MARK: git blame
alias gbl='git blame -b -w'

# MARK: git bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# MARK: git commit
alias gc='git commit -v'
alias gc!='git commit -v --amend'
alias gcn!='git commit -v --no-edit --amend'
alias gca='git commit -v -a'
alias gca!='git commit -v -a --amend'
alias gcan!='git commit -v -a --no-edit --amend'
alias gcans!='git commit -v -a -s --no-edit --amend'
alias gcam='git commit -a -m'
alias gcsm='git commit -s -m'
alias gcas='git commit -a -s'
alias gcasm='git commit -a -s -m'
alias gcmsg='git commit -m'
alias gcs='git commit -S'
alias gcss='git commit -S -s'
alias gcssm='git commit -S -s -m'

# MARK: git checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout $(git_develop_branch)'
alias gcor='git checkout --recurse-submodules'

# MARK: git config
alias gcf='git config --list'

# MARK: git clone
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# MARK: git diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdw='git diff --word-diff'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdtlk='git difftool -y -t Kaleidoscope'
alias gdup='git diff @{upstream}'

# MARK: git fetch
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfo='git fetch origin'

# MARK: git ls-file
alias gfg='git ls-files | grep'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-ls="\\ls -A --group-directories-first -1 | while IFS= read -r line; do git log --color --format=\"\$(\\ls -d -F --color \"\$line\") =} %C(bold black)▏%Creset%Cred%h %Cgreen(%cr)%Creset =} %C(bold black)▏%Creset%s %C(bold blue)<%an>%Creset\" --abbrev-commit --max-count 1 HEAD -- \"\$line\"; done | awk -F'=}' '{ nf[NR]=NF; for (i = 1; i <= NF; i++) { cell[NR,i] = \$i; gsub(/\\033\\[([[:digit:]]+(;[[:digit:]]+)*)?[mK]/, \"\", \$i); len[NR,i] = l = length(\$i); if (l > max[i]) max[i] = l; } } END { for (row = 1; row <= NR; row++) { for (col = 1; col < nf[row]; col++) printf \"%s%*s%s\", cell[row,col], max[col]-len[row,col], \"\", OFS; print cell[row,nf[row]]; } }'"

# MARK: git gui
alias gg='git gui citool'
alias gga='git gui citool --amend'

# MARK: git help
alias ghh='git help'

# MARK: git update-index
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

# MARK: git log
alias glg="git lg"
alias glgp='git log --stat -p'
alias glgg='git log --graph'
alias glgga='git log --graph --decorate --all'
alias glgm='git log --graph --max-count=10'
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glols="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"
alias glod="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset'"
alias glods="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ad) %C(bold blue)<%an>%Creset' --date=short"
alias glola="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'
alias glp="_git_log_prettily"

# MARK: git merge
alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmtl='git mergetool --no-prompt'
alias gmtlvim='git mergetool --no-prompt --tool=vimdiff'
alias gmtlk='git mergetool -y -t Kaleidoscope'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'

# MARK: git pull
alias gl='git pull'
alias glr='git pull --rebase'
alias gup='git pull --rebase'
alias gupv='git pull --rebase -v'
alias gupa='git pull --rebase --autostash'
alias gupav='git pull --rebase --autostash -v'
alias glum='git pull upstream $(git_main_branch)'
alias ggpull='git pull origin "$(git_current_branch)"'

# MARK: git push
alias gp='git push'
alias gu='git push -u origin HEAD'
alias gpd='git push --dry-run'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpoat='git push origin --all && git push origin --tags'
alias gpu='git push upstream'
alias gpv='git push -v'
alias ggpush='git push origin "$(git_current_branch)"'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# MARK: git remote
alias gr='git remote'
alias gra='git remote add'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'
alias grv='git remote -v'

# MARK: git rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'

# MARK: git revert
alias grev='git revert'

# MARK: git reset
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias gru='git reset --'
alias gpristine='git reset --hard && git clean -dffx'

# MARK: git rm
alias grm='git rm'
alias grmc='git rm --cached'

# MARK: git restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# MARK: git status
alias gs='git status'
alias gsb='git status -sb'
alias gss='git status -s'
alias gst='git status'

# MARK: git show
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

# MARK: git submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# MARK: git svn
alias gsr='git svn rebase'
alias gsd='git svn dcommit'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

# MARK: git stash
# use the default stash push on git 2.13 and newer
is-at-least 2.13 "$git_version" && alias gsta='git stash push' || alias gsta='git stash save'
alias gstaa='git stash apply'
alias gstc='git stash clear'
alias gstd='git stash drop'
alias gstl='git stash list'
alias gstp='git stash pop'
alias gsts='git stash show --text'
alias gstu='gsta --include-untracked'
alias gstall='git stash --all'

# MARK: git switch
alias gsw='git switch'
alias gswc='git switch -c'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'

# MARK: git tag
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

# MARK: git am
alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

unset git_version
# }}}

# for proxy {{{
alias set_http_proxy='export http_proxy="http://127.0.0.1:1080"'
alias set_https_proxy='export https_proxy="http://127.0.0.1:1080"'
alias set_all_proxy='export ALL_PROXY="http://127.0.0.1:1080"'
alias unset_http_proxy='unset http_proxy'
alias unset_https_proxy='unset https_proxy'
alias unset_all_proxy='unset ALL_PROXY'
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
# for iproxy {{{
if command_exists vim; then
    alias iproxy_iphone_7='iproxy 2222 22'
    alias iproxy_ipad_pro='iproxy 2223 22'
    alias iproxy_iphone_12='iproxy 2224 22'
    alias iproxy_iphone_se='iproxy 2225 22'
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
if (( $+aliases[colourify] )); then
  # default is better
  unalias gcc g++ 2>/dev/null || true
  # bug: https://github.com/garabik/grc/issues/72
  unalias mtr     2>/dev/null || true
  # buffering issues: https://github.com/garabik/grc/issues/25
  unalias ping    2>/dev/null || true
fi

# for flutter {{{
if command_exists flutter; then
    alias fua='flutter pub pub upgrade -C . && flutter pub pub upgrade -C ./example'
fi
# }}}

if is_darwin; then
    # alias show_external_ip='dig +short myip.opendns.com @resolver1.opendns.com'
    alias show_external_ip='curl -s https://api.ipify.org && echo'
    alias show_local_ip='ipconfig getifaddr en0'
    alias show_network_info='scutil --nwi'
    alias remove_dsstore="find . -type f -name '.DS_Store' -ls -delete"
    alias clipboard_convert_plain='pbpaste | textutil -convert txt -stdin -stdout -encoding 30 | pbcopy'
    alias clipboard_expand_tab='pbpaste | expand | pbcopy'
    alias clipboard_remove_duplicate='pbpaste | sort | uniq | pbcopy'
fi
