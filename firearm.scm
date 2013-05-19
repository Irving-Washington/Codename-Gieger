;class: firearm
;superclass: weapon
;this class defines firearms

(define firearm%
  
  (class weapon%
    
    (super-new)
    
    ;current-agent holds the name
    ;of the owner of an item.
    
    ;base-damage determines a base damage
    ;of a weapon.
    (inherit-field current-agent
                   base-damage)
    
    
    ;current-magazine holds the amount of
    ;ammunition left in the current weapon.
    (field (current-magazine #f))
    
    
    ;ammunition hold the value of how much ammo there is
    ;in a weapon when the weapon is created.
    
    ;ammunition-type is a symbol that determines what kind
    ;of ammunition the firearm dispenses.
    (init-field ammunition
                ammunition-type)
    
    
    ;Retrieves the amount of ammunition left in a weapon.
    (define/public (get-ammunition) ammunition)
    
    
    ;Use method
    
    ;Uses the firearm, dispensing ammunition.
    (define/override (use)
      (unless (<= ammunition 0)
        (cond
          ((eq? ammunition-type 'bullet)
           (fire-bullet))
          ((eq? ammunition-type 'pellets)
           (fire-pellets)))
        (send current-agent set-used-item! #t)))
    
    ;Dispenses the ammunition type 'bullet.
    (define/private (fire-bullet)
      (new projectile%
           [start-velocity (send current-agent get-projectile-velocity 32)]
           [projectile-size 2]
           [slow-down #f]
           [destroy-on-impact #t]
           [current-agent #f]
           [animation-package #f]
           [position (send current-agent get-projectile-position)]
           [image (read-bitmap "graphics/bullet-1.bmp")]
           [stationary-item #f]
           [projectile-damage base-damage]
           [excluded-collisions (cons decal% item%)])
      (set! ammunition (- ammunition 1)))
    
    ;Dispenses the ammunition type 'pellets.
    (define/private (fire-pellets)
      (define (pellet-spread-helper num)
        (unless (>= num 8)
          (new projectile%
               [start-velocity (send current-agent get-random-projectile-velocity 24)]
               [projectile-size 1]
               [slow-down #f]
               [destroy-on-impact #t]
               [current-agent #f]
               [animation-package #f]
               [position (send current-agent get-projectile-position)]
               [image (read-bitmap "graphics/bullet-1.bmp")]
               [stationary-item #f]
               [projectile-damage base-damage]
               [excluded-collisions (cons decal% item%)])
          (pellet-spread-helper (+ num 1))))
      (pellet-spread-helper 0)
      (set! ammunition (- ammunition 1)))
    
    
    ;Reload method
    
    ;Reloads the weapon if there is a magazine with the corresponding
    ;ammunition type in the agents secondary inventory slot.
    (define/public (reload!)
      (let ((second-item (send current-agent get-second-item)))
        (when (and (is-a? second-item magazine%) (eq? (send second-item get-ammunition-type)
                                                      ammunition-type))
          (begin (set! ammunition (send second-item get-ammunition))
                 (send current-agent item-remove-secondary!)))))
    
    ;Check method
    
    ;Checks the amount of ammunition left in a weapon
    (define/public (check)
      (send current-magazine remaining-ammunition))
    
    (void)))