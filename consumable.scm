;class: consumable
;subclass to: item
;this class defines all consumables that can be used by agents

(define consumable%
  
  (class item%
    
    ;consumable-health is the value that will be added to
    ;the agent using the item.
    
    ;consumable-radiation is the value that will be added to
    ;the agent using the item.
    (init-field consumable-health
                consumable-radiation)
    
    
    ;current-agent holds the name
    ;of the owner of an item.
    (inherit-field current-agent)
    
    
    ;Consumable methods
    
    ;Retrieves the health potential of a consumable.
    (define/public (get-consumable-health) consumable-health)
    
    ;Retrieves the radiation potential of a consumable.
    (define/public (get-consumable-radiation) consumeable-radiation)
    
    
    ;Use methods
    
    ;Causes an agent to use the consumable, gaining it's effects.
    (define/public (use)
      (begin (send current-agent increase-health! consumable-health)
             (send current-agent set-radiation! consumable-radiation)
             (send current-agent set-used-item! #t)
             (send current-agent item-remove-primary!)))

    (super-new)))