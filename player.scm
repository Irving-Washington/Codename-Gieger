(define player%
  
  (class agent%
    (inherit-field angle
                   inventory)
    (inherit get-projectile-position
             get-projectile-velocity
             item-remove-primary!)
    ;Item methods
    (define/public (item-switch! item)
      (let ((temp (mcar inventory)))
        (set-mcar! inventory (mcdr inventory))
        (set-mcdr! inventory temp)))
    
    (define/public (item-throw)
      (unless (not (mcar inventory))
        (begin
          (new projectile% 
               [projectile-size 8]
               [start-velocity (get-projectile-velocity)]
               [current-agent #f]
               [position (get-projectile-position)]
               [image (send (mcar inventory) get-image)])
          (item-remove-primary!))))
    
    ;Firarm methods
    (define/public (firearm-reload)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar inventory) reload)))
    
    (define/public (firearm-check)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar-inventory) check)))
    
    ;World interaction
    (define/public (world-interact)
      (void))
    
    (super-new)))