[[ -f "$HOME/.sh/init.zsh" ]] && source "$HOME/.sh/init.zsh"

#███████████████████████   MAIN   ██████████████████████████
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

setopt globdots # 使所有的ls显示 . 与 ..
EDITOR=vim # zsh 默认的编辑器为 vi, 比较难用, 因此设置为 vim
export HIST_STAMPS="yyyy-mm-dd" # history 时间格式更改
export EDITOR
export VISUAL="$EDITOR"
export HISTSIZE=100000
[[ -f "$HOME/.sh/.zsh_history" ]] && export HISTFILE="$HOME/.sh/.zsh_history"
export SAVEHIST=$HISTSIZE
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

##███████████████████████   PLUGINS   ██████████████████████████

### Added by Zinit's installer
if [[ ! -f $HOME/.sh/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.sh/.zinit" && command chmod g-rwX "$HOME/.sh/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.sh/.zinit/bin" && \
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
zinit light zdharma/fast-syntax-highlighting

@zi_w0
zinit light zsh-users/zsh-completions

@zi_w0
zinit light urbainvaes/fzf-marks

@zi_w0
zinit light skywind3000/z.lua

@zi_w0 has'fzf'
zinit light Aloxaf/fzf-tab

# ========

zinit snippet OMZL::git.zsh
zinit snippet OMZL::functions.zsh
zinit snippet OMZL::completion.zsh
zinit snippet OMZL::history.zsh
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

@zi_completion has'docker'
zinit snippet OMZP::docker/_docker

@zi_completion has'cargo'
zinit snippet OMZP::cargo/_cargo

@zi_completion has'fd'
zinit snippet OMZP::fd/_fd

@zi_completion has'pip'
zinit snippet OMZP::pip/_pip

zinit ice has'svn' svn silent wait'1'
zinit snippet OMZP::osx

@zi_w1
zinit snippet OMZP::command-not-found

@zi_w1
zinit snippet OMZP::git-auto-fetch

zinit ice multisrc'*.zsh'
zinit load "$ZDOTDIR/tool"

zinit light HanleyLee/Handy

# 为了使用 GitHub 项目的子目录作为 snippet，需要在 URL中添加 /trunk/{path-to-dir}
# zinit ice svn
# zinit snippet https://github.com/zsh-users/zsh-completions/trunk/src

# @zi_w1
# zinit snippet OMZP::zsh-interactive-cd

# zinit ice svn
# zinit snippet OMZP::gitfast

#███████████████████████   zstyle   ██████████████████████████
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

#███████████████████████   Utilities Settings   ██████████████████████████
#***************   autosuggest   *****************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245,underline" # 提示样式, 可设置前景, 背景, 加粗, 下划线

#***************   scmpuff   *****************
command_exists scmpuff && eval "$(scmpuff init -s)"

#███████████████████████   BINDKEYS   ██████████████████████████
zle -N _zfzf

bindkey -e # 使用 Emacs 键位
bindkey ',' autosuggest-accept
bindkey -s "^o" 'r^M'
bindkey "^u" backward-kill-line
bindkey '^h' _zfzf

#***************   source   *****************
source_if_exists "$HOME/.cargo/env"
# "$HOME/.config/lf/lfcd.sh" \
