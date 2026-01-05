;;; init.el --- AdiOS Doom Emacs PKM Init -*- lexical-binding: t; -*-

(doom! :input

       :completion
       company
       (ivy +fuzzy +prescient +icons)

       :ui
       doom
       doom-dashboard
       hl-todo
       (modeline +light)
       nav-flash
       ophints
       (popup +defaults)
       treemacs
       vc-gutter
       vi-tilde-fringe
       (window-select +numbers)
       workspaces

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       multiple-cursors
       snippets
       word-wrap

       :emacs
       dired
       electric
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       (spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       (magit +forge)
       make
       pdf
       rgb

       :lang
       emacs-lisp
       markdown
       (org +roam2 +present +journal +dragndrop +pandoc)
       python
       sh
       yaml

       :config
       (default +bindings +smartparens))