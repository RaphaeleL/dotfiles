colorscheme pablo

imap kj <Esc>

" no wrap 
set nowrap

" Moving Down with Line Break 
nnoremap j gj 

" Moving Up with Line Break 
nnoremap k gk

" Moving to the Top of the File
nnoremap 4 gg

" Moving to the End of the File
nnoremap 3 G

" Moving to the End of the Line
nnoremap 2 g$

" Moving to the Beginngin of the Line
nnoremap 1 g0

" Delete a word
nnoremap o dw

" Delete to the end of line
nnoremap ü D

" deactive line numbers 
set nonumber

" auto write files when changing when multiple files open 
set autowrite 

" turn col and row pos in bottom right
set ruler

" show command and insert mode 
set showmode 

" replace tabs with spaces auto.
"set expandtab

" risky but cleaner 
set noswapfile
set nowritebackup
set nobackup 

set icon

" highlight search hits
set hlsearch
set incsearch
set linebreak

" wrap around when searching 
set wrapscan

" stop complaints about switching buffer with changes
set hidden

" command history
set history=100

" faster scrolling
set ttyfast

" better contrast
set background=dark

" better command line completion 
set wildmenu

" disable search highlighting with <C-L> when refreshing screen
nnoremap ff :nohl<CR><C-L> 
set omnifunc=syntaxcomplete#Complete

" functions keys
map <F1> :set number!<CR> :set number!<CR>
map <F4> :set list!<CR>

" my old stuff
syntax on
set backspace=indent,eol,start
set shiftwidth=2
set autoindent 
set smartindent
set softtabstop=2
set expandtab

set mouse=a

