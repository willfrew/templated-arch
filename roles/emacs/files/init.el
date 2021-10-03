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

;; Vim bindings
(use-package evil
  :config
  (require 'evil)
  (evil-mode 1))

;; Line numbers
(global-display-line-numbers-mode)

;; Allow quitting with ESC key
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Which key
(use-package which-key
    :config
    (which-key-mode))

;; Completion
(use-package flx) ; Fuzzy matching
(use-package ivy
  :diminish ivy-mode
  :after flx
  :config
  (ivy-mode 1)
  (setq ivy-re-builders-alist
	'((t . ivy--regex-fuzzy))))

;; Replace common emacs functions with ivy-optimised ones
(use-package counsel
  :diminish counsel-mode
  :after ivy
  :config
  (counsel-mode 1))

;;; Project management & VCS

(defconst
  wf-project-root
  "~/Projects"
  "Root directory for all projects")

(defconst
  wf-project-autodiscover-depth
  3
  "Auto-discover projects recursively within the project root directory to this depth")

; Project indexing, search & command runner
(use-package projectile
  :diminish projectile-mode
  :bind (:map projectile-mode-map
              ("C-c p" . projectile-command-map))
  :config
  (setq projectile-project-search-path `((,wf-project-root . ,wf-project-autodiscover-depth)))
  (projectile-mode 1))

; Git interface
(use-package magit)

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

;; YAML
(use-package yaml-mode)

;; Scheme
(use-package geiser)
(use-package geiser-guile
  :after geiser)

;;; Programming Helpers

;; Editing tools for lisp(s)
(use-package paredit
  ; TODO add hooks https://www.emacswiki.org/emacs/ParEdit
  )

;; TODO company-mode / counsel-company (ivy)
;; http://company-mode.github.io/

;; Colour-matched delimiters
(use-package rainbow-delimiters
  :hook ((prog-mode . rainbow-limiters-mode)))

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
