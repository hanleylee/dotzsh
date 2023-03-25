# Author: Hanley Lee
# Website: https://www.hanleylee.com
# GitHub: https://github.com/hanleylee
# License:  MIT License

# Enabling completion for command options (which start with -- or -)
zmodload zsh/complist

WORDCHARS=''

# ... unless we really want to.
zstyle '*' single-ignored show
# Enables you to go through the list and select one option
zstyle ':completion:*' menu select
# zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*' group-name '' # 分组显示
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # Case insensitive auto-completion
# Use caching so that commands like apt and dpkg complete are useable
zstyle ':completion:*' use-cache yes
zstyle ':completion:*' cache-path "$ZSH_CACHE_DIR"
# partial completion suggestions
zstyle ':completion:*' list-suffixes
zstyle ':completion:*' expand prefix suffix 
# If the line has sudo or doas in it, then it tries to gain more access while completing command options (-/--)
zstyle ':completion::complete:*' gain-privileges 1 # double esc to put 'sudo'
zstyle ':completion:*' special-dirs false # Don't show . and .. in completion menu
# zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''

# 用本用户的所有进程补全
zstyle ':completion:*:processes' command 'ps -afu$USER'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USERNAME -o pid,user,comm -w -w"
zstyle ':completion:*:*:*:*:processes' force-list always
# 进程名补全
zstyle ':completion:*:processes-names' command  'ps c -u ${USER} -o command | uniq'

# cd 补全顺序
zstyle ':completion:*:-tilde-:*' group-order 'named-directories' 'path-directories' 'users' 'expand'
zstyle ':completion:*:cd:*' ignore-parents parent pwd # 在 cd 后不要显示 '.'

zstyle ':completion:*:cd:*' tag-order local-directories directory-stack path-directories # disable named-directories autocompletion

# complete manual by their section, from grml
zstyle ':completion:*:manuals'    separate-sections true
zstyle ':completion:*:manuals.*'  insert-sections   true

zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:exa' file-sort modification
zstyle ':completion:*:exa' sort false
# zstyle ':completion:*:directory-stack' list-colors '=(#b) #([0-9]#)*( *)==95=38;5;12'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

zstyle ':fzf-tab:complete:_zlua:*' query-string input
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
# zstyle ':fzf-tab:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':fzf-tab:*' popup-pad 30 10 # 宽内缩值, 高内缩值, 也可认为是扩展区域值
zstyle ':fzf-tab:*' fzf-flags --preview-window=down:3:hidden:wrap
zstyle ':fzf-tab:*' fzf-pad 4

# zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
# zstyle ':fzf-tab:complete:cd:*' popup-pad 80 0

# Don't complete uninteresting users
zstyle ':completion:*:*:*:users' ignored-patterns \
        adm amanda apache at avahi avahi-autoipd beaglidx bin cacti canna \
        clamav daemon dbus distcache dnsmasq dovecot fax ftp games gdm \
        gkrellmd gopher hacluster haldaemon halt hsqldb ident junkbust kdm \
        ldap lp mail mailman mailnull man messagebus  mldonkey mysql nagios \
        named netdump news nfsnobody nobody nscd ntp nut nx obsrun openvpn \
        operator pcap polkitd postfix postgres privoxy pulse pvm quagga radvd \
        rpc rpcuser rpm rtkit scard shutdown squid sshd statd svn sync tftp \
        usbmux uucp vcsa wwwrun xfs '_*'

#}}}

# the zstyle command must added before enable the compinit system
compinit   # load + start completion
bashcompinit

# Show hidden files in the menu
_comp_options+=(globdots)

# MARK: Completion for specific tool
compdef vman="man"
