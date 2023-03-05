# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# MARK: GLOB
setopt GLOBDOTS # 使所有的ls显示 . 与 ..(会导致 completion 有 . 与 ..)
setopt NO_CASE_GLOB # 通配符扩展不区分大小写
setopt GLOB_COMPLETE # 列出可能的补全, 但不会直接在提示符中替换补全的结果

# MARK: HISTORY
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
# setopt EXTENDED_GLOB
setopt RC_QUOTES # 单引号中的 '' 表示一个 ' (如同 Vimscript 中者)
setopt LISTPACKED # 补全列表不同列可以使用不同的列宽
setopt MAGIC_EQUAL_SUBST # 补全 identifier=path 形式的参数
setopt TRANSIENT_RPROMPT # 为方便复制, 右边的提示符只在最新的提示符上显示
setopt KSH_OPTION_PRINT # setopt 的输出显示选项的开关状态
setopt NO_BG_NICE
setopt NOFLOWCONTROL
