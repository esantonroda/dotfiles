#!/bin/bash

# install required packages

DATE_BCK=$(date +%Y%m%d%H%M%S)
OSID=$(grep -oP '(?<=^ID=).+' /etc/os-release | tr -d '"')
DOTFILES=$HOME/.dotfiles


zsh_install () {
if [ -d $HOME/.oh-my-zsh ]
then 
echo "Zsh installed. Installation skipped"
else
echo "Zsh NOT installed. Installing..."
# install oh-my-zsh and powerline10k theme
bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
bash -c "$(curl -fsSL https://gist.githubusercontent.com/romkatv/aa7a70fe656d8b655e3c324eb10f6a8b/raw/install_meslo_wsl.sh)"
# install plugins and powerlevel10k theme
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:=~/.oh-my-zsh/custom}/plugins/zsh-completions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone --depth=1 https://gitee.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
echo "Zsh installation done."
fi

git clone https://github.com/esantonroda/dotfiles.git $DOTFILES
if [ $? -eq 128 ]
then
echo "fatal error on clone"
  cd $DOTFILES
  git pull
fi

}

# fonts


fonts_install () {
FILE=$HOME/.fonts/MesloLGS%20NF%20Regular.ttf

    if [ -f "$FILE" ]
        then    
        echo "Fonts previously installed."
    else
        echo "Installing fonts..."
        mkdir -p $HOME/.fonts
        wget -O $HOME/.fonts/MesloLGS%20NF%20Regular.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Regular.ttf
        wget -O $HOME/.fonts/MesloLGS%20NF%20Bold.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold.ttf
        wget -O $HOME/.fonts/MesloLGS%20NF%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Italic.ttf
        wget -O $HOME/.fonts/MesloLGS%20NF%20Bold%20Italic.ttf https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20Bold%20Italic.ttf
        echo "MesloLGS Fonts installed on $HOME/.fonts"
    fi
}

zsh_backup () {
# backup of previous config files
echo "Backing up files..."
mkdir -p $DOTFILES/backup
cp -p $HOME/.zshrc  $DOTFILES/backup/.zshrc-$DATE_BCK
cp -p $HOME/.p10k.zsh $DOTFILES/backup/.p10k.zsh-$DATE_BCK
echo "Deleting files..."
rm -f $HOME/.zshrc $HOME/.p10k.zsh
echo "Backup Done."
}

## linking to new files

link_install () {
ln -s $DOTFILES/zshrc $HOME/.zshrc 
ln -s $DOTFILES/p10k.zsh $HOME/.p10k.zsh
}

link_install_cbld () {
ln -s $DOTFILES/zshrc $HOME/.zshrc 
ln -s $DOTFILES/p10k-azure.zsh $HOME/.p10k.zsh
}

# kube environment

#kubectl
## curl -LO "https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl"
## chmod +x ./kubectl
## # Move the binary in to your PATH.
## sudo mv ./kubectl /usr/local/bin/kubectl

# kubectx+kubens

kube_addons_install () {
if [ -d ~/.kubectx ]
then 
echo "Kubectx installed. Installation skipped"
else
echo "Kubectx NOT installed. Installing in local user..."
mkdir -p ~/bin
git clone https://github.com/ahmetb/kubectx.git ~/.kubectx
# only user install to avoid sudo
chmod +x ~/.kubectx/kubens ~/.kubectx/kubectx
ln -sf ~/.kubectx/kubens ~/bin/kubens
ln -sf ~/.kubectx/kubectx ~/bin/kubectx
mkdir -p ~/.oh-my-zsh/completions
chmod -R 755 ~/.oh-my-zsh/completions
ln -s ~/.kubectx/completion/kubectx.zsh ~/.oh-my-zsh/completions/_kubectx.zsh
ln -s ~/.kubectx/completion/kubens.zsh ~/.oh-my-zsh/completions/_kubens.zsh
echo "Kubectx installed.
}

case "$OSID" in

ubuntu)  echo "Installing in $OSID"
    sudo apt install zsh autojump curl git wget kubectl
    zsh_install
    fonts_install
    zsh_backup
    link_install
    kube_addons_install
    ;;
rhel)  echo "Installing in $OSID"
    yum install zsh autojump curl git wget kubectl
    zsh_install
    fonts_install
    zsh_backup
    link_install
    kube_addons_install
    ;;
#suse) echo "Installing in $OSID" # untested
#    zypper install zsh autojump curl git wget kubectl
#    ;;
cbld) echo "Installing in $OSID, posibly azure."
    zsh_install
    zsh_backup
    link_install_cbld
    kube_addons_install
;;
*) echo "Unsupported OS: $OSID"
exit 99
   ;;
esac

exit 0