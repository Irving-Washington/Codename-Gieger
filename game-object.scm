(define game-object%
  
  (class object%
    (init-field name
                position
                image)
    
    ;Name method
    (define/public (get-name) name)
    
    ;Position method
    (define/public (get-position) position)
    
    ;Image method
    (define/public (get-image) image)
    
    ;Draw method
    (define/public (draw)
      (send *renderer* draw-game-object image position))
    
    ;Delete method
    (define/public (delete!)
      (send *level* delete-game-object! name))
    
    (send *level* add-game-object! this)
    
    (super-new)))