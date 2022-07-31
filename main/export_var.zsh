# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# MARK: JUST FOR PATH AND EXPORT VARIABLES
# NOTE:
# 1. 多个环境变量之间如果有依赖, 那么 export 的顺序非常重要, 如果变量 a 在 export 之前就被另一个环境变量 b 使用, 那么 b 会异常
# 2. 在 $() 中使用环境变量会导致不被展开的问题, 可以使用 eval $var 解决
# 3. 在 $() 中如果遇到环境变量带有单引号的情况(可以通过 set -x 查看每一步的执行细节), 可以尝试先将整个命令作为变量进行构建, 然后再使用 $() 统一执行

#███████████████████████   PATH Variables   ██████████████████████████
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

export LANG="en_US.UTF-8"
export LANGUAGE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"

export ROOTMARKERS=(
    ".svn"
    ".git"
    ".root"
    ".project"
    ".hg"
    "_darcs"
    "build.xml"
    "Makefile"
    "CMakeLists.txt"
    ".idea"
)

# export str for macvim usage
export ROOTMARKERS_STR=${ROOTMARKERS[*]}

# Because the order is so important for PATH, so we can't use connected `path` to reflect its value
# "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin" \
typeset -U path
path=(
    "$HOME/.emacs.d/bin"
    "$HOME/.fzf/bin"
    "$HOME/.pyenv/bin"
    "$HOME/.pyenv/shims"
    "$HOME/.rbenv/shims"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$ZDOTDIR/bin/osascript"
    "$ZDOTDIR/bin/py"
    "$ZDOTDIR/bin/sh"
    "$ZDOTDIR/bin"
    "$HOMEBREW_PREFIX/opt/sqlite/bin"
    "$HOMEBREW_PREFIX/opt/llvm/bin"
    "$HOMEBREW_PREFIX/opt/openssl/bin"
    "$HOMEBREW_PREFIX/opt/dart/libexec/bin"
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/make/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/ruby/bin"
    "$HOMEBREW_PREFIX/opt/openjdk/bin"
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/sbin"
    "$HOMEBREW_PREFIX/bin"
    "/usr/sbin"
    "/usr/libexec"
    "/usr/bin"
    "/sbin"
    "/bin"
    "/test"
    $path
)
export PATH

typeset -U fpath
# Connected array Variables, fpath is connected with FPATH
fpath=(
    "$ZDOTDIR/lib"
    "$ZDOTDIR/completion"
    "$HOMEBREW_PREFIX/share/zsh/site-functions"
    $fpath
)
export FPATH

if command_exists pkg-config; then
    # 添加自定义的 pkg-config 路径, 默认的路径为 /usr/local/lib/pkgconfig
    _pkgconfig_path=(
        "$HOMEBREW_PREFIX/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/glib/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/openssl/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/readline/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/libffi/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/msgpack/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/lzo/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/sqlite/lib/pkgconfig"
        "/opt/X11/lib/pkgconfig"
    )
    insert_path_to_variable "PKG_CONFIG_PATH" "${_pkgconfig_path[@]}"
    unset _pkgconfig_path
fi

#███████████████████████   FLAGS(for makefile, use pkg-config)   ██████████████████████████
if command_exists pkg-config; then
    PKGS=() # array list
    # pkg-config --exists glib-2.0 && PKGS+=("glib-2.0")
    # pkg-config --exists zlib && PKGS+=("zlib")
    # pkg-config --exists openssl && PKGS+=("openssl")
    # pkg-config --exists readline && PKGS+=("readline")
    # pkg-config --exists libffi && PKGS+=("libffi")
    # pkg-config --exists x11 && PKGS+=("x11")
    # pkg-config --exists msgpack && PKGS+=("msgpack")
    # pkg-config --exists lzo2 && PKGS+=("lzo2")
    # pkg-config --exists lzo2 && PKGS+=("sqlite3")

    if [[ -n ${PKGS[*]} ]]; then
        CPPFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        export CPPFLAGS

        CFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        export CFLAGS

        CXXFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        export CXXFLAGS

        # LDFLAGS+="-I$HOMEBREW_PREFIX/opt/openjdk/include"
        LDFLAGS=$(pkg-config --libs "${PKGS[@]}")
        export LDFLAGS
        unset PKGS
    fi
fi

#***************   GPG   *****************
GPG_TTY=$(tty)
export GPG_TTY

#***************   LESS   *****************

# less options
less_opts=(
    # Quit if entire file fits on first screen.
    -+F
    -+X
    -M
    # show number
    -N
    # increasely search
    --incsearch
    # Ignore case in searches that do not contain uppercase.
    --ignore-case
    # Allow ANSI colour escapes, but no other escapes.
    --RAW-CONTROL-CHARS
    # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
    --quiet
    # Do not complain when we are on a dumb terminal.
    --dumb
)
export LESS="${less_opts[*]}"
unset less_opts

#***************   PAGER   *****************
# Default pager
export PAGER='hlpager'
# export PAGER='vmore'

#***************   MAN   *****************
export MANPAGER='less'

#***************   autosuggest   *****************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245,underline" # 提示样式, 可设置前景, 背景, 加粗, 下划线

#***************   BAT   *****************
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"

#***************   Homebrew   *****************
export HOMEBREW_NO_AUTO_UPDATE=true # 禁用 Homebrew 每次安装软件时的更新

#***************   PYTHON   *****************
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYTHONUNBUFFERED=1
[[ -d "$HOME/.pyenv" ]] && export PYENV_ROOT="$HOME/.pyenv"

#***************   RUBY   *****************
export RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl
# export GEM_HOME="$HOME/.gem"

#***************   GO   *****************
export GOROOT=$(go env GOROOT)
export GOPATH=$(go env GOPATH)
export GOBIN=$GOPATH/bin

#***************   GTAGS   *****************
export GTAGSLABEL='native-pygments'
[[ -f "$XDG_CONFIG_HOME/global/.globalrc" ]] && export GTAGSCONF="$XDG_CONFIG_HOME/global/.globalrc"

#***************   CHEAT   *****************
[[ -f "$HOME/.cheat/conf.yml" ]] && export CHEAT_CONFIG_PATH="$HOME/.cheat/conf.yml"
export CHEAT_USE_FZF=true

#***************   SHELLCHECK   *****************
export SHELLCHECK_OPTS="\
-e SC1071 \
-e SC2155 \
-e SC1091 \
"

#***************   fd   *****************
# -I 不忽略 .gitignore 列表内容(fd 默认是忽略的)
export FD_COMMON_EXCLUDE="\
{\
Pods,\
.git,\
.idea,\
.sass-cache,\
node_modules,\
build\
}\
"

export FD_COMMON_COMMAND="\
fd \
--full-path \
--hidden \
--follow \
--exclude=$FD_COMMON_EXCLUDE \
"

#***************   preview   *****************
export FILE_PREVIEW_COMMAND='highlight -O ansi -l'
export DIR_PREVIEW_COMMAND='tree -N -C -l -L 1'

#***************   fzf   *****************
if is_tmux; then
    export FZF_COMMON_COMMAND="fzf-tmux -p 90%,80%"
else
    export FZF_COMMON_COMMAND="fzf"
fi

export FZF_COMMON_PREVIEW="\
--preview '([[ -f {} ]] && $FILE_PREVIEW_COMMAND {} 2> /dev/null || $DIR_PREVIEW_COMMAND {}) 2> /dev/null | head -500' \
--preview-window right:50%:hidden:nowrap \
"

# fzf 要求的 FZF_DEFAULT_COMMAND 与 FZF_DEFAULT_OPTS
export FZF_DEFAULT_COMMAND="\
$FD_COMMON_COMMAND \
--type f \
"

# --sort \, 默认是 --no-sort, 就是根据你原有的结果顺序为以后所有的顺序基础
# 所有的 fzf 都会使用的 opt, 不需要在手动调用 fzf 时候再次加上
# --preview-window down:3:hidden:wrap
# --preview-window 'right:60%'
# --color fg:242,bg:236,hl:196,fg+:232,bg+:142,hl+:196:
# --color info:108,prompt:109,spinner:108,pointer:168,marker:168
# 默认 fzf 配置, 使用 fd 而不是系统的 find
# --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
# --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
# one dark

export FZF_DEFAULT_OPTS="\
--history-size=50000 \
--color=dark \
--color=fg:#707a8c,bg:-1,hl:#3e9831,fg+:#cbccc6,bg+:#434c5e,hl+:#5fff87 \
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7 \
--layout=reverse \
--no-sort \
--exact \
--bind '?:toggle-preview' \
--border \
--cycle \
--height=80% \
"
# fzf <c-t>
export FZF_CTRL_T_COMMAND=$FD_COMMON_COMMAND
export FZF_CTRL_T_OPTS="\
$FZF_DEFAULT_OPTS \
$FZF_COMMON_PREVIEW \
"
# fzf <c-r>
export FZF_CTRL_R_OPTS="\
$FZF_DEFAULT_OPTS \
--preview 'echo {} | head -500' \
--preview-window down:3:hidden:wrap \
"

# fzf <alt-c>
export FZF_ALT_C_COMMAND=$FD_COMMON_COMMAND
export FZF_ALT_C_OPTS="--preview '$DIR_PREVIEW_COMMAND {}'"

# fzf-tmux
export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
export FZF_COMPLETION_TRIGGER='**'

# fzf marks
[[ -f "$HOME/.fzf-marks" ]] && export FZF_MARKS_FILE="$HOME/.fzf-marks"
export FZF_MARKS_COMMAND="$FZF_COMMON_COMMAND $FZF_DEFAULT_OPTS --preview '$DIR_PREVIEW_COMMAND {3}' --preview-window right:50%:hidden:nowrap"
export FZF_MARKS_JUMP="^[m"
export FZF_MARKS_COLOR_LHS=39 # (default)	ANSI color code of left-hand side
export FZF_MARKS_COLOR_RHS=36 # (cyan)	ANSI color code of right-hand side
export FZF_MARKS_COLOR_COLON=33 # (yellow)	ANSI color code of separator
export FZF_MARKS_NO_COLORS=0
# export FZF_MARKS_KEEP_ORDER=1

# z.lua 使用的 fzf 参数
export _ZL_FZF="$FZF_COMMON_COMMAND $FZF_DEFAULT_OPTS --preview '$DIR_PREVIEW_COMMAND {2}' --preview-window right:40%:nowrap"
export _ZL_FZF_HEIGHT='80%'
export _ZL_NO_ALIASES=1
export _ZL_DATA="$ZDOTDIR/.zlua_history"
export _ZL_MAXAGE=100000
# export _ZL_CMD='z'
export _ZL_NO_PROMPT_COMMAND
# export _ZL_EXCLUDE_DIRS="$HOME,$VIM_CONFIG"
export _ZL_ADD_ONCE=1
export _ZL_CD='cd'
export _ZL_ECHO=0
export _ZL_MATCH_MODE=1
export _ZL_NO_CHECK=0
# export _ZL_HYPHEN=0
# export _ZL_CLINK_PROMPT_PRIORITY

# for ta-lib
# export TA_INCLUDE_PATH="$(brew --prefix ta-lib)/include"
# export TA_LIBRARY_PATH="$(brew --prefix ta-lib)/lib"

# zoxide
export _ZO_DATA_DIR=$XDG_DATA_HOME
export _ZO_ECHO=0
export _ZO_EXCLUDE_DIRS=""
export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --preview '$DIR_PREVIEW_COMMAND {2}' --preview-window right:50%:nowrap"
export _ZO_MAXAGE=100000
export _ZO_RESOLVE_SYMLINKS=0
