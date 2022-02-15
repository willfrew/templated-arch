(use-modules ((guix gexp)
	      #:select (local-file))
	     ((gnu services)
	      #:select (service
			simple-service))
	     ((gnu packages)
	      #:select (specification->package))
	     ((gnu home)
	      #:select (home-environment))
	     ((gnu home services)
	      #:select (home-environment-variables-service-type))
	     ((gnu home services shells)
	      #:select (home-zsh-service-type
			home-zsh-configuration)))

(home-environment
 (packages
  (map specification->package
       '(;; Guix need explicitly installed locales.
         "glibc-locales"
         ;; Email search & UI
         "notmuch"
         "emacs-notmuch"
         ;; Email sync tool.
         "isync"
         ;; Mailing list archive downloader.
         "l2md"
         )))
 (services
  (list
   ;; Env vars
   (simple-service
    'global-env-vars-service
    home-environment-variables-service-type
    `(
      ;; Tell guix where to find locale files.
      ("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale")
      ;; Fixes java-gui windows from blanking in tiling window managers.
      ("_JAVA_AWT_WM_NONREPARENTING" . "1")
      ;; Setup PATH(/GOPATH) for go development.
      ("GOPATH" . "$HOME/Projects/go")
      ("PATH" . "$PATH:$GOPATH/bin")))
   ;; Zsh
   (service home-zsh-service-type
            (home-zsh-configuration
             (zshrc (list (local-file "./zshrc"))))))))
