set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'

Plugin 'morhetz/gruvbox'
Plugin 'hzchirs/vim-material'
Plugin 'ayu-theme/ayu-vim'
Plugin 'reedes/vim-colors-pencil'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'scrooloose/nerdtree'
""Plugin 'vim-airline/vim-airline'
""Plugin 'vim-airline/vim-airline-themes'
 Plugin 'itchyny/lightline.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'ryanoasis/vim-devicons'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'Yggdroot/indentLine'

call vundle#end()
filetype plugin indent on
set expandtab
set shiftwidth=2
set softtabstop=2
set number
set cursorline
set clipboard=unnamed
syntax enable
if (has("termguicolors"))
    set termguicolors
endif
let &t_8f = "\e[38;2;%lu;%lu;%lum"
let &t_8b = "\e[48;2;%lu;%lu;%lum"
set background=light
colorscheme vim-material
"hi Normal guibg=#FAFAFA " Override background color
hi CursorLine term=bold cterm=bold 
set laststatus=2
set noshowmode

let g:lightline = { 
  \ 'colorscheme': 'ayu_light',
  \ 'active': {
  \   'right': [ [ 'lineinfo' ],
  \              [ 'percent' ],
  \              [ 'filetype' ], ]
  \ },
  \ }

"let g:airline_powerline_fonts = 1
"let g:airline_theme='material'

map <C-n> :NERDTreeToggle<CR>

set encoding=UTF-8
