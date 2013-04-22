(define projectile%
  
  (class item%
    (super-new)

    (init-field start-velocity
                projectile-size
                slow-down)   
    
    (inherit-field velocity
                   size) 
    (set! velocity start-velocity)
    (set! size projectile-size)
     
    (define/private (get-velocity-vector)
      (sqrt (+ (expt (mcar velocity) 2) (expt (mcdr velocity) 2))))
    
    (define/override (move!)
      (super move!)
      (unless (and (not slow-down))
        (set-mcar! velocity (- (mcar velocity) 1))
        (set-mcdr! velocity (- (mcdr velocity) 1))))))
      