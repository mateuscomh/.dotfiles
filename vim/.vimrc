"--------Instalador de plugins----------
call plug#begin('~/.vim/plugged')


 Plug 'vim-scripts/loremipsum'
 Plug 'vim-scripts/AutoComplPop'
 Plug 'morhetz/gruvbox'
 Plug 'vim-airline/vim-airline'
 Plug 'scrooloose/syntastic'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'junegunn/vim-easy-align'
 Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
 Plug 'sheerun/vim-polyglot'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'

call plug#end()

"------------Tema do vim------------
colorscheme gruvbox
set background=dark

"--------Cores de sintaxe--------
syntax on
filetype plugin indent on
set t_Co=256
let g:airline_powerline_fonts = 1

"----------Syntastic --------------
let g:syntastic_check_on_open       = 1
let g:syntastic_check_on_wq         = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers       = ['perl','podchecker']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"--------Numero de linhas----------
set number
set relativenumber

"----------Scroll forward----------
set scrolloff=1

"----------Cache arquivos----------
set hidden

"--------Pesquisa recursiva--------
set path+=**

"--------Adicionar interacao mouse--------
set mouse=a

"--------Definir titulo editor--------
set title

"--------Highlight em pesquisas--------
set hlsearch
set ignorecase

"--------Codificação--------
set encoding=utf-8
set nocompatible
set title
set cursorline
set ruler

"--------90 colunas----------
highlight ColorColumn ctermbg=gray
call matchadd('ColorColumn', '\%90v',100)

"-------Auto Complete--------
set complete+=kspell
set shortmess+=c
set completeopt=menuone,longest

"--------Caracteres Ocultos----------
set listchars=tab:>˜,nbsp:_,trail:.
set list

"--------Tabulacao----------
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2 expandtab
set autoindent
set smartindent

"--------Compatibilidade.py-----
set nocompatible

au BufNewFile,BufRead *.py
        \ set tabstop=4     |
        \ set softtabstop=4 |
        \ set shiftwidth=4  |
        \ set textwidth=89  |
        \ set expandtab     |
        \ set autoindent    |
        \ set foldmethod=syntax
au BufNewFile *.py set fileformat=unix

"--------Remapear teclas----------
"nnoremap ; :
"nnoremap : ;

"-----Add ControlD Nerdtree-----
nmap <silent> <C-D> :NERDTreeToggle<CR>
"nnoremap <ESC> :set hlsearch!<CR>

"--------Add ; com space no fim arquivo----
let mapleader="\<space>"
nnoremap <leader>; A;<esc>

"-----Add ControlP para files-----
nnoremap <c-f> :Files<cr>

"-----Esc whith s-tab------------
inoremap <S-Tab> <Esc>
onoremap <S-Tab> <Esc>

"-----Modes on Iterm2------------
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

"-----Keybind selection copy-----
"noremap <Leader>y "*y
"noremap <Leader>p "*p
"noremap <Leader>Y "+y
"noremap <Leader>P "+p
set clipboard=unnamed
