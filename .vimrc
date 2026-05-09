" ~/.vimrc: Vim configuration file
" see https://vimhelp.org/vimrc.txt.html

" Enable filetype detection and plugins
filetype plugin indent on

" Enable syntax highlighting
syntax on

" Set default encoding
set encoding=utf-8
set fileencoding=utf-8

" Show line numbers
set number
set relativenumber

" Enable mouse support
set mouse=a

" Set tab settings
set tabstop=4
set shiftwidth=4
set expandtab
set smarttab

" Search settings
set ignorecase
set smartcase
set hlsearch
set incsearch

" Display settings
set cursorline
set showmatch
set laststatus=2
set ruler

" Auto commands
autocmd BufWritePost * silent! !git add % 2>/dev/null || true
autoc BufWritePost * silent! !git commit -m "Auto-update $(basename %)" % 2>/dev/null || true

" Key mappings
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>wq! :wq!<CR>
nnoremap <leader>qa :qa<CR>

" Colors
set background=dark
colorscheme default