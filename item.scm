(define item%
  
  (class game-object%
    
    (inherit-field position
                   velocity)
    (init-field current-agent)
    
    ;Current agent methods
    (define/public (get-current-agent) current-agent)
    (define/public (set-current-agent! new-agent)
      (set! current-agent new-agent))
    
    (define/override (draw level-buffer)
      (unless current-agent
        (super draw level-buffer)))
    
    (define/override (move!)
      (set-mcar! position (+ (mcar position) (mcar velocity)))
      (set-mcdr! position (+ (mcdr position) (mcdr velocity))))
                     
    (super-new)))