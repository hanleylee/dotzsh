echo "$ARCH_MSG"

if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
    neofetch
fi
