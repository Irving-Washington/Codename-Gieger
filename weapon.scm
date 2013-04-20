(define weapon%
  
  (class item%
    (super-new)
    (init-field base-damage)
    
    ;Use method
    (define/public (use)
      (let ((agent (send *level* get-agent (send current-agent get-position))))
        (unless (not agent)
            (send agent set-health! (+ base-damage (- (random 21) 10))))))))
            
        