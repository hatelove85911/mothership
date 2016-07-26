FROM ubuntu
MAINTAINER Jun Shen <redwolf85911@gmail.com>

############################################################
# install software-properties-common to have add-apt-repository command available
############################################################
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common

############################################################
# add ppa
############################################################
RUN add-apt-repository -y ppa:git-core/ppa &&\
# tmux ppa
    add-apt-repository -y ppa:pi-rho/dev &&\
# add node 5.x apt repository
    curl -sL https://deb.nodesource.com/setup_5.x | bash -

############################################################
# install apt packages
############################################################
RUN apt-get update &&\
    apt-get install -y \
      zsh \
      git \
      tmux \
      curl \
      httpie \
      silversearcher-ag \
      libxml2-utils \
      xclip \
      corkscrew \
      unison \
      tree \
      watch \
      cmake \
      ruby \
      python3 \
      nodejs \
      openssh-server &&\
############################################################
# install npm global modules
############################################################
RUN npm install -g \
      eslint \
      standard \
      node-inspector \
      devtool \
      jsonlint \
      yeoman-doctor \
      yo \
      instant-markdown-d \
      hexo \
      grunt-cli \
############################################################
# add junshen sudo user
############################################################
RUN adduser junshen --ingroup sudo
