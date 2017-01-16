if exists('g:hugohelper_plugin_loaded') || &cp
  finish
endif
let g:hugohelper_plugin_loaded = 1

let g:hugohelper_plugin_path = expand('<sfile>:p:h')

command! -nargs=0 HugoHelperDraft call hugohelper#HugoHelperDraft()
command! -nargs=0 HugoHelperUndraft call hugohelper#HugoHelperUndraft()
command! -nargs=0 HugoHelperDateIsNow call hugohelper#HugoHelperDateIsNow()
command! -nargs=1 HugoHelperHighlight call hugohelper#HugoHelperHighlight(<f-args>)
command! -range -nargs=1 HugoHelperLink call hugohelper#HugoHelperLink(<f-args>)

function! HugoHelperFrontMatterReorder()
    exe 'g/^draft/m 1'
    exe 'g/^date/m 2'
    exe 'g/^title/m 3'
    exe 'g/^slug/m 4'
    exe 'g/^description/m 5'
    exe 'g/^tags/m 6'
    exe 'g/^categories/m 7'
    " create date taxonomy
    exe 'g/^date/co 8'
    exe ':9'
    exe ':s/.*\(\d\{4\}\)-\(\d\{2\}\).*/\1 = ["\2"]'
endfun
