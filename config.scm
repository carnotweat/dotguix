;;- TODO- split as base-os.scm+user.scm+module.scm
(use-modules
 (gnu)
 (gnu system nss)
 (nongnu packages linux)
 )

(use-service-modules sysctl admin monitoring admin networking nix cups desktop ssh xorg cgit security-token )

(use-package-modules shells rust ocaml guile-xyz haskell version-control web-browsers cryptsetup gnupg dns tls authentication bittorrent admin shells image autotools gnome
screen ssh tmux bootloaders certs emacs emacs-xyz haskell vpn avahi gstreamer xdisorg linux haskell-xyz ratpoison suckless wm certs )

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
	  cgit git
	  linux-libre-headers
	  nss-mdns
	  ;;gcc-toolchain
	  libtool
	  ;;dev
	  ghc ocaml guile-hall
	  ;; utils
	  flameshot xclip
	  ;; auth
	  gnupg pinentry openssl cryptsetup badvpn  
	  network-manager-openvpn openvpn wireguard-tools
	  
	  ;; browser
	  emacs-telega-server emacs-telega
	  emacs-mastodon emacs-ement emacs-nyxt
	  ;; plugins
	  gst-plugins-good gst-plugins-bad
	  gst-plugins-base gst-libav
	  gst-plugins-ugly gst-plugins-base
	  rhythmbox gst123 gstreamer
          ;; for HTTPS access
          nss-certs)
     ;;(cons (list isc-bind "utils")
     %base-packages))
   
  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append (list	    
	    (service openssh-service-type
                     (openssh-configuration
                      (openssh openssh-sans-x)
                      (port-number 2222)))
	   (service tor-service-type)
           (service cups-service-type)
	   (service nix-service-type)
	   (service cgit-service-type)
           (set-xorg-configuration
            (xorg-configuration (keyboard-layout keyboard-layout))))
	   ;;%desktop-services))
             (modify-services %desktop-services
             (elogind-service-type
               config =>
                 (elogind-configuration
		   (inherit config)
                   (handle-power-key 'suspend)
                   (handle-lid-switch-external-power 'suspend))))))
	    ;;bootloader
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


  ;;(kernel-arguments (list "console=ttyS0,115200"))
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
;; (swap-devices (list (swap-space
;;                        (target "/swapfile"))))

