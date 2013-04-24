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
    (field (animation-time 0))
    
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
            (else (set-mcar! inventory item))))
    
    (define/public (item-use)
      (unless dead
        (unless (not (mcar inventory))
          (send (mcar inventory) use))))
    
    (define/public (item-remove-primary!)
      (set-mcar! inventory #f))
    
    (define/public (item-remove-secondary!)
      (set-mcdr! inventory #f))
    
    ;Move method
    (define/override (move!)
      (unless dead
        (move-animation)
        (set-aim-target! target-coordinates)
        (set-mcar! position (+ (mcar position) (mcar velocity)))
        (set-mcdr! position (+ (mcdr position) (mcdr velocity)))))
    
    (define/public (move-animation)
      (if (and (= 0 (mcar velocity)) (= 0 (mcdr velocity)))
          (set-image! (send animation-package get-idle-image))
          (let ((delta-time (- (current-milliseconds) animation-time)))
            (unless (< delta-time 350)
              (begin
                (set-image! (send animation-package get-next-move-image))
                (set! animation-time (current-milliseconds)))))))
    
    ;Die method
    (define/public (die)
      (set! dead #t)
      (set! animation-time 0)
      
      (define (death-animation-loop delta-time stage)
        (cond
          ((= stage 3)
           (void))
          ((< delta-time 300)
           (death-animation-loop (- (current-milliseconds) animation-time) stage))
          (else                        
           (set-image! (send animation-package get-next-death-image))
           (set! animation-time (current-milliseconds))
           (death-animation-loop 0 (+ stage 1)))))
      
      (death-animation-loop 0 0))
    
    (super-new)))
