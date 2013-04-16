(define projectile%
  
  (class item%
    
    (init-field velocity)
    
    (define/private (get-velocity-vector)
      (sqrt (+ (expt (mcar velocity) 2) (expt (mcdr velocity) 2))))
    
    (define/public (move!)
      (set-mcar! position (+ (mcar position) (mcar velocity)))
      (set-mcdr! position (+ (mcdr position) (mcdr velocity))))
    
    (super-new)))
      