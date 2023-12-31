service
 cgit-service-type
 (cgit-configuration
  (enable-git-config? #t)
  (remove-suffix? #t)
  (root-title "git.example.com")
  (clone-prefix (list "https://git.example.com";))
  (strict-export "git-daemon-export-ok")
  (nginx
   (list
    (nginx-server-configuration
     (server-name '("git.example.com"))
     (root cgit)
     (locations
      (list
       (git-http-nginx-location-configuration
        (git-http-configuration (uri-path "/")))
       (nginx-location-configuration
        (uri "@cgit")
        (body '("fastcgi_param SCRIPT_FILENAME 
$document_root/lib/cgit/cgit.cgi;"
                "fastcgi_param PATH_INFO $uri;"
                "fastcgi_param QUERY_STRING $args;"
                "fastcgi_param HTTP_HOST $server_name;"
                "fastcgi_pass 127.0.0.1:9000;")))))
     (try-files (list "$uri" "@cgit"))
     (ssl-certificate "/etc/letsencrypt/live/example.com/fullchain.pem")
     (ssl-certificate-key "/etc/letsencrypt/live/example.com/privkey.pem"))))))

