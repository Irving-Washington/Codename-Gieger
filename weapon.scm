(define weapon%
  
  (class item%
    (super-new)
    (init-field base-damage)
    
    (field (animation-package (new animation-package%
                                   [idle-image (read-bitmap "graphics/litvinenko-still.png")]
                                   [move-image-pair (cons 
                                                     (read-bitmap "graphics/litvinenko-right-hand-forward.png")
                                                     (read-bitmap "graphics/litvinenko-left-hand-forward.png"))]
                                   [use-image (read-bitmap "graphics/litvinenko-still.png")])))
    
    
    ;Use method
    (define/public (use)
      (let ((agent (send *level* get-agent (send current-agent get-position))))
        (unless (not agent)
            (send agent set-health! (+ base-damage (- (random 21) 10))))))))
            
        