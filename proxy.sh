#! /bin/bash
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