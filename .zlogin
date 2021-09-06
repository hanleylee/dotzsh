echo "$ARCH_MSG"

if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
    neofetch
fi

# 如果是 kitty, 直接运行 nvim
if [[ "$TERM" == "xterm-kitty" ]]; then
    nv3
fi
