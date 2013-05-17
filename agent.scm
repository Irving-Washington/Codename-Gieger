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
