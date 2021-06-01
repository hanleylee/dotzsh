[[ -f "$HOME/.sh/base/preinit.sh" ]] && . "$HOME/.sh/base/preinit.sh"

#███████████████████████   MAIN   ██████████████████████████
export LC_CTYPE="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

setopt globdots # 使所有的ls显示 . 与 ..
EDITOR=vim # zsh 默认的编辑器为 vi, 比较难用, 因此设置为 vim
export EDITOR
export VISUAL="$EDITOR"
export HISTSIZE=100000
[[ -f "$HOME/.sh/.zsh_history" ]] && export HISTFILE="$HOME/.sh/.zsh_history"
export SAVEHIST=$HISTSIZE
setopt HIST_SAVE_NO_DUPS
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE

#███████████████████████   PATH Variables   ██████████████████████████
typeset -U PATH # 保证 TMUX 下及 source 后 PATH 不会有重复项

[[ -d "/bin" ]] && PATH="/bin:$PATH"
[[ -d "/sbin" ]] && PATH="/sbin:$PATH"
[[ -d "/usr/bin" ]] && PATH="/usr/bin:$PATH"
[[ -d "/usr/sbin" ]] && PATH="/usr/sbin:$PATH"
[[ -d "/usr/local/bin" ]] && PATH="/usr/local/bin:$PATH"
[[ -d "/usr/local/sbin" ]] && PATH="/usr/local/sbin:$PATH"
[[ -d "/opt/MonkeyDev/bin" ]] && PATH="/opt/MonkeyDev/bin:$PATH"
[[ -d "$HOMEBREW_PREFIX/bin" ]] && PATH="$HOMEBREW_PREFIX/bin:$PATH"
[[ -d "$HOMEBREW_PREFIX/sbin" ]] && PATH="$HOMEBREW_PREFIX/sbin:$PATH"
[[ -d "$HOME/.cargo/bin" ]] && PATH="$HOME/.cargo/bin:$PATH"
[[ -d "$HOME/.rbenv/shims" ]] && PATH="$HOME/.rbenv/shims:$PATH"
[[ -d "$HOME/.pyenv/shims" ]] && PATH="$HOME/.pyenv/shims:$PATH"
[[ -d "$HOME/.local/bin" ]] && PATH="$HOME/.local/bin:$PATH"
[[ -d "$HOMEBREW_PREFIX/opt/openssl@1.1/bin" ]] && PATH="$HOMEBREW_PREFIX/opt/openssl@1.1/bin:$PATH"
# export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
# export PATH="$GEM_HOME/bin:$PATH"
# export PATH="/usr/local/opt/ruby/bin:$PATH"
# export PATH="/usr/local/opt/openjdk/bin:$PATH"
export PATH

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

# 添加自定义的pkg-config路径, 默认的路径为 /usr/local/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/lib/pkgconfig" ]]                 && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig" ]]        && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/zlib/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/ruby/lib/pkgconfig" ]]        && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/ruby/lib/pkgconfig
[[ -d "$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig" ]] && PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$HOMEBREW_PREFIX/opt/openssl@1.1/lib/pkgconfig
# export PKG_CONFIG_PATH="/opt/homebrew/opt/ruby/lib/pkgconfig"
export PKG_CONFIG_PATH

export VIMCONFIG="$HOME/.vim"
export XDG_CACHE_HOME="$HOME/.cache"

#███████████████████████   FLAGS(for makefile, use pkg-config)   ██████████████████████████

pkg-config --exists glib-2.0 && PKGS+="glib-2.0 "
pkg-config --exists zlib && PKGS+="zlib "
pkg-config --exists openssl && PKGS+="openssl"

CPPFLAGS=$(pkg-config --cflags $PKGS)
export CPPFLAGS

CXXFLAGS=$(pkg-config --cflags $PKGS)
export CXXFLAGS

CFLAGS=$(pkg-config --cflags $PKGS)
export CFLAGS

# LDFLAGS+="-I$HOMEBREW_PREFIX/opt/openjdk/include"
LDFLAGS=$(pkg-config --libs $PKGS)
export LDFLAGS

# export LDFLAGS="-L/$HOMEBREW_PREFIX/opt/openssl/lib"
# export CPPFLAGS="-I$HOMEBREW_PREFIX/opt/openssl/include"

#***************   GPG   *****************
export GPG_TTY=$(tty)

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
[[ -f "$HOME/.config/global/.globalrc" ]] && export GTAGSCONF="$HOME/.config/global/.globalrc"

#***************   cargo   *****************
[[ -f "$HOME/.cargo/env" ]] && source "$HOME/.cargo/env"

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

#███████████████████████   ALIAS   ██████████████████████████
alias reignore='git rm -r --cached . && git add .'
alias whyignore='git check-ignore -v'
command_exists trash              && alias rm='trash'
command_exists nvim               && alias nv="nvim"
command_exists exa                && alias l='exa -laghHimU --git --group-directories-first --icons -F' || alias l='ls -lhia'
command_exists ranger             && alias r='source ranger'
[[ -d "$HOME/.hlconfig.git" ]]    && alias hlconfig="git --git-dir=$HOME/.hlconfig.git/ --work-tree=$HOME"
[[ -f "/opt/homebrew/bin/brew" ]] && alias abrew='arch -arm64 /opt/homebrew/bin/brew'
[[ -f "/usr/local/bin/brew" ]]    && alias ibrew='arch -x86_64 /usr/local/bin/brew'

if command_exists vim; then
    alias vim0='vim -u NONE -U NONE -N -i NONE'
    alias vim1='vim --cmd "let g:vim_weight=1"'
    alias vim2='vim --cmd "let g:vim_weight=2"'
    alias vim3='vim --cmd "let g:vim_weight=3"'
    alias vim4='vim --cmd "let g:vim_weight=4"'
fi

# alias Z='z -I .'
