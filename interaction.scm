(define interaction%
  
  (class object%
    
    (init-field *player*
                *game-loop*)
    
    (define/public (new-key-event key-event)
      (cond 
        ;Movement key-events
        ((eq? key-event 'w) (send *player* increase-velocity-y! -1))
        ((eq? key-event 'a) (send *player* increase-velocity-x! -1))
        ((eq? key-event 's) (send *player* increase-velocity-y! 1))
        ((eq? key-event 'd) (send *player* increase-velocity-x! 1))
        ((or (eq? key-event 'releasew) (eq? key-event 'releases)) (send *player* set-velocity-y! 0))
        ((or (eq? key-event 'releasea) (eq? key-event released)) (send *player* set-velocity-x! 0))
        
        ;Weapon key-events
        ((eq? key-event 'r) (send *player* firearm-reload))
        ((eq? key-event 'f) (send *player* firearm-check))
        
        ;Pause menu
        ((eq? key-event 'esc) (send *game-loop* pause))))
    
    (define/public (new-mouse-event mouse-event)
      (cond
        ;Fire
        ((eq? mouse-event 'left) (send *player* item-use))
        
        ;Throw
        ((eq? mouse-event 'right) (send *player* item-throw))))
    
    (define/public (new-mouse-position mouse-position)
      ;Update mouse position
      (send *player* set-aim-target! mouse-position))
    
    (super-new)))
