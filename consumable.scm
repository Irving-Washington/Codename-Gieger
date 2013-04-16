(define consumable%
  
  (class item%
    
    (init-field consumable-health
                consumable-radiation)
    
    ;Consumable methods
    (define/public (get-consumable-health) consumable-health)
    
    (define/public (get-consumable-radiation) consumeable-radiation)
    
    ;Use methods
    (define/public (use)
      (begin (set! (send current-agent get-health)
                   (+ consumable-health (send current-agent get-health)))
             (set! (send current-agent get-radiation)
                   (+ consumable-radiation (send current-agent get-radiation)))
             (send current-agent item-remove-primary!)))
    
    (super-new)))