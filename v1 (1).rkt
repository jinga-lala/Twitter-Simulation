#lang racket

(require racket/gui/base racket/draw (prefix-in i 2htdp/image))
(require "twitter-new.rkt")

(define (clear field-name)
  (send (send field-name get-editor) erase))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define image (read-bitmap "ritikpic.jpg"))
(define scene (read-bitmap "image/scene.jpg"))


(define frame1 (new frame%
                    [label "intro"]
                    [height 400]
                    [width 600]
                    [x 400]
                    [y 150]
                    [stretchable-width #t]
                    [stretchable-height #t]))

(define h-plane (new horizontal-panel%
                     [parent frame1]
                     [alignment '(center center)]))

(define canvas (new canvas%
                    [parent h-plane]
                    [style (list 'border)]
                    [min-height 400]
                    [min-width 350]
                    [paint-callback (lambda(c dc) (draw dc))]))

(define v-plane (new vertical-panel%
                     [parent h-plane]
                     [alignment '(left center)]))

(define h-plane3 (new horizontal-panel%
                      [parent v-plane]))

(define login-id (new text-field%
                      [parent v-plane]
                      [label "UserID      "]
                      [style (list 'single)]))

(define login-password (new text-field%
                            [parent v-plane]
                            [label "Password "]
                            [style (list 'single 'password)]))

(define h-plane2 (new horizontal-panel%
                      [parent v-plane]
                      [alignment '(center top)]))

(define login-button (new button%
                          [parent h-plane2]
                          [label "Login"]
                          [callback (lambda (button event)
                                      (cond  [(or (equal? (send login-id get-value) "") (equal? (send login-password get-value) ""))
                                              (DD "Invalid Username or Password")]
                                             [(hash-has-key? Sab (send login-id get-value))
                                              (begin (send (hash-ref Sab (send login-id get-value)) login (send login-id get-value) (send login-password get-value)) 
                                                     (if (= (send (hash-ref Sab (send login-id get-value)) get-login-status) 1)
                                                         (begin (f3 (send login-id get-value) #t)
                                                                (clear login-id)
                                                                (clear login-password)
                                                                (send frame1 show #f))
                                                         (begin (clear login-id)
                                                                (clear login-password))))]
                                             [else (DD "Check your Password")]))]))

(define signup-button (new button%
                           [parent h-plane2]
                           [label "SignUp"]
                           [callback (lambda (mouse event) (f2 #t) (send frame1 show #f))]))

(send frame1 show #t)

(define drawing-brush (new brush% [color "black"]))
(send drawing-brush set-stipple image)

(define (draw dc)
  (send dc set-brush drawing-brush)
  (send dc draw-rectangle 0 0 400 400))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;(define txt (itext/font "All fields are compulsory" 18 "red"
;                          #f 'roman 'normal 'normal #t)) 
(define (f2 b)
  (define drawing-brush (new brush% [color "black"]))
  (send drawing-brush set-stipple scene)

  (define (draw1 dc)
    (send dc set-brush drawing-brush)
    (send dc draw-rectangle 0 0 600 600))
  
  (define frame2 (new frame%
                      [label "SignUp"]
                      [height 400]
                      [width 600]
                      [alignment '(center center)]
                      [x 400]
                      [y 150]
                      [stretchable-width #t]
                      [stretchable-height #t]))
  
  (define horiz-plane1 (new horizontal-panel%
                            [parent frame2]))
  
  (define canvas-left (new canvas%
                           [parent horiz-plane1]
                           [style (list 'border)]
                           [min-height 400]
                           [min-width 130]
                           [paint-callback (lambda (c dc) (draw1 dc))]))
  
  (define vert-plane1 (new vertical-panel%
                           [parent horiz-plane1]
                           [alignment '(center center)]))
  
  (define horiz-plane3 (new horizontal-panel%
                            [parent  vert-plane1]
                            [alignment '(center bottom)]))
  
  (define First-name (new text-field%
                          [parent vert-plane1]
                          [label "Firstname "]
                          [style (list 'single)]))
  
  (define Last-name (new text-field%
                         [parent vert-plane1]
                         [label "Lastname "]
                         [style (list 'single)]))
  
  (define Gender (new radio-box%
                      [label "Gender    "]
                      [parent vert-plane1]
                      [choices (list "Male"
                                     "Female"
                                     "Unspecified")]))
  
  (define horiz-plane2 (new horizontal-pane%
                            [parent vert-plane1]
                            [alignment '(center center)]))
  
  (define Birthdate (new message%
                         [parent horiz-plane2]
                         [label "Birthdate "]))
                          
  (define date (new combo-field%
                    [parent horiz-plane2]
                    [label ""]
                    [choices (list "1" "2" "3" "4" "5" "6" "7" "8" "9" "10"
                                   "11" "12" "13" "14" "15" "16" "17" "18" "19"
                                   "20" "21" "22" "23" "24" "25" "26" "27" "28" "29" "30" "31")]
                    [init-value "DD"]))
  
  (define month (new combo-field%
                     [parent horiz-plane2]
                     [label ""]
                     [min-height 20]
                     [enabled #t]
                     [choices (list "1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12")]
                     [init-value "MM"]))
  
  (define year (new combo-field%
                    [parent horiz-plane2]
                    [label ""]
                    [min-width 40]
                    [choices (list "1999" "2000" "2001" "2002" "2003" "2004"
                                   "2005" "2006" "2007" "2008" "2009" "2010"
                                   "2011" "2012" "2013" "2014" "2015" "2016" "2017" "2018")]
                    [init-value "YY"]))

  (define User-name (new text-field%
                         [parent vert-plane1]
                         [label "Username "]
                         [style (list 'single)]))
  
  (define Password (new text-field%
                        [parent vert-plane1]
                        [label "Password  "]
                        [style (list 'single)]))
  
  
 
  
  (define (not-range input low-limit high-limit)
    (if (not (number? input))
        (DD "Enter a valid DOB")
        (if (and (<= input high-limit) (>= input low-limit))
            #f
            (DD "Enter a valid DOB"))))
  (define (empty given)
    (if (equal? given "")
        (DD "All fields are compulsory")
        #f))
  (define Save (new button%
                    [parent vert-plane1]
                    [label "Save"]
                    [callback (lambda (mouse event)
                                
                                (if (or (empty (send First-name get-value))
                                        (empty (send Last-name get-value))
                                        (empty (send User-name get-value))
                                        (empty (send Password get-value))
                                        (not-range (string->number (send date get-value)) 1 31)
                                        (not-range (string->number (send month get-value)) 1 12)
                                        (not-range (string->number (send year get-value)) 1999 2018))
                                    (void)
                                      
                                    (let*([y (new account%
                                                  [Firstname (send First-name get-value)]
                                                  [Lastname (send Last-name get-value)]
                                                  [u-id (send User-name get-value)]
                                                  [passwd (send Password get-value)]
                                                  [dob (string-append
                                                        (send date get-value)
                                                        " / "
                                                        (send month get-value)
                                                        " / "
                                                        (send year get-value))]
                                                  [gender (send Gender get-item-label (send Gender get-selection))]
                                                  [photo 1])])
                                      (hash-set! Sab (send User-name get-value) y)))
                                (clear First-name)(clear Last-name)
                                (clear User-name)(clear Password)
                                (send frame2 show #f)
                                (send frame1 show #t))]))
  
  (define horiz-plane4 (new horizontal-panel%
                            [parent  vert-plane1]))
  
  (define canvas-right (new canvas%
                            [parent horiz-plane1]
                            [style (list 'border)]
                            [min-height 400]
                            [min-width 130]
                            [paint-callback (lambda (c dc) (draw1 dc))]))
  
  (send frame2 show b))
  
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(define (f3 login-id b)
  
  (define frame3 (new frame%
                      [label "feed  frame"]
                      [height 400]
                      [width 600]
                      [x 400]
                      [y 150]
                      [alignment (list 'center 'center)]))
  
  (define horiz-plane5 (new horizontal-panel%
                            [parent frame3]))
  
  (define canvas3 (new canvas%
                       [parent horiz-plane5]
                       [min-height 400]
                       [min-width 100]))

  (define vert-plane3 (new vertical-panel%
                           [parent horiz-plane5]
                           [min-width 400]
                           [enabled #t]
                           [border 0]
                           [horiz-margin 10]
                           [alignment (list 'center 'top)]
                           [style (list 'auto-vscroll 'border)]
                           [stretchable-height #t]))

  (define atab-panel (new horizontal-pane%
                          [parent vert-plane3]
                          [min-height 10]
                          [alignment '(center top)]))
  
  (define bprofile (new button%
                        [parent atab-panel]
                        [label "Profile"]
                        [callback (lambda (mouse event)
                                    (f7 login-id #t 0))]))
  
  (define bpost (new button%
                     [parent atab-panel]
                     [label "Post"]
                     [callback (lambda (mouse event)
                                 (send frame3 show #f)
                                 (f5 login-id #t))]))
  
  (define bsearch (new button%
                       [parent atab-panel]
                       [label "Search"]
                       [callback (lambda (mouse event)
                                   (f4 login-id #t)
                                   (send frame3 show #f))]))
  
  (define bnoti (new button%
                     [parent atab-panel]
                     [label "Notification"]
                     [callback (lambda (mouse event)
                                 (display "clicked notification")
                                 (f6 login-id #t))]))
  
  (define blogout (new button%
                       [parent atab-panel]
                       [label "LogOut"]
                       [callback (lambda (mouse event)
                                   (send frame3 show #f)
                                   (send frame1 show #t))]))

  (define (post-print lst)           ;;;;;;;lst list of post struct
    (if (or (null? lst) (void? lst)) void
        (begin (f1 (Post-Content (car lst)) (Post-Reply-list (car lst)) (Post-P-ID (car lst)) (Post-U-ID (car lst)) (Post-Time (car lst)))
               (post-print (cdr lst))))) ;;;;;;;;add time sometime
  
                

  (define (f1 content replies-list p-id u-id time)
    (define v (new vertical-panel%
                   [parent vert-plane3]
                   [stretchable-height #t]))
    
    (define g (new group-box-panel%
                   [label (string-append u-id "                                                                                            "
                                         (number->string time)
                                         "   sec ago")]
                   [parent v]
                   [min-height 110]
                   [vert-margin 10]
                   [horiz-margin 10]))
    
    (define c (new editor-canvas%
                   [parent g]
                   [label "yahoo"]
                   [horiz-margin 2]
                   [style (list 'auto-vscroll 'control-border)]))
    
    (define h (new horizontal-panel%
                   [parent g]))
    
    (define replies (new group-box-panel%
                         [parent h]
                         [label "Replies"]))
    (define (my-format lst-of-struct)
      (cond [(null? lst-of-struct) (void)]
            [else (begin (new message%
                              [parent replies]
                              [label (Reply-Content (car lst-of-struct))])
                         (my-format (cdr lst-of-struct)))]))
    (my-format replies-list)
    
    (define more-replies (new button%
                              [parent h]
                              [label "More replies"]
                              [callback (lambda (mouse event)
                                          (f8 login-id p-id u-id #t)
                                          (send frame3 show #f))]))
    (define t (new text%
                   [auto-wrap #t]))
    
    (send t insert content)
    (send c set-editor t))
  
  (post-print (send (hash-ref Sab login-id) dispatch "Print-feed"))
  
  (define canvas2 (new canvas%
                       [parent horiz-plane5]
                       [min-height 400]
                       [min-width 100]))
  
  (send frame3 show b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;search
(define (f4 login-id b)
  (define frame4 (new frame%
                      [label "Search"]
                      [height 400]
                      [width 350]
                      [x 450]
                      [y 150]
                      [alignment (list 'center 'center)]))
  
  (define vert-plane6 (new vertical-panel%
                           [parent frame4]
                           [style (list 'border 'auto-vscroll)]
                           [vert-margin 20]))
  (define (print-search-list hash-list)
    (define a (hash-copy (make-immutable-hash (hash->list hash-list))))
    (define list-list (begin (hash-remove! a login-id) (hash->list a)))
    (define (helper l)
      (if (null? l) (void) (begin (psearch (car l)) (helper (cdr l)))))
    ;(define list-list (hash->list hash-list))
    (helper list-list))
  
  (define (psearch element)
    (define s 0)
    (new message%
         [parent vert-plane6]
         [label (car element)])
    (new message%
         [parent vert-plane6]
         [label (cdr element)]
         [vert-margin 0])
    (new button%
         [parent vert-plane6]
         [label "Follow"]
         [callback (lambda (mouse event)
                     (if (= s 0) (begin ((send (hash-ref Sab login-id) dispatch "Follow-k") (car element))
                                        (set! s 1)) (void)))])
    (new message%
         [parent vert-plane6]
         [label ""]))

  (print-search-list Database)
  (new button%
       [parent frame4]
       [label "close"]
       [callback (lambda (mouse event)
                   (f3 login-id #t)
                   (send frame4 show #f))])
  (send frame4 show b))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;POST


(define (f5 login-id b)
  (define frame5 (new frame%
                      [label "Post"]
                      [height 300]
                      [width 500]
                      [x 450]
                      [y 200]))
  
  (define type (new text-field%
                    [parent frame5]
                    [label ""]
                    [init-value "What's on your mind?"]
                    [style (list 'multiple)]
                    [vert-margin 20]))
  
  (define v5 (new vertical-panel%
                  [parent frame5]
                  [alignment (list 'right 'top)]))
  
  (define bb (new button%
                  [parent v5]
                  [label "Post"]
                  [callback (lambda (mouse event)
                              ((send (hash-ref Sab login-id) dispatch "new-post") (send type get-value))
                              (f3 login-id #t)
                              (send frame5 show #f))]))
  
  (send frame5 show b))
                  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Notification

(define (f6 login-id b)
  (define frame6 (new frame%
                      [label "Notification"]
                      [height 200]
                      [width 300]
                      [x 400]
                      [y 150]
                      [alignment (list 'center 'center)]))
  (define (multi-print lst)
    (if (null? lst) (void)
        (begin (display-noti (car lst)) (multi-print (cdr lst)))))
  
  (define (display-noti element)
    (define gbp (new group-box-panel%
                     [parent frame6]
                     [label ""]
                     [min-height 20]
                     [vert-margin 10]))
    (define m (new message%
                   [parent gbp]
                   [label "content"]
                   [min-width 170]
                   [min-height 20]
                   [vert-margin 10]))
    (send m set-label (string-append (cdr element) " replied on " (car element) " post")))
  (multi-print (send (hash-ref Sab login-id) get-notification-list))
  (send frame6 show b))





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Profile
(define (f7 login-id b photo-id)
  (define frame7 (new dialog%
                      [label "Profile"]
                      [height 450]
                      [width 600]
                      [x 400]
                      [y 150]
                      [alignment (list 'center 'center)]))
  
  (define h (new horizontal-panel%
                 [parent frame7]))
  
  (define v1 (new vertical-panel%
                  [parent h]))
  
  (define v2 (new vertical-panel%
                  [parent h]))
  (define d (new dialog%
                 [label "Select A Photo"]
                 [height 500]
                 [width 400]))
  (define select-radio (new radio-box%
                            [parent d]
                            [label ""]
                            [choices (list "p0" "p1" "p2" "p3" "p4" "p5"
                                           "p6" "p7" "p7" "p8" "p9")]))
  
  (define storage (list '(0 "image/p0.jpg")
                        '(1 "image/p1.jpg")
                        '(2 "image/p2.jpg")
                        '(3 "image/p3.jpg")
                        '(4 "image/p4.jpg")
                        '(5 "image/p5.jpg")
                        '(6 "image/p6.jpg")
                        '(7 "image/p7.jpg")
                        '(8 "image/p8.jpg")
                        '(9 "image/p9.jpg")))
  (define (search k)
    (define (helper lst) 
      (if (= (caar lst) k) (cadar lst) (helper (cdr lst))))
    (helper storage))
  ; (send Gender get-item-label (send Gender get-selection))
  (define bupload (new button%
                       [parent d]
                       [label "Upload"]
                       [callback (lambda (mouse event)
                                   (f7 login-id #t (send select-radio get-selection))
                                    
                                   (send d show #f))]))
                                               
  (define button (new button%
                      [parent v1]
                      [label "Upload photo"]
                      [callback (lambda (mouse event)
                                  (send d show #t)
                                  (send frame7 show #f))]))
  (define photo (new message%
                     [parent v1]
                     [label (read-bitmap (search photo-id))]
                     [vert-margin 100]))
  
  (define profile (new group-box-panel%
                       [parent v2]
                       [label "Profile"]))
  
  (define (play content)
    (define details (new message%
                         [parent profile]
                         [label "detail"]
                         [min-width 175]
                         [vert-margin 25]))
    (send details set-label content))
  (define str (hash-ref Sab login-id))
  (define un (string-append "Username : " (send str get-user-name)))
  (define uid (string-append "User-Id : " (send str get-user-id)))
  (define db (string-append "Date of Birth : " (send str get-dob)))
  (define gnder (string-append "Gender : " (send str get-gender))) 
  (define fk-num (string-append  "Followers : " (number->string (- (length (send str get-follow-k)) 1))))
  (define fh-num (string-append "Following : " (number->string (length (send str get-follow-h)))))
  (play un)
  (play uid)
  (play db)
  (play gnder)
  (play fk-num)
  (play fh-num)
  (send frame7 show b))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Reply to Post

(define (f8 login-id post-id user-jiski-post b)
  (define d (new dialog%
                 [label "Reply-to-post"]
                 [width 400]
                 [height 150]))
  (define txt-field (new text-field%
                         [parent d]
                         [label "New Reply : "]
                         [style (list 'multiple)]
                         [min-width 300]))
  (new button%
       [parent d]
       [label "Reply"]
       [callback (lambda (mouse event)
                   ((send (hash-ref Sab login-id) dispatch "new-reply") (string-append (send txt-field get-value)
                                                                                       "                                                "
                                                                                       (number->string (- (current-seconds)
                                                                                                          starting-Time))
                                                                                       "  sec ago")
                                                                        post-id user-jiski-post)
                   (send d show #f)
                   (f3 login-id #t))])
  (send d show #t))
                   
