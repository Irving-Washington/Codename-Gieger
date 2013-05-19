;class: player
;superclass: agent
;this class defines the player, the agent controlled by the user.

(define player%
  
  (class agent%
    
    ;angle defines which direction the player will be looking towards.
    ;inventory is the players inventory.
    (inherit-field angle
                   inventory)
    
    ;Retrieves the projectile position and velocity.
    ;Removes the main hand item.
    (inherit get-projectile-position
             get-projectile-velocity
             item-remove-primary!)

    ;Firarm methods
    
    ;Reloads the main hand item if it's a firearm, and the player
    ;has a magazine.
    (define/public (firearm-reload)
      (when (is-a? (mcar inventory) firearm%)
        (send (mcar inventory) reload!)))
    
    ;Checks the amount of ammunution left in the firearm.
    (define/public (firearm-check)
      (unless (not (is-a? (mcar inventory) firearm%))
        (send (mcar inventory) check)))
    
    
    ;World interaction
    
    ;Manages the world interaction between player and nearby objects.
    (define/public (world-interact)
      (send *level* agent-interact this))
    
    (super-new)))