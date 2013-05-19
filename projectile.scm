;class: projectile
;superclass: item
;this class defines the projectiles, "moving items".

(define projectile%
  
  (class item%
    
    (super-new)
    
    ;The initiation velocity is defined by start-velocity, as some projectiles
    ;suffer from friction and will eventually stop moving.
    ;Projectiles also has a size, which is used in the collision detection.
    ;slow-down is the friction value.
    ;destroy-on-impact is a #t/#f value that defines whether the projectile
    ;will be destroyed on collision or not.
    ;stationary-item is a #t/#f value that defines whether or not the
    ;item is stationary or not.
    ;projectile-damage holds a numeric value that will remove health from an
    ;agent if it collides with that agent.
    ;excluded-collisions are things the projectile does not collide with.
    (init-field start-velocity
                projectile-size
                slow-down
                destroy-on-impact
                stationary-item
                projectile-damage
                excluded-collisions)   
    
    ;get-future-position retrieves the future position of a projectile.
    ;delete! removes a projectile from the list of game objects.
    (inherit get-future-position
             delete!)
    
    ;velocity is the velocity of a projectile
    ;size is the size of a projectile
    ;position is the position of a projectile
    ;zero-velocity is a 1-decimal value, used to help with rounding/flooring.
    ;stationary is a #t/#f value, decides whether or not the projectile is
    ;stationary.
    (inherit-field velocity
                   size
                   position
                   zero-velocity
                   stationary)
    
    ;sets the velocity to start velocity.
    (set! velocity start-velocity)
    
    ;sets the size to projectile-size.
    (set! size projectile-size)
    
    ;converts from pixel-coordinates to tile-coordinates.
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    ;Predicate: will the projectile be destroyed when it collides?
    (define/public (destroy-on-impact?) destroy-on-impact)
    
    ;retrieves the list of objects the projectiles will not collide with.
    (define/public (get-excluded-collisions) excluded-collisions)
    
    ;Manages the collision between projectiles and game objects.
    (define/public (collide-with object)
      (cond
        ((is-a? object agent%)
         (agent-impact object))
        ((and (number? object) destroy-on-impact)
         (wall-impact))
        (else
         (bounce!))))
    
    
    ;Manages the collision between projectiles and agents.
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
      
    ;Manages the collision between projectiles and collidble walls.
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
    
    ;Causes the projectile to bounce off a collidible.
    (define/public (bounce!)
      (if (= (mcar (pixel-to-tile position)) (mcar (pixel-to-tile (get-future-position 1))))
            (set-mcar! velocity (- (mcar velocity)))
            (set-mcdr! velocity (- (mcdr velocity)))))
  
    ;Converts the projectile to a stationary item.
    (define/public (convert-to-stationary!)
      (set! velocity zero-velocity)
      (send *level* add-game-object! stationary-item)
      (send stationary-item set-position! position)
      (send stationary-item set-current-agent! #f)                   
      (delete!))
    
    ;Moves the projectile in the level.
    (define/override (move!)
      (super move!)
      (unless (not (and slow-down (not (equal? velocity zero-velocity))))
        (if (and (< (abs (mcdr velocity)) 8) (< (abs (mcar velocity)) 8))
            (convert-to-stationary!)
            (begin (set-mcar! velocity (* 0.96 (mcar velocity)))
                   (set-mcdr! velocity (* 0.96 (mcdr velocity)))))))))