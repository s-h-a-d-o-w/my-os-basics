#!/bin/bash
sudo apt update
sudo apt upgrade -y

# zsh
sudo apt install -y zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
sed -i 's/^plugins=(.*)/plugins=(git direnv kubectl zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc
# Unsure if needed to make zsh default
# chsh -s /usr/bin/zsh

# aliases
curl -fsSL https://.../aliases.zsh -o "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/aliases.zsh"

# nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.4/install.sh | bash
source ~/.zshrc
nvm install --lts

## Pure?! HAS TO BE AFTER NVM/NODE INSTALL!
npm install --global pure-prompt
echo "autoload -U promptinit; promptinit" >> ~/.zshrc
echo "prompt pure" >> ~/.zshrc
