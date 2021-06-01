[[ -f "$HOME/.sh/init.sh" ]]  && source "$HOME/.sh/init.sh"

if [[ -n $SSH_CLIENT ]] || [[ -n $SSH_TTY ]]; then
    neofetch
fi
