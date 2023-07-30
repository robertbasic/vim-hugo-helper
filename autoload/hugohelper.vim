function! hugohelper#SpellCheck()
    exe "setlocal spell! spelllang=" . g:hugohelper_spell_check_lang
endfun

function! hugohelper#TitleToSlug()
    normal gg
    exe '/^title'
    normal! vi"y
    exe '/^slug'
    normal! f"pVu
    " Not sure why I can't make \%V work here
    exe ':s/ /-/g'
    exe 'normal! f-r f-r '
endfun

function! hugohelper#TitleCase()
    normal gg
    exe '/^title'
    normal! vi"u~
endfun

function! hugohelper#Draft()
    call s:set_key('draft', 'true')
endfun

function! hugohelper#Undraft()
    call s:set_key('draft', 'false')
endfun

function! hugohelper#DateIsNow()
    call s:set_key('date', s:hugo_now())
endfun

function! hugohelper#LastmodIsNow()
    call s:set_key('lastmod', s:hugo_now())
endfun

function! hugohelper#Highlight(language)
    normal! I{{< highlight language_placeholder >}}
    exe 's/language_placeholder/' . a:language . '/'
    normal! o{{< /highlight >}}
endfun

function! hugohelper#Link(link)
    let l:selection = s:get_visual_selection()
    exe ':s/\%V\(.*\)\%V\(.\)/[\0]/'
    exe "normal! gv\ef]a(link_placeholder)\e"
    exe 's/link_placeholder/' . escape(a:link, '\\/.*^~[]') . '/'
    exe "normal! gv\ef)"
endfun

function! hugohelper#HasFrontMatter()
    try
        call s:front_matter_format()
        return 1
    catch
    endtry
    return 0
endfun

function! s:get_visual_selection()
    " From https://stackoverflow.com/a/6271254/794380
    let [lnum1, col1] = getpos("'<")[1:2]
    let [lnum2, col2] = getpos("'>")[1:2]
    let lines = getline(lnum1, lnum2)
    let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfun

function! s:front_matter_format()
    let l:line = getline(1)
    if l:line =~ '+++'
        return 'toml'
    elseif l:line =~ '---'
        return 'yaml'
    else
        throw "Could not determine Hugo front matter format. Looking for +++ or ---. JSON not supported."
    endif
endfun

function! s:set_key(key, value)
    let l:format = s:front_matter_format()
    if l:format == 'toml'
        exe '1;/+++/substitute/^' . a:key . '\s*=.*/' . a:key . ' = ' . a:value
    elseif l:format == 'yaml'
        exe '1;/---/substitute/^' . a:key . '\s*:.*/' . a:key . ': ' . a:value
    else
        throw "Can't set key, value pair for unknown format " . l:format
    endif
endfun

function! s:hugo_now()
    " Contrust a time string using the format: 2018-09-18T19:41:32-07:00
    let l:time = strftime("%FT%T%z")
    return l:time[:-3] . ':' . l:time[-2:]
endfun

" vim: expandtab shiftwidth=4
