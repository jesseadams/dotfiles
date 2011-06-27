#!/bin/bash
function abs_usage(){
    echo "snag [--search|--install|--aur] package"
    return 1
}

function abs_search() {
  find /var/abs/ -name "*$1*"
}

function abs_install() {
  if [ ! -d /var/abs/$1 ]; then
    echo "Package does not exist!"
    return 1
  fi

  package=`echo $1 | awk -F / '{ print $2 }'`

  cp -r /var/abs/$1 ~/.abs/
  original_dir=`pwd`
  cd ~/.abs/$package
  
  echo "Would you like to edit the PKGBUILD? [N/y]"
  read answer

  if [ ! -z $answer ]; then
    if [ "$answer" == "y" ] || [ "$answer" == "Y" ]; then
      vim PKGBUILD
    fi
  fi

  makepkg -s
  sudo pacman -U *.pkg.tar.xz
  cd $original_dir
}

function aur_install() {
  original_dir=`pwd`
  cd ~/.aur
  wget http://aur.archlinux.org/packages/$1/$1.tar.gz

  if [ ! -f "$1.tar.gz" ]; then
    echo "Package does not exist!"
    return 1
  fi

  tar xvzf $1.tar.gz
  cd $1
  makepkg -s
  sudo pacman -U *.pkg.tar.xz
  cd $original_dir
}

function snag() {
  command=$1
  package=$2

  if [ -z $command ] || [ -z $package ]; then
    abs_usage
  fi

  if [ "$command" == "--search" ];  then
    abs_search $package
    return
  fi

  if [ "$command" == "--install" ]; then
    abs_install $package
    return
  fi
  
  if [ "$command" == "--aur" ]; then
    aur_install $package
    return
  fi

  abs_usage
}
