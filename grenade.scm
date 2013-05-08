(define grenade%
  (class weapon%
    (super-new)
    
    (inherit-field current-agent
                   base-damage)
    
    (init-field grenade-type
                explosion-radius)
    
    ;Use method
    
    (define/override (use)
      (send current-agent item-remove-primary!)
      (send current-agent set-used-item! #t)
      
      (cond
        ((eq? grenade-type 'frag-grenade)
         (new projectile%
           [start-velocity (send current-agent get-projectile-velocity 16)]
           [projectile-size 12]
           [slow-down #t]
           [destroy-on-impact #f]
           [current-agent #f]
           [animation-package #f]
           [position (send current-agent get-projectile-position)]
           [image (read-bitmap "graphics/frag-grenade-1.png")]
           [stationary-item #f]
           [projectile-damage 10]
           [excluded-collisions (cons decal% item%)])
         (explode!))
        ((eq? grenade-type 'molotov)
         (new projectile%
           [start-velocity (send current-agent get-projectile-velocity 16)]
           [projectile-size 12]
           [slow-down #t]
           [destroy-on-impact #f]
           [current-agent #f]
           [animation-package #f]
           [position (send current-agent get-projectile-position)]
           [image (read-bitmap "graphics/molotov-1.png")]
           [stationary-item #f]
           [projectile-damage 10]
           [excluded-collisions (cons decal% item%)])
         (explode!)
         (burn-environment!))))))
      