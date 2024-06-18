# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License
 
# shellcheck disable=2034
# This file ia all about zsh option, it must be sourced after zshrc

# MARK: GLOB
setopt GLOBDOTS # 使所有的ls显示 . 与 ..(会导致 completion 有 . 与 ..)
setopt NO_CASE_GLOB # we want globbing to be case-insensitive
setopt GLOB_COMPLETE # 列出可能的补全, 但不会直接在提示符中替换补全的结果

#███████████████████████   History   ██████████████████████████
# History related variable must sourced after zshrc
HISTFILE=${PRE_HISTFILE:-"${ZDOTDIR}/.zsh_history"} # 它将使用 $ZDOTDIR 设置的值, 或者默认值 $HOME
HISTSIZE=100000 # lines remembered per session
SAVEHIST=$HISTSIZE # lines stored in history file
HIST_STAMPS="yyyy-mm-dd" # history 时间格式更改

# MARK: HISTORY
setopt EXTENDED_HISTORY # Save each command’s beginning timestamp (in seconds since the epoch) and the duration (in seconds) to the history file.
setopt HIST_IGNORE_SPACE # ignore lines starting with space
setopt HIST_IGNORE_DUPS # do not store duplications
# setopt HIST_IGNORE_ALL_DUPS # If a new line being added to the history list duplicates an older one, the older command is removed from the list (even if it is not the previous event)
setopt HIST_SAVE_NO_DUPS # When writing out to the history file, older commands that duplicate newer ones are omitted.
setopt HIST_EXPIRE_DUPS_FIRST # expire duplicates first
setopt HIST_FIND_NO_DUPS # ignore duplicates when searching 浏览时跳过重复记录
setopt HIST_REDUCE_BLANKS # remove blank lines from history 去除空白记录
setopt APPEND_HISTORY   # 以追加方式而不是覆盖
setopt SHARE_HISTORY    # 共享历史记录(read the history file everytime history is called upon as well as the functionality from `inc_append_history`)
# setopt INC_APPEND_HISTORY # 立即更新历史记录(save every command before it is executed), SHARE_HISTORY 已经包含了此功能
setopt HIST_VERIFY # show command with history expansion to user before running it
setopt PUSHD_IGNORE_DUPS           # push dir, remove the old items if it already existing

# setopt CORRECT
# setopt CORRECT_ALL
setopt AUTO_CD                     # will automaticaly change directory when enter with `~/Desktop` / `..`
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt AUTO_CONTINUE               # disown 后自动继续进程
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')

# unsetopt nomatch
# setopt nomatch
unsetopt BEEP
setopt RM_STAR_SILENT # rm * 时不要提示
setopt INTERACTIVE_COMMENTS # 允许在交互模式中使用注释
setopt EXTENDED_GLOB # extended globbing adds to the normal globbing syntax with qualifiers added in parenthese `(...)` at the end
setopt RC_QUOTES # 单引号中的 '' 表示一个 ' (如同 Vimscript 中者)
setopt LISTPACKED # 补全列表不同列可以使用不同的列宽
setopt MAGIC_EQUAL_SUBST # 补全 identifier=path 形式的参数
setopt TRANSIENT_RPROMPT # 为方便复制, 右边的提示符只在最新的提示符上显示
setopt KSH_OPTION_PRINT # setopt 的输出显示选项的开关状态
setopt NO_BG_NICE
setopt NOFLOWCONTROL

unsetopt menu_complete   # do not autoselect the first completion entry
unsetopt flowcontrol
setopt auto_menu         # show completion menu on successive tab press
setopt complete_in_word
setopt always_to_end

# Expand variables and commands in PROMPT variables
setopt prompt_subst
