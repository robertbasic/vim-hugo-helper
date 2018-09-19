if exists('g:hugohelper_plugin_loaded') || &cp
    finish
endif
let g:hugohelper_plugin_loaded = 1

let g:hugohelper_plugin_path = expand('<sfile>:p:h')

if !exists('g:hugohelper_spell_check_lang')
    let g:hugohelper_spell_check_lang = 'en_us'
endif

if !exists('g:hugohelper_update_lastmod_on_write')
    let g:hugohelper_update_lastmod_on_write = 0
endif

command! -nargs=0 HugoHelperSpellCheck call hugohelper#SpellCheck()
command! -nargs=0 HugoHelperDraft call hugohelper#Draft()
command! -nargs=0 HugoHelperUndraft call hugohelper#Undraft()
command! -nargs=0 HugoHelperDateIsNow call hugohelper#DateIsNow()
command! -nargs=0 HugoHelperLastmodIsNow call hugohelper#LastmodIsNow()
command! -nargs=0 HugoHelperTitleToSlug call hugohelper#TitleToSlug()
command! -nargs=1 HugoHelperHighlight call hugohelper#Highlight(<f-args>)
command! -range -nargs=1 HugoHelperLink call hugohelper#Link(<f-args>)

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

augroup vim-hugo-helper
    autocmd BufWritePre *.md call s:autosave()
augroup end

" Update lastmod on save.
function! s:autosave()
    if g:hugohelper_update_lastmod_on_write
        let l:isHugoFile = hugohelper#HasFrontMatter()
        if l:isHugoFile == 1
            echom "lastmod is now"
            call hugohelper#LastmodIsNow()
        else
            echom "nope"
        end
    endif
endfunction

" vim: expandtab shiftwidth=4
