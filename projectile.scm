(define projectile%
  
  (class item%
    (super-new)
    
    (init-field start-velocity
                projectile-size
                slow-down
                destroy-on-impact
                stationary-item
                projectile-damage
                excluded-collisions)   
    
    (inherit get-future-position
             delete!)
    
    (inherit-field velocity
                   size
                   position
                   zero-velocity
                   stationary)
    
    (set! velocity start-velocity)
    (set! size projectile-size)
    
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    (define/public (destroy-on-impact?) destroy-on-impact)
    
    (define/public (get-excluded-collisions) excluded-collisions)
    
    (define/public (collide-with object)
      (cond
        ((is-a? object agent%)
         (agent-impact object))
        ((and (is-a? object tile%) destroy-on-impact)
         (wall-impact))
        (else
         (bounce!))))
    
    (define/private (agent-impact agent)
      (send agent increase-health! (- 10 projectile-damage (random 20)))
      
      (define (blood-spray-helper num)
        (unless (>= num 15)           
          (new projectile%
               [start-velocity (mcons (* (+ num 3) (- (random 300) -300 (* 30 num)) 0.0002 (mcar velocity))
                                      (* (+ num 3) (- (random 300) -300 (* 30 num)) 0.0002 (mcdr velocity)))]
               [projectile-size 2]
               [slow-down #t]
               [destroy-on-impact #f]
               [current-agent #f]
               [animation-package #f]
               [position (mcons (+ (round (mcar velocity)) (mcar position))
                                (+ (round (mcdr velocity)) (mcdr position)))]
               [image (read-bitmap "graphics/blood-1.png")]
               [stationary-item (new decal%
                                     [position (mcons 0 0)]
                                     [image (read-bitmap "graphics/blood-1.png")])]
               [projectile-damage 0]
               [excluded-collisions (cons game-object% decal%)])
          (blood-spray-helper (+ num 1))))
      
      (blood-spray-helper 1)
      (if destroy-on-impact
          (delete!)
          (bounce!)))
      
 
    
    (define/private (wall-impact)      
      (let ((x-velocity-factor 1)
            (y-velocity-factor 1))
        
        (if (= (mcar (pixel-to-tile position)) (mcar (pixel-to-tile (get-future-position 1))))
            (set! x-velocity-factor -1)
            (set! y-velocity-factor -1))
        
        (define (wall-debree-helper num)
          (unless (>= num 4)           
            (new projectile%
                 [start-velocity (mcons (* num (+ 50 (random 100)) 0.001 x-velocity-factor (mcar velocity))
                                        (* num (+ 50 (random 150)) 0.001 y-velocity-factor (mcdr velocity)))]
                 [projectile-size 2]
                 [slow-down #t]
                 [destroy-on-impact #t]
                 [current-agent #f]
                 [animation-package #f]
                 [position (mcons (mcar position) (mcdr position))]
                 [image (read-bitmap "graphics/debris-1.png")]
                 [stationary-item (new decal%
                                       [position (mcons 0 0)]
                                       [image (read-bitmap "graphics/debris-1.png")])]
                 [projectile-damage 30]
                 [excluded-collisions (cons decal% item%)])
            (wall-debree-helper (+ num 1))))
        
        (wall-debree-helper 1)
        (delete!)))
    

    (define/public (bounce!)
      (if (= (mcar (pixel-to-tile position)) (mcar (pixel-to-tile (get-future-position 1))))
            (set-mcar! velocity (- (mcar velocity)))
            (set-mcdr! velocity (- (mcdr velocity)))))
  
  
    (define/public (convert-to-stationary!)
      (set! velocity zero-velocity)
      (send *level* add-game-object! stationary-item)
      (send stationary-item set-position! position)
      (send stationary-item set-current-agent! #f)                   
      (delete!))
    
    
    (define/override (move!)
      (super move!)
      (unless (not (and slow-down (not (equal? velocity zero-velocity))))
        (if (and (< (abs (mcdr velocity)) 8) (< (abs (mcar velocity)) 8))
            (convert-to-stationary!)
            (begin (set-mcar! velocity (* 0.96 (mcar velocity)))
                   (set-mcdr! velocity (* 0.96 (mcdr velocity)))))))))

      