#lang racket/gui

(require racket/mpair)

(define *level-size* (cons 24 48))

;class: game-object
;superclass: object
;this class defines all game objects, such as agents and items.a

(define game-object%
  
  (class object%
    
    (init-field position
                image)
    ;All agents are defined with a position
    ;and an image representing the game object.
    
    (field (angle 0)
           (size 32)
           (half-size (/ size 2))
           (velocity (mcons 0.0 0.0))
           (max-velocity 400)
           (stationary #f))
    ;Angle controls the rotation of a game object. It is defined
    ;in radians, with the same definitions of the unit circle,
    ;So an angle of 0 means the object is faced to the right,
    ;an angle of pi/2 means the object is faced upwards,
    ;an angle of pi means the object is faced to the left,
    ;and so on and so forth.
    
    ;Size is the pixel width and height of a game object.
    ;Half-size is self-explanatory. Half the size of the object.
    
    ;Velocity is an mpair of an objects velocity in
    ;x and y direction respectively.
    
    ;Max-velocity is the maximum velocity a game-object can obtain.
    
    ;Stationary explains whether or not a game object is stationary.

    
    (define/public (get-angle) angle)
    ;Retrieves the angle of a game object.
    
    (define/public (set-angle! new-angle)
      (set! angle new-angle))
    ;Sets the angle of a game object to a new value.
    
    
    ;Position method
    (define/public (get-position) position)
    ;Retrieves the position of a game object.
    
    (define/public (get-center-position)
      (mcons (+ (mcar position) half-size)
             (+ (mcdr position) half-size)))
    ;Retrieves the position of the game objects mass centre.
    
    
    ;Movement methods
    (define/public (move!)
      (void))
    ;Causes the game-object to move. This specific definition does
    ;nothing, but it is needed when calling a game-object to move.
    ;There are move! methods in the sub-classes, but they have different
    ;definitions.
    
    (define/public (get-stationary) stationary)
    ;Get's the #t/#f value of whether a game object is
    ;stationary of not.
    
    (define/public (set-stationary! value)
      (set! stationary value))
    ;Set's the #t/#f value of a game objects staionary field.
    
    (define/public (set-position! new-position)
      (set! position new-position))
    ;Set's the game-objects position.
    
    (define/public (get-future-position divisor)
      (mcons (+ (mcar position) (round (/ (mcar velocity) divisor)))
             (+ (mcdr position) (round (/ (mcdr velocity) divisor)))))
    ;Retrieves the game objects future position.
    
    (define/public (get-future-corner-positions)
      (list (cons
              (+ (mcar position) (mcar velocity) 8)
              (+ (mcdr position) (mcdr velocity) 8))
             (cons
              (+ (mcar position) (mcar velocity) size -8)
              (+ (mcdr position) (mcdr velocity) 8))
             (cons
              (+ (mcar position) (mcar velocity) 8)
              (+ (mcdr position) (mcdr velocity) size -8))
             (cons
              (+ (mcar position) (mcar velocity) size -8)
              (+ (mcdr position) (mcdr velocity) size -8))))
    ;Retireves the game-objects future positions for all of it's corners.
    ;This is needed so that a game object cannot for example
    ;walk through walls.
    
    
    (define/public (get-velocity) velocity)
    ;Retrieves the velocity of a game object.
    
    (define/public (set-velocity! new-velocity)
      (set! velocity new-velocity))
    ;Sets the velocity of a game object to another value.
    
    (define/public (set-velocity-x! value)
      (unless (>= value max-velocity)
        (set-mcar! velocity value)))
    ;Sets the velocity in x-direction of a game-object
    ;to another value.
    
    (define/public (set-velocity-y! value)
      (unless (>= value max-velocity)
        (set-mcdr! velocity value)))
    ;Sets the velocity in y-direction of a game-object
    ;to another value.
    
    (define/public (increase-velocity-x! delta-value)
      (unless (>= (abs (+ delta-value (mcar velocity))) max-velocity)
        (set-mcar! velocity (+ (mcar velocity) delta-value))))
    ;Increases the velocity in x-direction of a game-object.
    
    (define/public (increase-velocity-y! delta-value)
      (unless (>= (abs (+ delta-value (mcdr velocity))) max-velocity)
        (set-mcdr! velocity (+ (mcdr velocity) delta-value))))
    ;Increases the velocity in y-direction of a game-object.
    
    
    ;Image method
    (define/public (get-image) image)
    
    (define/public (set-image! new-image)
      (set! image new-image))
    
    ;Draw method
    (define/public (draw level-buffer)
      (let ((temp-angle angle))
        (send level-buffer translate (+ half-size (mcar position)) (+ half-size (mcdr position)))
        (send level-buffer rotate temp-angle)
        (send level-buffer draw-bitmap image (- half-size) (- half-size))
        (send level-buffer rotate (- temp-angle))
        (send level-buffer translate (- (+ half-size (mcar position))) (- (+ half-size (mcdr position))))))
    
    
    
    
    ;Delete method
    (define/public (delete!)
      (send *level* delete-game-object! this))
    
    (send *level* add-game-object! this)
    
    (super-new)))

(define matrix%
  
  (class object%
    
    (init-field rows
                columns)
    
    (field (matrix-representation '()))
    
    (define/public (set-matrix-representation! new-matrix-representation)
      (set! matrix-representation new-matrix-representation))
    
    (define/private (create-matrix-representation)
      
      (define (create-row-helper current-column-num row)
        (if (= current-column-num columns)
            row
            (create-row-helper (+ current-column-num 1) (mcons #f row))))
      
      (define (create-matrix-rep-helper current-row-num matrix-rep)
        (if (= current-row-num rows)
            matrix-rep
            (create-matrix-rep-helper (+ current-row-num 1) (mcons (create-row-helper 0 '()) matrix-rep))))
      
      (set! matrix-representation (create-matrix-rep-helper 0 '())))
    
    (create-matrix-representation)
    
    (define/public (get-element row column)
      
      (define (get-row-helper current-row-num matrix)
        (if (= current-row-num row)
            (mcar matrix)
            (get-row-helper (+ current-row-num 1) (mcdr matrix))))
      
      (define (get-element-helper current-column-num row)
        (if (= current-column-num column)
            (mcar row)
            (get-element-helper (+ current-column-num 1) (mcdr row))))
      
      (get-element-helper 0
                          (get-row-helper 0
                                          matrix-representation)))
      
    
    (define/public (set-element! row column value)
      
      (define (get-row-helper current-row-num matrix)
        (if (= current-row-num row)
            (mcar matrix)
            (get-row-helper (+ current-row-num 1) (mcdr matrix))))
      
      (define (set-element-helper current-column-num row)
        (if (= current-column-num column)
            (set-mcar! row value)
            (set-element-helper (+ current-column-num 1) (mcdr row))))
      
      (set-element-helper 0
                          (get-row-helper 0
                                          matrix-representation)))
    
    (define/public (get-matrix-representation)
      matrix-representation)
  
    (super-new)))

(define level%
  
  (class object%
    
    (init-field tile-matrix
                level-image)
    
    (field (game-objects (mlist))
           (ai-list (mlist))
           (object-count 0)
           (level-bitmap (make-bitmap 1536 768))
           (level-load (new bitmap-dc% [bitmap level-bitmap]))
           (buffered-bitmap (make-bitmap 1536 768))
           (objects-buffer (new bitmap-dc% [bitmap buffered-bitmap])))
    (send objects-buffer set-smoothing 'smoothed)
   
    (define/public (get-buffered-bitmap) buffered-bitmap)  
   
    ;Game objects methods
    (define/public (add-game-object! object)
      (set! game-objects (mcons object game-objects)))
    
    (define/public (get-game-objects) game-objects)
    
    (define/public (add-ai! ai)
      (set! ai-list (mcons ai ai-list)))
    
    (define/public (update-ai)
      (mfor-each (lambda (ai)
                   (send ai scan-level)
                   (send ai update-agent))
                 ai-list))
    
    (define/public (get-proximity-object coordinates size exclusion-types object-list)
      (if (null? object-list)
          #f
          (let* ((current-object (mcar object-list))
                (delta-x (- (mcar coordinates) (mcar (send current-object get-position))))
                (delta-y (- (mcdr coordinates) (mcdr (send current-object get-position)))))
            
            
            (if (and (not (is-a? current-object (car exclusion-types)))
                     (not (is-a? current-object (cdr exclusion-types)))
                     (>= delta-x 0)
                     (<= delta-x size)
                     (>= delta-y 0)
                     (<= delta-y size))
                current-object   
                (get-proximity-object coordinates size exclusion-types (mcdr object-list))))))
    
    
    (define/public (delete-game-object! object)
      (define (delete-helper old-game-objects new-game-objects)
        (cond
          ((null? old-game-objects) new-game-objects)
          ((equal? object (mcar old-game-objects))
           (delete-helper (mcdr old-game-objects) new-game-objects))
          (else
           (delete-helper (mcdr old-game-objects) (mcons (mcar old-game-objects) new-game-objects)))))
      (set! game-objects (delete-helper game-objects '())))
    
    
    (define/public (agent-interact agent)
      (let ((proximity-object (get-proximity-object (send agent get-center-position) 32 (cons agent% decal%) game-objects)))
        (cond ((is-a? proximity-object item%)
               (send agent item-add! proximity-object)
               (delete-game-object! proximity-object))
              (else (void)))))

    ;Load and draw level background
    (define/public (draw-level-buffer)
      (send level-load draw-bitmap level-image 0 0))
        
    
    (define/public (draw-objects-buffer)
      (send objects-buffer draw-bitmap level-bitmap 0 0)
      (mfor-each (lambda (object)
                   (send object draw objects-buffer))
                 game-objects))
    
    (define/public (draw-decals-to-background)
      (mfor-each (lambda (game-object)
                  (when (is-a? game-object decal%)
                    (send game-object draw level-load)
                    (delete-game-object! game-object)))
                game-objects))
    
    (define/public (draw-corpses-to-background)
      (mfor-each (lambda (game-object)
                   (when (and (is-a? game-object agent%) (send game-object death-animation-complete?))
                     (send game-object draw level-load)
                     (delete-game-object! game-object)))
                 game-objects))
    
    (define/public (draw-pause-menu)
      (send objects-buffer set-text-foreground "white")
      (send objects-buffer set-scale 2 2)
      (send objects-buffer draw-text "Game paused." 350 180)
      (send objects-buffer set-scale 1 1))
    
    ;Movement and collision
    (define/public (move-objects)
      (mfor-each (lambda (object)
                   (unless (send object get-stationary)
                     (cond 
                       ((is-a? object projectile%)
                        (projectile-collision object))
                       ((is-a? object agent%)
                        (agent-collision object))
                       (else
                        (send object move!)))))
                 game-objects))

    
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    (define/private (agent-collision agent)
      (let ((future-corners (send agent get-future-corner-positions)))
        (when (null? (filter (lambda (corner) (> (send tile-matrix
                                                        get-element
                                                        (quotient (cdr corner) 32)
                                                        (quotient (car corner) 32))
                                                  2))
                             future-corners))
          (send agent move!))))
    
    
    (define/private (projectile-collision projectile)
      (let ((collision-target #f)
            (excluded-collisions (send projectile get-excluded-collisions)))
        
        (define (projectile-collision-helper divisor)
          (let ((future-position (send projectile get-future-position divisor)))
            (set! collision-target (send tile-matrix
                                         get-element
                                         (quotient (mcdr future-position) 32)
                                         (quotient (mcar future-position) 32)))
            (if (> collision-target 2)
                #t
                (begin
                  (set! collision-target (get-proximity-object future-position 32 excluded-collisions game-objects))
                  (if collision-target
                      #t
                      #f)))))
                  
        
        (cond
          ((not (projectile-collision-helper 1))
           (send projectile move!))
          ((and #f (not (projectile-collision-helper 2)))
           (send projectile set-position! (send projectile get-future-position 2))
           (send projectile collide-with collision-target))
          ((and #f (not (projectile-collision-helper 4)))
           (send projectile set-position! (send projectile get-future-position 4))
           (send projectile collide-with collision-target))
          (else
           (send projectile collide-with collision-target)))))
    
    (super-new)))

(define level-loader%
  
  (class object%
    
    (super-new)
    
    (define/public (get-level-image num)
      (cdr (assq num level-image-list)))
    
    (define/public (get-level-data num)
      (let ((matrix (new matrix% 
                         [rows (car *level-size*)]
                         [columns (cdr *level-size*)])))
        (send matrix set-matrix-representation! (cdr (assq num level-list)))
        matrix))
      
    (define level-image-list
      (list
       (cons 1 (read-bitmap "levels/level-1.png"))))
    
    
    (define level-list
      (list
       (cons 1
             (mlist (mlist 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 4 4 4 4 4 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 4 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 4 4 4 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4 4 4 0 0 4 4 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 4)
                    (mlist 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4)))))))

;class: animation-package
;superclass: object
;this class creates animation packages for agents

(define animation-package%
  
  (class object%
    
    (init-field idle-image
                move-image-pair
                item-use-image
                item-secondary-image
                death-animation)
    ;idle-image is the image used as the agent stands still
    
    ;move-image-pair is a pair that contains the two images
    ;that are switched between during the course of walking
    
    ;item-use-image is an image that overrides the agents image
    ;as it uses a weapon
    
    ;item-secondary-image is the image that overrides the idle image
    
    ;death-animation is the animation that plays when an agent dies.
    
    
    (field (move-switcher #f)
           (death-switcher 0))
    
    ;move-switcher is a memory state that is used when playing 
    ;for example a walking animation
    
    ;death-switcher is a memory state that is used when playing
    ;the death animation.
    
    
    (define/public (get-idle-image) idle-image)
    ;Retrieves the idle-image from the agent.
    
    (define/public (get-item-use-image) item-use-image)
    ;Retrieves the item-use-image from the agent.
    
    (define/public (get-item-secondary-image) item-secondary-image)
    ;Retrieves the item-secondary-image from the agent.
    
    (define/public (get-next-move-image) 
      (set! move-switcher (not move-switcher))
      (if move-switcher
          (car move-image-pair)
          (cdr move-image-pair)))
    ;Retrieves the image that will be used next as the
    ;agent is moving.
    
    (define/public (get-next-death-image)
      (set! death-switcher (+ death-switcher 1))
      (cond
        ((= 1 death-switcher) (car death-animation))
        ((= 2 death-switcher) (cadr death-animation))
        (else (caddr death-animation))))
    ;Retrieves the image that will be used next during
    ;the course of death.
        
    
    (super-new)))

;class: decal
;superclass: game-object
;this class defines decals, small pictures such as stationary blood.

(define decal%
  
  (class game-object%
    
    (super-new)
    
    (define/public (set-current-agent! arg)
      (void))
    
    (inherit-field stationary)
    (set! stationary #t)))

;class: agent
;superclass: game-object
;this class defines all agents (i.e player and npc's)

(define agent%
  
  (class game-object%
    
    (init-field team
                animation-package)
    ;All agents belong to a certain team. this variable is used
    ;to help npc's determine whether to attack an agent or not
    
    ;Animation-package is a variable to determine what kind of
    ;animations a certain agent should perform, depending on what
    ;the current agent is doing, for example, this plays a walking
    ;animation if the agent is walking
    
    
    (inherit-field position
                   velocity
                   angle
                   size)
    ;Position, velocity, angle and size are variables that determine
    ;how a certain game-object performs in the game.
    
    
    (inherit set-image!)
    ;set-image! is a procedure defined in game-object that changes
    ;the current image to another image
    
    
    (field (health 100)
           (radiation 0)
           (radiation-time 0)
           (inventory (mcons #f #f))
           (target-coordinates (mcons 0 0))
           (dead #f)
           (death-animation-complete #f)
           (use-animation-time 0)
           (move-animation-time 0)
           (used-item #f)
           (default-animation-package animation-package)
           (out-of-ammo #f)
           (run-speed 2))
    ;All these fields are agent-specific variables. If an agents
    ;health reaches zero, the agent is considered dead.
    
    ;Radiation is a variable that can be gained by letting an agent,
    ;for example, eat contaminated bread, and will automatically
    ;decrease towards zero, while at the same time removing one
    ;health point every time one radiation point is removed.
    
    ;Inventory consists of two slots, and is defined as a pair
    ;An agent can have two different items in it's inventory
    ;at a time. The agents current item is defined as the mcar of the pair
    
    ;Target-coordinates is the cooridnate that will determine the
    ;aim direction (angle) of an agent.
    
    ;Dead is a variable that checks whether or not an agent is dead.
    
    ;Use-animation-time is the variable that determines the time it
    ;takes for an agent to perform an animation as it uses an objet,
    ;for example a handgun, or a consumable such as bread.
    
    ;Move-animation-time is the variable that determines how long
    ;it takes for each picture swap while an agent is moving.
    
    ;Used-item checks whether or not an agent has recently used an item.
    ;If the value is #t, the agent will play an animation in respect to
    ;it's current item in use.
    
    ;Default-animation-package is the animation package that is used
    ;while the player has nothing equipped in it's main inventory slot.
    
    ;Out-of-ammo is a #t/#f value that will determine whether or not
    ;the agents current firearm will display a use-animation.
    
    ;Run-speed is the velocity at which an npc moves.
   
    
    ;
    (define/public (get-team) team)
    ;Retrieves the team variable from an agent.
    
    
    ;
    ;Health methods
    (define/public (get-health) health)
    ;Retrieves the current health of an agent.
    
    (define/public (increase-health! delta-value)
      (unless dead
        (if (> (+ health delta-value) 100)
            (set! health 100)
            (set! health (+ health delta-value)))
        (unless (> health 0)
          (die))))
    ;Modifies the current health of an agent.
    
    
    ;
    ;Radiation methods
    (define/public (get-radiation) radiation)
    ;Retrieves the current amount of radiation 
    ;from an agent.
    
    (define/public (set-radiation! delta-value)
      (set! radiation (+ radiation delta-value)))
    ;Modifies the current radiation of an agent.
    
    (define/public (radiate!)
      (unless (< (- (current-milliseconds) radiation-time) 500)
        (when (> radiation 0)
          (increase-health! -1)
          (set-radiation! -1))
        (set! radiation-time (current-milliseconds))))
    ;Causes an agent to "radiate", which means the
    ;Radiation will decrease proportionally to the health, until
    ;it reaches zero.
    
    
    ;
    ;Aim-direction methods
    
    (define/public (set-aim-target! coordinates)
      (unless dead
        (set! target-coordinates coordinates)
        (let ((x-position (+ 16 (mcar position)))
              (y-position (+ 16 (mcdr position)))
              (x-coordinates (mcar coordinates))
              (y-coordinates (mcdr coordinates)))
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
    ;Sets the angle at which an agent will be rotated towards.
    
    (define/public (get-projectile-position)
      (mcons (+ 20 (round (* 16 (sin angle))) (mcar position)) (+ 20 (round (* -16 (sin angle))) (mcdr position))))
    ;Retrieves the current projectile position.
    
    (define/public (get-projectile-velocity speed-factor)
      (mcons (* speed-factor (cos angle)) (* (- speed-factor) (sin angle))))
    ;Retrieves the velocity of a projectile.
    
    (define/public (get-random-projectile-velocity speed-factor)
      (let ((random-angle (+ angle -0.3 (/ (random 30) 100.0))))
        (mcons (* speed-factor (cos random-angle)) (* (- speed-factor) (sin random-angle)))))
    ;Makes a random angle at which certain projectiles would
    ;be fired from.
    
    
    
    ;
    ;Inventory methods
    
    (define/public (item-add! item)
      (cond ((not (mcar inventory)) (set-mcar! inventory item))
            ((not (mcdr inventory)) (set-mcdr! inventory item))
            (else (item-throw)
                  (set-mcar! inventory item)))
      (send item set-current-agent! this)
      (change-animation-package!))
    ;Adds an item to an agents inventory. If both slots
    ;are filled, it will throw the main item and equip the item
    ;it recently added.
    
    (define/public (get-first-item)
      (mcar inventory))
    ;Retrieves the main item from an agents inventory.
    
    (define/public (get-second-item)
      (mcdr inventory))
    ;Retrieves the secondary item from an agents inventory.
    
    (define/public (item-use)
      (unless dead
        (unless (not (mcar inventory))
          (send (mcar inventory) use))))
    ;Makes the agent use it's item in it's main slot.
    
    (define/public (set-used-item! value)
      (set! used-item value))
    ;Sets the variable 'used-item' to a value, more specifically
    ;a #t/#f value.
    
    (define/public (item-remove-primary!)
      (set-mcar! inventory #f)
      (change-animation-package!))
    ;Removes the main inventory item from the agent.
    
    (define/public (item-remove-secondary!)
      (set-mcdr! inventory #f))
    ;Removes the secondary inventory item from an agent.
    
    (define/public (item-throw velocity)
      (unless dead
        (when (mcar inventory)
          (begin
            (new projectile% 
                 [projectile-size 32]
                 [start-velocity velocity]
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
    ;Creates a projectile out of the agents current main item,
    ;which is then reverted back to an item in the level, which
    ;can be picked up yet again.
    
    (define/public (item-switch!)
      (let ((temp (mcar inventory)))
        (set-mcar! inventory (mcdr inventory))
        (set-mcdr! inventory temp))
      (change-animation-package!))
    ;Swaps the secondary item with the main item in an agents inventory.

    
    ;
    ;Move method
    
    (define/override (move!)
      (unless dead
        (set-aim-target! target-coordinates)
        (set-mcar! position (+ (mcar position) (mcar velocity)))
        (set-mcdr! position (+ (mcdr position) (mcdr velocity)))))
    ;Moves the agent around in the level.
    
    
    ;
    ;Animation methods
    
    (define/public (move-animation)
      (unless (< (- (current-milliseconds) move-animation-time) 350)
        (if (and (= 0 (mcar velocity)) (= 0 (mcdr velocity)))
            (set-image! (send animation-package get-idle-image))
            (set-image! (send animation-package get-next-move-image)))
        (set! move-animation-time (current-milliseconds))))
    ;Animates an agents movement.
    
    (define/public (change-animation-package!)
      (if (mcar inventory)
          (set! animation-package (send (mcar inventory) get-animation team))
          (set! animation-package default-animation-package)))
    ;Changes an agents current animation packate, depending on what kind of
    ;item an agent is holding.
    
    (define/private (use-animation)
      (unless (and (< (- (current-milliseconds) use-animation-time) 100) out-of-ammo)
        (if used-item
            (begin
              (set-image! (send animation-package get-item-use-image))
              (set! used-item #f))
            (move-animation))
        (set! use-animation-time (current-milliseconds))))
    ;Changes an agents animation to a state so that it looks like it's using
    ;it's item.
    
    (define/public (death-animation)
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
      (if (> (- (current-milliseconds) use-animation-time) 3000)
          (set! death-animation-complete #t)
          (unless (< (- (current-milliseconds) move-animation-time) 500)
            (set-image! (send animation-package get-next-death-image))
            (blood-spray-helper 1)
            (set! move-animation-time (current-milliseconds)))))
    ;Begins a death animation.
    
    
    ;
    ;Die method
    
    (define/public (die)
      (item-throw (get-projectile-velocity 15))
      (item-switch!)
      (item-throw (get-projectile-velocity 15))
      (set! dead #t)
      (set! move-animation-time 0)
      (set! use-animation-time (current-milliseconds)))
    ;Kills the agent, rendering it un-interactable by the AI and player.
    
    (define/public (is-dead?) dead)
    ;Checks whether or not the agent is dead.
    
    (define/public (death-animation-complete?) death-animation-complete)
    
    
    ;
    ;Draw method
    
    (define/override (draw level-buffer)
      (if dead
          (death-animation)
          (begin
            (move-animation)
            (use-animation)))
      (super draw level-buffer))
    ;Draws the agent on the level.
    
    (super-new)))

(define item%
  
  (class game-object%
    
    (inherit-field position
                   velocity)
    
    (init-field current-agent
                animation-package)
    
    (field (zero-velocity (mcons 0.0 0.0)))
    
    (define/public (get-animation team) 
      (cond ((eq? team 'kgb) (car animation-package))
            ((eq? team 'cia) (cdr animation-package))))
    
    ;Current agent methods
    (define/public (get-current-agent) current-agent)
    (define/public (set-current-agent! new-agent)
      (set! current-agent new-agent))
    
    (define/override (draw level-buffer)
      (unless current-agent
        (super draw level-buffer)))
    
    (define/override (move!)
      (unless (equal? velocity zero-velocity)
        (set-mcar! position (+ (mcar position) (round (mcar velocity))))
        (set-mcdr! position (+ (mcdr position) (round (mcdr velocity))))))
      
    (super-new)))

(define player%
  
  (class agent%
    (inherit-field angle
                   inventory)
    (inherit get-projectile-position
             get-projectile-velocity
             item-remove-primary!)

    ;Firarm methods
    (define/public (firearm-reload)
      (when (is-a? (mcar inventory) firearm%)
        (send (mcar inventory) reload!)))
    
    (define/public (firearm-check)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar inventory) check)))
    
    ;World interaction
    (define/public (world-interact)
      (send *level* agent-interact this))
    
    (super-new)))

(define npc%  
  
  (class agent%
    
    (field (ai (new ai% [current-agent this]))
           (current-move-target #f)
           (delta-x #f)
           (delta-y #f)
           (distance-to-target #f))
    
    (inherit-field position
                   velocity
                   run-speed)
    
    
    (define/public (set-current-move-target! target)
      (set! current-move-target target))
    
    (define/public (remove-move-target!)
      (set! current-move-target #f)
      (set! velocity (mcons 0 0)))
    
    (define/public (get-delta-x) delta-x)
    (define/public (get-delta-y) delta-y)
    (define/public (get-distance-to-target) distance-to-target)
    
    (define/override (move!)
      (when current-move-target
        (set! delta-x (- (mcar current-move-target) (mcar position)))
        (set! delta-y (- (mcdr current-move-target) (mcdr position)))
        (set! distance-to-target (sqrt (+ (expt delta-x 2) (expt delta-y 2))))
        
        (unless (<= distance-to-target 32)
          (set! velocity (mcons (round (/ (* run-speed delta-x) distance-to-target))
                                (round (/ (* run-speed delta-y) distance-to-target))))))
    (super move!))
  
  
  (super-new)))

(define weapon% 
  (class item%
    (super-new)
    
    (init-field base-damage)
    
    
    ;Use method
    (define/public (use)
      (void))))

;class: consumable
;subclass to: item
;this class defines all consumables that can be used by agents

(define consumable%
  
  (class item%
    
    (init-field consumable-health
                consumable-radiation)
    ;consumable-health is the value that will be added to
    ;the agent using the item.
    
    ;consumable-radiation is the value that will be added to
    ;the agent using the item.
    
    
    (inherit-field current-agent)
    ;current-agent holds the name
    ;of the owner of an item.
    
    
    ;Consumable methods
    (define/public (get-consumable-health) consumable-health)
    ;Retrieves the health potential of a consumable.
    
    (define/public (get-consumable-radiation) consumable-radiation)
    ;Retrieves the radiation potential of a consumable.
    
    
    ;Use methods
    (define/public (use)
      (begin (send current-agent increase-health! consumable-health)
             (send current-agent set-radiation! consumable-radiation)
             (send current-agent set-used-item! #t)
             (send current-agent item-remove-primary!)))
    ;Causes an agent to use the consumable, gaining it's effects.

    (super-new)))

(define magazine%
  
  (class item%
    
    (init-field ammunition-capacity
                ammunition-type)
    (field (ammunition ammunition-capacity))
    
    ;Ammunition methods

    (define/public (get-ammunition-capacity) ammunition-capacity)
    (define/public (get-ammunition-type) ammunition-type)
    (define/public (get-ammunition) ammunition)
    
    (define/public (use)
      (void))

    (super-new)))

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
        ((and (number? object) destroy-on-impact)
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

;class: firearm
;superclass: weapon
;this class defines firearms

(define firearm%
  
  (class weapon%
    
    (super-new)
    
    (inherit-field current-agent
                   base-damage)
    ;current-agent holds the name
    ;of the owner of an item.
    
    ;base-damage determines a base damage
    ;of a weapon.
    
    
    (field (current-magazine #f))
    ;current-magazine holds the amount of
    ;ammunition left in the current weapon.
    
    
    (init-field ammunition
                ammunition-type)
    ;ammunition hold the value of how much ammo there is
    ;in a weapon when the weapon is created.
    
    ;ammunition-type is a symbol that determines what kind
    ;of ammunition the firearm dispenses.
    
    
    (define/public (get-ammunition) ammunition)
    ;Retrieves the amount of ammunition left in a weapon.
    
    
    ;Use method
    (define/override (use)
      (unless (<= ammunition 0)
        (cond
          ((eq? ammunition-type 'bullet)
           (fire-bullet))
          ((eq? ammunition-type 'pellets)
           (fire-pellets)))
        (send current-agent set-used-item! #t)))
    ;Uses the firearm, dispensing ammunition.
    
    (define/private (fire-bullet)
      (new projectile%
           [start-velocity (send current-agent get-projectile-velocity 32)]
           [projectile-size 2]
           [slow-down #f]
           [destroy-on-impact #t]
           [current-agent #f]
           [animation-package #f]
           [position (send current-agent get-projectile-position)]
           [image (read-bitmap "graphics/bullet-1.bmp")]
           [stationary-item #f]
           [projectile-damage base-damage]
           [excluded-collisions (cons decal% item%)])
      (set! ammunition (- ammunition 1)))
    ;Dispenses the ammunition type 'bullet.
    
    (define/private (fire-pellets)
      (define (pellet-spread-helper num)
        (unless (>= num 8)
          (new projectile%
               [start-velocity (send current-agent get-random-projectile-velocity 24)]
               [projectile-size 1]
               [slow-down #f]
               [destroy-on-impact #t]
               [current-agent #f]
               [animation-package #f]
               [position (send current-agent get-projectile-position)]
               [image (read-bitmap "graphics/bullet-1.bmp")]
               [stationary-item #f]
               [projectile-damage base-damage]
               [excluded-collisions (cons decal% item%)])
          (pellet-spread-helper (+ num 1))))
      (pellet-spread-helper 0)
      (set! ammunition (- ammunition 1)))
    ;Dispenses the ammunition type 'pellets.
    
    
    ;Reload method
    (define/public (reload!)
      (let ((second-item (send current-agent get-second-item)))
        (when (and (is-a? second-item magazine%) (eq? (send second-item get-ammunition-type)
                                                      ammunition-type))
          (begin (set! ammunition (send second-item get-ammunition))
                 (send current-agent item-remove-secondary!)))))
    ;Reloads the weapon if there is a magazine with the corresponding
    ;ammunition type in the agents secondary inventory slot.
    
    ;Check method
    (define/public (check)
      (send current-magazine remaining-ammunition))
    ;Checks the amount of ammunition left in a weapon
    
    (void)))

;class: ai
;superclass: object
;this class is the artificial intelligence that controls the npc's

(define ai%
  
  (class object%
    
    (init-field current-agent)
    ;An AI belongs to an agent, but never a player.
    
    (field (current-target #f)
           (attack-target #f)
           (last-use-time (current-milliseconds))
           (use-delay 1000)
           (possible-targets (mlist)))
    ;Current-target is the field that determines the angle at which the
    ;NPC will be rotated towards.
    
    ;Attack-target is the field that determines whether or not the NPC will
    ;attack another agent.
    
    ;Last-use-time is used to cause some latency between the use of items
    ;to prevent NPCs from shooting without delay
    
    ;Possible-targets is a mutable list of agents that belongs to a team not
    ;eq? to the current agents team.
    
    
    
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
    ;Scans the level for possible targets, and sets the NPCs current
    ;target to a possible target.
          
          
    
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
    ;Updates the AI to make the NPC act, depending on it's current state.
      
    
    
    (define/private (use-weapon)
      (send current-agent item-use)
      (set! last-use-time (current-milliseconds)))
    ;Causes the NPC to use it's weapon.  
    
    
    
    (define/private (visible-from-agent? target-position)     
      #t)
    ;Checks whether or not the NPC can see it's target.
    
    
    
    (send *level* add-ai! this)
    (super-new)))

(define interaction%
  
  (class object%
    
    (field (list-of-keys '())
           (game-paused #f))
    
    ;list-of-keys will be refered to as lok from here on
    
    ;Keyboard controls
    (define/public (new-key-event key-code shift-code)
      (cond       
        ;Movement key-events
        
        ((eq? key-code #\w) (send *player* set-velocity-y! -3))
        ((eq? key-code #\a) (send *player* set-velocity-x! -3))
        ((eq? key-code #\s) (send *player* set-velocity-y! 3))
        ((eq? key-code #\d) (send *player* set-velocity-x! 3))  
        ;Weapon key-events
        ((eq? key-code #\r) (send *player* firearm-reload))
        ((eq? key-code #\f) (send *player* increase-health! -50))
        ((eq? key-code #\q) (send *player* item-switch!))
        ;Interaction event
        ((eq? key-code #\e) (send *player* world-interact)) 
        ;Pause menu
        ((eq? key-code 'escape) (pause-game))))
    
    (define/public (new-key-release-event key-release)
      (cond 
        ;Movement key-release-events
        ((or (eq? key-release #\w) (eq? key-release #\s)) (send *player* set-velocity-y! 0))
        ((or (eq? key-release #\d) (eq? key-release #\a)) (send *player* set-velocity-x! 0))))
    
    
    ;Mouse controls
    (define/public (new-mouse-event mouse-event)
      ;(display mouse-event)
      (cond
        ;Fire
        ((eq? mouse-event 'left-down) (send *player* item-use))
        ;Throw
        ((eq? mouse-event 'right-down) (send *player* item-throw (send *player* get-projectile-velocity 25)))))
    
    
    ;Update mouse position
    (define/public (new-mouse-position mouse-position)
      (send *player* set-aim-target! mouse-position))
    
    (define/private (pause-game)
      (set! game-paused (not game-paused))
      (if game-paused
          (send *game-loop* stop)
          (send *game-loop* start 16))
      (send *level* draw-pause-menu)
      (send *canvas* refresh))
    
    (super-new)))

(define input-canvas%
  
  (class canvas%
    
    (inherit refresh)
    (define aux-eventspace (make-eventspace))
    
    ;Keyboard events
    (define/override (on-char key-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda ()
           (send *interaction* new-key-event (send key-event get-key-code) (send key-event get-shift-down))
           (send *interaction* new-key-release-event (send key-event get-key-release-code))))))
    
    ;Mouse events
    (define/override (on-event mouse-event)
      (parameterize ((current-eventspace aux-eventspace))
        (queue-callback
         (lambda () 
           (send *interaction* new-mouse-event (send mouse-event get-event-type))
           (send *interaction* new-mouse-position (mcons (send mouse-event get-x)
                                                        (send mouse-event get-y)))))))
    
    (super-new)))

;This file contains all the animation packages that
;are used by the agents.

(define animation-package-list
  (list
   (cons 'kgb-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-unarmed-move1.png")
                                (read-bitmap "graphics/kgb-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'kgb-bread
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-bread-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-bread-move1.png")
                                (read-bitmap "graphics/kgb-bread-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-bread-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-bread-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'kgb-magazine
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-unarmed-move1.png")
                                (read-bitmap "graphics/kgb-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'kgb-pistol
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-pistol-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-pistol-move1.png")
                                (read-bitmap "graphics/kgb-pistol-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-pistol-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-pistol-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   (cons 'kgb-shotgun
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-shotgun-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-shotgun-move1.png")
                                (read-bitmap "graphics/kgb-shotgun-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-shotgun-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   (cons 'cia-pistol
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-pistol-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-pistol-move1.png")
                                (read-bitmap "graphics/cia-pistol-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-pistol-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-pistol-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))
   
   (cons 'cia-shotgun
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-shotgun-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-shotgun-move1.png")
                                (read-bitmap "graphics/cia-shotgun-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-shotgun-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-shotgun-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))
   
   (cons 'cia-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-unarmed-move1.png")
                                (read-bitmap "graphics/cia-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-unarmed-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))))

(define (get-animation-package package-name)
  (cdr (assq package-name animation-package-list)))

(define (create-item item-name item-position item-agent)
  (cond
    ((eq? item-name 'makarov-pb)
     (new firearm%
          [ammunition 8]
          [ammunition-type 'bullet]
          [base-damage 70]
          [current-agent item-agent]
          [animation-package (cons (get-animation-package 'kgb-pistol)
                                   (get-animation-package 'cia-pistol))]
          [position item-position]
          [image (read-bitmap "graphics/makarov-pb.png")]))
    ((eq? item-name 'mp-133)
     (new firearm%
          [ammunition 6]
          [ammunition-type 'pellets]
          [base-damage 30]
          [current-agent item-agent]
          [animation-package (cons (get-animation-package 'kgb-shotgun)
                                   (get-animation-package 'cia-shotgun))]
          [position item-position]
          [image (read-bitmap "graphics/mp-133.png")]))
    ((eq? item-name 'bread-clean)
     (new consumable%
          [consumable-health 40]
          [consumable-radiation 0]
          [current-agent item-agent]
          [animation-package (cons (get-animation-package 'kgb-bread)
                                   #f)]
          [position item-position]
          [image (read-bitmap "graphics/bread-1.png")]))
    ((eq? item-name 'irridated-bread)
     (new consumable%
          [consumable-health 30]
          [consumable-radiation 30]
          [current-agent item-agent]
          [animation-package (cons (get-animation-package 'kgb-bread)
                                   #f)]
          [position item-position]
          [image (read-bitmap "graphics/irridated-bread1.png")]))
    ((eq? item-name 'mp-133-magazine)
     (new magazine%
          [ammunition-capacity 6]
          [ammunition-type 'pellets]
          [current-agent item-agent]
          [animation-package (cons (get-animation-package 'kgb-magazine)
                                   #f)]
          [position item-position]
          [image (read-bitmap "graphics/magazine-1.png")]))
          
          
    (else
     (error "Invalid item name: " item-name))))


(define (spawn-item item-name item-position)
  (create-item item-name item-position #f))

(define (give-item item-name agent)
  (let ((new-item (create-item item-name (mcons 0 0) #f)))
    (send agent item-add! new-item)))

(define *level-loader* (new level-loader%))
(define *level* (new level% 
                     [tile-matrix (send *level-loader* get-level-data 1)]
                     [level-image (send *level-loader* get-level-image 1)]))
(send *level* draw-level-buffer)

(define *player* (new player%
                      [position (mcons 800 120)]
                      [image (read-bitmap "graphics/kgb-unarmed-idle.png")]
                      [team 'kgb]
                      [animation-package (get-animation-package 'kgb-unarmed)]))

(spawn-item 'mp-133-magazine (mcons 500 400))
(spawn-item 'bread-clean (mcons 300 300))
(spawn-item 'irridated-bread (mcons 300 350))
(spawn-item 'makarov-pb (mcons 150 150))
(give-item 'mp-133 *player*)

(give-item 'makarov-pb (new npc%
                            [position (mcons 1000 100)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))
(give-item 'makarov-pb (new npc%
                            [position (mcons 200 600)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))
(give-item 'makarov-pb (new npc%
                            [position (mcons 1050 600)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))

 

(define *window* (new frame%
                      [width 1550]
                      [height 805]
                      [label "The Exclusion Zone"]))

(define (*renderer* canvas dc)
  (send dc draw-bitmap (send *level* get-buffered-bitmap) 0 0))

(define *canvas* (new input-canvas%
                        [parent *window*]
                        [paint-callback *renderer*]))

(define *interaction* (new interaction%))

(send *window* show #t)

(define *game-loop*
  (new timer%
       [notify-callback (lambda ()
                          (begin
                            (send *level* move-objects)
                            (send *level* update-ai)
                            (send *level* draw-decals-to-background)
                            (send *level* draw-corpses-to-background)
                            (send *level* draw-objects-buffer)
                            (send *player* radiate!)
                            (send *canvas* refresh)))]))
(send *game-loop* start 16)

;Launches the game