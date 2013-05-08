(define player%
  
  (class agent%
    (inherit-field angle
                   inventory)
    (inherit get-projectile-position
             get-projectile-velocity
             item-remove-primary!)

    ;Firarm methods
    (define/public (firearm-reload)
      (when (is-a? (mcar inventory) firearm%)
        (send (mcar inventory) reload!)))
    
    (define/public (firearm-check)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar-inventory) check)))
    
    ;World interaction
    (define/public (world-interact)
      (send *level* agent-interact this))
    
    (super-new)))