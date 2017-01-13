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
