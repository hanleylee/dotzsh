# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# shellcheck disable=2034,2086
#
# Zinit instruction: https://zdharma-continuum.github.io/zinit/wiki/INTRODUCTION/
typeset -gAH ZINIT
export ZINIT_HOME="${ZDOTDIR:-${HOME}}/zinit" # 这里需要 export, 因为 zfzf 文件中使用到了 ZINIT_HOME, zfzf 是在 subshell 中执行的
ZINIT_GIT_DIR="${ZINIT_HOME}/zinit.git"
ZINIT[HOME_DIR]="${ZINIT_HOME}"
ZINIT[BIN_DIR]="${ZINIT_GIT_DIR}"
# ZINIT[PLUGINS_DIR]="${ZINIT_GIT_DIR}"
[ ! -d $ZINIT_GIT_DIR ] && mkdir -p "$ZINIT_GIT_DIR"
[ ! -d $ZINIT_GIT_DIR/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_GIT_DIR"

source "${ZINIT_GIT_DIR}/zinit.zsh"

autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Common ICE modifiers {{{
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
# }}}

# MARK: ======== zinit snippet ========= {{{

zinit for \
    OMZL::git.zsh
    # OMZL::theme-and-appearance.zsh
# zinit snippet OMZL::git.zsh
# zinit snippet OMZL::functions.zsh
# zinit snippet OMZL::completion.zsh
# # zinit snippet OMZL::history.zsh
# zinit snippet OMZL::key-bindings.zsh
# zinit snippet OMZL::theme-and-appearance.zsh

# ========
zinit snippet OMZP::last-working-dir

@zi_w1
zinit snippet OMZP::sudo

@zi_w1
zinit snippet OMZP::command-not-found

@zi_w1
zinit snippet OMZP::git-auto-fetch

# @zi_w1
# zinit snippet OMZP::colored-man-pages

@zi_completion has'docker'
zinit snippet OMZP::docker/_docker

@zi_completion has'fd'
zinit snippet OMZP::fd/_fd

@zi_completion has'pip'
zinit snippet OMZP::pip/_pip

@zi_completion has'pod'
zinit snippet OMZP::pod/_pod

if is_darwin; then
    @zi_w1 has'svn' svn silent
    zinit snippet OMZP::macos
fi

@zi_w1 has'svn' svn silent
zinit snippet OMZP::flutter

# 为了使用 GitHub 项目的子目录作为 snippet, 需要在 URL中添加 /trunk/{path-to-dir}
# zinit ice svn
# zinit snippet https://github.com/zsh-users/zsh-completions/trunk/src

# @zi_w1
# zinit snippet OMZP::zsh-interactive-cd

# zinit ice svn
# zinit snippet OMZP::gitfast
#}}}


# MARK: zinit light {{{
# 命令补全
@zi_w0 atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# 语法高亮
@zi_w0 atinit='zpcompinit'
zinit light zdharma-continuum/fast-syntax-highlighting

@zi_w0
zinit light zsh-users/zsh-completions

@zi_w0 has'fzf'
zinit light Aloxaf/fzf-tab

@zi_w0 has'fzf'
zinit light hanleylee/fzf-marks
# zinit light urbainvaes/fzf-marks
# zinit light "/Users/hanley/github/lang/sh/fzf-marks" # use for debug

@zi_w0
zinit light skywind3000/z.lua

@zi_w1 has'git'
zinit light paulirish/git-open

@zi_w1
zinit light scriptingosx/mac-zsh-completions

@zi_w0 multisrc'*.{sh,zsh,*rc}'
zinit light "$ZDOTDIR/modules"

# zinit light "/Users/hanley/repo/handy" # use for debug
zinit light hanleylee/handy
# }}}
