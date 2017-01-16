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

![link helper in action](http://i.imgur.com/mVPqgXs.gif)

Probably works only for markdown documents.

# Installation

Using [vim-plug](https://github.com/junegunn/vim-plug):

`Plug 'robertbasic/vim-hugo-helper'`
