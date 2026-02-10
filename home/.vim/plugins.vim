filetype off                  " required

" set the runtime path to include Vundle and initialize
let s:script_dir = expand('<sfile>:p:h')
execute 'set rtp+=' . s:script_dir . '/bundle/Vundle.vim'
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-vinegar'
Plugin 'scrooloose/nerdtree'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required