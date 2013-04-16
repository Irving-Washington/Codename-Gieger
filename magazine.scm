(define magazine%
  
  (class item%
    
    (init-field ammunition-capacity)
    
    (field (ammunition ammunition-capacity))
    
    (define/public (get-ammunition-capacity) ammunition-capacity)
    (define/public (get-ammunition) ammunition)
    (define/public (unload!) (set! ammunition (- anmmunition 1)))
    (super-new)))