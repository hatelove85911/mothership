function run() {
    # Ask for the administrator password upfront
    sudo -v

    # Keep-alive: update existing `sudo` time stamp until the script has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    if [[ "$OSTYPE" == "linux-gnu" ]]; then
        echo "*******************************************************************"
        echo "Linux"
        echo "*******************************************************************"
        ./linux.sh
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        echo "*******************************************************************"
        echo "Mac OS"
        echo "*******************************************************************"
        ./macos.sh
    fi
}

run

