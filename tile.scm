(define tile%
  
  (class object%
    
    (init-field position
                seethrough 
                collidable 
                image)
    
    ;Environment methods
    (define/public (seethrough?) seethrough)
    (define/public (collidable?) collidable)
    
    ;Position method
    (define/public (get-position) position)

    ;Draw method
    (define/public (draw level-buffer)
      (send level-buffer draw-bitmap image (car position) (cdr position)))
    
    (super-new)))