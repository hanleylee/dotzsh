# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

if command_exists dircolors; then
    if [[ -f $ZDOTDIR/.dircolors ]]; then eval "$(dircolors -b "$ZDOTDIR"/.dircolors)"; else eval "$(dircolors -b)"; fi
fi
