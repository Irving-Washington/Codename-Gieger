;class: item
;superclass: game-object
;this class defines all items that can be obtained in the game.

(define item%
  
  (class game-object%
    
    ;Position and velocity are fields from the class game object,
    ;they keep track of the position and velocity of the item.
    (inherit-field position
                   velocity)
    
    ;The field current-agent holds information about what agent is currently
    ;in posession of this item. If the value is #f, the item belongs to no one
    ;and can be found lying on the ground.
   
    ;animation-package holds the animation an agent recieves when the agent
    ;picks this item up.
    (init-field current-agent
                animation-package)
    
    ;zero-velocity is defined with one decimal in each direction, to easily
    ;round down the velocity until the item reaches zero.
    (field (zero-velocity (mcons 0.0 0.0)))
    
    ;Retrieves the animation the item holds for the agent.
    (define/public (get-animation team) 
      (cond ((eq? team 'kgb) (car animation-package))
            ((eq? team 'cia) (cdr animation-package))))
    
    ;Current agent methods
    
    ;Retrieves the current agent of the item.
    (define/public (get-current-agent) current-agent)
    
    ;Sets the current agent to a new agent.
    (define/public (set-current-agent! new-agent)
      (set! current-agent new-agent))
    
    ;Draws the item on the level.
    (define/override (draw level-buffer)
      (unless current-agent
        (super draw level-buffer)))
    
    ;Moves the item around in level.
    (define/override (move!)
      (unless (equal? velocity zero-velocity)
        (set-mcar! position (+ (mcar position) (round (mcar velocity))))
        (set-mcdr! position (+ (mcdr position) (round (mcdr velocity))))))
      
    (super-new)))