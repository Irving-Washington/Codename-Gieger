(define ai%
  
  (class object%
    
    (init-field current-agent)
    
    (field (current-target #f)
           (attack-target #f)
           (last-use-time (current-milliseconds))
           (use-delay 1000)
           (possible-targets (mlist)))
    
    (define/public (scan-level)
      (mfor-each (lambda (target)
                   (when (and (is-a? target agent%)
                              (not (eq? (send target get-team) (send current-agent get-team)))
                              (not (send target is-dead?))
                              (visible-from-agent? (send target get-position)))
                     (set! possible-targets (mcons target possible-targets))))                                            
                 (send *level* get-game-objects))
      (if (null? possible-targets)
          (begin
            (set! current-target #f)
            (set! attack-target #f))
          (begin
            (set! current-target (send (mcar possible-targets) get-position))
            (set! attack-target #t)))
      (set! possible-targets (mlist)))
          
          
    
    (define/public (update-agent)
      (if current-target
        (begin
          (send current-agent set-aim-target! current-target)
          (cond ((not attack-target)
                 (send current-agent set-current-move-target! current-target))
                ((and (> (- (current-milliseconds) last-use-time) use-delay) 
                      (is-a? (send current-agent get-first-item) firearm%)
                      (> (send (send current-agent get-first-item) get-ammunition) 0))
                 (use-weapon)
                 (send current-agent set-current-move-target! current-target))
                ((and (> (- (current-milliseconds) last-use-time) use-delay)
                      (is-a? (send current-agent get-first-item) weapon%)
                      (< (send current-agent get-distance-to-target) 40))
                 (use-weapon))))
        (send current-agent remove-move-target!)))
                    
                    
      
    
    (define/private (use-weapon)
      (send current-agent item-use)
      (set! last-use-time (current-milliseconds)))
      
    
    (define/private (visible-from-agent? target-position)     
      #t)
    
    (send *level* add-ai! this)
    (super-new)))
    