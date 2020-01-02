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

if !exists('g:hugohelper_content_dir')
    let g:hugohelper_content_dir = 'content'
endif

if !exists('g:hugohelper_site_config')
    " List of site configuration files vim-hugo-helper uses to detemine
    " the root of the hugo site.
    " For more information, see: https://gohugo.io/getting-started/configuration/
    let g:hugohelper_site_config = [ 'config.toml', 'config.yaml', 'config.json' ]
endif



command! -nargs=0 HugoHelperSpellCheck call hugohelper#SpellCheck()
command! -nargs=0 HugoHelperDraft call hugohelper#Draft()
command! -nargs=0 HugoHelperUndraft call hugohelper#Undraft()
command! -nargs=0 HugoHelperDateIsNow call hugohelper#DateIsNow()
command! -nargs=0 HugoHelperLastmodIsNow call hugohelper#LastmodIsNow()
command! -nargs=0 HugoHelperTitleToSlug call hugohelper#TitleToSlug()
command! -nargs=0 HugoHelperTitleCase call hugohelper#TitleCase()
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
    autocmd BufWritePre *.md call s:UpdateLastMod()
augroup end

" Update lastmod on save.
function! s:UpdateLastMod()
    if s:ShouldUpdateLastMod()
        let save_cursor = getcurpos()
        call hugohelper#LastmodIsNow()
        call setpos('.', save_cursor)
    endif
endfunction

function! s:ShouldUpdateLastMod()
    if !g:hugohelper_update_lastmod_on_write
        return v:false
    endif

    if hugohelper#HasFrontMatter() == 0
        return v:false
    endif

    " Only update lastmod in markdown in the content directory. In particular, archetypes
    " should not be automatically updated.
    return s:IsFileInHugoContentDirectory(expand('<afile>'))
endfunction

function! s:IsFileInHugoContentDirectory(filepath)
    let l:mods = ':p:h'
    let l:dirname = 'dummy'
    while !empty(l:dirname)
        let l:path = fnamemodify(a:filepath, l:mods)
        let l:mods .= ':h'
        let l:dirname = fnamemodify(l:path, ':t')
        if l:dirname == g:hugohelper_content_dir
            " Check if the parent of the content directory contains a config file.
            let l:parent = fnamemodify(l:path, ":h")
            if s:HasHugoConfigFile(l:parent)
                return v:true
            endif
        endif
    endwhile

    return v:false
endfunction

function! s:HasHugoConfigFile(dir)
    " :p adds the final path separator if a:dir is a directory.
    let l:dirpath = fnamemodify(a:dir, ':p')
    for config in g:hugohelper_site_config
        let l:file = l:dirpath . config
        if filereadable(l:file)
            return v:true
        endif
    endfor
    return v:false
endfunction

" vim: expandtab shiftwidth=4
