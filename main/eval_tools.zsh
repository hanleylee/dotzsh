# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

#***************   Homebrew   *****************
if command_exists brew; then
    export HOMEBREW_NO_AUTO_UPDATE=true # 禁用 Homebrew 每次安装软件时的更新
    export HOMEBREW_NO_INSTALLED_DEPENDENTS_CHECK=true
    # export HOMEBREW_API_DOMAIN="https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api"
    # export HOMEBREW_BREW_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git"
    # export HOMEBREW_CORE_GIT_REMOTE="https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git"
    eval "$(brew shellenv)" # this line will export some variable, such as below:
    # export HOMEBREW_PREFIX="/usr/local";
    # export HOMEBREW_CELLAR="/usr/local/Cellar";
    # export HOMEBREW_REPOSITORY="/usr/local/Homebrew";
    # export PATH="/usr/local/bin:/usr/local/sbin${PATH+:$PATH}";
    # export MANPATH="/usr/local/share/man${MANPATH+:$MANPATH}:";
    # export INFOPATH="/usr/local/share/info:${INFOPATH:-}";

    # MARK: 恢复仓库上游
    # unset HOMEBREW_BREW_GIT_REMOTE
    # git -C "$(brew --repo)" remote set-url origin https://github.com/Homebrew/brew

    # unset HOMEBREW_API_DOMAIN
    # unset HOMEBREW_CORE_GIT_REMOTE
    # BREW_TAPS="$(BREW_TAPS="$(brew tap 2>/dev/null)"; echo -n "${BREW_TAPS//$'\n'/:}")"
    # for tap in core cask{,-fonts,-drivers,-versions} command-not-found; do
        # if [[ ":${BREW_TAPS}:" == *":homebrew/${tap}:"* ]]; then  # 只复原已安装的 Tap
            # brew tap --custom-remote "homebrew/${tap}" "https://github.com/Homebrew/homebrew-${tap}"
        # fi
    # done
    # brew update
fi

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

# >>> conda initialize >>>
if command_exists conda; then
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/homebrew/anaconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
fi
# <<< conda initialize <<<

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
