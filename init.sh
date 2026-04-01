#!/bin/bash

NO_NVM=false
HIDE_USER_HOST_IN_PROMPT=false
for arg in "$@"; do
  if [[ "$arg" == "no-nvm" ]]; then
    NO_NVM=true
  fi
  if [[ "$arg" == "no-user-host-in-prompt" ]]; then
    HIDE_USER_HOST_IN_PROMPT=true
  fi
done

sudo apt update
sudo apt upgrade -y

# common tools
sudo apt install -y vim git

# zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/^plugins=(.*)/plugins=(git direnv kubectl zsh-autosuggestions zsh-history-substring-search)/' ~/.zshrc

# my custom aliases
curl -fsSL https://raw.githubusercontent.com/s-h-a-d-o-w/my-os-basics/refs/heads/main/aliases.zsh -o ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/aliases.zsh

# nvm
if ! $NO_NVM; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  source "$HOME/.nvm/nvm.sh"
  nvm install --lts
fi

## pure prompt - HAS TO BE AFTER NVM/NODE INSTALL!
npm install --global pure-prompt
cat >> ~/.zshrc << 'EOF'

# pure prompt
fpath+=("$(npm root -g)/pure-prompt/functions")
autoload -U promptinit; promptinit
prompt pure
prompt_newline='%666v' # Single line mode
EOF
if $HIDE_USER_HOST_IN_PROMPT; then
  echo "psvar[13]= # Don't show user@host in prompt" >> ~/.zshrc
fi

## zsh mods
cat >> ~/.zshrc << 'EOF'

# history substring search
HISTORY_SUBSTRING_SEARCH_ENSURE_UNIQUE=true
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# misc
export LS_COLORS="ow=30;101:tw=30;101" # red background for directories with dangerous permissions
EOF