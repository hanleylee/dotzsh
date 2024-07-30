# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# shellcheck disable=2298

autoload -Uz is-at-least
git_version="${${(As: :)$(git version 2>/dev/null)}[3]}"

# MARK: Alias for git {{{
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

# git apply
alias gap='git apply'
alias gap3='git apply --3way'

# git branch
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gbda='git branch --no-color --merged | command grep -vE "^([+*]|\s*($(git_main_branch)|$(git_develop_branch))\s*$)" | command xargs git branch -d 2>/dev/null'
alias gbD='git branch -D'
alias gbnm='git branch --no-merged'
alias gbr='git branch --remote'
alias gbl="git branch -a --sort=-committerdate --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]'"
alias ggsup='git branch --set-upstream-to=origin/$(git_current_branch)'


# git blame
# alias gbl='git blame -b -w'

# git bisect
alias gbs='git bisect'
alias gbsb='git bisect bad'
alias gbsg='git bisect good'
alias gbsr='git bisect reset'
alias gbss='git bisect start'

# git commit
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

# git checkout
alias gco='git checkout'
alias gcb='git checkout -b'
alias gcm='git checkout $(git_main_branch)'
alias gcd='git checkout $(git_develop_branch)'
alias gcor='git checkout --recurse-submodules'

# git config
alias gcf='git config --list'

# git clone
alias gcl='git clone --recurse-submodules'
alias gclean='git clean -id'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gcpa='git cherry-pick --abort'
alias gcpc='git cherry-pick --continue'

# git diff
alias gd='git diff'
alias gdca='git diff --cached'
alias gdw='git diff --word-diff'
alias gdcw='git diff --cached --word-diff'
alias gdct='git describe --tags $(git rev-list --tags --max-count=1)'
alias gds='git diff --staged'
alias gdt='git diff-tree --no-commit-id --name-only -r'
alias gdtk='git difftool -y -t Kaleidoscope'
alias gdtv='git difftool -y -t vimdiff'
alias gdtmv='git difftool -y -t gvimdiff'
alias gdup='git diff @{upstream}'

# git fetch
alias gf='git fetch'
alias gfa='git fetch --all --prune --jobs=10'
alias gfo='git fetch origin'

# git ls-file
alias gfg='git ls-files | grep'
alias gignored='git ls-files -v | grep "^[[:lower:]]"'
alias git-ls="\\ls -A --group-directories-first -1 | while IFS= read -r line; do git log --color --format=\"\$(\\ls -d -F --color \"\$line\") =} %C(bold black)▏%Creset%Cred%h %Cgreen(%cr)%Creset =} %C(bold black)▏%Creset%s %C(bold blue)<%an>%Creset\" --abbrev-commit --max-count 1 HEAD -- \"\$line\"; done | awk -F'=}' '{ nf[NR]=NF; for (i = 1; i <= NF; i++) { cell[NR,i] = \$i; gsub(/\\033\\[([[:digit:]]+(;[[:digit:]]+)*)?[mK]/, \"\", \$i); len[NR,i] = l = length(\$i); if (l > max[i]) max[i] = l; } } END { for (row = 1; row <= NR; row++) { for (col = 1; col < nf[row]; col++) printf \"%s%*s%s\", cell[row,col], max[col]-len[row,col], \"\", OFS; print cell[row,nf[row]]; } }'"

# git gui
alias gg='git gui citool'
alias gga='git gui citool --amend'

# git help
alias ghh='git help'

# git update-index
alias gignore='git update-index --assume-unchanged'
alias gunignore='git update-index --no-assume-unchanged'

# git log
alias glo='git log --oneline --decorate'
alias glol="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
alias glg="git log --graph --all --abbrev-commit --pretty=format:'%C(bold red)%h%Creset -%C(bold green)%d %C(bold yellow)%s %Creset- %C(red)%cd %Creset- %C(dim green)%an' --date=format:'%Y-%m-%d %H:%M:%S'"
# `glg -- stat`: 显示每次提交具体改动的文件
# `glg -p`: 显示每个文件的具体改动
# `glg -2`: 显示前两个提交
# `glg HEAD~3..HEAD`: 显示三次提交的记录(左开右闭, 且较早的提交写在左边)
# `glg -p -S networksetup`: 查找所有提交内容中包含 networksetup 的提交
# `glg -p --grep highlight`: 查找所有提交记录中包含 highlight 的提交
# `glg file_name`: 查看某个文件或者文件夹的改动历史

# alias glg1="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
# alias glg2="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
# alias glg3="git log --graph --abbrev-commit --decorate --date=short --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ad)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
# alias ghist="git log --graph --date-order --date=short --pretty=format:'%C(auto)%h%d %C(reset)%s %C(bold blue)%ce %C(reset)%C(green)%cr (%cd)'"

# git merge
alias gm='git merge'
alias gmom='git merge origin/$(git_main_branch)'
alias gmt='git mergetool --no-prompt'
alias gmtv1='git mergetool --no-prompt --tool=vimdiff1'
alias gmtgv3='git mergetool --no-prompt --tool=gvimdiff3'
alias gmtmv3='git mergetool --no-prompt --tool=mvimdiff3'
alias gmtmv1='git mergetool --no-prompt --tool=mvimdiff1'
alias gmtk='git mergetool -y --tool=Kaleidoscope'
alias gmum='git merge upstream/$(git_main_branch)'
alias gma='git merge --abort'

# git pull
alias gl='git pull'
alias glr='git pull --rebase'
alias glum='git pull upstream $(git_main_branch)'

# git push
alias gp='git push'
alias gpv='git push -v'
alias gpu='git push -u origin HEAD'
alias gpf='git push --force-with-lease'
alias gpf!='git push --force'
alias gpd='git push --dry-run'
alias ggpush='git push origin "$(git_current_branch)"'
alias gpsup='git push --set-upstream origin $(git_current_branch)'

# git remote
alias gr='git remote'
alias grv='git remote -v'
alias gra='git remote add'
alias grmv='git remote rename'
alias grrm='git remote remove'
alias grset='git remote set-url'
alias grup='git remote update'

# git rebase
alias grb='git rebase'
alias grba='git rebase --abort'
alias grbc='git rebase --continue'
alias grbd='git rebase $(git_develop_branch)'
alias grbi='git rebase -i'
alias grbm='git rebase $(git_main_branch)'
alias grbom='git rebase origin/$(git_main_branch)'
alias grbo='git rebase --onto'
alias grbs='git rebase --skip'

# git revert
alias grev='git revert'

# git reset
alias grh='git reset'
alias grhh='git reset --hard'
alias groh='git reset origin/$(git_current_branch) --hard'
alias gru='git reset --'
alias gpristine='git reset --hard && git clean -dffx'

# git rm
alias grm='git rm'
alias grmc='git rm --cached'

# git restore
alias grs='git restore'
alias grss='git restore --source'
alias grst='git restore --staged'
alias grt='cd "$(git rev-parse --show-toplevel || echo .)"'

# git status
alias gs='git status'
alias gsb='git status -sb'
alias gss='git status -s'
alias gst='git status'

# git show
alias gsh='git show'
alias gsps='git show --pretty=short --show-signature'

# git submodule
alias gsi='git submodule init'
alias gsu='git submodule update'

# git svn
alias gsr='git svn rebase'
alias gsd='git svn dcommit'
alias git-svn-dcommit-push='git svn dcommit && git push github $(git_main_branch):svntrunk'

# git stash
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

# git switch
alias gsw='git switch'
alias gswc='git switch -c'
alias gswm='git switch $(git_main_branch)'
alias gswd='git switch $(git_develop_branch)'

# git tag
alias gts='git tag -s'
alias gtv='git tag | sort -V'
alias gtl='gtl(){ git tag --sort=-v:refname -n -l "${1}*" }; noglob gtl'

alias gunwip='git log -n 1 | grep -q -c "\-\-wip\-\-" && git reset HEAD~1'
alias gwch='git whatchanged -p --abbrev-commit --pretty=medium'
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign -m "--wip-- [skip ci]"'

# git am
alias gam='git am'
alias gamc='git am --continue'
alias gams='git am --skip'
alias gama='git am --abort'
alias gamscp='git am --show-current-patch'

unset git_version
# }}}

# MARK: Function for git {{{

# *************** fzf-git *****************
function _fzf_git_fzf() {
    fzf-tmux -p90%,90% -- \
        --layout=reverse --multi --height=90% --min-height=20 --border \
        --color='header:italic:underline' \
        --preview-window='right,50%,border-left' \
        --bind='ctrl-/:change-preview-window(down,50%,border-top|hidden|)' "$@"
}

function gfzflog() {
    local log_fmt="%C(yellow)%h%Cred%d %Creset%s %Cgreen(%ar)%Creset"
    local commit_hash="echo {} | grep -o '[a-f0-9]\{7\}' | head -1"
    local view_commit="$commit_hash | xargs -I hash sh -c \"git i --color=always hash | delta\""

    git log --color=always --format="$log_fmt" "$@" | fzf --no-sort --tiebreak=index --no-multi --reverse --ansi \
        --header="enter to view, alt-y to copy hash" --preview="$view_commit" \
        --bind="enter:execute:$view_commit | less -R" \
        --bind="alt-y:execute:$commit_hash | xclip -selection clipboard"
}

# Warn if the current branch is a WIP
function work_in_progress() {
    if $(git log -n 1 2>/dev/null | grep -q -c "\-\-wip\-\-"); then
        echo "WIP!!"
    fi
}

# Check if main exists and use instead of master
function git_main_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local ref
    for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk}; do
        if command git show-ref -q --verify "$ref"; then
            echo "${ref:t}"
            return
        fi
    done
    echo master
}

# Check for develop and similarly named branches
function git_develop_branch() {
    command git rev-parse --git-dir &>/dev/null || return
    local branch
    for branch in dev devel development; do
        if command git show-ref -q --verify "refs/heads/$branch"; then
            echo "$branch"
            return
        fi
    done
    echo develop
}

function git_refresh() {
    git fetch && git stash && git rebase $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/@@") && git stash pop
}

function git_workon() {
    git fetch && git checkout -b "$1" $(git symbolic-ref refs/remotes/origin/HEAD | sed "s@^refs/remotes/@@");
}

function git_rename_branch() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "Usage: $0 old_branch new_branch"
        return 1
    fi

    # Rename branch locally
    git branch -m "$1" "$2"
    # Rename branch in origin remote
    if git push origin :"$1"; then
        git push --set-upstream origin "$2"
    fi
}

function git_keep_one() {
    git pull --depth 1
    git reflog expire --expire=all --all
    git tag -l | xargs git tag -d
    git stash drop
    git gc --prune=all
}

function gstpush() {
    git stash push -m "hanley_$1"
}

function gstpop() {
    stash_index=$(git stash list | grep "hanley_$1$" | cut -d: -f1)
    if [[ -n "${stash_index}" ]]; then
        git stash pop "${stash_index}"
    else
        echo "There is no stash for name \"hanley_$1\""
        return
    fi
}

function git_current_branch() {
    local branch=$(git rev-parse --abbrev-ref HEAD)
    echo "$branch"
}

function git_copy_branch() {
    git_current_branch | tr -d '\n' | pbcopy
}
# }}}
