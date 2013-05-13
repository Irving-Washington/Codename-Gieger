(define ray%
  
  (class object%
    
    (init-field position
                velocity
                current-ai)
    
    (define/public (move!)
      (set-mcar! position (+ (mcar position) (mcar velocity)))
      (set-mcdr! position (+ (mcdr position) (mcdr velocity))))
    
    (super-new)))