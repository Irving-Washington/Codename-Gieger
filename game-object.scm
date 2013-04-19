(define game-object%
  
  (class object%
    (init-field position
                image)
    
    ;Name method
    ;(define/public (get-name) name)
    
    ;Position method
    (define/public (get-position) position)
    
    ;Image method
    (define/public (get-image) image)
    
    ;Draw method
    (define/public (draw level-buffer)
      (send level-buffer draw-bitmap image (mcar position) (mcdr position)))
    
    ;Delete method
    ;(define/public (delete!)
     ; (send *level* delete-game-object! name))
    
    ;(send *level* add-game-object! this)
    
    (super-new)))