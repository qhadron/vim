#!/bin/bash

LOCATION="$(realpath $(dirname "$BASH_SOURCE"))"

function check_exists() {
	if [[ -e $1 ]]; then
		echo "$1" already exists. Exiting...
		exit 1
	fi
}

check_exists "$HOME/.vimrc"

if [[ ! "$(which git)" ]]; then
	echo "git executable not found on \$PATH, exiting..."
fi

mkdir -p "$LOCATION/temp_dirs/undodir"

> ~/.vimrc cat <<VIM_HEREDOC
set runtimepath+=$LOCATION

let \$VIM_PREFIX = '$LOCATION'
source \$VIM_PREFIX/main.vim
VIM_HEREDOC

# install vim-plug
curl -fLo "$LOCATION/autoload/plug.vim" --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# install plugins
vim +PlugInstall +qall

# install dependencies
if [[ ! "$(which ag)" ]]; then
	read -p "Installing silver searcher automatically? [y]/n"
	if [[ "$REPLY" =~ y ]]; then
		( set -x; sudo apt-get -y install silversearcher-ag) && installed_ag=true
	fi
	if [[ ! "$installed_ag" ]]; then
		echo "Please install silver searcher with the following:"
	fi
fi
