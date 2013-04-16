(define magazine%
  
  (class firearm%
    
    (init-field ammunition-capacity)
    (field (ammunition ammunition-capacity))
    
    ;Ammunition capacity methods
    (define/public (get-ammunition-capacity) ammunition-capacity)
    (define/public (get-ammunition) ammunition)
    
    ;Unload method
    (define/public (unload!)
      (set! ammunition (- ammunition 1))
    
    (super-new))))