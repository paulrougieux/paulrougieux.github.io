""""""""""""""""""""""""""""
" # Vundle package manager "
""""""""""""""""""""""""""""
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
Plugin 'tpope/vim-dispatch'
" Latex editing
Plugin 'lervag/vimtex'
" Line up text in tables
Plugin 'godlygeek/tabular'
" Markdown table of content 
Plugin 'vim-voom/VOoM'
" Markdown citation and syntax
Plugin 'vim-pandoc/vim-pandoc'
Plugin 'vim-pandoc/vim-pandoc-syntax' 
" Python autocompletion 
Plugin 'davidhalter/jedi-vim'
" Python linter
Plugin 'dense-analysis/ale' 
" R programming
Plugin 'jalvesaq/Nvim-R'
Plugin 'jalvesaq/R-Vim-runtime'
" Tests
Plugin 'vim-test/vim-test'

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


"""""""""""""""""""""""""""
" # General configuration "
"""""""""""""""""""""""""""
" Auto save
autocmd TextChanged,TextChangedI <buffer> silent write

" Determine the type of the current file
filetype on
syntax enable

" Set autocompletion to longest common string
set wildmode=list:longest

" change leader key from \ (the default) to ,
let mapleader = ","
let maplocalleader = ";"

" Case insensitive search
set ignorecase
set smartcase

" Spelling
set spell spelllang=en_gb,fr

" Split settings
" Commented out because I use tmux-navigator in normal mode
"nnoremap <C-J> <C-W><C-J>
"nnoremap <C-K> <C-W><C-K>
"nnoremap <C-L> <C-W><C-L>
"nnoremap <C-H> <C-W><C-H>
" Mappings for terminal buffer similar to tmux navigator
tnoremap <C-J> <C-W><C-J>
tnoremap <C-K> <C-W><C-K>
tnoremap <C-L> <C-W><C-L>
tnoremap <C-H> <C-W><C-H>
set splitbelow
set splitright
" See also tmux configuration

" Set the height of the terminal buffer to 10 lines
"set termwinsize=10x0

" Recursively search all files in pwd for the word under the cursor 
nmap <F3> :vimgrep /<C-R><C-W>/ **<CR>

" Toggle taglist
nnoremap <silent> <F8> :TlistToggle<CR>

" Add date 
command! Date put =strftime('%Y-%m-%d')

" Add a read counter item to a list of papers to read
iabbrev azer - {1}

" Pomodoro entry
nmap <LocalLeader>m $4b

" Convert the current line to snake case
" 1. Replace any non alphanumeric characters by underscores
" 2. Convert to lower case
command! -range=% Snake s/[^a-zA-Z0-9]\+/_/g | normal Vu

""""""""""""""""""""
" # AZERTY keyboard "
""""""""""""""""""""
" Shared on https://stackoverflow.com/a/62195253/2641825
" Move to the end of the line
noremap m $
" Search backward for the word under the cursor
noremap µ #
" Navigate to the help tag under the cursor with ctrl-ù
noremap ' <C-]>
" Move into wrapped lines with arrow keys
nnoremap <Up> gk
vnoremap <Up> gk
nnoremap <Down> gj
vnoremap <Down> gj

""""""""""""""""""
" # Colour theme "
""""""""""""""""""
set t_Co=256
" terminal’s colour palette #444444 is suggested by jellybeans.vim,
" I used 353131
" Change the background colour
"set background=dark

" copied from https://github.com/nanotech/jellybeans.vim#screenshots
" These settings have to be before setting the colour scheme
let g:jellybeans_overrides = {
\    'background': { 'guibg': '303030' },
\    'signcolumn': { 'guibg': '000000' },
\}
" Use the jelly beans colour scheme
colorscheme jellybeans

" Underline bad spelling instead of highlighting it
" this should be placed after colorscheme and background colour
hi clear SpellBad
"hi SpellBad cterm=underline
hi SpellBad cterm=underline ctermbg=black

"""""""""""""""""""
" # File Explorer "
"""""""""""""""""""
" Tree list view
let g:netrw_liststyle = 3
" Remove the banner
let g:netrw_banner = 0
" Per default, netrw leaves unmodified buffers open. This autocommand
" deletes netrw's buffer once it's hidden (using ':q', for example)
autocmd FileType netrw setl bufhidden=delete

" Lexplore with a 30 character size buffer only
command! Ll Lexplore | vert res 30


"""""""""""""""""""""""
" # Git configuration "
"""""""""""""""""""""""
" Configure the fugitive plugin
" Open git grep in a quickfix window with 'G grep'
autocmd QuickFixCmdPost *grep* cwindow
" Display a word diff
command! Gwdiff vert term git diff --word-diff

" An attempt to add arguments the issue is that I don't how to tell vim that
" the argument is optional
"command! -nargs=1 Gwdiff vert term git diff --word-diff <q-args>


"""""""""""""""""""""""""
" # Latex configuration "
"""""""""""""""""""""""""
" Settings for the vim-latex plugin
" No folding
:let Tex_FoldedSections=""
:let Tex_FoldedEnvironments=""
:let Tex_FoldedMisc=""
" Settings for the vimtex plugin
" Only citation keys for completion
let g:vimtex_complete_bib = { 'simple': 1 }

" Use zathura as a PDF viewer
let g:vimtex_view_method = 'zathura'
" use xdotool in a hook function
" https://github.com/lervag/vimtex/issues/1719
function! ZathuraHook() dict abort
  if self.xwin_id <= 0 | return | endif

" Settings only implemented for .tex files
" Key combination to insert citation and references using the vimtex plugin or
" Note: ctrl-space appears as ctrl-@ in my terminal
au BufRead,BufNewFile *.tex inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>
au BufRead,BufNewFile *.Rnw inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>


" Map key to view the pdf
nmap <silent><Leader>lv <Esc>:VimtexView<CR>
nmap <silent><Leader>ll <Esc>:VimtexCompile<CR>


  silent call system('xdotool windowactivate ' . self.xwin_id . ' --sync')
  silent call system('xdotool windowraise ' . self.xwin_id)
endfunction

" List article references in the quickfix window
command! Article vim /@article/ % | cw

""""""""""""""""""""""""""""
" # Markdown configuration "
""""""""""""""""""""""""""""
" Shortcut to align the current paragraph
" J added to format also quoted paragraph correctly
au BufRead,BufNewFile *.md map <C-P> vipJgqk
au BufRead,BufNewFile *.Rmd map <C-P> vipJgqk

" Remove trailing white spaces in markdown files
autocmd BufWritePre *.md %s/\s\+$//e

" Wrap markdown text to 88 characters like psf/black
au BufRead,BufNewFile *.md setlocal textwidth=88
" Command to disable auto wrap to edit long tables for example
command! Nowrap set formatoptions=cq
" Do not use double spaces after points
set nojoinspaces
" Disable folding of vim-pandoc plugin
let g:pandoc#modules#disabled = ["folding"]
let g:pandoc#formatting#mode = "ha"

" Voom plugin 
let voom_ft_modes = {'markdown': 'pandoc', 'pandoc': 'pandoc', 'rmd': 'pandoc', 'tex': 'latex', 'rnoweb' : 'latex', 'quarto' : 'pandoc'}

" Create a Toc command
augroup Toc
    autocmd!
    autocmd Filetype markdown command! -buffer Toc Voom
    autocmd Filetype rmd command! -buffer Toc Voom
    autocmd Filetype quarto command! -buffer Toc Voom
    " rnoweb are the Rnw notebooks mixing latex and R code
    autocmd Filetype rnoweb command! -buffer Toc Voom
    autocmd Filetype tex command! -buffer Toc VimtexTocOpen
    autocmd Filetype python command! -buffer Toc vimgrep /#.*#/ %
augroup END
command! TOc Toc

" Insert citations or autocomplete code with Ctrl-Space, 
" Might conflict with python plugin Jedi's autocomplete when editing a python
" file in parallel?
au BufRead,BufNewFile *.md inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>
au BufRead,BufNewFile *.Rmd inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>
au BufRead,BufNewFile *.qmd inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>

command! -range=% Hyphen <line1>,<line2>s/\(\i\)- /\1/g

" Render markdown documents with Pandoc
command! Ppdf execute '!pandoc % -o %:r.pdf'
command! Phtml execute '!pandoc % -o %:r.html'

" Render quarto documents with quarto
command! Qpdf execute '!quarto render % --to pdf'
command! Qhtml execute '!quarto render % --to html'

" Add quote formatting to pasted text - only for markdown files
augroup markdown_quotes
  autocmd!
  autocmd FileType markdown,rmd,qmd nnoremap <buffer> <localleader>pq :call PasteQuoted()<CR>
augroup END

function! PasteQuoted()
  " Create a temporary file
  let l:tmpfile = tempname()
  
  " Use system clipboard tools to get content
  if has('mac')
    silent execute '!pbpaste > ' . l:tmpfile
  elseif has('unix')
    silent execute '!xclip -selection clipboard -o > ' . l:tmpfile
  elseif has('win32') || has('win64')
    silent execute '!powershell -command "Get-Clipboard" > ' . l:tmpfile
  endif
  
  " Read the content from temp file
  let lines = readfile(l:tmpfile)

  

  " Process each line - add > and quotes
  let quoted_lines = map(lines, '"> \"" . v:val . "\""')
  
  " Insert the formatted text at cursor position
  call append(line('.'), quoted_lines)
  
  " Clean up
  call delete(l:tmpfile)
endfunction

""""""""""""""""""""""""""
" # Python configuration "
""""""""""""""""""""""""""
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
" Jedi go to definition, alternative to <leader>-d to avoid
" au BufRead,BufNewFile *.py noremap <leader>f :ALEGoToDefinition<CR>
" Jedi do not start completion when I type a dot
let g:jedi#popup_on_dot = 0
" Disable call signatures
let g:jedi#show_call_signatures = "0" 

" Vim Test
let g:test#python#pytest#executable = 'python3 -m pytest'
let test#strategy = "make"
" let test#strategy = "dispatch"
nmap <silent> <leader>T :TestFile<CR>
nmap <silent> <leader>a :TestSuite<CR>

" Pytest TODO: delete if not used
autocmd FileType python nmap <silent><Leader>f <Esc>:Pytest file<CR>
autocmd FileType python nmap <silent><Leader>m <Esc>:Pytest method<CR>

" Remove all trailing whitespace by pressing F5
nnoremap <F5> :let _s=@/<Bar>:%s/\s\+$//e<Bar>:let @/=_s<Bar><CR>
" Specify which ALE linter is complaining
let g:ale_echo_msg_format = '[%linter%] %s'
" Disable ale for some file extensions
let g:ale_pattern_options = {
\   '.*\.md$': {'ale_enabled': 0},
\   '.*\.Rmd$': {'ale_enabled': 0},
\}
" Disable Ale virtual text
let g:ale_virtualtext_cursor = 0

" Vim Dispatch setup for the quickfix list
autocmd FileType python let b:dispatch = 'pylint -f parseable %'

" Title inside a script https://vi.stackexchange.com/q/40376/6671
autocmd FileType python command! Title normal! A #<esc>yyppv$r#kkv$r#

"""""""""""""""""""""
" # R configuration "
"""""""""""""""""""""
" Autocomplete with Ctrl-Space, 
au BufRead,BufNewFile *.R inoremap <C-Space> <C-x><C-o> | inoremap <C-@> <C-x><C-o>

" Nvim-R options
" disable auto replacement of _ to <- by Nvim-R
let R_assign = 0
" Chunk current echo and down
"nnoremap <LocalLeader>cq <LocalLeader>ca

" Add tags as explained in :help Nvim-R-tagsfile
autocmd FileType r set tags+=R/tags,~/rp/tradeharvester/R/tags,~/rp/eutradeflows/R/tags,~/rp/FAOSTATpackage/FAOSTAT/R/tags
autocmd FileType rmd set tags+=R/tags,~/rp/tradeharvester/R/tags,~/rp/eutradeflows/R/tags,~/rp/FAOSTATpackage/FAOSTAT/R/tags

" NVim-R command to set the working directory to the project root in knitr
" map <silent> <LocalLeader>w  :call g:SendCmdToR("setwd(opts_knit$get()$root.dir)")<CR>
" R's working directory to be the same as Vim's working directory
let R_nvim_wd = 1

" Map > to %>% in insert mode https://github.com/jalvesaq/Nvim-R/issues/85
autocmd FileType r inoremap <buffer> > <Esc>:normal! a%>%<CR>a
autocmd FileType rmd inoremap <buffer> > <Esc>:normal! a%>%<CR>a

" No wrap in csv files, also affects the data frame view of ;vs
autocmd FileType csv set nowrap 

" Map send line and down to j (avoid deleting stuff with d)
nmap <LocalLeader>j <Plug>RDSendLine

" Table of content of R functions in a file
" Create a Rfunc command
augroup  Rfunc
    autocmd!
    autocmd Filetype r command! -buffer Rfunc vim /function(/ % | cw
augroup END


" Press `gz` in Normal mode to emulate Tmux ^bz
" see help Nvim-R tips 

" See :help R_external_term
" Run R in an external terminal emulator
" let R_external_term = 1

" Right align columns in tab separated files generated by Nvim-R.
" After pressing the <local leader> r v comment to view a data frame.
command! Tt Tabularize /\t/r0


""""""""""""""""""""""""
" # Tmux configuration "
""""""""""""""""""""""""
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
" https://github.com/jpalardy/vim-slime/issues/131
let g:slime_python_ipython = 1

" Similar to NvimR's shortcut send line, but with Slime
autocmd FileType python nmap <buffer> <LocalLeader>l <Plug>SlimeLineSend
autocmd Filetype markdown nmap <buffer> <LocalLeader>l <Plug>SlimeLineSend
" Shortcut to send the current paragraph with Slime
autocmd FileType python nmap <buffer> <LocalLeader>p <Plug>SlimeParagraphSend
autocmd Filetype markdown nmap <buffer> <LocalLeader>p <Plug>SlimeParagraphSend
" Similar NvimR's send selection, but with with slime
autocmd FileType python xmap <buffer> <LocalLeader>m <Plug>SlimeRegionSend
autocmd FileType markdown xmap <buffer> <LocalLeader>m <Plug>SlimeRegionSend
" Send the current word under the cursor to the last active tmux buffer with slime
autocmd FileType python nmap <buffer> <LocalLeader>w viw<Plug>SlimeRegionSend
autocmd Filetype markdown nmap <buffer> <LocalLeader>w viw<Plug>SlimeRegionSend


" # TODO
" I have a vim markdown plugin that displays
" ## Title
" "quote"  as
" §§ Title
" “quote” this is really annoying how can I remove this behaviour?
" See LLM reply



" To reload this file :source ~/.vimrc
