;class: npc
;superclass: agent
;this class defines all non-player characters controlled by the AI.

(define npc%  
  
  (class agent%
    
    ;Each NPC has an AI that controls them, this data is kept inside the field ai.
    ;current-move-target is the position at which the NPC is moving towards.
    ;delta-x  -and y are distances in x and y direction respectively to their target.
    ;distance-to-target is the pythagorean distance to the target.
    (field (ai (new ai% [current-agent this]))
           (current-move-target #f)
           (delta-x #f)
           (delta-y #f)
           (distance-to-target #f))
    
    ;position is the current position of an npc on the level.
    ;velocity is the current velocity of an npc on the level.
    ;run-speed is the maximum speed an npc can recieve.
    (inherit-field position
                   velocity
                   run-speed)
    
    ;Sets the current move target to a new location.
    (define/public (set-current-move-target! target)
      (set! current-move-target target))
    
    ;Removes the current move target, stopping the npc from moving.
    (define/public (remove-move-target!)
      (set! current-move-target #f)
      (set! velocity (mcons 0 0)))
    
    ;Retrieves the distance left in x and y directions respectively.
    (define/public (get-delta-x) delta-x)
    (define/public (get-delta-y) delta-y)
    
    ;Retrieves the pythagorean distance left to the target.
    (define/public (get-distance-to-target) distance-to-target)
    
    ;Moves the npc on the level.
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