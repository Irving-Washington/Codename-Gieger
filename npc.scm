(define npc%  
  (class agent%
    
    (inherit-field angle
                   inventory)
    
    (inherit get-projectile-position
             get-projectile-velocity
             item-remove-primary!)
    
    (super-new)))
    
    
    
    