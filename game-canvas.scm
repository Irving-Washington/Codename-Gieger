(define input-listener%
 
  (class canvas%
    
    (inherit get-width get-height refresh)
    (init-field *interaction*)
    (define aux-eventspace (make-eventspace))

    ;Keyboard events
    (define/override (on-char key-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (send *interaction* new-key-event (send key-event get-key-code))
           (send *interaction* new-key-event (send key-event get-key-release-code))
           (refresh)))))
    
    ;Mouse events
    (define/override (on-event mouse-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (send *interaction* new-mouse-event (send mouse-event get-mouse-event))
           (send *interaction* new-mouse-position (cons (send mouse-event get-x)
                                                        (send mouse-event get-y)))
           (refresh)))))

    (super-new)))

(define game-frame (new frame% (label "game") (width 600) (height 400)))
(define input-listener (new input-listener% (parent game-frame)))
(send game-frame show #t)
