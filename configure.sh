#!/bin/bash

# install required packages

sudo apt install zsh autojump curl git wget

# install oh-my-zsh and powerline10k 

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

bash -c "$(curl -fsSL https://gist.githubusercontent.com/romkatv/aa7a70fe656d8b655e3c324eb10f6a8b/raw/install_meslo_wsl.sh)"

# install plugins and powerlevel10k theme

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

git clone https://github.com/esantonroda/dotfiles.git $HOME/.dotfiles

# backup of previous config files

mkdir -p $HOME/.dotfiles/backup

DOTFILES=$HOME/.dotfiles

cp -p $HOME/.zshrc $HOME/.p10k.zsh $DOTFILES/backup

rm -f $HOME/.zshrc $HOME/.p10k.zsh

## linking to new files

ln -s $DOTFILES/zshrc $HOME/.zshrc 
ln -s $DOTFILES/p10k.zsh $HOME/.p10k.zsh

