(define player%  
  
  (class agent%
    
    (define/public (item-switch!)
      (let ((temp (mcar inventory)))
        (set-mcar! inventory (mcdr inventory))
        (set-mcdr! inventory (temp))))
    
    
    (define/public (item-throw)
      (new projectile%
           [name 'projectile]
           [position position]
           [image (send (mcar inventory) get-image)]
           [velocity (mcons 10 10)])
      (item-remove!))
    
    (define/public (firearm-reload)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar inventory) reload)))
    
    (define/public (firearm-check)
      (unless (not (is-a? (mcar inventory) %firearm))
        (send (mcar-inventory) check)))
    
    (define/public (world-interact)
      (void))
    
    (super-new)))
    
    
           