# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

[[ -f "$HOME/.sh/init.zsh" ]] && source "$HOME/.sh/init.zsh"

#███████████████████████   MAIN   ██████████████████████████
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

setopt GLOBDOTS # 使所有的ls显示 . 与 ..
setopt NO_CASE_GLOB # 通配符扩展不区分大小写
setopt GLOB_COMPLETE # 列出可能的补全, 但不会直接在提示符中替换补全的结果
EDITOR="$HOMEBREW_PREFIX/bin/vim" # zsh 默认的编辑器为 vi, 比较难用, 因此设置为 vim
export EDITOR
export VISUAL="$EDITOR"
export HIST_STAMPS="yyyy-mm-dd" # history 时间格式更改
export HISTSIZE=100000
# [[ -f "$HOME/.sh/.zsh_history" ]] && export HISTFILE="$HOME/.sh/.zsh_history"
export HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history # 它将使用ZDOTDIR设置的值, 或者默认值 HOME
export SAVEHIST=$HISTSIZE
setopt EXTENDED_HISTORY
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_SPACE # ignore commands that start with space
setopt HIST_EXPIRE_DUPS_FIRST # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS # 去除重复记录
setopt HIST_FIND_NO_DUPS # 浏览时跳过重复记录
setopt HIST_REDUCE_BLANKS # 去除空白记录
setopt APPEND_HISTORY   # 以追加方式而不是覆盖
setopt SHARE_HISTORY    # 共享历史记录(read the history file everytime history is called upon as well as the functionality from `inc_append_history`)
# setopt INC_APPEND_HISTORY # 立即更新历史记录(save every command before it is executed), SHARE_HISTORY 已经包含了此功能
setopt HIST_VERIFY # show command with history expansion to user before running it
# setopt CORRECT
# setopt CORRECT_ALL
setopt AUTO_CD
setopt AUTO_PUSHD                  # pushes the old directory onto the stack
setopt PUSHD_MINUS                 # exchange the meanings of '+' and '-'
setopt CDABLE_VARS                 # expand the expression (allows 'cd -2/tmp')
setopt PUSHD_IGNORE_DUPS           # push dir, remove the old items if it already existing

# zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

autoload -Uz compinit && compinit   # load + start completion

##███████████████████████   PLUGINS   ██████████████████████████ {{{

### Added by Zinit's installer
if [[ ! -f $HOME/.sh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.sh/.zinit" && command chmod g-rwX "$HOME/.sh/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.sh/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.sh/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Common ICE modifiers
@zi_lucid() {
    zinit ice lucid "$@"
}

@zi_w0() {
    @zi_lucid wait'0' "$@"
}

@zi_w1() {
    @zi_lucid wait'1' "$@"
}

@zi_completion() {
    @zi_w1 as'completion' blockf "$@"
}

@zi_w0 atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 语法高亮
@zi_w0 atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

@zi_w0
zinit light zsh-users/zsh-completions

@zi_w0 has'fzf'
zinit light Aloxaf/fzf-tab

@zi_w0
# zinit light urbainvaes/fzf-marks
zinit light "/Users/hanley/github/lang/sh/fzf-marks" # use for debug

@zi_w0
zinit light skywind3000/z.lua

@zi_w0 has'git'
zinit light paulirish/git-open
# ========

zinit snippet OMZL::git.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::completion.zsh
# zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh
zinit snippet OMZL::theme-and-appearance.zsh

# ========
zinit snippet OMZP::last-working-dir

@zi_w1
zinit snippet OMZP::sudo

@zi_w1
zinit snippet OMZP::colored-man-pages

@zi_w1
zinit snippet OMZP::git

@zi_completion has'cargo'
zinit snippet OMZP::cargo

@zi_completion has'docker'
zinit snippet OMZP::docker/_docker

@zi_completion has'fd'
zinit snippet OMZP::fd/_fd

@zi_completion has'pip'
zinit snippet OMZP::pip/_pip

zinit ice has'svn' svn silent wait'1'
zinit snippet OMZP::macos

@zi_w1
zinit snippet OMZP::command-not-found

@zi_w1
zinit snippet OMZP::git-auto-fetch

zinit ice multisrc'*.zsh'
zinit load "$ZDOTDIR/tool"

zinit light HanleyLee/Handy
# zinit light "/Users/hanley/repo/handy" # use for debug

# 为了使用 GitHub 项目的子目录作为 snippet, 需要在 URL中添加 /trunk/{path-to-dir}
# zinit ice svn
# zinit snippet https://github.com/zsh-users/zsh-completions/trunk/src

# @zi_w1
# zinit snippet OMZP::zsh-interactive-cd

# zinit ice svn
# zinit snippet OMZP::gitfast
#}}}

#███████████████████████   zstyle   ██████████████████████████ {{{
zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' popup-pad 30 10 # 宽内缩值, 高内缩值, 也可认为是扩展区域值
zstyle ':fzf-tab:*' fzf-flags --preview-window=down:3:hidden:wrap
zstyle ':fzf-tab:*' fzf-pad 4
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false
# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:cd:*' popup-pad 80 0
#}}}

#███████████████████████   Utilities Settings   ██████████████████████████ {{{
#***************   autosuggest   *****************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245,underline" # 提示样式, 可设置前景, 背景, 加粗, 下划线

#***************   scmpuff   *****************
command_exists scmpuff && eval "$(scmpuff init -s)"
#}}}

#███████████████████████   BINDKEYS   ██████████████████████████ {{{
zle -N _zfzf
bindkey -e # 使用 Emacs 键位
bindkey ',' autosuggest-accept
bindkey "^u" backward-kill-line

if command_exists lf; then
    bindkey -s "^o" 'lfcd^M'
fi

if command_exists lazygit; then
    bindkey -s "^g" 'lg^M'
fi

if command_exists fzf; then
    bindkey '^h' _zfzf
fi
#}}}

#***************   source   ***************** {{{
source_if_exists "$HOME/.cargo/env" \
    "$XDG_CONFIG_HOME/lf/lfcd.sh" \
    "$XDG_CONFIG_HOME/broot/launcher/bash/br"

[[ $TERM_PROGRAM == "iTerm.app" ]] && source_if_exists "$ZDOTDIR/.iterm2_shell_integration.zsh"
#}}}
