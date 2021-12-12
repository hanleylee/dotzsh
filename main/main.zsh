# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

# setopt GLOBDOTS # 使所有的ls显示 . 与 ..(会导致 completion 有 . 与 ..)
setopt NO_CASE_GLOB # 通配符扩展不区分大小写
setopt GLOB_COMPLETE # 列出可能的补全, 但不会直接在提示符中替换补全的结果
EDITOR="$HOMEBREW_PREFIX/bin/vim" # zsh 默认的编辑器为 vi, 比较难用, 因此设置为 vim
export EDITOR
export VISUAL="$EDITOR"
export HIST_STAMPS="yyyy-mm-dd" # history 时间格式更改
export HISTSIZE=100000
# [[ -f "$HOME/.sh/.zsh_history" ]] && export HISTFILE="$HOME/.sh/.zsh_history"
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history # 它将使用 $ZDOTDIR 设置的值, 或者默认值 $HOME
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE # ignore commands that start with space
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS # do not store duplications, 去除重复记录
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching, 浏览时跳过重复记录
setopt HIST_REDUCE_BLANKS # remove blank lines from history, 去除空白记录
setopt APPEND_HISTORY   # 以追加方式而不是覆盖
setopt SHARE_HISTORY    # 共享历史记录(read the history file everytime history is called upon as well as the functionality from `inc_append_history`)
# setopt INC_APPEND_HISTORY # 立即更新历史记录(save every command before it is executed), SHARE_HISTORY 已经包含了此功能
setopt HIST_VERIFY # show command with history expansion to user before running it
# setopt CORRECT
# setopt CORRECT_ALL
setopt AUTO_CD                     # will automaticaly change directory when enter with `~/Desktop` / `..`
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
setopt PUSHD_IGNORE_DUPS           # push dir, remove the old items if it already existing

