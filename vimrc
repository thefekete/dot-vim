" Read http://learnvimscriptthehardway.stevelosh.com/
" Got a lot of good info from: http://dougblack.io/words/a-good-vimrc.html
" Tim Pope's vim-sensible plugin has some interesting defaults

" Environment {{{
" Here we figure set some helper variables so we can tune settings based on
" 'where' vim is running.

" Hosts
if hostname() ==# "thinkrad"
    let g:env_linux=1
    let g:env_win=0
elseif hostname() ==# "HTKMNB075"                    " TODO verify this hostname
    let g:env_linux=1
    let g:env_win=0
else
    " unknown host, no os specific settings
    let g:env_linux=0
    let g:env_win=0
endif

" }}}

" pathogen  {{{

execute pathogen#infect()

" }}}
" Leaders {{{

" leader is just '\', but it's an escape char so we need two
let mapleader = "\\"
" localleader is just '\\', but it's an escape char so we need four
let maplocalleader = "\\\\"

" }}}
" Colors {{{

set t_Co=256  " 256 color mode
syntax enable  " enables syntax highlighting
set background=dark  " we're using a dark background
"set background=light  " we're using a light background
let g:solarized_termtrans=1
let g:solarized_termcolors=256
colorscheme solarized

" super hacky way to get rid of folded line highlighting
"highlight Folded ctermbg=black

" }}}
" Spaces & Tabs {{{

set expandtab                             " insert spaces when <TAB> is pressed
set softtabstop=4                                 " number of spaces for <TAB>s
set shiftwidth=4                             " number of spaces for indentation
set tabstop=8                                       " <TAB> character is 8 wide

" }}}
" UI Layout {{{

set number                                                   " show line numbers
set relativenumber                                 " use relative line numbers
set autoindent                                    " enable automatic indentation
set cursorline                                          " highlight current line
filetype plugin on                                      " Enable filetype plugin
filetype indent on                             " load file-specific indent files
set wildmenu                             " visual auto-complete for command menu
"set wildmode=longest:full                             " not sure what this does
"set lazyredraw                                       " redraw only when necesary
set showmatch                                        " highlight matching [{()}]
set matchtime=1                               " tenths of a second for showmatch
set scrolloff=3                                " show extra lines when scrolling
set scroll=5                                   " num lines to jump with ctrl-u/d
set ruler
set cmdheight=1
set laststatus=2
set statusline=%t\ %m%r%y
set statusline+=\ %{fugitive#statusline()}
set statusline+=%=%c,%l/%L\ %P
set listchars=tab:»·,eol:¬,trail:·   " set up non-printing characters display

" }}}
" Searching {{{

set incsearch                                       " enable incremental search
set hlsearch                                         " highlight search results
set ignorecase                                    " ignore case while searching
set smartcase                        " case sensitive if case is used in search

" remove search highlight
nnoremap <leader>k :nohlsearch<CR>

" }}}
" Folding {{{

set foldenable                                                  " enable folding
set foldlevelstart=10                                 " default level to open to
set foldnestmax=10                                  " max number of nested folds
set foldmethod=marker                          " fold based on indent by default
set foldtext=SuperFoldText()                   " ~/.vim/plugin/SuperFoldText.vim
" set fold style to just bold, no underline or highlight
highlight Folded term=bold cterm=bold ctermbg=NONE

" space opens/closes folds
nnoremap <space> za

" Isolate fold, close all except for parents of current line
nnoremap zI zMzv
"nnoremap zI zMzO  " XXX does the same?

" }}}
" General Settings {{{

set nocompatible                                       " Use Vim options, not vi
set autoread                          " reload file when it changes (externally)
set title                                                 " set the window title
set ttyfast                                                  " smoother changes?
set history=1000                   " why not remember the last thousand changes?
set sessionoptions-=options           " don't save options when saving a session
set spelllang=en_us,de                   " use english and Deutsche dictionaries
set spellfile=~/.vim/spell/en.utf-8.add,~/.vim/spell/de.utf-8.add
set complete+=kspell                    " add dictionary when spellcheck enabled
set path+=**                                     " search sub-dirs for files too

"autocmd! bufwritepost .vimrc source ~/.vimrc         " reload vimrc when saved

" }}}
" Abbreviations {{{

iabbrev @@ Dan Fekete <thefekete@gmail.com>

" }}}
" Mappings, Normal mode {{{

" map these to something useful:
"nnoremap <up> ...
"nnoremap <down> ...
"nnoremap <left> ...
"nnoremap <right> ...

" open vimrc in a split to edit
nnoremap <leader>ve :split $MYVIMRC<cr>
" source vimrc
nnoremap <leader>vs :source $MYVIMRC<cr>

" move to start of line
nnoremap H ^
" move to end of line
nnoremap L $

" move current line down one
nnoremap - ddp
" move current line up one
nnoremap _ ddkP

" switch windows with the ctrl key
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" open next/previous buffers with ctrl-n/b
nnoremap <C-n> :bnext<cr> 
nnoremap <C-b> :bprevious<cr> 

" our RepeatUntil() func
nnoremap <leader><space> :call RepeatWidth()<cr>

" }}}
" Mappings, Insert mode {{{

" convert word under cursor to uppercase in insert mode
" use it to type constant names in lowercase, then convert at the end
inoremap <c-u> <esc>viwUea

" use jk for escape
inoremap jk <esc>

" }}}
" Mappings, Visual mode {{{

" visual double quote
vnoremap " <esc>`>a"<esc>`<i"<esc>`>
" visual single quote
vnoremap ' <esc>`>a'<esc>`<i'<esc>`>

" }}}
" Autocommands, bash-fc {{{

" augroup and autocmd! prevent mupliple definitions of auto commands
augroup filetype_bash-fc
    autocmd!

    " default to c.doxygen type for .dox files
    autocmd BufNewFile,BufRead bash-fc-* setlocal filetype=sh
augroup END

" }}}
" Autocommands, C/C++ {{{
augroup filetype_c
    autocmd!

    " c/c++/arduino autocmds - autoformat with astyle, fold by syntax
    autocmd BufNewFile,BufRead *.c,*.h,*.cpp,*.ino setlocal
                \ formatprg=astyle\ -s4plSC
                \ foldmethod=syntax

    " create a color column
    autocmd FileType c,cpp let
                \ &colorcolumn=join(range(&textwidth+1,999),",")

    " only fold one level (functions), use doxygen syntax
    autocmd BufNewFile,BufRead *.c setlocal foldnestmax=1 filetype=c.doxygen

    " default to c.doxygen type for headers
    autocmd BufNewFile,BufRead *.h setlocal foldnestmax=1 filetype=c.doxygen

    " default to c.doxygen type for .dox files
    autocmd BufNewFile,BufRead *.dox setlocal foldnestmax=1 filetype=c.doxygen

    " compile and run current file
    autocmd FileType c nnoremap <buffer> gcc
                \ :w<cr>:!gcc -std=gnu99 -D_GNU_SOURCE % && ./a.out<cr>
augroup END

" }}}
" Autocommands, gEDA config files {{{

" augroup and autocmd! prevent mupliple definitions of auto commands
augroup filetype_gedarc
    autocmd!

    " c/c++/arduino autocmds - autoformat with astyle, fold by syntax
    autocmd BufNewFile,BufRead *.gEDA/*rc setlocal
                \ filetype=scheme

augroup END

" }}}
" Autocommands, html/css {{{

" settings for makefiles
augroup filetype_html
    autocmd!
    autocmd Filetype html,css setlocal
                \ shiftwidth=2
                \ softtabstop=2
                \ foldnestmax=10
                \ foldlevelstart=10
    " open current html file in default browser
    autocmd Filetype html nnoremap <buffer> <f5>
          \ :silent !xdg-open % &>/dev/null<cr>:redraw!<cr>
augroup END

" }}}
" Autocommands, make {{{

" settings for makefiles
augroup filetype_make
    autocmd!
    autocmd Filetype make setlocal
                \ list
augroup END

" }}}
" Autocommands, markdown {{{
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh', 'c', 'cpp']
augroup filetype_markdown
    autocmd!
    autocmd filetype markdown setlocal
                \ wrap
                \ linebreak
                \ spell
                \ nonumber
    " remap j/k keys to go down displayed lines (useful with wrapped lines)
    autocmd Filetype markdown noremap <buffer> j gj
    autocmd Filetype markdown noremap <buffer> k gk
    " write and open in browser
    autocmd Filetype markdown nnoremap <buffer> <F5>
                \ :w<cr>:! mdr --number-sections %<cr>
    " print current file's html
    autocmd Filetype markdown nnoremap <buffer> <F6>
                \ :w<cr>:! pandoc --number-sections -t html5 %<cr>
augroup END
" }}}
" Autocommands, python {{{
augroup filetype_python
    autocmd!

    " basic settings
    autocmd filetype python setlocal
                \ number
                \ relativenumber
                \ encoding=utf-8

    " PEP8
    autocmd filetype python setlocal
                \ tabstop=4
                \ softtabstop=4
                \ shiftwidth=4
                \ textwidth=79
                \ expandtab
                \ autoindent

    " create a color column
    autocmd FileType c,cpp let
                \ &colorcolumn=join(range(&textwidth+1,999),",")

    " run current file
    autocmd FileType python nnoremap <buffer> <f5>
                \ :w<cr>:!python %<cr>

augroup END

" }}}
" Autocommands, text {{{
augroup filetype_text
    autocmd!

    " set up word wrapping
    autocmd Filetype text setlocal
            \ wrap
            \ linebreak
            \ spell
            \ nonumber
            \ noexpandtab

    " remap j/k keys to go down displayed lines (useful with wrapped lines)
    autocmd Filetype text noremap <buffer> j gj
    autocmd Filetype text noremap <buffer> k gk

augroup END

" }}}
" Autocommands, TODO {{{

augroup filetype_todo
    autocmd!

    " TODO files are todo.txt files
    autocmd BufNewFile,BufRead TODO setlocal filetype=todo

augroup END

" Or put this at the top:
" vim: foldmethod=marker:foldlevel=0:noexpandtab:softtabstop=0

" }}}
" Autocommands, vim {{{

" settings for vim files (vimrc, vimscripts, etc)
augroup filetype_vim
    autocmd!
    autocmd Filetype vim setlocal
                \ foldmethod=marker
                \ foldlevel=0
augroup END

" Or put this at the top:
" vim: foldmethod=marker:foldlevel=0

" }}}
" Autocommands, xdefaults {{{

" settings for xdefaults files (.Xresources, .Xdefaults)
augroup filetype_xdefaults
    autocmd!
    autocmd Filetype xdefaults setlocal
                \ foldmethod=marker
                \ foldlevelstart=0
augroup END

" Or put this at the top:
" vim: foldmethod=marker:foldlevelstart=0

" }}}
" Functions {{{

function! RepeatWidth()  "{{{2
    " Inserts the character under the cursor until line is &textwidth characters long
    if &textwidth > 0
        while strlen(getline('.')) < &textwidth
            exec "normal! vyP"
        endwhile
    else
        echo "textwidth not set, ignoring"
    endif
endfunction  " }}}2
function! DeleteWidth()  "{{{2
    " delete chars under the cursor until line is len chars long
    if &textwidth > 0
        while strlen(getline('.')) > &textwidth
            exec "normal! x"
        endwhile
    else
        echo "textwidth not set, ignoring"
    endif
endfunction  " }}}2
function! ChangeDirTo()  "{{{2
    " windows fix - change working directory if a dir is opened first
    " this is just so that I can drag a folder onto the nvim.exe and have it open
    " up as the working directory
    "
    " Not needed for MSYS2, but to enable it, put this somewhere:
    "   au VimEnter * call ChangeDirTo()  " check for dir and change to it
    echom "hello from ChangeDirTo"
    echom "file: " @%
    if @% =~ '\\$'
        echom "file ends with a backslash!"
        echom "changing to the opened directory"
        cd %
    else
        echom "file doesn't end with a backslash"
    endif
endfunction  " }}}2
function! CHSwap()  "{{{2
    " switches between header and source file
    " uses :find so will look in path
    " execute("find " . substitute(expand('%:t'), '.c', '.h',''))
    if @% =~ '\.c$'
        echom "In source file, will find header file"
        execute("find " . substitute(expand('%:t'), '.c', '.h',''))
    elseif @% =~ '\.h$'
        echom "In header file, will find source file"
        execute("find " . substitute(expand('%:t'), '.h', '.c',''))
    elseif @% =~ '\.cpp$'
        echom "In header file, will find source file"
        execute("find " . substitute(expand('%:t'), '.cpp', '.h',''))
    else
        echoerr "Not source or header file, not sure what to do here"
    endif
endfunction  " }}}2
function! GetMarkdownFold(lnum)  "{{{2
    if getline(a:lnum) =~? '\v^\s*$'
        return '='
    "elseif getline(a:lnum) =~? '\v^######'
    "    return '>6'
    "elseif getline(a:lnum) =~? '\v^#####'
    "    return '>5'
    "elseif getline(a:lnum) =~? '\v^####'
    "    return '>4'
    "elseif getline(a:lnum) =~? '\v^###'
    "    return '>3'
    "elseif getline(a:lnum) =~? '\v^##'
    "    return '>2'
    elseif getline(a:lnum) =~? '\v^#'
        return '>1'
    else
        return '='
    endif
endfunction  "}}}2

" }}}
