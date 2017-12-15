" http://learnvimscriptthehardway.stevelosh.com/chapters/33.html
" http://learnvimscriptthehardway.stevelosh.com/chapters/34.html

nnoremap <silent> <c-g>
            \ :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <silent> <c-g>
            \ :<c-u>call <SID>GrepOperator(visualmode())<cr>
function! s:GrepOperator(type)  "{{{
    let saved_unnamed_register = @@

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    let cmd = "grep! -HIR " . shellescape(@@) . " ."
    echom 'GrepOperator(): ' . cmd
    silent execute cmd
    redraw!
    if len(getqflist())
        " only open qfl if there are results
        copen
    else
        " TODO delete the empty quickfix list
        echoerr "':" . cmd . "' returned no results!"
    endif

    let @@ = saved_unnamed_register
endfunction  "}}}


nnoremap <silent> <c-f>
            \ :set operatorfunc=<SID>VimGrepOperator<cr>g@
vnoremap <silent> <c-f>
            \ :<c-u>call <SID>VimGrepOperator(visualmode())<cr>

" Operator function to search for stuff with vimgrep                        {{{
"
" The global variable 'g:VimGrepOperator_path' or the buffer-variable
" b:VimGrepOperator_path can be set to whichever path you would like to search
" with :vimgrep, the buffer-variable will take precedence over the global. If
" neither is set, then the default will be '**' (recursive search from the
" current working directory).
"                                                                           }}}
function! s:VimGrepOperator(type)  "{{{
    let saved_unnamed_register = @@

    " check the buffer then global scopes for VimGrepOperator_path setting,
    " default to ** if not set
    let path = get(b:, 'VimGrepOperator_path',
                \ get(g:, 'VimGrepOperator_path', '**'))

    if a:type ==# 'v'
        normal! `<v`>y
    elseif a:type ==# 'char'
        normal! `[v`]y
    else
        return
    endif

    " escape the string for vimgrep with very-nomagic
    let cmd = "vimgrep /\\V\\C"
                \ . escape(@@, '/\')
                \ . "/gj"
                \ . path
    echom 'VimGrepOperator(): ' . cmd
    try
        silent execute cmd
        copen
    catch /^Vim\%((\a\+)\)\=:E480/                " catch No match error (E480)
        echoerr "':" . cmd . "' returned no results!"
    endtry

    let @@ = saved_unnamed_register
endfunction  "}}}
