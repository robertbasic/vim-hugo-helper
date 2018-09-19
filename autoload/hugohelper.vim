function! hugohelper#HugoHelperSpellCheck()
    exe "setlocal spell! spelllang=" . g:hugohelper_spell_check_lang
endfun

function! hugohelper#HugoHelperTitleToSlug()
    normal gg
    exe '/^title'
    normal! vi"y
    exe '/^slug'
    normal! f"pVu
    " Not sure why I can't make \%V work here
    exe ':s/ /-/g'
    exe 'normal! f-r f-r '
endfun

function! s:yaml_set_key(key, value)
    " Assume yaml mode has been detected, which means line 1 is the starting
    " --- marker. Search for the key only in the range of the yaml markers.
    exe '1;/---/substitute/^' . a:key . '\s*:.*/' . a:key . ': ' . a:value
endfun

function! hugohelper#HugoHelperDraft()
    let l:format = s:front_matter_format()
    if l:format == 'toml'
        exe 'g/^draft\s*=/s/false/true'
    elseif l:format == 'yaml'
        call s:yaml_set_key('draft', 'true')
    endif
endfun

function! hugohelper#HugoHelperUndraft()
    let l:format = s:front_matter_format()
    if l:format == 'toml'
        exe 'g/^draft\s*=/s/true/false'
    elseif l:format == 'yaml'
        call s:yaml_set_key('draft', 'false')
    endif
endfun

function! s:hugo_now()
    " Contrust a time string using the format: 2018-09-18T19:41:32-07:00
    let l:time = strftime("%FT%T%z")
    return l:time[:-3] . ':' . l:time[-2:]
endfun

function! s:date_is_now(key)
    let l:format = s:front_matter_format()
    if l:format == 'toml'
        exe 'g/^' . a:key . '\s*=.*/s//\=strftime("%FT%T%z")/'
        exe 'normal! I' . a:key . ' = '
        normal! $2ha:
    elseif l:format == 'yaml'
        call s:yaml_set_key(a:key, s:hugo_now())
    endif
endfun

function! hugohelper#HugoHelperDateIsNow()
    call s:date_is_now( 'date')
endfun

function! hugohelper#HugoHelperLastmodIsNow()
    call s:date_is_now('lastmod')
endfun

function! hugohelper#HugoHelperHighlight(language)
    normal! I{{< highlight language_placeholder >}}
    exe 's/language_placeholder/' . a:language . '/'
    normal! o{{< /highlight >}}
endfun

function! hugohelper#HugoHelperLink(link)
    let l:selection = s:get_visual_selection()
    exe ':s/\%V\(.*\)\%V\(.\)/[\0]/'
    exe "normal! gv\ef]a(link_placeholder)\e"
    exe 's/link_placeholder/' . escape(a:link, '\\/.*^~[]') . '/'
    exe "normal! gv\ef)"
endfun

function! s:get_visual_selection()
    " From http://stackoverflow.com/a/6271254/794380
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

" vim: expandtab shiftwidth=4
