#!/bin/bash
sudo apt update
sudo apt upgrade -y

# common tools
sudo apt install -y vim git

# zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/^plugins=(.*)/plugins=(git direnv kubectl zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

# my custom aliases
curl -fsSL https://raw.githubusercontent.com/s-h-a-d-o-w/my-os-basics/refs/heads/main/aliases.zsh -o ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/aliases.zsh

# nvm
if [[ "$1" != "no-nvm" ]]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
  source "$HOME/.nvm/nvm.sh"
  nvm install --lts
fi

## pure prompt - HAS TO BE AFTER NVM/NODE INSTALL!
npm install --global pure-prompt
echo 'fpath+=("$(npm root -g)/pure-prompt/functions")' >> ~/.zshrc
echo "autoload -U promptinit; promptinit" >> ~/.zshrc
echo "prompt pure" >> ~/.zshrc
echo "prompt_newline='%666v' # Single line mode" >> ~/.zshrc
if [[ "$1" != "no-user-host-in-prompt" ]]; then
  echo "psvar[13]= # Don't show user@host in prompt" >> ~/.zshrc
fi
