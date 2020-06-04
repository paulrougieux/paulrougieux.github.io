""""""""""""""""""""""""""
" Vundle package manager "
""""""""""""""""""""""""""
" Should be at the beginning 
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Colour themes for Vim
Plugin 'morhetz/gruvbox'
Plugin 'nanotech/jellybeans.vim'
" Code structure i.e. table of content of classes, methods and functions
Plugin 'yegappan/taglist'
" Git interface 
Plugin 'tpope/vim-fugitive'
" Latex editing
"Plugin 'vim-latex/vim-latex'
Plugin 'lervag/vimtex'
" Markdown toc navigation
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
" Python autocompletion 
Plugin 'davidhalter/jedi-vim'
" Python linter
Plugin 'dense-analysis/ale' 
" R programming
Plugin 'jalvesaq/Nvim-R'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" Enable file type detection

" Temporarily disable a plugin 
" https://stackoverflow.com/questions/601412/how-to-turn-off-a-plugin-in-vim-temporarily
" set runtimepath-=~/.vim/bundle/vim-latex


"""""""""""""""""""""""""
" General configuration "
"""""""""""""""""""""""""
" Determine the type of the current file
filetype on
syntax enable

" Case insensitive search
set ignorecase
set smartcase

" Spelling
set spell spelllang=en_gb,fr

" Split settings
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright

" Toggle taglist
nnoremap <silent> <F8> :TlistToggle<CR>

""""""""""""""""""
" AZERTY keyboard "
""""""""""""""""""
" Shared on https://stackoverflow.com/a/62195253/2641825
" Move to the end of the line
noremap m $
" Search backward for the word under the cursor
noremap µ #
" Navigate to the help tag under the cursor
noremap ' <C-]>
" Move into wrapped lines with arrow keys
nnoremap <Up> gk
nnoremap <Down> gj

""""""""""""""""
" Colour theme "
""""""""""""""""
set t_Co=256
" terminal’s color palette #444444 is suggested by jellybeans.vim,
" I used 353131
" This is suggested by a stackoverflow answer
set background=dark
"autocmd vimenter * colorscheme gruvbox
colorscheme jellybeans

" Underline bad spelling instead of highlighting it
" this should be placed after colorscheme and background colour
hi clear SpellBad
"hi SpellBad cterm=underline
hi SpellBad cterm=underline ctermbg=black

"""""""""""""""""
" File Explorer "
"""""""""""""""""
" Tree list view
let g:netrw_liststyle = 3
" Remove the banner
let g:netrw_banner = 0
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

"""""""""""""""""""""
" Git configuration "
"""""""""""""""""""""
" Open git grep in a quickfix window
autocmd QuickFixCmdPost *grep* cwindow

"""""""""""""""""""""""
" Latex configuration "
"""""""""""""""""""""""
" No folding
:let Tex_FoldedSections=""
:let Tex_FoldedEnvironments=""
:let Tex_FoldedMisc=""
" Only citation keys for completion
let g:vimtex_complete_bib = { 'simple': 1 }

""""""""""""""""""""""""""
" Markdown configuration "
""""""""""""""""""""""""""
" wrap markdown text to 88 characters like psf/black
au BufRead,BufNewFile *.md setlocal textwidth=88
" Do not use double spaces after points
set nojoinspaces

" disable folding in vim-markdown 
let g:vim_markdown_folding_disabled = 1
" enable vim-markdown for .Rmd files too
augroup filetypedetect_markdown
    au!
    au BufRead,BufNewFile *.Rmd set ft=markdown
augroup END

""""""""""""""""""""""""
" Python configuration "
""""""""""""""""""""""""
" Indentation settings
set tabstop=4
set expandtab
set softtabstop=4
set shiftwidth=4
filetype indent on 

" Tell Jedi vim to use python2 for the engine only
" https://github.com/davidhalter/jedi-vim/issues/841
" let g:jedi#loader_py_version = 2
"
" Jedi go to definition
noremap <F2> <leader>-d
" Jedi  do not start completion when I type a dot
let g:jedi#popup_on_dot = 0
" Disable call signatures
let g:jedi#show_call_signatures = "0" 
" change leader key from \ (the default) to ,
:let mapleader = ","

" Pytest
nmap <silent><Leader>f <Esc>:Pytest file<CR>
nmap <silent><Leader>c <Esc>:Pytest class<CR>
nmap <silent><Leader>m <Esc>:Pytest method<CR>
" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Specify which ALE linter is complaining
let g:ale_echo_msg_format = '[%linter%] %s'
" Disable ale for some file extensions
let g:ale_pattern_options = {
\   '.*\.md$': {'ale_enabled': 0},
\   '.*\.Rmd$': {'ale_enabled': 0},
\}


"""""""""""""""""""
" R configuration "
"""""""""""""""""""
" disable autoreplacement of _ to <- by Nvim-R
let R_assign = 0

""""""""""""""""""""""
" Tmux configuration "
""""""""""""""""""""""
" Activate bracketed paste in tmux
if &term =~ "screen"
  let &t_BE = "\e[?2004h"
  let &t_BD = "\e[?2004l"
  exec "set t_PS=\e[200~"
  exec "set t_PE=\e[201~"
endif
" use tmux with slime
let g:slime_target = "tmux"
" configuration for vim in a split tmux window with a REPL in the other pane:
let g:slime_default_config = {"socket_name": "default", "target_pane": "{last}"}
" Handle indentation correctly  https://github.com/jpalardy/vim-slime/issues/54
" let g:slime_python_ipython = 1


" To reload :source ~/.vimrc
