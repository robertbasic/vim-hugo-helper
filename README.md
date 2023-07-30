# vim-hugo-helper

A small Vim plugin to help me with writing posts with [Hugo](https://gohugo.io).

# Helpers

The following helpers are available:

## Draft

`:HugoHelperDraft` drafts the current post.

## Undraft

`:HugoHelperUndraft` undrafts the current post.

## Date is now

`:HugoHelperDateIsNow` sets the date and time of the current post to current date and time.

## Highlight

`:HugoHelperHighlight language` inserts the `highlight` block for "language" in to the current post.

## Link

`:HugoHelperLink` helps with adding links to a document. Visually select the word(s) you want to be a link, enter `:HugoHelperLink https://gohugo.io` and it will turn the selected word(s) to `[selected words](https://gohugo.io)`.

![link helper in action](https://i.imgur.com/mVPqgXs.gif)

Probably works only for markdown documents.

## Spell check

`:HugoHelperSpellCheck` toggles the spell check for the current language. Running it once, turns the spell check on. Running it again, turns it off.

You can set the language by setting the following in your `.vimrc` file:

```
let g:hugohelper_spell_check_lang = 'en_us'
```

By default it is set to `en_us`.

## Title to slug

`:HugoHelperTitleToSlug` turns the title of the Hugo post to the slug. It assumes the following two lines are present in the frontmatter:

```
+++
// frontmatter
title = "Title of the post"
// frontmatter
slug = ""
// frontmatter
+++
```

It will turn it into:

```
+++
// frontmatter
title = "Title of the post"
// frontmatter
slug = "title-of-the-post"
// frontmatter
+++
```

# Installation

## [vim-plug](https://github.com/junegunn/vim-plug)

`Plug 'robertbasic/vim-hugo-helper'`

## [Vundle](https://github.com/VundleVim/Vundle.vim)

`PluginInstall 'robertbasic/vim-hugo-helper'`
