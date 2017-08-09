---
title: "Vim Commands"
output: 
  html_document: 
    toc: yes
    toc_float: true
---

This page is the continuation of [my blog post on Vim commands](https://paulremote.blogspot.de/2014/07/vim-commands.html).


# Help

    :help  -  vim help
    :help commandname - help on a particular command
    CTRL+] - jump to a highlighted topic
    CTRL+T - jump backwards

# Navigating 
## Motion

    :help left-right-motion
    j,k move up down
    h,l move left right
    b,w move previous or next word
    ctrl+b, ctrl+d move page up or page down

## Search
    "/" to search, then n forward and N backwards
    "*" to search for the word under the cursor (you can also create a mapping to search for a selected text)

### Markdown
Display a list of first level header in a markdown document (found in quick markdown navigation/TOC)

    :g/^# /#

Then enter the line number to jump to that line.

## Line numbers
 Display line numbers

    :set nu

Disable line numbers

    :set nonu

## Working directory

Display the present working directory

    :pwd

[Set working directory to the current file](http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file) (for all windows):

    :cd %:p:h

Set working directory to the current file, for the current window only

    :lcd %:p:h

In these commands, % gives the name of the current file, %:p gives its full path, and %:p:h gives its directory (the "head" of the full path). 

Automatically change the working directory to the file currently edited

    set autochdir

# Editing
## Undo redo

    u: undo last change (can be repeated to undo preceding commands)
    Ctrl-R: Redo changes which were undone (undo the undos). 
    Compare to '.' to repeat a previous change, at the current cursor position. Ctrl-R will redo a previously undone change, wherever the change occurred. 

## Switch between navigation and editing mode

    A - move to the end of the line and switch to editing mode 
    I - switch to editing mode at the current place
    Escape - switch to navigation mode
    alt+h alt+j alt+k alt+l - switch to navigation mode and move
    alt+: - switch to navigation mode and send a command

## Replace characters

Vim wiki on search and replace 

    :s/foo/bar/g Find each occurrence of 'foo' (in the current line only), and replace it with 'bar'. 

    :%s/foo/bar/g Find each occurrence of 'foo' (in all lines), and replace it with 'bar'.

    %s/option value=".*"//g remove all beginnings of line. :%s/\option\n/, /g replace all end of line by comma + space. This cleans an html list of species for inclusion in a text.

## Editing a whole line

    dd to delete a whole line
    yy to copy a whole line
    p to paste the copied or deleted text after the current line or 
    P to paste the copied or deleted text before the current line 

## Copy, cut and paste

    Position the cursor where you want to begin cutting.
    Press v (or upper case V if you want to cut whole lines).
    Move the cursor to the end of what you want to cut.
    Press d to cut or y to copy.
    Move to where you would like to paste.
    Press P to paste before the cursor, or p to paste after. 

## Indentation

Indentation replaced by spaces, add this to the ~/.vimrc file

    set tabstop=4
    set expandtab
    set softtabstop=4
    set shiftwidth=4
    filetype indent on 

More details on vim indentation in the python wiki.

# Multiple files and windows

    :e filename - edit another file 
    :ls         - show current buffers
    :b 2        - open buffer #2 in this window
    :b filename - open buffer #filename in this window
    :bd         - close the current buffer (! to forget changes)
    :bd filename -close a buffer by name 

## Window split

    :sp[lit] filename  - split window and load another file
    :vs[plit] - same but split vertically  
    ctrl-w up arrow - move cursor up a window
    ctrl-w ctrl-w   - move cursor to another window (cycle)
    ctrl-w_         - maximize current window
    ctrl-w=         - make all equal size
    CTRL+z - suspend the process and get back to the shell
    fg - get back to vim

[Easier split navigations](https://robots.thoughtbot.com/vim-splits-move-faster-and-more-naturally#easier-split-navigations)

    nnoremap <C-J> <C-W><C-J>
    nnoremap <C-K> <C-W><C-K>
    nnoremap <C-L> <C-W><C-L>
    nnoremap <C-H> <C-W><C-H> 

Natural split opening

    set splitbelow
    set splitright

# Tools

## Shell

[Working with external commands](https://www.linux.com/learn/vim-tips-working-external-commands)
explains how to start a shell:

    :shell

Then exit the shell normaly with `exit`.

Use a Bang! to run a command directly, for example to
see how many words are in the file, run:

    :! wc %

You can copy (`y $`) and paste a command in the vim command line with `CTRL + R + "`.

Insert text from a specified file into the current buffer:

    :r textfile

You can also read in the output of shell applications. For example, if you wanted to include a list of files from a specific directory, you could include them using this read command:

    :r ! ls -1 /home/user/directory

## Vimdiff
View differences between file1 and file2 (vim documentation)

    vimdiff file1 file2


## spell check
Set spell check only in the local buffer:

    :setlocal spell spelllang=en_gb   

 Turn spell check off

    :set nospell 


Mark word as correct, this creates a spell file under /home/user/.vim/spell:

    zg 

Mark word as incorrect

    zw

## Plugins for programming languages

    Vim R
    Vim on Python wiki (set softtabstop=4) or your  python development environment (set tabstop=4 and set softtabstop=4)

# .vimrc
Text colour.
Add syntax highlight to your .vimrc

    syntax enable

How to add a file extension to vim syntax highlight

    au BufNewFile,BufRead *.dump set filetype=sql

I used it to display markdown files as text files:

    au BufNewFile,BufRead *.md set filetype=txt

