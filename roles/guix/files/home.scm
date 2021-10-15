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
  (map specification->package '("glibc-locales" "isync" "l2md")))
 (services
  (list
   (simple-service 'global-env-vars-service
		   home-environment-variables-service-type
		   `(("GUIX_LOCPATH" . "$HOME/.guix-home/profile/lib/locale")
		     ("_JAVA_AWT_WM_NONREPARENTING" . #t)
		     ("GOPATH" . "$HOME/Projects/go")
		     ("PATH" . "$PATH:$GOPATH/bin")))
   (service home-zsh-service-type
	    (home-zsh-configuration
	     (zshrc (list (local-file "./zshrc"))))))))
