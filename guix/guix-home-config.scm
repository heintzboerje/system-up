;; This is a sample Guix Home configuration which can help setup your
;; home directory in the same declarative manner as Guix System.
;; For more information, see the Home Configuration section of the manual.
(define-module (guix-home-config)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu services)
  #:use-module (gnu system shadow)
  #:use-module (gnu packages)
  #:use-module (guix gexp)
  #:use-module (gnu packages shellutils))

(define home-config
  (home-environment
    (services
      (list
        ;; Uncomment the shell you wish to use for your user:
        ;(service home-bash-service-type)
        ;(service home-fish-service-type)
       (service home-zsh-service-type
		(home-zsh-configuration
		 (environment-variables '(
					 ("HISTFILE" . "$HOME/.zhistory")
					 ("share_history" . #t)))
		 (zshrc (list (mixed-text-file "liquidprompt"
					       "[[ $- = *i* ]] && source " liquidprompt "/share/liquidprompt/liquidprompt")
			      (mixed-text-file "zsh-autosugestions"
					       ". " zsh-autosuggestions "/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh")
			      (mixed-text-file "zsh-syntax-highlighting"
					       ". " zsh-syntax-highlighting "/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh")
			      (mixed-text-file "zsh-completions"
					       "fpath=(" zsh-completions "/src $fpath)")
			      ))))

        (service home-files-service-type
         `((".guile" ,%default-dotguile)
           (".Xdefaults" ,%default-xdefaults)))

        (service home-xdg-configuration-files-service-type
         `(("gdb/gdbinit" ,%default-gdbinit)
           ("nano/nanorc" ,%default-nanorc)))

	(simple-service 'my-home-config home-profile-service-type
			 (map specification->package '("btop"
				   "qutebrowser" "wev" "zsh-syntax-highlighting"
				   "zsh-completions" "zsh-autosuggestions"
				   "zsh-history-substring-search" "brightnessctl"
				   "pamixer" "playerctl" "libnotify" "scrot"
				   "swayidle" "python-pywal" "imagemagick"
				   "git" "font-awesome" "libreoffice"
				   "liquidprompt" "vifm" "zathura" "zathura-pdf-mupdf"
				   "zathura-djvu" "zathura-ps" "zathura-cb" "gpodder"
				   "python"
				   )))))))

home-config
