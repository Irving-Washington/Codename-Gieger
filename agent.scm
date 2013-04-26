;(load "game-object.scm")
(define agent%
  
  (class game-object%
    
    (init-field team
                animation-package)
    
    (inherit-field position
                   velocity
                   angle
                   size)
    
    (inherit set-image!)
    
    (field (health 100))
    (field (radiation 0))
    (field (inventory (mcons #f #f)))
    (field (target-coordinates (cons 0 0)))
    (field (dead #f))
    (field (use-animation-time 0))
    (field (move-animation-time 0))
    (field (used-item #f))
    (field (default-animation-package animation-package))
    
    (define/public (get-team) team)
    
    ;Health methods
    (define/public (get-health) health)
    (define/public (increase-health! delta-value)
      (set! health (+ health delta-value))
      (unless (> health 0)
        (die)))
    
    ;Radiation methods
    (define/public (get-radiation) radiation)
    (define/public (set-radiation! delta-value)
      (set! radiation (+ radiation delta-value)))
       
    ;Aim-direction methods
    
    (define/public (set-aim-target! coordinates)
      (unless dead
        (set! target-coordinates coordinates)
        (let ((x-position (+ 16 (mcar position)))
              (y-position (+ 16 (mcdr position)))
              (x-coordinates (car coordinates))
              (y-coordinates (cdr coordinates)))
          (cond ((or (and (> (- x-coordinates x-position) 0)
                          (> (- y-coordinates y-position) 0))
                     (and (> (- x-coordinates x-position) 0)
                          (< (- y-coordinates y-position) 0)))
                 (set! angle (- (atan (/ (- y-position y-coordinates)
                                         (- x-position x-coordinates))))))
                ((or (and (< (- x-coordinates x-position) 0)
                          (> (- y-coordinates y-position) 0))
                     (and (< (- x-coordinates x-position) 0)
                          (< (- y-coordinates y-position) 0)))
                 (set! angle (- 3.1416 (atan (/ (- y-position y-coordinates)
                                                (- x-position x-coordinates))))))))))
    
    (define/public (get-projectile-position)
      (mcons (+ (mcar position) (round (* 32 (cos angle)))) (+ (mcdr position) (round (* -32 (sin angle))))))
    
    (define/public (get-projectile-velocity speed-factor)
      (mcons (round (* speed-factor (cos angle))) (round (* (- speed-factor) (sin angle)))))
   
    ;Inventory methods
    (define/public (item-add! item)
      (cond ((not (mcar inventory)) (set-mcar! inventory item))
            ((not (mcdr inventory)) (set-mcdr! inventory item))
            (else (item-throw)
                  (set-mcar! inventory item)))
      (send item set-current-agent! this)
      (change-animation-package!))
    
    (define/public (item-use)
      (unless dead
        (unless (not (mcar inventory))
          (send (mcar inventory) use)
          (set! used-item #t))))
    
    (define/public (item-remove-primary!)
      (set-mcar! inventory #f)
      (change-animation-package!))
    
    (define/public (item-remove-secondary!)
      (set-mcdr! inventory #f))
    
    (define/public (item-throw)
      (unless dead
        (unless (not (mcar inventory))
          (begin
            (new projectile% 
                 [projectile-size 8]
                 [start-velocity (get-projectile-velocity 25)]
                 [slow-down #t]
                 [destroy-on-impact #f]
                 [current-agent #f]
                 [position (get-projectile-position)]
                 [image (send (mcar inventory) get-image)]
                 [stationary-item (mcar inventory)])
            (item-remove-primary!)))))
    
    (define/public (item-switch!)
      (let ((temp (mcar inventory)))
        (set-mcar! inventory (mcdr inventory))
        (set-mcdr! inventory temp))
      (change-animation-package!))
    
    ;Move method
    (define/override (move!)
      (unless dead
        (set-aim-target! target-coordinates)
        (set-mcar! position (+ (mcar position) (mcar velocity)))
        (set-mcdr! position (+ (mcdr position) (mcdr velocity)))))
    
    ;Animation methods
    (define/public (move-animation)
      (unless (< (- (current-milliseconds) move-animation-time) 350)
        (if (and (= 0 (mcar velocity)) (= 0 (mcdr velocity)))
            (set-image! (send animation-package get-idle-image))
            (set-image! (send animation-package get-next-move-image)))
        (set! move-animation-time (current-milliseconds))))
    
    (define/public (change-animation-package!)
      (if (mcar inventory)
          (set! animation-package (send (mcar inventory) get-animation))
          (set! animation-package default-animation-package)))
    
    (define/private (use-animation)
      (unless (< (- (current-milliseconds) use-animation-time) 100)
        (if used-item
            (begin
              (set-image! (send animation-package get-item-use-image))
              (set! used-item #f))
            (move-animation))
        (set! use-animation-time (current-milliseconds))))
    
    ;Die method
    (define/public (die)
      (set! dead #t)
      (set! move-animation-time 0)
      
      (define (death-animation-loop delta-time stage)
        (cond
          ((= stage 3)
           (void))
          ((< delta-time 300)
           (death-animation-loop (- (current-milliseconds) move-animation-time) stage))
          (else                        
           (set-image! (send animation-package get-next-death-image))
           (set! move-animation-time (current-milliseconds))
           (death-animation-loop 0 (+ stage 1)))))
      
      (death-animation-loop 0 0))
    
    ;Draw method
    (define/override (draw level-buffer)
      (unless dead
        (move-animation)
        (use-animation))
      (super draw level-buffer))
    
    (super-new)))
