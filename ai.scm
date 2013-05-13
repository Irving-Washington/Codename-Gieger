(define ai%
  
  (class object%
    
    (init-field current-agent)
    
    (define/public (scan-level)
      (define (scan-helper num)
        (unless (>= num 8)
          (new ray%
               [position (send current-agent get-position)]
               [velocity (send current-agent get-random-velocity 24)]
               [current-ai this])
          (scan-helper (+ num 1))))
      (scan-helper 1))
    
    
    
    (super-new)))
    