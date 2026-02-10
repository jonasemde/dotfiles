set nocompatible                            "We want the latest Vim settings/options."
so ~/.vim/plugins.vim


"-------------Visuals--------------"
syntax enable
colorscheme atom-dark

set t_CO=256                                "Use 256 colors.This is useful for Terminal Vim.
set guifont=Fira_Code:h15                       "Set the default font family and size.
set linespace=15                                "Macvim-specific line-height.
set colorcolumn=100

set guioptions-=l                                                       "Disable Gui scrollbars.
set guioptions-=L
set guioptions-=r
set guioptions-=R




"-------------General Settings--------------"
set shell=/bin/zsh
set backspace=indent,eol,start                                          "Make backspace behave like every other editor.
let mapleader = ','                                 "The default leader is \, but a comma is much better.
set number                              "Let's activate line numbers.




"-------------Search--------------"
set hlsearch
set incsearch




"-------------Split Management--------------"
set splitbelow                              "Make splits default to below...
set splitright                              "And to the right. This feels more natural.

"We'll set simpler mappings to switch between splits.
nmap <C-J> <C-W><C-J>
nmap <C-K> <C-W><C-K>
nmap <C-H> <C-W><C-H>
nmap <C-L> <C-W><C-L>




"-------------Mappings--------------"

"Make it easy to edit the Vimrc file.
nmap <Leader>ev :tabedit $MYVIMRC<cr>

"Add simple highlight removal.
nmap <Leader><space> :nohlsearch<cr>

"Make NERDTree easier to toggle mith CMD+1 like in PHPStorm."
nmap <D-1> :NERDTreeToggle<CR>


"-------------Plugins--------------"
"/
"/ CtrlP
"/
let g:ctrlp_custom_ignore = 'node_modules\DS_Store\|git'
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:30,results:30'
nmap <c-R> :CtrlPBufTag<cr>
nmap <D-e> :CtrlPMRUFiles<cr>

"/
"/ NERDTree change default arrows
"/
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'


"-------------Auto-Commands--------------"

"Automatically source the Vimrc file on save.
augroup autosourcing
    autocmd!
    autocmd BufWritePost .vimrc source %
augroup END 
