;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules
 (gnu)
 (gnu system nss)
 (gnu packages linux)
 (gnu packages tmux)
 (gnu packages xdisorg)
 (gnu packages gstreamer)
 (gnu packages gnome)
 (gnu packages autotools)
 (gnu packages image)
 (gnu packages shells)
 (gnu packages admin)
 (gnu packages bittorrent)
 (gnu packages authentication)
 (gnu packages tls)
 (gnu packages gnupg)
 (gnu packages cryptsetup)
 (gnu packages web-browsers) 
 (gnu packages version-control)
 (gnu packages haskell)
 (gnu packages guile-xyz)
 (gnu packages ocaml)
 (gnu packages rust)
 )
(use-service-modules cups desktop networking ssh xorg)

(use-package-modules bootloaders certs emacs emacs-xyz haskell
		     haskell-xyz ratpoison suckless wm)
(operating-system
  (locale "en_IN.utf8")
  (timezone "Asia/Kolkata")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "dev")
                  (comment "Dev")
                  (group "users")
                  (home-directory "/home/dev")
                  (supplementary-groups '("wheel" "netdev" "audio" "video")))
                %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list
		      ;; window managers
                     i3-wm i3status dmenu rofi
                     emacs 
                     ;; terminal emulator
                     st tabbed tmux fish oath-toolkit tree aria2
		     zsh emacs-vterm emacs-rustic emacs-ox-hugo
		     emacs-org-webring emacs-haskell-snippets
		     emacs-haskell-snippets emacs-org-roam
		     emacs-haskell-mode
		     ;; vcs
		     cgit
		     git
		     linux-libre-headers
		     ;;gcc-toolchain
		     libtool
		     ;;sqlite3
		     xclip
		     ;;dev
		     ghc
		     ;;hugo
		     ;;agda
		     ocaml
		     guile-hall
		     ;;rustc
		     ;;rust-rustc-rayon
		     ;;rust-cargo
		     ;; utils
		     flameshot
		     ;; auth
		     gnupg
		     pinentry
		     openssl
		     ;;system
		     cryptsetup
		     ;; browser
		      emacs-telega-server emacs-telega
		     emacs-mastodon emacs-ement emacs-nyxt
		     ;; plugins
		     gst-plugins-good
		     gst-plugins-bad
		     gst-libav
		     gst-plugins-ugly
		     gst-plugins-base
		     rhythmbox gst123
		     gstreamer
		     ;;emacs-agda2-mode
                     ;; for HTTPS access
                     nss-certs)
                    %base-packages))
		     ;; (specification->package "i3-wm")
                    ;;       (specification->package "i3status")
                    ;;       (specification->package "dmenu")
                    ;;       (specification->package "st")
                    ;;       (specification->package "nss-certs"))
                    ;; %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service openssh-service-type)
                 (service tor-service-type)
                 (service cups-service-type)
		 ;;(service cgit-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

           ;; This is the default list of services we
           ;; are appending to.
           %desktop-services))
  ;;(service cgit-service-type)
  ;;(name-service-switch %mdns-host-lookup-nss))
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (mapped-devices (list (mapped-device
                          (source (uuid
                                   "0964fce5-eb40-4bf2-bc93-8bb4675c0a11"))
                          (target "cryptroot")
                          (type luks-device-mapping))
                        (mapped-device
                          (source (uuid
                                   "81f4227a-5471-43ff-8a86-608a94168ea8"))
                          (target "crypthome")
                          (type luks-device-mapping))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "8B04-75F4"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device "/dev/mapper/cryptroot")
                         (type "ext4")
                         (dependencies mapped-devices))
                       (file-system
                         (mount-point "/home")
                         (device "/dev/mapper/crypthome")
                         (type "ext4")
                         (dependencies mapped-devices)) %base-file-systems)))
