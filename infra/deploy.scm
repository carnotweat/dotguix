(use-modules
  (gnu machine) ; machine definition
  (gnu machine ssh) ; machine-ssh-configuration
  (gnu machine digital-desktop) ; digital-desktop-configurations
  (dev machine desktop)
   )

(define c-ssh
  (machine-ssh-configuration
    (host-name "178.128.203.133")
    (system "x86_64-linux")
    (host-key "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbm1/zJQzqBZAV7sVka8mGyCD1qPqAvL0/bO8G9PCNyMw5x0a+V67DWlSON4B5Mp9462NC+ezSmOkuev44q/Byql/OUUKoGNHmXf1ariHQkte7Q9gNu+Lg70g5RCcQ/ik11T3UMey6o7iX64hYL4Dr1cqXuBQ6XflGhlxR+SPxx0CsniPWNyufHCXDu7WP35u9VHt0UxLAHKmbPmvSB91GqEro/FDrnMDDs4p5j70iBn4hSqRc8dk3wdzRITnGKETtRjh8x7QKixC61dpEB0qMNe7Z8kepb1YnQy15CfihLLnG4OMiNkl54iJxBEelgeuQ4krLDPB6hvEpeSNr0jhRJlI/wzXIIQqNa5ABHWC08kIsxx9mwgRbJ2+Bsl0oJeo+drRy71z5xlUkbxL0YCLD0xRCKgf/kHOiJN+e+YdUD4bajwxSyRYZwOeExHdnrd1ES00Xfwnl7/nGdUW9DYMvov6P8uuFwv/jJEGGJgxgnXn69bQn731plGiCjiTpUs8= Android Password Store
")
    (user "root")
    ;;(identity "./keys/coin")
    (port 22)))

(define c-do
  (digital-desktop-configuration
    (region "nyc1")
    (size "s-1vcpu-1gb")
    (enable-ipv6? #f)
    (ssh-key "../keys/coin")
    (tags (list "ubuntu-s-1vcpu-1gb-nyc1-01"
      ))
      ))


(define machine-desktop 
   (machine
     (environment managed-host-environment-type)
     (configuration c-ssh)
     (operating-system  desktop-os)
   ))



(list 
  machine-desktop
  )

; this needs to be run from time to time.
; /var/lib/certbot/renew-certificates


