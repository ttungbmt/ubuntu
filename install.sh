#!/bin/bash
sudo -v

source ./utils.sh

# echo "------------------------------"
# echo "Initializing Development Workspace [×]"

require_root
#update_system

#install_gum

#pkgs=(sudo ca-certificates software-properties-common)
#install_missing_pkgs "${pkgs[@]}"


#ppa_repos=("ppa:ondrej/php" "ppa:ondrej/php")
#add_ppa_repos "${pkgs[@]}"

#git_setup

#print_colored "# Install appications..." "info"
##cat ./pkgs.txt | gum choose --no-limit
#cat ./pkgs.txt | gum filter

# Finishing Up
clean_system

print_colored "# DONE! All required software are installed" success
