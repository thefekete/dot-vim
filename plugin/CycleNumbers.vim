" who needs help anyways?
nnoremap <silent> <F1> :call CycleNumberSettings()<cr>

" Cycles between:
"   1. no line numbers
"   2. regular line numbers
"   3. relative line numbers
function! CycleNumberSettings()  "{{{
    if &number && &relativenumber
        " relative -> none
        set nonumber norelativenumber
    elseif &number
        " number -> relative
        set number relativenumber
    else
        " none -> number
        set number norelativenumber
    endif
endfunction  "}}}
