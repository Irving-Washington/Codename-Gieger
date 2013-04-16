(define game-object%
  
  (class object%
    
    (init-field name
                position
                image)

    (define/public (get-name) name)
    (define/public (get-position) position)
    (define/public (get-image) image)
    
    (define/public (draw)
      (send *renderer* draw-game-object position image))
    (define/public (delete!)
      (send *level* delete-game-object! name))
    
    (send *level* add-game-object! this)
    
    (super-new)))