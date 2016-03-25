if exists('g:loaded_hugo_helper') || &cp
  finish
endif
let g:loaded_hugo_helper = 1

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

function! HugoHelperDraft()
    exe 'g/^draft/s/false/true'
endfun

function! HugoHelperUndraft()
    exe 'g/^draft/s/true/false'
endfun

function! HugoHelperDateIsNow()
    exe 'g/^date/s/".*"/\=strftime("%FT%T%z")/'
    normal! $a"
    normal! Bi"
    normal! f+2la:
endfun

function! HugoHelperHighlight(language)
    normal! I{{< highlight language_placeholder >}}
    exe 's/language_placeholder/' . a:language . '/'
    normal! o{{< /highlight }}
endfun
