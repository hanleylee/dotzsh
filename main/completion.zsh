# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Enables you to go through the list and select one option
zstyle ':completion:*' menu select
# Case insensitive auto-completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
# If the line has sudo or doas in it, then it tries to gain more access while completing command options (-/--)
zstyle ':completion::complete:*' gain-privileges 1
# Don't show . and .. in completion menu
zstyle ':completion:*' special-dirs false

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false
# zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'

zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' popup-pad 30 10 # 宽内缩值, 高内缩值, 也可认为是扩展区域值
zstyle ':fzf-tab:*' fzf-flags --preview-window=down:3:hidden:wrap
zstyle ':fzf-tab:*' fzf-pad 4

# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:cd:*' popup-pad 80 0

# Show hidden files in the menu
_comp_options+=(globdots)

# Enabling completion for command options (which start with -- or -)
zmodload zsh/complist
#}}}

autoload -Uz compinit && compinit   # load + start completion
