(define firearm%
  (class weapon%
    
    (init-field ammunition)
    (inherit-field current-agent)
    (field (current-magazine #f))
    
    ;Use method
    (define/override (use)
      (if (> ammunition 0)
          (begin 
            (new projectile%
                 [start-velocity (send current-agent get-projectile-velocity 30)]
                 [projectile-size 2]
                 [slow-down #f]
                 [destroy-on-impact #t]
                 [current-agent #f]
                 [position (send current-agent get-projectile-position)]
                 [image (read-bitmap "graphics/bullet-1.bmp")])
            (set! ammunition (- ammunition 1)))))
    
    ;Reload method
    (define/public (reload)
      (if (is-a? magazine% (cdr (send current-agent get-inventory)))
          (begin (set! ammunition ammunition-capacity) 
                 (send current-agent item-remove-secondary!))))
    
    ;Check method
    (define/public (check)
      (send current-magazine remaining-ammunition))
    
    (super-new)))

             
             
    