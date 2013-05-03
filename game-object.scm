(define game-object%
  
  (class object%
    (init-field position
                image)
    
    (field (angle 0)
           (size 32)
           (half-size 16)
           (velocity (mcons 0 0))
           (max-velocity 4)
           (stationary #f))

    (define/public (get-angle) angle)
    
    (define/public (set-angle! new-angle)
      (set! angle new-angle))
    
    ;Position method
    (define/public (get-position) position)
    
    ;Movement methods
    (define/public (move!)
      (void))
    
    (define/public (get-stationary) stationary)
    
    (define/public (set-stationary!)
      (set! stationary #f))
    
    (define/public (set-position! new-position)
      (set! position new-position))
    
    (define/public (get-future-position divisor)
      (mcons (+ (mcar position) (quotient (mcar velocity) divisor))
             (+ (mcdr position) (quotient (mcdr velocity) divisor))))
    
    (define/public (get-future-corner-positions)
      (list (cons
              (+ (mcar position) (mcar velocity))
              (+ (mcdr position) (mcdr velocity)))
             (cons
              (+ (mcar position) (mcar velocity) size)
              (+ (mcdr position) (mcdr velocity)))
             (cons
              (+ (mcar position) (mcar velocity))
              (+ (mcdr position) (mcdr velocity) size))
             (cons
              (+ (mcar position) (mcar velocity) size)
              (+ (mcdr position) (mcdr velocity) size))))
       
    
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
      (unless (>= (abs (+ delta-value (mcar velocity))) max-velocity)
        (set-mcar! velocity (+ (mcar velocity) delta-value))))
    
    (define/public (increase-velocity-y! delta-value)
      (unless (>= (abs (+ delta-value (mcdr velocity))) max-velocity)
        (set-mcdr! velocity (+ (mcdr velocity) delta-value))))
    
    (define/public (divide-velocity! divisor)
      (set! velocity
            (mcons (round (/ (mcar velocity) divisor))
                   (round (/ (mcdr velocity) divisor)))))
    
    ;Image method
    (define/public (get-image) image)
    (define/public (set-image! new-image)
      (set! image new-image))
    
    ;Draw method
    (define/public (draw level-buffer)
      (let ((temp-angle angle))
        (send level-buffer translate (+ half-size (mcar position)) (+ half-size (mcdr position)))
        (send level-buffer rotate temp-angle)
        (send level-buffer draw-bitmap image (- half-size) (- half-size))
        (send level-buffer rotate (- temp-angle))
        (send level-buffer translate (- (+ half-size (mcar position))) (- (+ half-size (mcdr position))))))
    
    
    
    
    ;Delete method
    (define/public (delete!)
      (send *level* delete-game-object! this))
    
    (send *level* add-game-object! this)
    
    (super-new)))