
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
    (define/public (draw)
      (display position))
      ;(send *renderer* draw-tile image position))
    
    (super-new)))