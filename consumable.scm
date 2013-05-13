(define consumable%
  
  (class item%
    
    (init-field consumable-health
                consumable-radiation)
    (inherit-field current-agent)
    
    ;Consumable methods
    (define/public (get-consumable-health) consumable-health)
    
    (define/public (get-consumable-radiation) consumeable-radiation)
    
    ;Use methods
    (define/public (use)
      (begin (send current-agent increase-health! consumable-health)
             (send current-agent set-radiation! consumable-radiation)
             (send current-agent set-used-item! #t)))
             ;(send current-agent item-remove-primary!)))
    
    (super-new)))

;Branch test experimental
