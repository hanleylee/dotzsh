# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# MARK: JUST FOR EXPORT ENVIRONMENT VARIABLES
# NOTE:
# 1. 多个环境变量之间如果有依赖, 那么 export 的顺序非常重要, 如果变量 a 在 export 之前就被另一个环境变量 b 使用, 那么 b 会异常
# 2. 在 $() 中使用环境变量会导致不被展开的问题, 可以使用 eval $var 解决
# 3. 在 $() 中如果遇到环境变量带有单引号的情况(可以通过 set -x 查看每一步的执行细节), 可以尝试先将整个命令作为变量进行构建, 然后再使用 $() 统一执行

# MARK: EDITOR
EDITOR="$HOMEBREW_PREFIX/bin/vim" # zsh 默认的编辑器为 vi, 比较难用, 因此设置为 vim
export EDITOR
export VISUAL="$EDITOR"

# PS4 is used as prefix of set -x
export PS4='+{$LINENO:${FUNCNAME[0]}} '

# MARK: Tab-Completion
export FIGNORE='*DS_Store:.test'

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
    "CMakeLists.txt"
    ".idea"
)

# export str for macvim usage
export ROOTMARKERS_STR=${ROOTMARKERS[*]}

export HL_REPO="$HOME/repo"
export HL_TODO="$HOME/Library/Mobile Documents/com~apple~CloudDocs/iCloud_HL/todo"
export HL_SECRET="$HOME/.secret"
export HL_LOCAL="$HOME/.local"
export HL_SNIPPETS="$HL_REPO/snippets"
export HKMS="$HL_REPO/hkms"

# export HL_TODO="$HL_REPO/todo"

# Language {{{
export HL_LANG="$HL_REPO/lang"
export HL_LANG_C="$HL_REPO/lang/c"
export HL_LANG_CPP="$HL_REPO/lang/cpp"
export HL_LANG_RUBY="$HL_REPO/lang/ruby"
export HL_LANG_HTML="$HL_REPO/lang/html"
export HL_LANG_OBJC="$HL_REPO/lang/objc"
export HL_LANG_PYTHON="$HL_REPO/lang/python"
export HL_LANG_RUST="$HL_REPO/lang/rust"
export HL_LANG_SHELL="$HL_REPO/lang/shell"
export HL_LANG_SWIFT="$HL_REPO/lang/swift"
export HL_LANG_VIMSCRIPT="$HL_REPO/lang/vimscript"
export HL_LANG_JAVASCRIPT="$HL_REPO/lang/javascript"
export HL_LANG_APPLESCRIPT="$HL_REPO/lang/applescript"
export HL_LANG_PLANTUML="$HL_REPO/lang/plantuml"
export HL_LANG_DART="$HL_REPO/lang/dart"
export HL_FRAMEWORK="$HL_REPO/framework"
export HL_FRAMEWORK_ios="$HL_REPO/framework/ios"
export HL_FRAMEWORK_flutter="$HL_REPO/framework/flutter"
# }}}

export ANDROID_HOME="$HOME/Library/Android/sdk"
export THEMIS_HOME="$HOME/vim-themis"

# MARK: PATH
# Because the order is so important for PATH, so we can't use connected `path` to reflect its value
# "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin" \
typeset -g -U path PATH
path=(
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
    "$HL_LOCAL/bin/ruby"
    "$HL_LOCAL/bin/osascript"
    "$HL_LOCAL/bin/py"
    "$HL_LOCAL/bin/sh"
    "$HL_LOCAL/bin"
    "$HOME/.fvm/default/bin"
    "$HOME/.node_modules_global/bin"
    "$HOME/.vim/bin"
    "$HOME/.emacs.d/bin"
    "$HOME/.fzf/bin"
    "$HOME/.pyenv/bin"
    "$HOME/.pyenv/shims"
    "$HOME/.rbenv/shims"
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$ZDOTDIR/bin/perl"
    "$ZDOTDIR/bin/osascript"
    "$ZDOTDIR/bin/py"
    "$ZDOTDIR/bin/sh"
    "$ZDOTDIR/bin/ruby"
    "$ZDOTDIR/bin"
    "$HOMEBREW_PREFIX/opt/sqlite/bin"
    # "$HOMEBREW_PREFIX/opt/llvm/bin"
    "$HOMEBREW_PREFIX/opt/openssl/bin"
    "$HOMEBREW_PREFIX/opt/dart/libexec/bin"
    "$HOMEBREW_PREFIX/opt/grep/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/make/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/findutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin"
    "$HOMEBREW_PREFIX/opt/file-formula/bin"
    "$HOMEBREW_PREFIX/opt/ncurses/bin"
    # "$HOMEBREW_PREFIX/opt/ruby/bin"
    "$HOMEBREW_PREFIX/opt/openjdk/bin"
    "$HOMEBREW_PREFIX/sbin"
    "$HOMEBREW_PREFIX/bin"
    "/usr/sbin"
    "/usr/libexec"
    "/usr/bin"
    "/sbin"
    "/bin"
    "${path[@]}"
)
remove_element_if_path_not_exist path
export PATH

# MARK: FPATH

# we must use -g option here, otherwise fpath will be empty after typeset -U if this file is sourced in a function, because zsh will *create a new
# local variable* in this case
typeset -g -U fpath FPATH
# Connected array Variables, fpath is connected with FPATH
fpath=(
    "$ZDOTDIR/lib"
    "$ZDOTDIR/completion"
    "${fpath[@]}"
)
remove_element_if_path_not_exist fpath
export FPATH

# MARK: MANPATH
typeset -g -U manpath MANPATH
# Connected array Variables, manpath is connected with MANPATH
manpath=(
    "$HOMEBREW_PREFIX/share/man"
    "$ZDOTDIR/man"
    # "$HOMEBREW_PREFIX/opt/java/share/man"
    "/usr/share/man"
    "${manpath[@]}"
)
remove_element_if_path_not_exist manpath
export MANPATH

# 为 system 范围添加 header 路径, 会影响到 vim 的 ycm 与 ale.
# refer to <https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html>
# CPATH 会对 c, c++, objc 这三种语言的搜索路径起作用
# 而 C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, OBJC_INCLUDE_PATH 只对其对应语言的编译起作用
# 其作用类似于使用 `-I path`, 在此处进行了变量的定义后方便全局都起作用

# MARK: C_INCLUDE_PATH
temp_arr=(
    "$HL_LANG/c/foundation"
)
remove_element_if_path_not_exist temp_arr
insert_path_to_variable "C_INCLUDE_PATH" "${temp_arr[@]}"
unset temp_arr

# MARK: CPLUS_INCLUDE_PATH
temp_arr=(
    "$HL_LANG/cpp/foundation"
)
remove_element_if_path_not_exist temp_arr
insert_path_to_variable "CPLUS_INCLUDE_PATH" "${temp_arr[@]}"
unset temp_arr

# MARK: OBJC_INCLUDE_PATH
temp_arr=(
    "$HL_LANG/objc/foundation"
)
remove_element_if_path_not_exist temp_arr
insert_path_to_variable "OBJC_INCLUDE_PATH" "${temp_arr[@]}"
unset temp_arr
# insert_path_to_variable "LD_LIBRARY_PATH" ""

# MARK: CPATH
temp_arr=(
    "$C_INCLUDE_PATH"
)
remove_element_if_path_not_exist temp_arr
insert_path_to_variable "CPATH" "${temp_arr[@]}"
unset temp_arr

# MARK: PYTHONPATH
temp_arr=(
    "$HL_LANG/python/foundation"
)
remove_element_if_path_not_exist temp_arr
insert_path_to_variable "PYTHONPATH" "${temp_arr[@]}"
unset temp_arr

if command_exists pkg-config; then
    # 添加自定义的 pkg-config 路径, 默认的路径为 /usr/local/lib/pkgconfig
    temp_arr=(
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
    remove_element_if_path_not_exist temp_arr
    insert_path_to_variable "PKG_CONFIG_PATH" "${temp_arr[@]}"
    unset temp_arr
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
        # CPPFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        # export CPPFLAGS

        # CFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        # export CFLAGS

        # CXXFLAGS=$(pkg-config --cflags "${PKGS[@]}")
        # export CXXFLAGS

        # # LDFLAGS+="-I$HOMEBREW_PREFIX/opt/openjdk/include"
        # LDFLAGS=$(pkg-config --libs "${PKGS[@]}")
        # export LDFLAGS
        unset PKGS
    fi
fi

#***************   CHEZMOI   *****************
[[ -f "$HL_SECRET/config.json" ]] && export CHEZMOI_GITHUB_ACCESS_TOKEN=$(jq -r '.CHEZMOI_GITHUB_ACCESS_TOKEN' "$HL_SECRET/config.json")

#***************   GITHUB   *****************
[[ -f "$HL_SECRET/config.json" ]] && export GITHUB_TOKEN=$(jq -r '.GITHUB_TOKEN' "$HL_SECRET/config.json")
export GITHUB_USER=hanleylee

#***************   GPG   *****************
GPG_TTY=$(tty)
export GPG_TTY

#***************   LESS   *****************

# output of less -V is following
# less 530 (POSIX regular expressions)
# Copyright (C) 1984-2017  Mark Nudelman
export LESS_VERSION=$(less -V | head -n1 | cut -d" " -f2)

# less options
temp_arr=(
    # Quit if entire file fits on first screen.
    -+F # forbidden less automatically exit if the entire file can be displayed on the first screen
    -+X # forbidden sending the termcap initialization and deintialization strings to the terminal
    -M # or --LONG-PROMPT prompt even more verbosely than more
    -N # or --line-numbers show number
    # -n # supress the line number
    # -+N # hide number
    # Ignore case in searches that do not contain uppercase.
    --ignore-case
    # Allow ANSI colour escapes, but no other escapes.
    --RAW-CONTROL-CHARS
    # Quiet the terminal bell. (when trying to scroll past the end of the buffer)
    --quiet
    # Do not complain when we are on a dumb terminal.
    --dumb
)
autoload -Uz is-at-least
if is-at-least 598 "$LESS_VERSION"; then
    temp_arr+=(
        # increasely search
        --incsearch
    )
fi
export LESS="${temp_arr[*]}"
unset less_version
unset temp_arr

autoload -Uz colors && colors
export LESS_TERMCAP_mb="${fg_bold[red]}"
export LESS_TERMCAP_md="${fg_bold[red]}"
export LESS_TERMCAP_me="${reset_color}"
export LESS_TERMCAP_so="${fg_bold[black]}${bg[yellow]}"
export LESS_TERMCAP_se="${reset_color}"
export LESS_TERMCAP_us="${fg_bold[green]}"
export LESS_TERMCAP_ue="${reset_color}"
# export LESS_TERMCAP_mb=$'\e[1;32m'
# export LESS_TERMCAP_md=$'\e[1;32m'
# export LESS_TERMCAP_me=$'\e[0m'
# export LESS_TERMCAP_se=$'\e[0m'
# export LESS_TERMCAP_so=$'\e[01;33m'
# export LESS_TERMCAP_ue=$'\e[0m'
# export LESS_TERMCAP_us=$'\e[1;4;31m'

#***************   PAGER   *****************
# Default pager
export PAGER='hlpager'
# export PAGER='vmore'

#***************   MAN   *****************
export MANPAGER='less'
export MANWIDTH=150

#***************   autosuggest   *****************
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=245,underline" # 提示样式, 可设置前景, 背景, 加粗, 下划线
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)      # the auto suggestion will only use the command history for suggestions by default

#***************   BAT   *****************
export BAT_CONFIG_PATH="$XDG_CONFIG_HOME/bat/config"

#***************   PYTHON   *****************
export PYTHON_CONFIGURE_OPTS="--enable-framework"
export PYTHONUNBUFFERED=1
[[ -d "$HOME/.pyenv" ]] && export PYENV_ROOT="$HOME/.pyenv"

#***************   RUBY   *****************
export RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl
# export GEM_HOME="$HOME/.gem"

#***************   GO   *****************
if command_exists go; then
    export GOROOT=$(go env GOROOT)
    export GOPATH=$(go env GOPATH)
    export GOBIN=$GOPATH/bin
fi

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

export JAVA_HOME="$HOMEBREW_PREFIX/opt/openjdk"
export JDK_HOME="$HOMEBREW_PREFIX/opt/openjdk"

export XML_CATALOG_FILES="$HOMEBREW_PREFIX/etc/xml/catalog"
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

# shellcheck disable=2016
export RGV_EDITOR='vv $file:$line:$col'

#***************   preview   *****************
export FILE_PREVIEW_COMMAND='preview_code'
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
# export _ZO_DATA_DIR=$XDG_DATA_HOME
# export _ZO_ECHO=0
# export _ZO_EXCLUDE_DIRS=""
# export _ZO_FZF_OPTS="$FZF_DEFAULT_OPTS --preview '$DIR_PREVIEW_COMMAND {2}' --preview-window right:50%:nowrap"
# export _ZO_MAXAGE=100000
# export _ZO_RESOLVE_SYMLINKS=0

# search-and-view
# uses 'vv'
export RGV_EDITOR='vv $file:$line:$col'
# # uses 'vim'
# export RGV_EDITOR='vim +$line $file'

#***************   SHELLCHECK   *****************
export SHELLCHECK_OPTS="\
-e SC1071 \
-e SC2155 \
-e SC1091 \
-e SC2296 \
"

# Flutter
export FVM_HOME="$HOME/.fvm"
export FLUTTER_ROOT="$HOME/.fvm/default"
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn

# MARK: For vim
# export VIMTEST=true
