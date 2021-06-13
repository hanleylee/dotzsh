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
typeset -U PATH # 保证 TMUX 下及 source 后 PATH 不会有重复项

insert_path_if_exists "/bin"
insert_path_if_exists "/sbin"
insert_path_if_exists "/usr/bin"
insert_path_if_exists "/usr/sbin"
insert_path_if_exists "/opt/MonkeyDev/bin"
insert_path_if_exists "$HOMEBREW_PREFIX/bin"
insert_path_if_exists "$HOMEBREW_PREFIX/sbin"
insert_path_if_exists "$HOMEBREW_PREFIX/opt/make/libexec/gnubin"
insert_path_if_exists "$HOMEBREW_PREFIX/opt/openssl@1.1/bin"
insert_path_if_exists "$HOME/.cargo/bin"
insert_path_if_exists "$HOME/.rbenv/shims"
insert_path_if_exists "$HOME/.pyenv/shims"
insert_path_if_exists "$HOME/.local/bin"
insert_path_if_exists "$HOME/.pyenv/bin"
insert_path_if_exists "$HOME/.fzf/bin"
insert_path_if_exists "$HOMEBREW_PREFIX/opt/llvm/bin"
# export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
# export PATH="$GEM_HOME/bin:$PATH"
# export PATH="/usr/local/opt/ruby/bin:$PATH"
# export PATH="/usr/local/opt/openjdk/bin:$PATH"

# 为 system 范围添加 header 路径, 会影响到 vim 的 ycm 与 ale.
[[ -d "$HOMEBREW_PREFIX/include" ]] && HL_HEADER="$HOMEBREW_PREFIX/include:$HL_HEADER"
[[ -d "$HOME/.local/share/header" ]] && HL_HEADER="$HOME/.local/share/header:$HL_HEADER"
export HL_HEADER

# refer to <https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html>
# CPATH 会对 c, c++, objc 这三种语言的搜索路径起作用
# 而 C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, OBJC_INCLUDE_PATH 只对其对应语言的编译起作用
# 其作用类似于使用 `-I path`, 在此处进行了变量的定义后方便全局都起作用
CPATH=$HL_HEADER
export CPATH

C_INCLUDE_PATH=''
export C_INCLUDE_PATH

CPLUS_INCLUDE_PATH=''
export CPLUS_INCLUDE_PATH

OBJC_INCLUDE_PATH=''
export OBJC_INCLUDE_PATH

export VIMCONFIG="$HOME/.vim"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local"

# 添加自定义的pkg-config路径, 默认的路径为 /usr/local/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/lib/pkgconfig" ]]                 && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig" ]]        && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/ruby/lib/pkgconfig" ]]        && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/ruby/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig" ]] && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig
# export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export PKG_CONFIG_PATH

#███████████████████████   FLAGS(for makefile, use pkg-config)   ██████████████████████████
if command_exists pkg-config; then
    pkg-config --exists glib-2.0 && PKGS+="glib-2.0 "
    pkg-config --exists zlib && PKGS+="zlib "
    pkg-config --exists openssl && PKGS+="openssl"

    CPPFLAGS=$(pkg-config --cflags "$PKGS")
    export CPPFLAGS

    CXXFLAGS=$(pkg-config --cflags "$PKGS")
    export CXXFLAGS

    CFLAGS=$(pkg-config --cflags "$PKGS")
    export CFLAGS

    # LDFLAGS+="-I$HOMEBREW_PREFIX/opt/openjdk/include"
    LDFLAGS=$(pkg-config --libs "$PKGS")
    export LDFLAGS
fi

# export LDFLAGS="-L/$HOMEBREW_PREFIX/opt/openssl/lib"
# export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl/include"

#***************   pyenv   *****************
if command_exists pyenv; then
    eval "$(pyenv init --path)"
fi

#***************   GPG   *****************
GPG_TTY=$(tty)
export GPG_TTY

#***************   LESS   *****************
# Default pager
export PAGER='less'

# less options
less_opts=(
    # Quit if entire file fits on first screen.
    -+F
    -+X
    # show number
    -N
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

#***************   Homebrew   *****************
export HOMEBREW_NO_AUTO_UPDATE=true # 禁用 Homebrew 每次安装软件时的更新

#***************   MonkeyDev   *****************
[[ -d "/opt/MonkeyDev" ]] && export MonkeyDevPath="/opt/MonkeyDev"
export MonkeyDevDeviceIP=

#***************   PYTHON   *****************
export PYTHON_CONFIGURE_OPTS="--enable-framework"

#***************   RUBY   *****************
# export RUBY_CONFIGURE_OPTS=--with-openssl-dir=$HOMEBREW_PREFIX/opt/openssl@1.1
# export GEM_HOME="$HOME/.gem"

#***************   GTAGS   *****************
export GTAGSLABEL='native-pygments'
[[ -f "$XDG_CONFIG_HOME/global/.globalrc" ]] && export GTAGSCONF="$XDG_CONFIG_HOME/global/.globalrc"

#***************   fzf   *****************
# --color fg:242,bg:236,hl:196,fg+:232,bg+:142,hl+:196:
# --color info:108,prompt:109,spinner:108,pointer:168,marker:168
# 默认 fzf 配置, 使用 fd 而不是系统的 find
# --color fg:#ebdbb2,bg:#282828,hl:#fabd2f,fg+:#ebdbb2,bg+:#3c3836,hl+:#fabd2f
# --color info:#83a598,prompt:#bdae93,spinner:#fabd2f,pointer:#83a598,marker:#fe8019,header:#665c54
# one dark
FZF_HIDDEN_PREVIEW="\
fzf-tmux \
-p 90%,80% \
--layout=reverse \
--no-sort \
--exact \
--preview-window down:3:hidden:wrap \
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

# --sort \, 默认是 --no-sort, 就是根据你原有的结果顺序为以后所有的顺序基础
export FZF_DEFAULT_OPTS="\
--history-size=50000 \
--color=dark \
--color=fg:#707a8c,bg:-1,hl:#3e9831,fg+:#cbccc6,bg+:#434c5e,hl+:#5fff87 \
--color=info:#af87ff,prompt:#5fff87,pointer:#ff87d7,marker:#ff87d7,spinner:#ff87d7 \
--layout=reverse \
--no-sort \
--exact \
--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -N -C {}) 2> /dev/null | head -500' \
--preview-window right:50%:hidden:wrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"
# --preview-window down:3:hidden:wrap
# --preview-window 'right:60%'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_CTRL_T_OPTS=$FZF_DEFAULT_OPTS
export FZF_CTRL_R_OPTS="\
--layout=reverse \
--no-sort \
--exact \
--preview 'echo {}' \
--preview-window down:3:hidden:wrap \
--bind '?:toggle-preview' \
--border \
--cycle \
"

export FZF_ALT_C_OPTS="--preview 'tree -N -C {} | head -500'"
export FZF_TMUX_OPTS="-p 90%,80%" # 控制着fzf的window 是 popup 的还是 split panel 的
export FZF_COMPLETION_TRIGGER='**'

[[ -f "$HOME/.fzf-marks" ]] && export FZF_MARKS_FILE="${HOME}/.fzf-marks"
export FZF_MARKS_COMMAND=$FZF_HIDDEN_PREVIEW
export FZF_MARKS_JUMP="^g"
export FZF_MARKS_NO_COLORS=0
export FZF_MARKS_KEEP_ORDER=1

# z.lua 使用的 fzf 参数
export _ZL_FZF=$FZF_HIDDEN_PREVIEW
