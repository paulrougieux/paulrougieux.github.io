filetype on
syntax enable

set ignorecase
set smartcase

" Split settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Indentation settings
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
filetype indent on 

" wrap markdown text to 80 characters
au BufRead,BufNewFile *.md setlocal textwidth=80

" Spelling
set spell spelllang=en_gb,fr

