#!/bin/bash

# adapted form https://github.com/startup-class/setup

# Install nvm: node-version manager
# https://github.com/creationix/nvm
sudo apt-get install -y git
sudo apt-get install -y curl
curl https://raw.githubusercontent.com/creationix/nvm/v0.22.1/install.sh | bash

# Load nvm and install latest production node
source $HOME/.nvm/nvm.sh
nvm install v0.10.33
nvm use v0.10.33

# install npm: node-package-manager
sudo apt-get install -y npm

# npm no sudo (https://github.com/sindresorhus/guides/blob/master/npm-global-without-sudo.md)
curl https://raw.githubusercontent.com/glenpike/npm-g_nosudo/master/npm-g-no-sudo.sh | bash


# Install jshint to allow checking of JS code within emacs
# http://jshint.com/
npm install -g jshint
# Install rlwrap to provide libreadline features with node
# See: http://nodejs.org/api/repl.html#repl_repl
sudo apt-get install -y rlwrap
# Install emacs24
# https://launchpad.net/~cassou/+archive/emacs
sudo add-apt-repository -y ppa:cassou/emacs
sudo apt-get -qq update
sudo apt-get install -y emacs24-nox emacs24-el emacs24-common-non-dfsg

# Install Heroku toolbelt
# https://toolbelt.heroku.com/debian
wget -qO- https://toolbelt.heroku.com/install-ubuntu.sh | sh

# git pull and install dotfiles as well
cd $HOME
if [ -d ./dotfiles/ ]; then
mv dotfiles dotfiles.old
fi
if [ -d .emacs.d/ ]; then
mv .emacs.d .emacs.d~
fi
git clone https://github.com/startup-class/dotfiles.git
ln -sb dotfiles/.screenrc .
ln -sb dotfiles/.bash_profile .
ln -sb dotfiles/.bashrc .
ln -sb dotfiles/.bashrc_custom .
ln -sf dotfiles/.emacs.d .

# make sure npm variables are in .bashrc
echo NPM_PACKAGES="${HOME}/.npm-packages" >> $HOME/.bashrc
echo NODE_PATH="$NPM_PACKAGES/lib/node_modules:$NODE_PATH" >> $HOME/.bashrc
echo 'PATH="$NPM_PACKAGES/bin:$PATH"
# Unset manpath so we can inherit from /etc/manpath via the `manpath`
# command
unset MANPATH # delete if you already modified MANPATH elsewhere in your config
MANPATH="$NPM_PACKAGES/share/man:$(manpath)"' >> $HOME/.bashrc
echo prefix=${HOME}/.npm-packages >> $HOME/.npmrc

source $HOME/.npmrc
source $HOME/.bashrc
