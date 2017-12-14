" SuperFoldText - better looking foldtext, one command at a time
" started with https://gist.github.com/sjl/3360978
"
" Place this funciton in a file inside ~/.vim/plugin and add the following
" to $MYVIMRC:
"   set foldtext=SuperFoldText()
function! SuperFoldText() "{{{
    let cont = ' … '                                     " continuation string
    let fillchar = ' '
    let foldcount = (v:foldend - v:foldstart) . "↓"
    let width = winwidth(0) - (&foldcolumn
                \ + ((&number||&relativenumber) * &numberwidth))

    let firstline = getline(v:foldstart)
    let lastline = substitute(getline(v:foldend), '\v^\s*(.*)\s*$', '\1', '')

    if &foldmethod ==# 'marker'
        " remove markers from foldtext if used
        let match = '\(\s*' . substitute(&commentstring, '%s', '', '') . '\)\?'
        let match .= '\s*\(' . join(split(&foldmarker, ','), '\|')
        let match .= '\)[0-9]*\s*'
        let firstline = substitute(firstline, match, '', 'g')
        let lastline = substitute(lastline, match, '', 'g')
    endif

    " check if ftext is too long, truncate if it is
    if (strdisplaywidth(firstline)
        \ + strdisplaywidth(lastline)
        \ + strdisplaywidth(cont)) > (width - foldcount)
        let ftext = strpart(firstline, 0, width - (
                    \ strdisplaywidth(foldcount) + strdisplaywidth(cont))). cont
    else
        let ftext = firstline . cont . lastline
    endif

    " get number of chars to fill
    let fillwidth = width - strdisplaywidth(ftext) - strdisplaywidth(foldcount)

    return ftext . repeat(fillchar,fillwidth) . foldcount
endfunction  "}}}
