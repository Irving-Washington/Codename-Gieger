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
          
                