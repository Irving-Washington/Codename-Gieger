(load "matrix.scm")
(load "tile.scm")
(require racket/mpair)

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
      (mfor-each (lambda (row)
                  (mfor-each (lambda (tile)
                              (send tile draw))
                            row))
                  (send tile-matrix get-matrix-representation)))
    
    (super-new)))
    

;Bara för att testa!
(define (level-test)
  (let ((tiles (new matrix% [rows 3] [columns 3])))
    (for-each (lambda (row)
                (for-each (lambda (column)
                            (send tiles set-element! row column (new tile% 
                                                                     [position '(25 35)]
                                                                     [seethrough #t]
                                                                     [collidable #f]
                                                                     [image #f])))
                          '(0 1 2)))
              '(0 1 2))
    tiles))
