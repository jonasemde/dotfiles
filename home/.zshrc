unsetopt nomatch

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh-custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="agnoster"

# Hide username in prompt
DEFAULT_USER=`whoami`

# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how many often would you like to wait before auto-updates occur? (in days)
export UPDATE_ZSH_DAYS=30

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git laravel composer macos docker docker-compose dotenv npm brew vscode aws)
# Note: z plugin removed - using zoxide instead (loaded below)
[[ -e $ZSH/oh-my-zsh.sh ]] && source $ZSH/oh-my-zsh.sh

#set numeric keys
# 0 . Enter
bindkey -s "^[Op" "0"
bindkey -s "^[Ol" "."
bindkey -s "^[OM" "^M"
# 1 2 3
bindkey -s "^[Oq" "1"
bindkey -s "^[Or" "2"
bindkey -s "^[Os" "3"
# 4 5 6
bindkey -s "^[Ot" "4"
bindkey -s "^[Ou" "5"
bindkey -s "^[Ov" "6"
# 7 8 9
bindkey -s "^[Ow" "7"
bindkey -s "^[Ox" "8"
bindkey -s "^[Oy" "9"
# + -  * /
bindkey -s "^[Ok" "+"
bindkey -s "^[Om" "-"
bindkey -s "^[Oj" "*"
bindkey -s "^[Oo" "/"

# Load the shell dotfiles, and then some:
# * ~/.dotfiles-custom can be used for other settings you don't want to commit.
for file in ~/.dotfiles/home/.{exports,aliases,functions}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file"
done
for file in ~/.dotfiles-custom/shell/.{exports,aliases,functions,zshrc}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"

# import ssh keys in keychain
ssh-add -A 2>/dev/null;

# setup xdebug
export XDEBUG_CONFIG="idekey=VSCODE remote_enable=1 remote_mode=req remote_port=9001 remote_host=127.0.0.1 remote_connect_back=0"

# zsh-completions
# To activate these completions, add the following to your .zshrc
fpath=(/opt/homebrew/share/zsh-completions $fpath)

# Enable autosuggestions
[[ -e /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Modern CLI tools initialization
# zoxide - smarter cd (replaces z)
if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
else
    # Fallback to z if zoxide not installed yet
    [[ -e $(brew --prefix)/etc/profile.d/z.sh ]] && source $(brew --prefix)/etc/profile.d/z.sh
fi

# nvm - Node.js version manager
export NVM_DIR="$HOME/.nvm"
if [ -s "/opt/homebrew/opt/nvm/nvm.sh" ]; then
    \. "/opt/homebrew/opt/nvm/nvm.sh"  # Load nvm
fi
if [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ]; then
    \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # Load nvm bash_completion
fi

# Python - unversioned symlinks (python, pip instead of python3, pip3)
# Note: Update version number when upgrading Python in Brewfile (e.g., 3.14 -> 3.15)
export PATH="/opt/homebrew/opt/python@3.14/libexec/bin:$PATH"

# fzf - Fuzzy finder
if command -v fzf &> /dev/null; then
    eval "$(fzf --zsh)"
fi

# direnv - Per-directory environment variables
if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

# hub - Alias hub to git
if command -v hub &> /dev/null; then
    eval "$(hub alias -s)"
fi

###-tns-completion-start-###
if [ -f ~/.tnsrc ]; then
    source ~/.tnsrc
fi
###-tns-completion-end-###


# Herd injected PHP binary.
export PATH="$HOME/Library/Application Support/Herd/bin/":$PATH


# Load assume-role if available (optional dependency)
if command -v assume-role &> /dev/null; then
    source $(which assume-role)
fi
export PATH="$HOME/.local/bin:$PATH"


# Herd injected PHP configurations
export HERD_PHP_85_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/85/"
export HERD_PHP_84_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/84/"
export HERD_PHP_83_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/83/"
export HERD_PHP_82_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/82/"
export HERD_PHP_81_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/81/"
export HERD_PHP_80_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/80/"
export HERD_PHP_74_INI_SCAN_DIR="$HOME/Library/Application Support/Herd/config/php/74/"
