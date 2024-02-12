;; -*- mode: scheme; -*-
;; This is an operating system configuration template
;; for a "desktop" setup without full-blown desktop
;; environments.

(use-modules (gnu) (gnu system nss) (nongnu packages linux))
(use-service-modules desktop xorg sddm nix)
(use-package-modules linux bootloaders certs emacs display-managers wm 
                     xorg xdisorg terminals shells zig-xyz image freedesktop package-management)

(operating-system
 (kernel linux)
 (label "A Fresh Start")
 (firmware  (list linux-firmware))
 (host-name "mimisbrunnr")
 (timezone "Europe/Paris")
 (locale "fr_FR.utf8")
 (keyboard-layout (keyboard-layout "fr"))
 
 ;; Use the UEFI variant of GRUB with the EFI System
 ;; Partition mounted on /boot/efi.
 (bootloader (bootloader-configuration
              (bootloader grub-efi-bootloader)
              (targets '("/boot/efi"))))
 
 ;; Assume the target root file system is labelled "my-root",
 ;; and the EFI System Partition has UUID 1234-ABCD.
 (file-systems (append
                (list (file-system
                       (device (file-system-label "yggdrasil"))
                       (mount-point "/")
                       (type "ext4"))
                      (file-system
                       (device (file-system-label "hvergelmir"))
                       (mount-point "/boot/efi")
                       (type "vfat")))
                %base-file-systems))
 
 (users (cons (user-account
               (name "jheyrree")
               (comment "Jheyrree")
               (home-directory "/home/nous")
               (group "users")
	       (shell (file-append zsh "/bin/zsh"))
               (supplementary-groups '("wheel" "netdev"
                                       "audio" "video" "lp")))
              %base-user-accounts))
 
 ;; Add a bunch of window managers; we can choose one at
 ;; the log-in screen with F1.
 (packages (append (list
                    ;; window managers
                    sway emacs-no-x waybar swaybg
                    river sxhkd rofi-wayland swaylock
                    fnott tofi grim wayland
                    ;; terminal emulator
                    foot
                    ;; bluetooth
                    bluez
                    ;; for HTTPS access
                    nss-certs
                    ;; other services
                    nix
                    )
                   %base-packages))
 
 ;; Use the "desktop" services, which include the X11
 ;; log-in service, networking with NetworkManager, and more.
 (services (append (list
		    (simple-service 'my-bluetooth-service bluetooth-service-type
				    (list
				    (bluetooth-configuration (name "yggdrasil"))))
		   ; (service bluetooth-service-type (bluetooth-configuration
		       
		    (service greetd-service-type
			     (greetd-configuration
			      (greeter-supplementary-groups '("video" "input"))
			      (terminals
			       (list (greetd-terminal-configuration
				      (terminal-vt "1")
				      (terminal-switch #t)
				      (default-session-command
					(greetd-agreety-session
					 (command (file-append river "/bin/river"))
					 (command-args '())
					 (extra-env '(("XKB_DEFAULT_LAYOUT" . "fr"))))))
				     (greetd-terminal-configuration
				      (terminal-vt "2"))
				     (greetd-terminal-configuration
				      (terminal-vt "3"))
				     (greetd-terminal-configuration
				      (terminal-vt "4"))
				     (greetd-terminal-configuration
				      (terminal-vt "5"))
				     (greetd-terminal-configuration
				      (terminal-vt "6"))
				     (greetd-terminal-configuration
				      (terminal-vt "7"))
				     (greetd-terminal-configuration
				      (terminal-vt "8"))
				     (greetd-terminal-configuration
				      (terminal-vt "9"))
				     ))))

		    (service file-database-service-type)

		    (service package-database-service-type)

		    (service cups-service-type
			     (cups-configuration
			      (web-interface? #t)
			      (extensions
			       (list cups-filters hplip-minimal))))

            (service nix-service-type)

		    (service screen-locker-service-type
			     (screen-locker-configuration
			      (name "swaylock")
			      (program (file-append swaylock "/bin/swaylock"))
			      (allow-empty-password? #t)
			      (using-pam? #t)
			      (using-setuid? #f)))
		    )
		   (modify-services %desktop-services (delete gdm-service-type)
				    (delete login-service-type)
				    (delete mingetty-service-type))))
 
 ;; Allow resolution of '.local' host names with mDNS.
 (name-service-switch %mdns-host-lookup-nss))
