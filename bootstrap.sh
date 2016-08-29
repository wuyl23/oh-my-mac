#!/bin/bash

# initialize
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
ZSH=~/.oh-my-zsh
CHECK_FISH_INSTALLED=$(grep /fish$ /etc/shells | wc -l)
FISHERMAN=~/.config/fish/functions/fisher.fish

# Git
echo -n "Please input your git username: "
read username
echo -n "Please input your git email: "
read email

git config --global user.name "${username}"
git config --global user.email ${email}
git config --global push.default simple

# Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew tap caskroom/cask
brew tap homebrew/services
brew cask install iterm2
brew cask install launchrocket

# Oh My Zsh
if [ ! -d $ZSH ]; then
  git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh.git $ZSH
  cp $ZSH/templates/zshrc.zsh-template ~/.zshrc
fi

# fish shell
if [ ! $CHECK_FISH_INSTALLED -ge 1 ]; then
  brew install fish
  echo "/usr/local/bin/fish" | sudo tee -a /etc/shells
fi

# fisherman
if [ ! -f $FISHERMAN ]; then
  curl -Lo $FISHERMAN  --create-dirs git.io/fisher
fi

# profile
echo "# Homebrew Bottles" | tee -a ~/.config/fish/config.fish ~/.zshrc ~/.bashrc
echo "set -gx HOMEBREW_BOTTLE_DOMAIN $HOMEBREW_BOTTLE_DOMAIN" | tee -a ~/.config/fish/config.fish
echo "export HOMEBREW_BOTTLE_DOMAIN=\"$HOMEBREW_BOTTLE_DOMAIN\"" |  tee -a ~/.zshrc ~/.bashrc


# https://segmentfault.com/a/1190000004413842
cat >> ~/.bash_profile << EOF
if [ -f ~/.bashrc ]; then
   source ~/.bashrc
fi
EOF