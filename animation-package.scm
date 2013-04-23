(define animation-package%
  
  (class object%
    
    (init-field idle-image
                move-image-pair
                use-image)
    
    (field (death-animation
            (list (read-bitmap "graphics/litvinenko-dead1.png")
                  (read-bitmap "graphics/litvinenko-dead2.png")
                  (read-bitmap "graphics/litvinenko-dead3.png"))))
    
    (field (move-switcher #f))
    (field (death-switcher 0))
    
    (define/public (get-idle-image) idle-image)
    (define/public (get-use-image) use-image)
    
    (define/public (get-next-move-image) 
      (set! move-switcher (not move-switcher))
      (if move-switcher
          (car move-image-pair)
          (cdr move-image-pair)))
    
    (define/public (get-next-death-image)
      (set! death-switcher (+ death-switcher 1))
      (cond
        ((= 1 death-switcher) (car death-animation))
        ((= 2 death-switcher) (cadr death-animation))
        ((= 3 death-switcher) (caddr death-animation))))
        
    
    (super-new)))
          
                