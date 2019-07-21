" source all the component vimrcs

" Basic configs
source $VIM_PREFIX/basic.vim

" Plugin List
source $VIM_PREFIX/plugins.vim

" Plugin configs
source $VIM_PREFIX/plugin_configs.vim

" Mappings
source $VIM_PREFIX/mappings.vim

" Main configs
try
	source $VIM_PREFIX/configs.vim
catch
endtry

" platform dependent configs
try
	source $VIM_PREFIX/platform.vim
catch
endtry
