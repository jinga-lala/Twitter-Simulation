#lang racket
(provide (all-defined-out))
(require racket/gui/base)
(define starting-Time (current-seconds))

(struct Post (Content Time Reply-list U-ID P-ID) #:transparent)     ; U-ID - userid of banda jiski post hai
;Reply-list is a list of structs Reply-list
(struct Reply (User-id Content Time) #:transparent)
(define Sab (make-hash))
(define Database (make-hash))
(define (print-everyone)
  (hash-map Database (lambda(x y) (display x)
                       (display " -- ") (display y)
                       (newline))))

(define (notify racro jinga-lala lst)
  (begin
    (map (lambda (x) (send (hash-ref Sab x) change-notify racro jinga-lala)) lst)
    (void)))

(define (DD txt)
    (define D (new dialog%
                   [label ""]
                   [width 300]
                   [height 100]))
   
    (define (draw1 dc txt)
      (send dc set-text-foreground "red")
      (send dc draw-text txt 20 20))
       
    
    (define c (new canvas%
                   [parent D]
                   [label "hi"]
                   [paint-callback (lambda(c dc) (draw1 dc txt))]))
   
    (send D show #t))


(define post-id-counter 0)
(define account%
  (class object%
   
    (init Firstname)
    (init Lastname)
    (init u-id)
    (init passwd)
    (init-field photo)
    (init dob)
    (init gender)
    (super-new)
    (define logged 0)
    (define notif-bool 0)
    (define Pehla-name Firstname)
    (define aakhri-name Lastname)
    (define user-name (string-append Pehla-name " " aakhri-name)) 
    (define user-id u-id)
    (define password passwd)
    (define DOB dob)
    (define GENDER gender)
    (hash-set! Database user-id user-name)
    (define post-bank (make-hash))
    (define follow-k (list user-id))
    (define follow-h '())
    (define notifications-list '())
    
    (define/public (change-notify racro jinga-lala)    ; jiski-post-hai - racro, jisne-dali = jinga-lala
      (begin (set! notifications-list(cons (cons racro jinga-lala) notifications-list))
             (set! notif-bool 1)
             (void)))
    
    (define (new-post c)
      (set! post-id-counter (+ 1 post-id-counter))
      (let* ([stru (Post c (- (current-seconds) starting-Time) '() user-id post-id-counter)])
        (hash-set! post-bank post-id-counter stru)))
    
    (define (new-reply c post-id user-jiski-post)
      (let* ([s (Reply user-id c (- (current-seconds) starting-Time))]
             [lst (cons user-jiski-post (send (hash-ref Sab user-jiski-post) update-bank post-id s))]) ;a public fn that updates parent post struct
        (notify user-jiski-post user-id (remove1 (remove-duplicates lst)))))

    (define (remove1 lst)
      (append* (map (lambda(x) (if (equal? (hash Sab x) user-id) '() (list x))) lst)))

    (define/public (update-bank post-id reply-struct)
      (let*([s (hash-ref post-bank post-id)]
            [ls (map (lambda(x) (Reply-User-id x)) (Post-Reply-list s))])
        (begin (hash-set! post-bank post-id (Post (Post-Content s)
                                                  (Post-Time s)
                                                  (append (Post-Reply-list s) (list reply-struct))
                                                  (Post-U-ID s)
                                                  (Post-P-ID s)))
               ls)))

    (define/public (login u pwd)
      (if (and (equal? u user-id)
               (equal? pwd password))
          (set! logged 1)
          (begin (DD "Wrong username or password"))))
    (define/public (dispatch m) 
      (if (= logged 1)
          (cond [(equal? m "new-post") new-post]
                [(equal? m "new-reply") new-reply]
                [(equal? m "Print-feed") (Print-feed)]
                [(equal? m "Logout") (set! logged 0)]
                [(equal? m "Follow-k") Follow-k])
          (DD "Login first"))) 


    ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


    (define (Follow-k zinga-lala)
      (begin (set! follow-k (cons zinga-lala follow-k))
             (send (hash-ref Sab zinga-lala) Follow-h user-id)))     ; updates follow-h list of zinga-lala with racro
    ; Follow-h will be public

    (define/public (Follow-h racro)
      (set! follow-h (cons racro follow-h)))

    (define (Print-feed)     ; returns list of post structs
      (define list-of-structs (list ))
  
      (define (obtain-post-bank l1)    ; l1 = follow-k , obtain-post-bank = collect posts of all users which racro follows-k
        (cond [(null? l1) list-of-structs]
              (else (begin (set! list-of-structs (append list-of-structs (send (hash-ref Sab (car l1)) get-post-struct)))
                           (obtain-post-bank (cdr l1))))))   ; define get-post-struct ; we can even sort ever user's post bank and take top 5 from them

      (define l (obtain-post-bank follow-k))
  
      (define (obtain-time lst)  ; lst = (list of post-bank-structs)
        (sort (map (lambda (x) (Post-Time x)) lst) <))
  
      (define (sorted-list l1 l2)    ; l2 = (obtain-time lst) , l1= (list of post-bank-structs)
        (cond [(null? l2) (list )]
              [(equal? (Post-Time (car l1)) (car l2)) (cons (car l1) (sorted-list (remove (car l1) l) (cdr l2)))]
              (else (sorted-list (cdr l1) l2))))
  
      (define (pick-max lst upper-limit k)    ; k=1
        (cond [(null? lst) (list )]
              [(= k upper-limit) (list )]
              (else (cons (car lst) (pick-max (cdr lst) upper-limit (+ k 1))))))
  
      (sorted-list l (pick-max (obtain-time l) 20 1)))    ;give upper limit as per your desire; upper-limit=20

    (define/public (get-post-struct)
      (hash-map post-bank (lambda (x y) y)))
    (define/public (get-post-bank)
      post-bank)
    (define/public (get-follow-h)
      follow-h)
    (define/public (get-follow-k)
      follow-k)
    (define/public (get-user-id)
      user-id)
    (define/public (get-notification-list)
      (let ([lt notifications-list])
      (cond [(= notif-bool 1) (begin (set! notif-bool 0) (set! notifications-list '()) lt)]
            (else '()))))
    (define/public (get-dob)
      DOB)
    (define/public (get-user-name)
      user-name)
    (define/public (get-gender)
      GENDER)
    (define/public (get-login-status)
      logged)
     ))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;Sample Accounts
(define a
  (new account%
       [Firstname "Yash"]
       [Lastname "Jain"]
       [u-id "yj"]
       [passwd "yj"]
       [photo 1]
       [dob "03/05/1999"]
       [gender "Male"]))
(define b
  (new account%
       [Firstname "Ritik"]
       [Lastname "Roongta"]
       [u-id "rr"]
       [passwd "rr"]
       [photo 1]
       [dob "20/10/1999"]
       [gender "Male"]))
(define c
  (new account%
       [Firstname "Sagar"]
       [Lastname "Kalsaria"]
       [u-id "sk"]
       [passwd "sk"]
       [photo 1]
       [dob "28/08/1999"]
       [gender "Male"]))
(hash-set! Sab "yj" a)
(hash-set! Sab "rr" b)
(hash-set! Sab "sk" c)


