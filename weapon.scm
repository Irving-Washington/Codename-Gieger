;class: weapon
;superclass: item
;this class defines all weapons.

(define weapon% 
  
  (class item%
    
    (super-new)
    
    ;Holds the value of the base damage a wepaon causes.
    (init-field base-damage)
    
    
    ;Use method
    
    ;Activates the weapon.
    (define/public (use)
      (void))))