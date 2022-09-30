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
export HL_REPO="$HOME/repo"
export HKMS="$HL_REPO/hkms"
export HL_TODO="$HOME/Library/Mobile Documents/com~apple~CloudDocs/iCloud_HL/todo"
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
export HL_BNC_NOTE="$HL_REPO/bnc-note"
# }}}

export HL_SECRET="$HOME/.secret"
export HL_LOCAL="$HOME/.local"

export ANDROID_HOME="$HOME/Library/Android/sdk"
export THEMIS_HOME="$HOME/vim-themis"

# Because the order is so important for PATH, so we can't use connected `path` to reflect its value
# "/Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin" \
typeset -U path
path=(
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/tools"
    "$HL_LOCAL/bin/ruby"
    "$HL_LOCAL/bin/osascript"
    "$HL_LOCAL/bin/py"
    "$HL_LOCAL/bin/sh"
    "$HL_LOCAL/bin"
    "$HL_BNC_NOTE/bin"
    "/opt/MonkeyDev/bin"
    "$HOME/.fvm/default/bin"
    "$HOME/.node_modules_global/bin"
    $path
    # "$HOME/.gem/bin" \
    # export PATH="$GEM_HOME/bin:$PATH"
    # export PATH="/usr/local/opt/ruby/bin:$PATH"
    # export PATH="/usr/local/opt/openjdk/bin:$PATH"
)
# insert_path_to_variable "PATH" "${_path_arr[@]}"
# unset _path_arr
export PATH

typeset -U fpath
# Connected array Variables, fpath is connected with FPATH
fpath=(
    "$HL_BNC_NOTE/completion"
    $fpath
)
export FPATH
# 为 system 范围添加 header 路径, 会影响到 vim 的 ycm 与 ale.
# refer to <https://gcc.gnu.org/onlinedocs/cpp/Environment-Variables.html>
# CPATH 会对 c, c++, objc 这三种语言的搜索路径起作用
# 而 C_INCLUDE_PATH, CPLUS_INCLUDE_PATH, OBJC_INCLUDE_PATH 只对其对应语言的编译起作用
# 其作用类似于使用 `-I path`, 在此处进行了变量的定义后方便全局都起作用
insert_path_to_variable "C_INCLUDE_PATH" "$HL_LANG/c/foundation"
insert_path_to_variable "CPLUS_INCLUDE_PATH" "$HL_LANG/cpp/foundation"
insert_path_to_variable "OBJC_INCLUDE_PATH" "$HL_LANG/objc/foundation"
# insert_path_to_variable "LD_LIBRARY_PATH" ""

insert_path_to_variable "CPATH" "$C_INCLUDE_PATH"

insert_path_to_variable "PYTHONPATH" "$HL_LANG/python/foundation"

#***************   MonkeyDev   *****************
[[ -d "/opt/MonkeyDev" ]] && export MonkeyDevPath="/opt/MonkeyDev"
export MonkeyDevDeviceIP=

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
