" Default setting when not explicitly set
let s:setting_default='**'


function! InitSetting()
    " check for buffer-local setting
    if !exists("b:my_plugin_setting")
        " no buffer-local setting set
        if exists("g:my_plugin_setting")
            " there is a global setting set, use that
            let b:my_plugin_setting=g:my_plugin_setting
        else
            " no setting set anywhere, set the default
            let b:my_plugin_setting=s:setting_default
        endif
    endif
endfunction
