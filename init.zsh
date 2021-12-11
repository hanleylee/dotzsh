# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# MARK: JUST FOR PATH AND EXPORT VARIABLES

if [ -z "$_INIT_ZSH_LOADED" ]; then
    _INIT_ZSH_LOADED=1
else
    return
fi

# 如果是非交互式则退出, 比如 bash test.sh 这种调用 bash 运行脚本时就不是交互式
# 只有直接敲 bash 进入的等待用户输入命令的那种模式才成为交互式, 才往下初始化
# case "$-" in
#     *i*) ;;
#     *) return
# esac
[[ -f "$ZDOTDIR/base/preinit.zsh" ]] && . "$ZDOTDIR/base/preinit.zsh"

#███████████████████████   PATH Variables   ██████████████████████████
export HL_REPO="$HOME/repo"
export HL_LANG="$HOME/repo/lang"
export HL_SECRET="$HOME/.secret"
export HL_LOCAL="$HOME/.local"
export HKMS="$HL_REPO/hkms"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
# export LANG=en_CN.UTF8
export LANG=en_US.UTF-8
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

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
)

_fpath_arr=(
    "$ZDOTDIR/lib"
    "$ZDOTDIR/completion"
    "$HOMEBREW_PREFIX/share/zsh/site-functions"
)

insert_path_to_variable "FPATH" "${_fpath_arr[@]}"
unset _fpath_arr

typeset -U PATH # 保证 TMUX 下及 source 后 PATH 不会有重复项

# "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin" \
_path_arr=(
    "/bin"
    "/sbin"
    "/usr/bin"
    "/usr/sbin"
    "/opt/MonkeyDev/bin"
    "$HOMEBREW_PREFIX/bin"
    "$HOMEBREW_PREFIX/sbin"
    "$HOMEBREW_PREFIX/opt/make/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/openssl/bin"
    "$HOMEBREW_PREFIX/opt/llvm/bin"
    "$HL_LOCAL/bin"
    "$HL_LOCAL/bin/sh"
    "$HL_LOCAL/bin/py"
    "$HL_LOCAL/bin/osascript"
    "$ZDOTDIR/bin"
    "$HOME/.cargo/bin"
    "$HOME/go/bin"
    "$HOME/.rbenv/shims"
    "$HOME/.pyenv/shims"
    "$HOME/.pyenv/bin"
    "$HOME/.fzf/bin"
    "$HOME/.emacs.d/bin"
    # "$HOME/.gem/bin" \
)
insert_path_to_variable "PATH" "${_path_arr[@]}"
unset _path_arr
# export PATH="$GEM_HOME/bin:$PATH"
# export PATH="/usr/local/opt/ruby/bin:$PATH"
# export PATH="/usr/local/opt/openjdk/bin:$PATH"

# 为 system 范围添加 header 路径, 会影响到 vim 的 ycm 与 ale.
# refer to <https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html>
# CPATH 会对 c, c++, objc 这三种语言的搜索路径起作用
# 而 C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, OBJC_INCLUDE_PATH 只对其对应语言的编译起作用
# 其作用类似于使用 `-I path`, 在此处进行了变量的定义后方便全局都起作用
insert_path_to_variable "C_INCLUDE_PATH" "$HL_LANG/c/foundation"
insert_path_to_variable "CPLUS_INCLUDE_PATH" "$HL_LANG/cpp/foundation"
insert_path_to_variable "OBJC_INCLUDE_PATH" "$HL_LANG/objc/foundation"
insert_path_to_variable "LD_LIBRARY_PATH" ""

insert_path_to_variable "CPATH" "$C_INCLUDE_PATH"

insert_path_to_variable "PYTHONPATH" "$HL_LANG/python/foundation"

if command_exists pkg-config; then
    # 添加自定义的 pkg-config 路径, 默认的路径为 /usr/local/lib/pkgconfig
    _pkgconfig_path=(
        "$HOMEBREW_PREFIX/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/openssl/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/readline/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/libffi/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/msgpack/lib/pkgconfig"
        "$HOMEBREW_PREFIX/opt/lzo/lib/pkgconfig"
        "/opt/X11/lib/pkgconfig"
    )
    insert_path_to_variable "PKG_CONFIG_PATH" "${_pkgconfig_path[@]}"
fi

#███████████████████████   FLAGS(for makefile, use pkg-config)   ██████████████████████████
if command_exists pkg-config; then
    PKGS=() # array list
    pkg-config --exists glib-2.0 && PKGS+=("glib-2.0")
    pkg-config --exists zlib && PKGS+=("zlib")
    pkg-config --exists openssl && PKGS+=("openssl")
    pkg-config --exists readline && PKGS+=("readline")
    pkg-config --exists libffi && PKGS+=("libffi")
    pkg-config --exists x11 && PKGS+=("x11")
    pkg-config --exists msgpack && PKGS+=("msgpack")
    pkg-config --exists lzo2 && PKGS+=("lzo2")

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
export PAGER='less'

#***************   MAN   *****************
export MANPAGER='less'

#***************   autosuggest   *****************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245,underline" # 提示样式, 可设置前景, 背景, 加粗, 下划线

#***************   BAT   *****************
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"

#***************   Homebrew   *****************
export HOMEBREW_NO_AUTO_UPDATE=true # 禁用 Homebrew 每次安装软件时的更新

#***************   MonkeyDev   *****************
[[ -d "/opt/MonkeyDev" ]] && export MonkeyDevPath="/opt/MonkeyDev"
export MonkeyDevDeviceIP=

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
[[ -f "$XDG_CONFIG_HOME/cheat/conf.yml" ]] && export CHEAT_CONFIG_PATH="$XDG_CONFIG_HOME/cheat/conf.yml"
export CHEAT_USE_FZF=true

#***************   SHELLCHECK   *****************
export SHELLCHECK_OPTS="\
-e SC1071 \
-e SC2155 \
-e SC1091 \
"

#***************   fzf   *****************
# --color fg:242,bg:236,hl:196,fg+:232,bg+:142,hl+:196:
# --color info:108,prompt:109,spinner:108,pointer:168,marker:168
# 默认 fzf 配置, 使用 fd 而不是系统的 find
# --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
# --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
# one dark
FZF_FULL_COMMAND="\
fzf-tmux \
-p 90%,80% \
--layout=reverse \
--no-sort \
--exact \
--height=80% \
--preview-window right:50%:hidden:nowrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"

# -I 不忽略 .gitignore 列表内容(fd 默认是忽略的)
export FZF_DEFAULT_COMMAND="\
fd \
--hidden \
--follow \
--exclude={Pods,.git,.idea,.sass-cache,node_modules,build} \
--type f \
"
# export FZF_PREVIEW_COMMAND="\
# highlight -O ansi -l {} || coderay {} || rougify {} || cat {}\
# "

# --sort \, 默认是 --no-sort, 就是根据你原有的结果顺序为以后所有的顺序基础
export FZF_DEFAULT_OPTS="\
--history-size=50000 \
--color=dark \
--color=fg:#707a8c,bg:-1,hl:#3e9831,fg+:#cbccc6,bg+:#434c5e,hl+:#5fff87 \
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7 \
--layout=reverse \
--no-sort \
--exact \
--height=80% \
--preview '([[ -f {} ]] && highlight -O ansi -l {} 2> /dev/null || tree -N -C -l -L 1 {}) 2> /dev/null | head -500' \
--preview-window right:50%:hidden:nowrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"
# --preview-window down:3:hidden:wrap
# --preview-window 'right:60%'

export DIR_PREVIEW_COMMAND='tree -N -C -l -L 1'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="\
--layout=reverse \
--no-sort \
--exact \
--height=80% \
--preview 'echo {} | head -500' \
--preview-window down:3:hidden:wrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"

export FZF_ALT_C_OPTS="--preview '$DIR_PREVIEW_COMMAND {}'"
export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
export FZF_COMPLETION_TRIGGER='**'

[[ -f "$HOME/.fzf-marks" ]] && export FZF_MARKS_FILE="$HOME/.fzf-marks"
export FZF_MARKS_COMMAND="$FZF_FULL_COMMAND --preview '$DIR_PREVIEW_COMMAND {3}'"
export FZF_MARKS_JUMP="^[m"
export FZF_MARKS_COLOR_LHS=39 # (default)	ANSI color code of left-hand side
export FZF_MARKS_COLOR_RHS=36 # (cyan)	ANSI color code of right-hand side
export FZF_MARKS_COLOR_COLON=33 # (yellow)	ANSI color code of separator
export FZF_MARKS_NO_COLORS=0
# export FZF_MARKS_KEEP_ORDER=1

# z.lua 使用的 fzf 参数
export _ZL_FZF="$FZF_FULL_COMMAND --preview '$DIR_PREVIEW_COMMAND {2}'"
export _ZL_FZF_HEIGHT='80%'
export _ZL_NO_ALIASES=1
export _ZL_DATA="$HOME/.zlua"
export _ZL_MAXAGE=100000
# export _ZL_CMD='z'
# export _ZL_NO_PROMPT_COMMAND
# export _ZL_EXCLUDE_DIRS="$HOME,$VIM_CONFIG"
# export _ZL_ADD_ONCE
# export _ZL_CD='cd'
# export _ZL_ECHO=0
# export _ZL_MATCH_MODE=0
# export _ZL_NO_CHECK=0
# export _ZL_HYPHEN=0
# export _ZL_CLINK_PROMPT_PRIORITY

# for ta-lib
# export TA_INCLUDE_PATH="$(brew --prefix ta-lib)/include"
# export TA_LIBRARY_PATH="$(brew --prefix ta-lib)/lib"
