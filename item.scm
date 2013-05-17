(define item%
  
  (class game-object%
    
    (inherit-field position
                   velocity)
    
    (init-field current-agent
                animation-package)
    
    (field (zero-velocity (mcons 0.0 0.0)))
    
    (define/public (get-animation team) 
      (cond ((eq? team 'kgb) (car animation-package))
            ((eq? team 'cia) (cdr animation-package))))
    
    ;Current agent methods
    (define/public (get-current-agent) current-agent)
    (define/public (set-current-agent! new-agent)
      (set! current-agent new-agent))
    
    (define/override (draw level-buffer)
      (unless current-agent
        (super draw level-buffer)))
    
    (define/override (move!)
      (unless (equal? velocity zero-velocity)
        (set-mcar! position (+ (mcar position) (round (mcar velocity))))
        (set-mcdr! position (+ (mcdr position) (round (mcdr velocity))))))
      
    (super-new)))