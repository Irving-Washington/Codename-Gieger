(define agent%
  
  (class game-object%
    
    (init-field team
                animation-package)
    
    (inherit-field position
                   velocity
                   angle
                   size)
    
    (inherit set-image!)
    
    (field (health 100)
           (radiation 0)
           (inventory (mcons #f #f))
           (target-coordinates (cons 0 0))
           (dead #f)
           (use-animation-time 0)
           (move-animation-time 0)
           (used-item #f)
           (default-animation-package animation-package)
           (out-of-ammo #f))
  
    (define/public (get-team) team)
    
    ;Health methods
    (define/public (get-health) health)
    (define/public (increase-health! delta-value)
      (if (> (+ health delta-value) 100)
          (set! health 100)
          (set! health (+ health delta-value)))
      (unless (> health 0)
        (die)))
    
    ;Radiation methods
    (define/public (get-radiation) radiation)
    (define/public (set-radiation! delta-value)
      (set! radiation (+ radiation delta-value)))
    
    (define/public (radiate!)
      (when (> radiation 0)
        (increase-health! -1)
        (set-radiation! -1)))
       
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
      (mcons (+ 16 (round (* 20 (sin angle))) (mcar position)) (+ 20 (round (* -16 (sin angle))) (mcdr position))))
    
    (define/public (get-projectile-velocity speed-factor)
      (mcons (* speed-factor (cos angle)) (* (- speed-factor) (sin angle))))
    
        (define/public (get-random-projectile-velocity speed-factor)
          (let ((random-angle (+ angle -0.3 (/ (random 30) 100.0))))
            (mcons (* speed-factor (cos random-angle)) (* (- speed-factor) (sin random-angle)))))
   
    ;Inventory methods
    (define/public (item-add! item)
      (cond ((not (mcar inventory)) (set-mcar! inventory item))
            ((not (mcdr inventory)) (set-mcdr! inventory item))
            (else (item-throw)
                  (set-mcar! inventory item)))
      (send item set-current-agent! this)
      (change-animation-package!))
    
    (define/public (get-first-item)
      (mcar inventory))
    
    (define/public (get-second-item)
      (mcdr inventory))
    
    (define/public (item-use)
      (unless dead
        (unless (not (mcar inventory))
          (send (mcar inventory) use))))
    
    (define/public (set-used-item! value)
      (set! used-item value))
    
    (define/public (item-remove-primary!)
      (set-mcar! inventory #f)
      (change-animation-package!))
    
    (define/public (item-remove-secondary!)
      (set-mcdr! inventory #f))
    
    (define/public (item-throw)
      (unless dead
        (when (mcar inventory)
          (begin
            (new projectile% 
                 [projectile-size 32]
                 [start-velocity (get-projectile-velocity 25)]
                 [slow-down #t]
                 [destroy-on-impact #f]
                 [current-agent #f]
                 [animation-package animation-package]
                 [position (get-projectile-position)]
                 [image (send (mcar inventory) get-image)]
                 [stationary-item (mcar inventory)]
                 [projectile-damage 50]
                 [excluded-collisions (cons decal% item%)])
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
      (unless (and (< (- (current-milliseconds) use-animation-time) 100) out-of-ammo)
        (if used-item
            (begin
              (set-image! (send animation-package get-item-use-image))
              (set! used-item #f))
            (move-animation))
        (set! use-animation-time (current-milliseconds))))
    
    (define/public (death-animation)
      (unless (or (< (- (current-milliseconds) move-animation-time) 500) (> (- (current-milliseconds) use-animation-time) 3000))
        (set-image! (send animation-package get-next-death-image))
        (define (blood-spray-helper num)
        (unless (>= num 7)           
          (new projectile%
               [start-velocity (mcons (* (+ 5 num) (- (random 300) -300 (* 20 num)) (mcar (get-random-projectile-velocity 20)) 0.0002) 
                                      (* (+ 5 num) (- (random 300) -300 (* 20 num)) (mcdr (get-projectile-velocity 20)) 0.0002))]
               [projectile-size 2]
               [slow-down #t]
               [destroy-on-impact #f]
               [current-agent #f]
               [animation-package #f]
               [position (mcons (+ 14 (mcar position))
                                (+ 10 (mcdr position)))]
               [image (read-bitmap "graphics/blood-1.png")]
               [stationary-item (new decal%
                                     [position (mcons 0 0)]
                                     [image (read-bitmap "graphics/blood-1.png")])]
               [projectile-damage 0]
               [excluded-collisions (cons game-object% decal%)])
          (blood-spray-helper (+ num 1))))
        (blood-spray-helper 1)
        (set! move-animation-time (current-milliseconds))))
    
    ;Die method
    (define/public (die)
      (set! dead #t)
      (set! move-animation-time 0)
      (set! use-animation-time (current-milliseconds)))
      
      ;(death-animation-loop 0 0))
    
    (define/public (is-dead?) dead)
    
    ;Draw method
    (define/override (draw level-buffer)
      (if dead
          (death-animation)
          (begin
            (move-animation)
            (use-animation)))
      (super draw level-buffer))
    
    (super-new)))
