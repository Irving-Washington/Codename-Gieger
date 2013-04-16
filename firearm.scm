(define firearm%
  
  (class weapon%
    
    (init-field ammunition)
    
    ;Use method
    (define/override (use)
      (if (> 0 ammunition)
          (begin (new projectile%
                      [velocity-x (acos (send current-agent get-aim-direction))]
                      [velocity-y (asin (send current-agent get-aim-direction))]
                      [name (+ 1 (send *level* object-count))]
                      [position (send current-agent get-position)]
                      [image "bitmap.bmp"])
                 (set! ammunition (- ammunition 1)))
          (display "Your magazine is empty.")))
    
    ;Reload method
    (define/public (reload)
      (if (is-a? magazine% (cdr (send current-agent get-inventory)))
          (begin (set! ammunition ammunition-capacity) 
                 (send current-agent item-remove-secondary!))))
    
    ;Check method
    (define/public (check)
      (send current-magazine remaining-ammunition))
    
    (super-new)))

             
             
    