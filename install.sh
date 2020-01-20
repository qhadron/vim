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
	echo "git executable not found in \$PATH, exiting..."
fi

# create vimrc
> ~/.vimrc cat <<VIM_HEREDOC
set runtimepath+=$LOCATION

let \$VIM_PREFIX = '$LOCATION'
source \$VIM_PREFIX/main.vim
VIM_HEREDOC

# directory for undo files
mkdir -p "$LOCATION/temp_dirs/undodir"

# platform specific config file
touch "$LOCATION/platform.vim"

# install vim-plug
curl -fLo "$LOCATION/autoload/plug.vim" --create-dirs "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
# install plugins
vim +PlugInstall +qall

# install dependencies
#   silver searcher
if [[ ! "$(which ag)" ]]; then
	read -p "Installing silver searcher automatically? y/[n]"
	if [[ "$REPLY" =~ y ]]; then
		( set -x; sudo apt-get -y install silversearcher-ag) && installed_ag=true
	fi
	if [[ ! "$installed_ag" ]]; then
		echo "Please install silver searcher package. On Ubuntu it's:"
		echo "silversearcher-ag"
	fi
fi
#  latex
if [[ ! "$(which latexmk)" ]]; then
	pkgs="latexmk texlive texlive-recommend texlive-latex-extra texlive-xetex"
	read -p "Installing latex tools automatically? y/[n]"
	if [[ "$REPLY" =~ y ]]; then
		( set -x; sudo apt-get -y install $pkgs) && installed_tex=true
	fi
	if [[ ! "$installed_tex" ]]; then
		echo "Please install the latex tools. On Ubuntu it's:"
		echo "$pkgs"
	fi
fi
