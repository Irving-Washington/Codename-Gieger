(define npc%  
  
  (class agent%
    
    (field (ai (new ai% [current-agent this]))
           (current-move-target #f)
           (delta-x #f)
           (delta-y #f)
           (distance-to-target #f))
    
    (inherit-field position
                   velocity
                   run-speed)
    
    
    (define/public (set-current-move-target! target)
      (set! current-move-target target))
    
    (define/public (remove-move-target!)
      (set! current-move-target #f)
      (set! velocity (mcons 0 0)))
    
    (define/public (get-delta-x) delta-x)
    (define/public (get-delta-y) delta-y)
    (define/public (get-disctance-to-target) distance-to-target)
    
    (define/override (move!)
      (when current-move-target
        (set! delta-x (- (mcar current-move-target) (mcar position)))
        (set! delta-y (- (mcdr current-move-target) (mcdr position)))
        (set! distance-to-target (sqrt (+ (expt delta-x 2) (expt delta-y 2))))
        
        (unless (<= distance-to-target 32)
          (set! velocity (mcons (round (/ (* run-speed delta-x) distance-to-target))
                                (round (/ (* run-speed delta-y) distance-to-target))))))
    (super move!))
  
  
  (super-new)))

    
    
    