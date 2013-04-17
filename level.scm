(define level%
  
  (class object%
    
    (init-field tile-matrix)
    
    (field (game-objects '()))
    (field (object-count 0))
    
    (define/public (add-game-object! name object)
      (set! game-objects (mcons (mcons name object) game-objects)))
    
    (define/public (object-counter) 
                    (begin
                      (set! object-count (+ 1 object-count))
                      (- object-count 1)))

    (define/public (draw)
      (for-each (lambda (row)
                  (for-each (lambda (tile)
                              (send tile draw))
                            row)
                  tile-matrix)))
    
    (super-new)))
    
    ;(define/public (collision? position
    
