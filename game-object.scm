(define game-object%
  
  (class object%
    (init-field position
                image)
    
    (field (angle 0))
    (field (size 16))
    (field (velocity (mcons 0 0)))
    (field (max-velocity 20))

    (define/public (get-angle) angle)
    
    (define/public (set-angle! new-angle)
      (set! angle new-angle))
    
    ;Position method
    (define/public (get-position) position)
    
    ;Movement methods
    (define/public (get-future-position)
      (cond
        ((and (>= (mcar velocity) 0) (>= (mcdr velocity) 0))
         (mcons (+ (mcar position) (* 2 size) (mcar velocity)) (+ (mcdr position) (* 2 size) (mcdr velocity))))
        ((and (>= (mcar velocity) 0) (<= (mcdr velocity) 0))
         (mcons (+ (mcar position) (* 2 size) (mcar velocity)) (+ (mcdr position) (mcdr velocity))))
        ((and (<= (mcar velocity) 0) (<= (mcdr velocity) 0))
         (mcons (+ (mcar position) (mcar velocity)) (+ (mcdr position) (mcdr velocity))))
        ((and (<= (mcar velocity) 0) (>= (mcdr velocity) 0))
         (mcons (+ (mcar position) (mcar velocity)) (+ (mcdr position) (* 2 size) (mcdr velocity))))))
    
    (define/public (get-velocity) velocity)
    (define/public (set-velocity! new-velocity)
      (set! velocity new-velocity))
    (define/public (set-velocity-x! value)
      (unless (>= value max-velocity)
        (set-mcar! velocity value)))
    (define/public (set-velocity-y! value)
      (unless (>= value max-velocity)
        (set-mcdr! velocity value)))
    (define/public (increase-velocity-x! delta-value)
      (unless (>= (+ delta-value (mcar velocity)) max-velocity)
        (set-mcar! velocity (+ (mcar velocity) delta-value))))
    (define/public (increase-velocity-y! delta-value)
      (unless (>= (+ delta-value (mcdr velocity)) max-velocity)
        (set-mcdr! velocity (+ (mcdr velocity) delta-value))))
    
    ;Image method
    (define/public (get-image) image)
    
    ;Draw method
    (define/public (draw level-buffer)
      (send level-buffer translate (+ size (mcar position)) (+ size (mcdr position)))
      (send level-buffer rotate angle)
      (send level-buffer draw-bitmap image (- size) (- size))
      (send level-buffer rotate (- angle))
      (send level-buffer translate (- (+ size (mcar position))) (- (+ size (mcdr position)))))
    
    (define/public (move!)
      (display 'whyyy))
    
    
    ;Delete method
    (define/public (delete!)
      (send *level* delete-game-object! name))
    
    (send *level* add-game-object! this)
    
    (super-new)))