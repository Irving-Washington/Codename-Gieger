(define weapon%
  
  (class item%
    
    (init-field base-damage)
    
    (define/public (use)
      (let ((agent (send *level* get-agent (send current-agent get-position))))
        (unless (not agent)
          (send agent set-health! (+ base-damage (- (random 21) 10))))))
    
    (super-new)))
            
          