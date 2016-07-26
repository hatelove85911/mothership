#! /bin/bash
echo "*******************************************************************"
echo "mothership: who am i?"
echo "*******************************************************************"
whoami

proxy_server=proxy.tyo.sap.corp
proxy_addr=http://proxy.tyo.sap.corp:8080
#######################################################################
# set proxy
#######################################################################
ping -c 1 "$proxy_server" > /dev/null 2>&1
corporate=$?
if [ "$corporate" -eq 0 ]; then
	echo "*******************************************************************"
	echo "mothership: behind corporate proxy, setting proxy for apt-get and http_proxy, https_proxy environment variabls"
	echo "*******************************************************************"

	sudo touch /etc/apt/apt.conf.d/80proxy
	echo Acquire::http::proxy "\"$proxy_addr\";" | sudo tee /etc/apt/apt.conf.d/80proxy
	echo Acquire::https::proxy "\"$proxy_addr\";" | sudo tee -a /etc/apt/apt.conf.d/80proxy

	export http_proxy=$proxy_addr
	export https_proxy=$proxy_addr
else
	echo "*******************************************************************"
	echo "mothership: NO corporate proxy, deleting proxy for apt-get and http_proxy, https_proxy environment variabls"
	echo "*******************************************************************"
	sudo rm /etc/apt/apt.conf.d/80proxy

	unset http_proxy
	unset https_proxy	
fi

echo "*******************************************************************"
echo "mothership: adding ppa"
echo "*******************************************************************"
sudo -E add-apt-repository ppa:nginx/stable
sudo -E add-apt-repository ppa:git-core/ppa
#tmux ppa
sudo -E add-apt-repository ppa:pi-rho/dev
#neovim
sudo -E add-apt-repository ppa:neovim-ppa/unstable
#fasd
sudo -E add-apt-repository ppa:aacebedo/fasd
sudo apt-get update -y

echo "*******************************************************************"
echo "mothership: starting install apt packages "
echo "*******************************************************************"
sudo apt-get install --reinstall ca-certificates
sudo apt-get install -y software-properties-common
sudo apt-get install -y build-essential

sudo apt-get install -y zsh
sudo apt-get install -y git
sudo apt-get install -y tmux
sudo apt-get install -y nginx
sudo apt-get install -y mongodb
sudo apt-get install -y ruby
sudo apt-get install -y cmake

# python
sudo apt-get install -y python
sudo apt-get install -y python-pip
sudo apt-get install -y python-dev

sudo apt-get install -y python3
sudo apt-get install -y python3-pip
sudo apt-get install -y python3-dev

sudo apt-get install -y neovim

sudo apt-get install -y fasd
sudo apt-get install -y unison
sudo apt-get install -y tree
sudo apt-get install -y watch
sudo apt-get install -y httpie
sudo apt-get install -y silversearcher-ag
sudo apt-get install -y libxml2-utils
sudo apt-get install -y xclip
sudo apt-get install -y corkscrew

echo "*******************************************************************"
echo "mothership: install nvm"
echo "*******************************************************************"
git clone https://github.com/creationix/nvm.git ~/.nvm && cd ~/.nvm && git checkout `git describe --abbrev=0 --tags`
source ~/.nvm/nvm.sh

echo "*******************************************************************"
echo "mothership: install node 5.0"
echo "*******************************************************************"

nvm install node
nvm use node

#######################################################################
# npm & git set proxy
#######################################################################


if [ "$corporate" -eq 0 ]; then
	echo "*******************************************************************"
	echo "mothership: behind corporate proxy, setting git & npm proxy"
	echo "*******************************************************************"

	npm config set proxy $proxy_addr
	npm config set https-proxy $proxy_addr
	git config --global http.proxy $proxy_addr
	git config --global https.proxy $proxy_addr
else
	echo "*******************************************************************"
	echo "mothership: NO corporate proxy, deleting git & npm proxy"
	echo "*******************************************************************"
	npm config delete http-proxy
	npm config delete https-proxy
	git config --global --unset http.proxy
	git config --global --unset https.proxy
fi

echo "*******************************************************************"
echo "mothership: installing npm packages"
echo "*******************************************************************"

npm install -g eslint  # pluggable linting utility for javascript and jsx
npm install -g standard  # javascript standard code checker
# npm install -g node-inspector
# npm install -g devtool # the best debugger on node
# npm install -g iron-node # node debugger
npm install -g jsonlint # eslint json checker
npm install -g yeoman-doctor
npm install -g yo
npm install -g instant-markdown-d # preview markdown in vim server
npm install -g hexo # nodejs blogging generator
npm install -g grunt-cli


echo "*******************************************************************"
echo "mothership: installing python packages"
echo "*******************************************************************"
sudo -E pip install neovim
sudo -E pip install cheat

echo "*******************************************************************"
echo "mothership: install oh-my-zsh"
echo "*******************************************************************"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/antigen.git ~/.zsh-antigen

sudo chsh -s /usr/bin/zsh vagrant

echo "*******************************************************************"
echo "mothership: install vim-plug and plugs"
echo "*******************************************************************"

mkdir -p ${XDG_CONFIG_HOME:=$HOME/.config}
curl -fLo $XDG_CONFIG_HOME/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
sudo ln -sf ~/Dropbox/mymeta/home/init.vim $XDG_CONFIG_HOME/nvim/init.vim

echo | echo | nvim -c PlugInstall -c qall


# echo "*******************************************************************"
# echo "mothership: install vundle and plugins"
# echo "*******************************************************************"
# git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

# sudo ln -sf ~/Dropbox/mymeta/home/.vimrc ~/.vimrc

# echo | echo | vim -c PluginInstall -c qall

# # make vimproc.vim plugin
# cd ~/.vim/bundle/vimproc.vim
#

# # cmake youcompleteme
# cd ~/.vim/bundle/YouCompleteMe
# ./install.py --tern-completer

# # install tern for vim
# cd ~/.vim/bundle/tern_for_vim
# npm install

echo "*******************************************************************"
echo "mothership: install tpm(tmux plugin manager) and tmux plugins"
echo "*******************************************************************"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
sudo ln -sf ~/Dropbox/mymeta/home/.tmux.conf ~/.tmux.conf
bash ~/.tmux/plugins/tpm/bin/install_plugins

echo "*******************************************************************"
echo "mothership: symlinks"
echo "*******************************************************************"
sudo ln -sf /usr/bin/nodejs /usr/bin/node
sudo ln -sf ~/Dropbox/mymeta/home/.gitconfig ~/.gitconfig
sudo ln -sf ~/Dropbox/mymeta/home/.zshenv ~/.zshenv
sudo ln -sf ~/Dropbox/mymeta/home/.zshrc ~/.zshrc
sudo ln -sf ~/Dropbox/mymeta/home/bin ~/bin
sudo ln -sf ~/Dropbox/mymeta/home/.cheat ~/.cheat
sudo ln -sf ~/Dropbox/mymeta/home/Ultisnips ~/$XDG_CONFIG_HOME/nvim/UltiSnips
