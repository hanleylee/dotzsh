# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Useful alias and function for apple reverse engineering

# for iproxy {{{
if command_exists iproxy; then
    alias iproxy_iphone_7='iproxy 2222 22'
    alias iproxy_ipad_pro='iproxy 2223 22'
    alias iproxy_iphone_12='iproxy 2224 22'
    alias iproxy_iphone_se='iproxy 2225 22'
fi
# }}}

# verify the mach-o file is crypted or not
function verify_crypt() {
    otool -l "$1" | grep --color=always cryptid -C 5
}
