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

;;; Themeing & UI

;; Dracula theme
(use-package dracula-theme)
(load-theme 'dracula t)

;; Vim bindings
(use-package evil)
(require 'evil)
(evil-mode 1)

;; Line numbers
(global-display-line-numbers-mode)

;; Which key
(use-package which-key
    :config
    (which-key-mode))

;;; Programming Languages

;; Typescript
(use-package typescript-mode
  :mode "\\.ts\\'" ; TODO tsx?
  :hook (typescript-mode . lsp-deferred)
  :config
  (setq typescript-indent-level 2))

;; YAML
(use-package yaml-mode)

;; Language server protocol
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :hook ((lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(yaml-mode use-package-ensure-system-package exec-path-from-shell lsp-mode typescript-mode which-key use-package evil dracula-theme)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
