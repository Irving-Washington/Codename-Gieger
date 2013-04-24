(define input-canvas%
  
  (class canvas%
    
    (inherit refresh)
    (define aux-eventspace (make-eventspace))
    
    ;Keyboard events
    (define/override (on-char key-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (send *interaction* new-key-event (send key-event get-key-code) (send key-event get-shift-down))
           (send *interaction* new-key-release-event (send key-event get-key-release-code))))))
    
    ;Mouse events
    (define/override (on-event mouse-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda () 
           (send *interaction* new-mouse-event (send mouse-event get-event-type))
           (send *interaction* new-mouse-position (cons (send mouse-event get-x)
                                                        (send mouse-event get-y)))))))
    
    (super-new)))


