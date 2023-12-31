(use-modules (guix monads)
             (ice-9 ftw)
             (ice-9 textual-ports))

(define (build-derivation monadic-drv)
  (with-store store
    (run-with-store store
      (mlet* %store-monad ((drv monadic-drv))
        (mbegin %store-monad
          ;; BUILT-DERIVATIONS is the monadic version of BUILD-DERIVATIONS.
          (built-derivations (list drv))
          (return (derivation-output-path
                   (assoc-ref (derivation-outputs drv) "out"))))))))
                   
(define world-greeting-output
  (build-derivation
   (gexp->derivation "world-greeting"
     #~(begin
         (mkdir #$output)
         (symlink #$(plain-file "hi-world"
                      "Hi, world!")
                  (string-append #$output "/hi"))
         (symlink #$(plain-file "hello-world"
                      "Hello, world!")
                  (string-append #$output "/hello"))
         (symlink #$(plain-file "greetings-world"
                      "Greetings, world!")
                  (string-append #$output "/greetings"))))))

;; We turn the list into multiple values using (APPLY VALUES …).
(apply values
       (map (lambda (file-path)
              (let* ((path (string-append world-greeting-output "/" file-path))
                     (contents (call-with-input-file path get-string-all)))
                (list path contents)))
            ;; SCANDIR from (ICE-9 FTW) returns the list of all files in a
            ;; directory (including ``.'' and ``..'', so we remove them with the
            ;; second argument, SELECT?, which specifies a predicate).
            (scandir world-greeting-output
                     (lambda (path)
                       (not (or (string=? path ".")
                                (string=? path "..")))))))
⇒ ("/gnu/store/…-world-greeting/greetings" "Greetings, world!")
⇒ ("/gnu/store/…-world-greeting/hello" "Hello, world!")
⇒ ("/gnu/store/…-world-greeting/hi" "Hi, world!")
