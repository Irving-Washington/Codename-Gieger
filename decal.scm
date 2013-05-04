(define decal%
  (class game-object%
    
    (super-new)
    
    (define/public (set-current-agent! arg)
      (void))
    
    (inherit-field stationary)
    (set! stationary #t)))