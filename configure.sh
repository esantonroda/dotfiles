#!/bin/bash

# install required packages

sudo apt install zsh autojump curl git wget kubectl

# install oh-my-zsh and powerline10k 

bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

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

# kube environment
#kubectl
## curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
## chmod +x ./kubectl
## # Move the binary in to your PATH.
## sudo mv ./kubectl /usr/local/bin/kubectl

# kubectx+kubens
mkdir -p ~/bin

git clone https://github.com/ahmetb/kubectx.git ~/.kubectx

chmod +x ~/.kubectx/kubens ~/.kubectx/kubectx
ln -sf ~/.kubectx/kubens /usr/local/bin/kubens
ln -sf ~/.kubectx/kubectx /usr/local/bin/kubectx

mkdir -p ~/.oh-my-zsh/completions
chmod -R 755 ~/.oh-my-zsh/completions
ln -s ~/.kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
ln -s ~/.kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh