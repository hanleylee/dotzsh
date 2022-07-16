# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

#***************   scmpuff   *****************
command_exists scmpuff && eval "$(scmpuff init -s)"
#}}}

#***************   pyenv   *****************
if command_exists pyenv; then
    eval "$(pyenv init -)"

    # 过于耗费性能
    # if command_exists pyenv-virtualenv-init; then
    #     eval "$(pyenv virtualenv-init -)" #
    # fi

fi

#***************   rbenv   *****************
if command_exists rbenv; then
    eval "$(rbenv init - zsh)"
fi

#***************   zoxide   *****************
if command_exists zoxide; then
    eval "$(zoxide init zsh)"
fi


