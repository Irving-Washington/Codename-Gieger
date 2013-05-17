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