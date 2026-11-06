[[ -e ~/.dotfiles/home/.profile ]] && source ~/.dotfiles/home/.profile
[[ -e ~/.dotfiles/home/.aliases ]] && source ~/.dotfiles/home/.aliases
[[ -e ~/.dotfiles/home/.exports ]] && source ~/.dotfiles/home/.exports


# Added by Antigravity CLI installer
export PATH="/Users/jonasemde/.local/bin:$PATH"
. "$HOME/.cargo/env"
