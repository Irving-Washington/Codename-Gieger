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