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

#***************   nodeenv   *****************
if command_exists nodeenv; then
    eval "$(nodenv init -)"
fi

#***************   zoxide   *****************
if command_exists zoxide; then
    eval "$(zoxide init zsh)"
fi

#***************   mise   *****************
if command_exists mise; then
    eval "$(mise activate zsh)"
fi


#***************   z.lua   *****************
# if command_exists lua; then
#     ZLUA_SCRIPT="$ZINIT_HOME/plugins/skywind3000---z.lua/z.lua"

#     if [[ -f "$ZLUA_SCRIPT" ]]; then
#         eval "$(lua $ZLUA_SCRIPT --init zsh once enhanced)"
#     else
#         echo 'Not found z.lua'
#         return
#     fi
# fi
