(define projectile%
  
  (class item%
    (super-new)
    
    (init-field start-velocity
                projectile-size
                slow-down
                destroy-on-impact)
    
    (field (decimal-velocity (mcons (* 1.0 (mcar start-velocity)) (* 1.0 (mcdr start-velocity)))))
    
    (inherit get-future-position)
    
    (inherit-field velocity
                   size
                   position
                   zero-velocity)
    
    (set! velocity start-velocity)
    (set! size projectile-size)
    
    (define/public (destroy-on-impact?) destroy-on-impact)
    
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    (define/public (bounce!)
      (if (= (mcar (pixel-to-tile position)) (mcar (pixel-to-tile (get-future-position))))
          (begin (set-mcar! velocity (- (mcar velocity)))
                 (set-mcar! decimal-velocity (- (mcar decimal-velocity))))
          (begin (set-mcdr! velocity (- (mcdr velocity)))
                 (set-mcdr! decimal-velocity (- (mcdr decimal-velocity))))))
     
    (define/private (get-velocity-vector)
      (sqrt (+ (expt (mcar velocity) 2) (expt (mcdr velocity) 2))))
    
    (define/override (move!)
      (super move!)
      (unless (and (not slow-down) (equal? velocity zero-velocity))
        (if (and (< (abs (mcdr decimal-velocity)) 1) (< (abs (mcar decimal-velocity)) 1))
            (begin (set-mcar! decimal-velocity 0)
                   (set-mcdr! decimal-velocity 0))
            (begin (set-mcar! decimal-velocity (* 0.98 (mcar decimal-velocity)))
                   (set-mcdr! decimal-velocity (* 0.98 (mcdr decimal-velocity)))))
        (set-mcar! velocity (round (mcar decimal-velocity)))
        (set-mcdr! velocity (round (mcdr decimal-velocity)))))))
      