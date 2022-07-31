#!/bin/bash

setup_git() {
  # Git Configuration
  print_colored "# Congigure Git.." info

  # echo "Enter the Global Username for Git:";
  # read GITUSER;
  GIT_USER=$(gum input --placeholder "Enter the Global Username:")
  GIT_EMAIL=$(gum input --placeholder "Enter the Global Email:")

  git config --global user.name "${GIT_USER}"
  git config --global user.email "${GIT_EMAIL}"

  print_colored 'Git has been configured!' success
  git config --list
}

add_ppa_repos() {
  print_colored "# Add PPA repository..." "info"
  repo_path="$@"
  for ppa in "${ppa_repos[@]}"; do
    add-apt-repository -y "$ppa"
  done
}

install_gum() {
  pkg_name="gum"

  if installed $pkg_name; then
    print_colored "$pkg_name - Already installed" "warning"
  else
    echo 'deb [trusted=yes] https://repo.charm.sh/apt/ /' | tee /etc/apt/sources.list.d/charm.list
    apt update && apt install $pkg_name
  fi
}

require_root() {
  if [[ $(id -u) -ne 0 ]]; then
    echo "Ubuntu bootstrapper, APT-GETs all the things -- run as root..."
    exit 1
  fi
}

update_system() {
  # Update system repos
  print_colored "# Update and upgrade system..." "info"
  gum spin --title "Updating system..." -- apt update -y
  echo "- System updated"
  gum spin --title "Upgrading system..." -- apt upgrade -y
  gum spin --title "Upgrading dist system..." -- apt dist-upgrade -y
  echo "- System upgraded"
}

clean_system() {
  print_colored "# Clean system..." "info"
  apt -yqq autoremove
  apt -yqq clean
  apt -yqq autoclean
}

installed() {
  return $(dpkg-query -W -f '${Status}\n' "${1}" 2>&1 | awk '/ok installed/{print 0;exit}{print 1}')
}

install_missing_pkgs() {
  pkgs=("$@")
  missing_pkgs=""

  for pkg in "${pkgs[@]}"; do
    if ! $(installed "$pkg"); then
      missing_pkgs+="$pkg "
    fi
  done

  if [ ! -z "$missing_pkgs" ]; then
    echo "Install missing pkgs: $missing_pkgs" | xargs
    apt install -y "$missing_pkgs"
  fi
}

print_colored() {
  COLOR_PREFIX="\033[0;"
  RED="31m"
  GREEN="32m"
  ORANGE="33m"
  BLUE="34m"
  PURPLE="35m"
  CYAN="36m"
  GREY="37m"
  DARK_GREY="90m"
  LIGHT_RED="91m"
  LIGHT_GREEN="92m"
  YELLOW="93m"
  LIGHT_BLUE="94m"
  LIGHT_PURPLE="95m"
  TURQUOISE="96m"
  WHITE="97m"
  NO_COLOR="\033[0m"

  if [ "$2" == "red" ]; then
    COLOR="${COLOR_PREFIX}${RED}"
  elif [ "$2" == "green" ]; then
    COLOR="${COLOR_PREFIX}${GREEN}"
  elif [ "$2" == "orange" ]; then
    COLOR="${COLOR_PREFIX}${ORANGE}"
  elif [ "$2" == "blue" ]; then
    COLOR="${COLOR_PREFIX}${BLUE}"
  elif [ "$2" == "purple" ]; then
    COLOR="${COLOR_PREFIX}${PURPLE}"
  elif [ "$2" == "cyan" ]; then
    COLOR="${COLOR_PREFIX}${CYAN}"
  elif [ "$2" == "grey" ]; then
    COLOR="${COLOR_PREFIX}${GREY}"
  elif [ "$2" == "dark_grey" ]; then
    COLOR="${COLOR_PREFIX}${DARK_GREY}"
  elif [ "$2" == "light_red" ]; then
    COLOR="${COLOR_PREFIX}${LIGHT_RED}"
  elif [ "$2" == "light_green" ]; then
    COLOR="${COLOR_PREFIX}${LIGHT_GREEN}"
  elif [ "$2" == "yellow" ]; then
    COLOR="${COLOR_PREFIX}${YELLOW}"
  elif [ "$2" == "light_blue" ]; then
    COLOR="${COLOR_PREFIX}${LIGHT_BLUE}"
  elif [ "$2" == "light_purple" ]; then
    COLOR="${COLOR_PREFIX}${LIGHT_PURPLE}"
  elif [ "$2" == "turquoise" ]; then
    COLOR="${COLOR_PREFIX}${TURQUOISE}"
  elif [ "$2" == "white" ]; then
    COLOR="${COLOR_PREFIX}${WHITE}"
  elif [ "$2" == "error" ]; then
    COLOR="${COLOR_PREFIX}${RED}"
  elif [ "$2" == "warning" ]; then
    COLOR="${COLOR_PREFIX}${ORANGE}"
  elif [ "$2" == "info" ]; then
    COLOR="${COLOR_PREFIX}${CYAN}"
  elif [ "$2" == "success" ]; then
    COLOR="${COLOR_PREFIX}${GREEN}"
  elif [ "$2" == "debug" ]; then
    COLOR="${COLOR_PREFIX}${GREY}"
  else
    COLOR="${NO_COLOR}"
  fi

  printf "${COLOR}%b${NO_COLOR}\n" "$1"
}
