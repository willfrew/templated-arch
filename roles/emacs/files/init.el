(setq inhibit-startup-message t)

(scroll-bar-mode -1) ; Disable scrollbar
(tool-bar-mode -1) ; Disable toolbar
(tooltip-mode -1) ; Disable tooltip
(set-fringe-mode 10) ; ?

(menu-bar-mode -1) ; Disable menu bar

;; Allow quitting with ESC key
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

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
(setq use-package-always-ensure t) ; Always pull packages if not available

;; Dracula theme
(use-package dracula-theme)
(load-theme 'dracula t)

;; Vim bindings
(use-package evil)
(require 'evil)
(evil-mode 1)

;; Line numbers
(global-display-line-numbers-mode)
