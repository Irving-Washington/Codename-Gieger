(define game-canvas%
  (class canvas%
    (inherit get-width get-height refresh)

    (define aux-eventspace (make-eventspace))

    (define/override (on-char ke)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (display (send ke get-key-code))
           (refresh)))))
    
    (define/override (on-event me)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (display (send me get-event-type))
           (refresh)))))

    (super-new)))

(define game-frame (new frame% (label "game") (width 600) (height 400)))
(define game-canvas (new game-canvas% (parent game-frame)))
(send game-frame show #t)