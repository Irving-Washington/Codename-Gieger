(define agent%
  
  (class game-object%
    
    (init-field team)
    
    (field (health 100))
    (field (radiation 0))
    (field (velocity (mcons 0 0)))
    (field (aim-direction (/ pi 2)))
    (field (inventory (mcons #f #f)))
    
    (define/public (get-team) team)
    
    (define/public (get-health) health)
    (define/public (set-health! delta-value)
      (set! health (+ health delta-value)))
    
    (define/public (get-radiation) radiation)
    (define/public (set-radiation! delta-value)
      (set! radiation (+ radiation delta-value)))
    
    (define/public (get-velocity) velocity)
    (define/public (set-velocity-x! delta-value)
      (set-mcar! velocity (+ (mcar velocity) delta-value)))
    (define-public (set-velocity-y! delta-value)
      (set-mcdr! velocity (+ (mcdr velocity) delta-value)))
    
    (define/public (set-aim-direction! angle)
      (set! aim-direction angle)) 
    
    (define/public (item-use)
      (send (mcar hand-items) use))
    
    (define/public (item-add! item)
      (cond ((not (mcar inventory)) (set-mcar! inventory item))
            ((not (mcdr inventory)) (set-mcdr! inventory item))
            (else (set-mcar! inventory item))))
    
    (define/public (item-remove-primary!)
      (set-mcar! inventory #f))
    
    (define/public (item-remove-secondary!)
      (set-mcdr! inventory #f))
     
    (define/public (move)
      (set-mcar! position (+ (mcar position) (mcar velocity)))
      (set-mcdr! position (+ (mcdr position) (mcdr velocity))))
   
    (define/public (die)
      (void))
    
    (super-new)))
    