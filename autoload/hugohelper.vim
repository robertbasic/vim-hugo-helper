function! hugohelper#HugoHelperSpellCheck()
    exe "setlocal spell! spelllang=" . g:hugohelper_spell_check_lang
endfun

function! hugohelper#HugoHelperDraft()
    exe 'g/^draft/s/false/true'
endfun

function! hugohelper#HugoHelperUndraft()
    exe 'g/^draft/s/true/false'
endfun

function! hugohelper#HugoHelperDateIsNow()
    exe 'g/^date/s/".*"/\=strftime("%FT%T%z")/'
    normal! $a"
    normal! Bi"
    normal! f+2la:
endfun

function! hugohelper#HugoHelperHighlight(language)
    normal! I{{< highlight language_placeholder >}}
    exe 's/language_placeholder/' . a:language . '/'
    normal! o{{< /highlight >}}
endfun

function! hugohelper#HugoHelperLink(link)
    let l:selection = hugohelper#get_visual_selection()
    exe ':s/\%V\(.*\)\%V\(.\)/[\0]/'
    exe "normal! gv\ef]a(link_placeholder)\e"
    exe 's/link_placeholder/' . escape(a:link, '\\/.*^~[]') . '/'
    exe "normal! gv\ef)"
endfun

function! hugohelper#get_visual_selection()
	" From http://stackoverflow.com/a/6271254/794380
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]
	let lines = getline(lnum1, lnum2)
	let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]
    return join(lines, "\n")
endfun
