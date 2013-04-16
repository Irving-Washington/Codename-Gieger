(define tile%
  
  (class object%
    
    (init-field position
                seethrough
                collidable
                image)
    
    (define/public (seethrough?) seethrough)
    (define/public (collidable?) collidable)
    (define/public (get-position) position)
             
    (define/public (draw)
      (send renderer draw-tile image position))
    
    (super-new)))