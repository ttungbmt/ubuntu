#/bin/bash

apt_soft=$1

dpkg -s $apt_soft &> /dev/null  

if [ $? -ne 0 ]
    then
        gum spin --title "$apt_soft - Not installed, installing it" -- apt-get install $apt_soft
        echo "$apt_soft - Installed successfully"
    else
        echo "$apt_soft - Already installed"
fi