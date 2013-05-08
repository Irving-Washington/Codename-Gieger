(define firearm%
  (class weapon%
    (super-new)
    
    (inherit-field current-agent
                   base-damage)
    
    (field (current-magazine #f))
    
    (init-field ammunition
                ammunition-type)
    
    ;Use method
    
    (define/override (use)
      (unless (<= ammunition 0)
        (cond
          ((eq? ammunition-type 'bullet)
           (fire-bullet))
          ((eq? ammunition-type 'pellets)
           (fire-pellets)))
        (send current-agent set-used-item! #t)))
    
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
    (define/public (reload!)
      (let ((second-item (send current-agent get-second-item)))
        (when (and (is-a? second-item magazine%) (eq? (send second-item get-ammunition-type)
                                                      ammunition-type))
          (begin (set! ammunition (send second-item get-ammunition))
                 (send current-agent item-remove-secondary!)))))
    
    ;Check method
    (define/public (check)
      (send current-magazine remaining-ammunition))))

             
             
    