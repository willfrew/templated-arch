(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable scrollbar
(tool-bar-mode -1) ; Disable toolbar
(tooltip-mode -1) ; Disable tooltip
(set-fringe-mode 10) ; ?

(menu-bar-mode -1) ; Disable menu bar

;; Initialise package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
;; Reload package database
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install use package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)

;; Always pull packages if not available
;; TODO pin versions of packages
(setq use-package-always-ensure t)

;;; Themeing & UI

;; Dracula theme
(use-package dracula-theme)
(load-theme 'dracula t)

;; Hide common modes
(use-package diminish)

;; Line numbers
(global-display-line-numbers-mode)

;; Highlight trailing whitespace
(setq-default show-trailing-whitespace t)

;; Always follow output in compilation buffers
(setq compilation-scroll-output t)

;; Open help windows in a side window
(customize-set-variable
 'display-buffer-alist
 '(("\\*\\(Help\\|Apropos\\)\\*"
    display-buffer-in-side-window
    (side . right))))

;; Always select help windows after they open
(customize-set-variable 'help-window-select t)

;;; Key bindings

;; Vim bindings
(use-package evil
  :init
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  ; TODO
  ;:custom
  ;(evil-undo-system 'undo-redo)
  :config
  (require 'evil)
  (evil-mode 1)
  ;; Better movement in info-mode
  (define-key Info-mode-map (kbd "l") 'evil-forward-char)
  (define-key Info-mode-map (kbd "h") 'evil-backward-char))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; Always spaces
(setq-default indent-tabs-mode nil)

;; Display available key combinations mid-entry
(use-package which-key
  :config
  (which-key-mode))

;; Show last entered
(use-package keycast
  :config
  (setq keycast-remove-tail-elements nil)
  (setq keycast-separator-width 1)
  ()
  (keycast-mode 1))

;;; Completion

;; Completion(ivy) & search(swiper)
(use-package ivy
  :diminish ivy-mode
  :after flx evil
  :config
  (ivy-mode 1)
  (setq ivy-re-builders-alist
        '((t . ivy--regex-fuzzy)))
  ;; Remap evil's default search to use swiper instead
  (define-key evil-normal-state-map (kbd "/") 'swiper))

;; Better sorting for fuzzy-matched swiper(ivy) results
(use-package flx
  :config
  (require 'flx))

;; Replace common emacs functions with ivy-optimised ones
(use-package counsel
  :diminish counsel-mode
  :after ivy
  :config
  (counsel-mode 1))

;; Inline completion
(use-package company
  :config
  (company-mode 1))

;;; Terminal Emulation

(defun wf-configure-repl ()
  "Configure repl-style modes"
  (display-line-numbers-mode 0)
  (setq show-trailing-whitespace f))

(use-package vterm
  :init (setq vterm-always-compile-module t)
  :hook ((vterm-mode . #'wf-configure-repl))
  :bind (:map vterm-mode-map)
  :config
  ; Disable vim key bindings in the shell
  (evil-set-initial-state 'vterm-mode 'emacs))

(defun wf-new-terminal ()
  "Split the current window and spawn a new terminal in one of them"
  (interactive)
  (evil-window-vsplit)
  (multi-vterm))

(use-package multi-vterm
  :after vterm
  :config
  (global-set-key (kbd "M-RET") 'wf-new-terminal))

;;; Project management & VCS

(defconst
  wf-project-root
  "~/Projects"
  "Root directory for all projects")

(defconst
  wf-project-autodiscover-depth
  3
  "Auto-discover projects recursively within the project root directory to this depth")

;; Project indexing, search & command runner
(use-package projectile
  :diminish projectile-mode
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path `((,wf-project-root . ,wf-project-autodiscover-depth))))

;; Git interface
(use-package magit)

;; Human readable units for dired
(setq-default dired-listing-switches "-alh")
;; Recursive copy by default
(setq dired-recursive-copies 'always)

;;; Programming Languages

;; Language server protocol
(use-package lsp-mode
  :init
  (setq lsp-keymap-prefix "C-c l")
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; Typescript
(use-package typescript-mode
  :mode "\\.tsx?\\'"
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; Scheme/Guile
(use-package geiser)
(use-package geiser-guile
  :after geiser)
;; TODO this does make guile aware of the guix sources, but they're not really
;; usable as the guile load path is not properly set for other sources installed by guix.
(with-eval-after-load 'geiser-guile
  (add-to-list 'geiser-guile-load-path
	       (concat wf-project-root "/savannah/guix")))

;; Guix
(use-package guix
  :hook ((scheme-mode . guix-devel-mode)))

;; Haskell
(use-package haskell-mode)
(use-package lsp-haskell
  :hook ((haskell-mode . lsp)
	 (haskell-literate-mode . lsp)))

;;; Markup & configuration languages

;; YAML
(use-package yaml-mode)

;; Udev rules
(use-package udev-mode)

;;; Programming Helpers

;; Editing tools for lisp(s)
;; See here for cheatsheet:
;;   http://pub.gajendra.net/src/paredit-refcard.pdf
(use-package paredit
  :hook ((emacs-lisp-mode scheme-mode lisp-mode) . paredit-mode))

;; Colour-matched delimiters
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-delimiters-mode)))

;;; Note-taking & knowledge management

(use-package org
  :config
  ; Open org mode files with headings collapsed
  (setq org-startup-folded "fold"))

(use-package org-roam
  :after org
  :custom
  ; TODO ensure org-files repo is checked out here
  (org-roam-directory "~/org-files/")
  :bind (("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ("C-c n f" . org-roam-node-find)
         ("C-c n l" . org-roam-buffer-toggle)
         ("C-c n g" . org-roam-graph)
         ("C-c n j" . org-roam-dailies-capture-today))
  :config
  (setq org-roam-v2-ack t)
  (org-roam-db-autosync-mode))
