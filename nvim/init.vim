call plug#begin('~/.vim/plugged')
 Plug 'mboughaba/i3config.vim'
 Plug 'mg979/vim-visual-multi'
 Plug 'vim-airline/vim-airline'
 Plug 'scrooloose/Syntastic'
 Plug 'vim-airline/vim-airline-themes'
 Plug 'junegunn/vim-easy-align'
 Plug 'ekalinin/dockerfile.vim'
 Plug 'sainnhe/sonokai'
call plug#end()

"------------Tema do nvim------------
if exists('+termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

let g:sonokai_style = 'andromeda'
let g:sonokai_enable_italic = 1
let g:sonokai_disable_italic_comment = 0
let g:sonokai_diagnostic_line_highlight = 0
let g:sonokai_current_word = 'bold'
colorscheme sonokai

if (has("nvim")) "Transparent background. Only for nvim
    highlight Normal guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
endif

"--------Cores de sintaxe--------
syntax enable
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'sonokai'
let g:airline_powerline_fonts = 1

"----------Syntastic --------------
"let g:syntastic_check_on_open       = 0
"let g:syntastic_check_on_wq         = 0
"let g:syntastic_enable_perl_checker = 1
"let g:syntastic_perl_checkers       = ['perl','podchecker']
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"--------Numero de linhas----------
set number
set relativenumber
set scrolloff=8

" ------!Insert Mode Relative-------
autocmd InsertEnter * set norelativenumber

" ------Insert Mode Relative-------
autocmd InsertLeave * set relativenumber

"------Insert Mode Cursor--------
let &t_SI="\e[6 q"
let &t_EI="\e[2 q"

"----------Menu suspenso----------
set wildmenu
set wildmode=longest,full
set wildoptions=pum

"----------Cache arquivos----------
set hidden
set updatetime=100

"--------Pesquisa recursiva--------
set path+=**

"--------Adicionar interacao mouse--------
set mouse=a

"--------Definir titulo editor--------
set title

"--------Highlight em pesquisas--------
set hlsearch
set ignorecase
set smartcase
set incsearch
let @/ = ""
set inccommand=split

"--------Codificação--------
set encoding=utf-8
set nocompatible
set title
set cursorline
set ruler

"--------71 colunas----------
highlight ColorColumn ctermbg=gray
call matchadd('ColorColumn', '\%81v',100)

"-------Auto Complete--------
set complete+=kspell,w,b,u,i,t
set shortmess+=c
set completeopt=menuone,longest

"--------Caracteres Ocultos----------
set nolist
set listchars=tab:›-,space:·,trail:◀,eol:↲
set fillchars=vert:│,fold:-,eob:~


"--------Tabulacao----------
set tabstop=2
set shiftwidth=2
set expandtab
set softtabstop=2 
set autoindent
set smartindent

"--------Compatibilidade.py-----
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
nnoremap <tab> .
"nnoremap ; :
"vnoremap ; :
map j gj
map k gk
map <down> gj
map <up> gk
inoremap <down> <c-o>gj
inoremap <up> <c-o>gk
nnoremap <silent> [ :normal O<CR>
nnoremap <silent> ] :normal o<CR>

"--------Autoclose ----------------
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>

"-----Add ControlD Nerdtree-----
"nmap <silent> <C-D> :NERDTreeToggle<CR>

"--------Funcoes macro----
let mapleader="\<space>"
nnoremap <leader>; A;<esc>
vnoremap <leader>/ :norm i#<CR>
vnoremap <leader>? :norm ^x<CR>
nnoremap <leader>? :silent s/^#//<CR>
nnoremap <leader>/ :silent s/^/#/<CR>:nohlsearch<CR>

"-----Copiar area de transf-------
vmap <silent> <leader>yy "+y
vmap <silent> <leader>dd "+c

"-----Executar o terminal-----
map <f7> :term bash %<cr>

"-----Go to last position-----
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
endif

"-----Terminal abaixo-----
set splitbelow

"----Alternar numeros de linhas------
map <F2> :set number!<cr>

"----Alternar numeros relativos----
map <F3> :set relativenumber!<cr>

"----Alternar caracteres invisíveis----
map <f4> :set list!<cr>

"-----Corretor ortografico-------
map <f5> :set spell!<cr>

"-----Alternar quebra de linha------
map <f6> :set wrap!<cr>

"-----Indentar visual mode----
vmap < <gv
vmap > >gv

