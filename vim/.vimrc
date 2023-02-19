"--------Instalador de plugins----------
call plug#begin('~/.vim/plugged')
 Plug 'johngrib/vim-game-snake'
" Plug 'vim-scripts/AutoComplPop'
 Plug 'morhetz/gruvbox'
 Plug 'vim-airline/vim-airline'
 Plug 'scrooloose/syntastic'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'junegunn/vim-easy-align'
 Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
 Plug 'sheerun/vim-polyglot'
 Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
 Plug 'junegunn/fzf.vim'
 Plug 'vim-scripts/loremipsum'

call plug#end()

"------------Tema do vim------------
colorscheme gruvbox
set background=dark

"--------Cores de sintaxe--------
syntax enable
set t_Co=256
let g:airline_powerline_fonts = 1

"----------Syntastic --------------
let g:syntastic_check_on_open       = 0
let g:syntastic_check_on_wq         = 0
let g:syntastic_enable_perl_checker = 1
let g:syntastic_perl_checkers       = ['perl','podchecker']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"--------YAML Recursos----------
set paste
set cursorcolumn

"--------Numero de linhas----------
set number
set relativenumber

"----------Menu suspenso----------
set wildmenu

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

"--------71 colunas----------
highlight ColorColumn ctermbg=gray
"call matchadd('ColorColumn', '\%81v',100)

"-------Auto Complete--------
set complete+=kspell,w,b,u,i,t
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
nnoremap <tab> .

"--------Autoclose ----------------
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O

nnoremap"-----Add ControlD Nerdtree-----
nmap <silent> <C-D> :NERDTreeToggle<CR>
"nnoremap <ESC> :set hlsearch!<CR>

"--------Add ; com space no fim arquivo----
let mapleader="\<space>"
nnoremap <leader>; A;<esc>

"-----Add ControlP para files-----
nnoremap <c-f> :Files<cr>

"CUrsor type"
highlight Cursor guifg=white guibg=black
highlight iCursor guifg=white guibg=magenta
set guicursor=n-v-c:block-Cursor
set guicursor+=i:ver100-iCursor
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkwait10

if &term =~ "xterm\\|rxvt"
  " use an orange cursor in insert mode
  let &t_SI = "\<Esc>]12;red\x7"
  " use a red cursor otherwise
  let &t_EI = "\<Esc>]12;white\x7"
  silent !echo -ne "\033]12;white\007"
  " reset cursor when vim exits
  autocmd VimLeave * silent !echo -ne "\033]112\007"
  " use \003]12;gray\007 for gnome-terminal and rxvt up to version 9.21
endif
