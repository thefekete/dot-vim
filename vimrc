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

"set number                                                  " show line numbers
set number                                                   " show line numbers
set autoindent                                    " enable automatic indentation
set cursorline                                          " highlight current line
filetype plugin on                                      " Enable filetype plugin
filetype indent on                             " load file-specific indent files
set wildmenu                             " visual auto-complete for command menu
"set wildmode=longest:full                             " not sure what this does
set lazyredraw                                       " redraw only when necesary
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

set foldenable  " enable folding
set foldlevelstart=10  " default level to open to
set foldnestmax=10  " max number of nested folds
set foldmethod=indent  " fold based on indent by default
set fillchars="fold: "  " get rid of those dashes in fold

" space opens/closes folds
nnoremap <space> za
" fold all except current fold (isolate fold)
nnoremap <leader><space> zMzO

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
" Autocommands, bash-fc {{{

" augroup and autocmd! prevent mupliple definitions of auto commands
augroup filetype_bash-fc
    autocmd!

    " default to c.doxygen type for .dox files
    autocmd BufNewFile,BufRead bash-fc-* setlocal filetype=sh
augroup END

" }}}
" Autocommands, C/C++ {{{

" augroup and autocmd! prevent mupliple definitions of auto commands
augroup filetype_c
    autocmd!

    " c/c++/arduino autocmds - autoformat with astyle, fold by syntax
    autocmd BufNewFile,BufRead *.c,*.h,*.cpp,*.ino setlocal
                \ formatprg=astyle\ -s4plSC
                \ foldmethod=syntax

    " highlight any characters over column 80
    autocmd BufNewFile,BufRead *.c,*.h,*.cpp,*.ino
                \ :match ErrorMsg /\%>80v.\+/

    " only fold one level (functions), use doxygen syntax
    autocmd BufNewFile,BufRead *.c setlocal foldnestmax=1 filetype=c.doxygen

    " default to c.doxygen type for headers
    autocmd BufNewFile,BufRead *.h setlocal foldnestmax=1 filetype=c.doxygen

    " default to c.doxygen type for .dox files
    autocmd BufNewFile,BufRead *.dox setlocal foldnestmax=1 filetype=c.doxygen

    " compile and run current file
    autocmd FileType c nnoremap <buffer> <f5>
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
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
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
    " print current files html
    autocmd Filetype markdown nnoremap <buffer> <F6>
                \ :w<cr>:! pandoc --number-sections -t html5 %<cr>

"    " *.md files are mardown, not 'modal2', whatever the hell that is..
"    autocmd BufNewFile,BufRead *.md setlocal filetype=markdown
"
"    " set up word wrapping
"    autocmd BufNewFile,BufRead *.md setlocal wrap linebreak spell
"
"    " no line numbers
"    autocmd BufNewFile,BufRead *.md setlocal nonumber
"
"    " remap j/k keys to go down displayed lines (useful with wrapped lines)
"    autocmd Filetype markdown noremap <buffer> j gj
"    autocmd Filetype markdown noremap <buffer> k gk
"
"    " mappings for headers
"    autocmd Filetype markdown nnoremap <buffer> <localleader>=
"                \ yypVr=:syntax sync fromstart<cr>
"    autocmd Filetype markdown nnoremap <buffer> <localleader>-
"                \ yypVr-:syntax sync fromstart<cr>
"
"    " headers in insert mode, make header and start new line
"    autocmd Filetype markdown inoremap <buffer> \\=
"                \ <Esc>yypVr=:syntax sync fromstart<cr>o
"    autocmd Filetype markdown inoremap <buffer> \\-
"                \ <Esc>yypVr-:syntax sync fromstart<cr>o
"
"    " redraw syntax highlighting, useful since headings don't always update
"    autocmd Filetype markdown nnoremap <buffer> <F12>
"                \ <Esc>:syntax sync fromstart<cr>
"    autocmd Filetype markdown inoremap <buffer> <F12>
"                \ <C-o>:syntax sync fromstart<cr>
"
"    " write and open in browser
"    autocmd Filetype markdown nnoremap <buffer> <F5>
"                \ :w<cr>:! mdr %<cr>
"
"    " print current files html
"    autocmd Filetype markdown nnoremap <buffer> <F6>
"                \ :w<cr>:! pandoc -t html5 %<cr>
augroup END

" }}}
" Autocommands, python {{{
augroup filetype_python
    autocmd!

    " basic settings
    autocmd filetype python setlocal
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

    " Show trailing whitepace and spaces before a tab:
    highlight ExtraWhitespace ctermbg=red guibg=red
    :autocmd filetype python syn match ExtraWhitespace /\s\+$\| \+\ze\t/

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
" Autocommands, snippets {{{

" settings for UltiSnips snippet files
augroup filetype_snippets
    autocmd!
    autocmd Filetype snippets setlocal
                \ foldmethod=marker
                \ foldlevel=0
                \ noexpandtab
                \ softtabstop=0
augroup END

" Or put this at the top:
" vim: foldmethod=marker:foldlevel=0:noexpandtab:softtabstop=0

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
                \ foldlevel=0
augroup END

" Or put this at the top:
" vim: foldmethod=marker:foldlevel=0

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

" " scrolling with ctrl-j/k
" nnoremap <c-j> 5<c-d> 
" nnoremap <c-k> 5<c-u> 

" switch windows with the ctrl key
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" open next/previous buffers with ctrl-n/b
nnoremap <C-n> :bnext<cr> 
nnoremap <C-b> :bprevious<cr> 

" our RepeatUntil() func
nnoremap <leader><space> :call RepeatUntil(80)<cr>

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
" Functions {{{

" Inserts the character under the cursor until line is len characters long
function! RepeatUntil(len)  " {{{2
    while strlen(getline('.')) < a:len
        exec "normal! vyP"
    endwhile
endfunction  " }}}2

" delete chars under the cursor until line is len chars long
function! DeleteUntil(len)  " {{{2
    while strlen(getline('.')) > a:len
        exec "normal! x"
    endwhile
endfunction  " }}}2


" }}}
