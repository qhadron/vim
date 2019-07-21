# Vim Configuration

This is my vim configuration.

Many configurations are from <https://github.com/amix/vimrc>.

## Installation

0. Backup existing `~/.vimrc` file if it already exists
```sh
mv ~/.vimrc ~/.vimrc.bak
```

1. Install required programs
```sh
sudo apt-get install -y curl git vim
# if YouCompleteMe is needed
sudo apt-get install -y build-essential cmake python3-dev
```

2. Download and install the configurations:
```sh
# $location is the directory to keep all the configuration files
git clone 'https://github.com/qhadron/vim/' "$location" && cd "$location"

# to install at ~/.vim
git clone 'https://github.com/qhadron/vim/' ~/.vim && cd ~/.vim
```

3. Run the install script to automatically create a `.vimrc` and install plugins.
```sh
bash ./install.sh
```

## Usage

The default leader key is `,`.

To see a list of mappings press `,fm` in vim's normal mode.

### Plugins

A list of plugins can be found at `$location/plugins.vim`

Plugin mappings and configurations are found at `$location/plugin_configs.vim`

### Mappings

A list of mappings (plugin-independent) can be found at `$location/mappings.vim`

### Customizations

In vim, press `,e` to change the default configuration file.
The file is automatically loaded after write, but you can also press `,R`(comma, shift + R) to reload the file.

### Machine dependent settings

Edit the file `$location/platform.vim` to add settings that are specific to that machine. Any changes are ignored by git.
