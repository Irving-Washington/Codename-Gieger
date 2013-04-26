(define item%
  
  (class game-object%
    
    (inherit-field position
                   velocity)
    (init-field current-agent)
    (field (zero-velocity (mcons 0 0)))

    (field (animation-package (get-animation-package 'player-pistol)))
    
    (define/public (get-animation) animation-package)
    
    ;Current agent methods
    (define/public (get-current-agent) current-agent)
    (define/public (set-current-agent! new-agent)
      (set! current-agent new-agent))
    
    (define/override (draw level-buffer)
      (unless current-agent
        (super draw level-buffer)))
    
    (define/override (move!)
      (unless (equal? velocity zero-velocity)
        (set-mcar! position (+ (mcar position) (mcar velocity)))
        (set-mcdr! position (+ (mcdr position) (mcdr velocity)))))
      
    (super-new)))