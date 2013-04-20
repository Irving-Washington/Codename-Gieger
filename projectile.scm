(define projectile%
  
  (class item%
    (super-new)

    (init-field start-velocity
                projectile-size)   
    (inherit-field velocity
                   size) 
    (set! velocity start-velocity)
    (set! size projectile-size)
     
    (define/private (get-velocity-vector)
      (sqrt (+ (expt (mcar velocity) 2) (expt (mcdr velocity) 2))))))
      