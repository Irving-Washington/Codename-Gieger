(define animation-package%
  
  (class object%
    
    (init-field idle-image
                move-image-pair
                item-use-image
                item-secondary-image
                death-animation)
    
    
    (field (move-switcher #f)
           (death-switcher 0))
    
    (define/public (get-idle-image) idle-image)
    (define/public (get-item-use-image) item-use-image)
    (define/public (get-item-secondary-image) item-secondary-image)
    
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
          
                