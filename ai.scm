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
    