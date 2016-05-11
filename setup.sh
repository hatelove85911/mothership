#! /bin/bash
echo "*******************************************************************"
echo "mothership: who am i?"
echo "*******************************************************************"
whoami

proxy_server=proxy.sin.sap.corp
proxy_addr=http://proxy.sin.sap.corp:8080
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
	sudo touch /etc/apt/apt.conf.d/80proxy
	echo "" | sudo tee /etc/apt/apt.conf.d/80proxy
fi

echo "*******************************************************************"
echo "mothership: adding ppa"
echo "*******************************************************************"

sudo apt-get update -y
sudo apt-get install --reinstall ca-certificates

sudo -E add-apt-repository ppa:nginx/stable
sudo -E add-apt-repository ppa:git-core/ppa
#tmux ppa
sudo -E add-apt-repository ppa:pi-rho/dev

echo "*******************************************************************"
echo "mothership: starting install apt packages "
echo "*******************************************************************"


sudo apt-get install -y zsh
sudo apt-get install -y git
sudo apt-get install -y tmux
sudo apt-get install -y nginx
sudo apt-get install -y mongodb
sudo apt-get install -y ruby
sudo apt-get install -y python3
sudo apt-get install -y unison
sudo apt-get install -y tree
sudo apt-get install -y watch
sudo apt-get install -y cmake
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
npm install -g node-inspector
# npm install -g devtool # the best debugger on node
# npm install -g iron-node # node debugger
npm install -g jsonlint # eslint json checker
npm install -g yeoman-doctor
npm install -g yo
npm install -g instant-markdown-d # preview markdown in vim server
npm install -g hexo # nodejs blogging generator
npm install -g grunt-cli


echo "*******************************************************************"
echo "mothership: symlinks"
echo "*******************************************************************"
sudo ln -sf /usr/bin/nodejs /usr/bin/node
sudo ln -sf ~/Dropbox/mymeta/home/.gitconfig ~/.gitconfig
sudo ln -sf ~/Dropbox/mymeta/home/.zshenv ~/.zshenv
sudo ln -sf ~/Dropbox/mymeta/home/.zshrc ~/.zshrc
sudo ln -sf ~/Dropbox/mymeta/home/bin ~/bin
sudo ln -sf ~/Dropbox/mymeta/home/.cheat ~/.cheat
sudo ln -sf ~/Dropbox/mymeta/home/.vimrc ~/.vimrc
sudo ln -sf ~/Dropbox/mymeta/home/Ultisnips ~/.vim/UltiSnips
sudo ln -sf ~/Dropbox/mymeta/home/.tmux.conf ~/.tmux.conf

echo "*******************************************************************"
echo "mothership: install oh-my-zsh"
echo "*******************************************************************"
bash -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/antigen.git ~/.zsh-antigen

sudo chsh -s /usr/bin/zsh vagrant

echo "*******************************************************************"
echo "mothership: install vundle and plugins"
echo "*******************************************************************"
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
echo | echo | vim -c PluginInstall -c qall

# make vimproc.vim plugin
cd ~/.vim/bundle/vimproc.vim
make

# cmake youcompleteme
cd ~/.vim/bundle/YouCompleteMe
bash ./install.sh

# install tern for vim
cd ~/.vim/bundle/tern_for_vim
npm install

echo "*******************************************************************"
echo "mothership: install tpm(tmux plugin manager) and tmux plugins"
echo "*******************************************************************"

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
bash ~/.tmux/plugins/tpm/bin/install_plugins
