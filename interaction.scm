;class: interaction
;superclass: object
;this class defines the interaction methods the user has
;to control the player.

(define interaction%
  
  (class object%
    
    (field (game-paused #f))
    
    
    ;Keyboard controls
    
    
    ;Recieves information from input-canvas, and does the appropriate action
    ;in regards to what key has been pressed or released.
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
    
    ;Recieves information from input-canvas, and does the appropriate action
    ;in regards to what mouse events has occured.
    (define/public (new-mouse-event mouse-event)
      ;(display mouse-event)
      (cond
        ;Fire
        ((eq? mouse-event 'left-down) (send *player* item-use))
        ;Throw
        ((eq? mouse-event 'right-down) (send *player* item-throw (send *player* get-projectile-velocity 25)))))
    
    ;Update mouse position
    
    ;Recieves information about the current mouse position and updates
    ;the angle of the player accordingly.
    (define/public (new-mouse-position mouse-position)
      (send *player* set-aim-target! mouse-position))
    
    
    ;Pauses the game loop.
    (define/private (pause-game)
      (set! game-paused (not game-paused))
      (if game-paused
          (send *game-loop* stop)
          (send *game-loop* start 16))
      (send *level* draw-pause-menu)
      (send *canvas* refresh))
    
    (super-new)))
