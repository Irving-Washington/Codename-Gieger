(define magazine%
  
  (class item%
    
    (init-field ammunition-capacity
                ammunition-type)
    (field (ammunition ammunition-capacity))
    
    ;Ammunition methods

    (define/public (get-ammunition-capacity) ammunition-capacity)
    (define/public (get-ammunition-type) ammunition-type)
    (define/public (get-ammunition) ammunition)
    
    (define/public (use)
      (void))

    (super-new)))