(load "matrix.scm")
(load "tile.scm")
(require racket/mpair)

(define level%
  
  (class object%
    
    (init-field tile-matrix)
    
    (field (game-objects (mlist *player*)))
    (field (object-count 0))
    (field (level-bitmap (make-bitmap 1024 1024)))
    (field (level-buffer (new bitmap-dc% [bitmap level-bitmap])))
   
    (define/public (get-level-bitmap) level-bitmap)    
    
    (define/public (add-game-object! name object)
      (set! game-objects (mcons (mcons name object) game-objects)))

    (define/public (draw-level-buffer)
      (send level-buffer clear)
      (let ((start-time (current-milliseconds))
            (delta-time 0))
            (mfor-each (lambda (row)
                         (mfor-each (lambda (tile)
                                      (send tile draw level-buffer))
                                    row))
                       (send tile-matrix get-matrix-representation))
        (set! delta-time (- (current-milliseconds) start-time))
        (display delta-time)))
    
    
    (define/public (object-counter) 
                    (begin
                      (set! object-count (+ 1 object-count))
                      (- object-count 1)))
    
    (define/public (draw-objects-buffer)
      (mfor-each (lambda (object)
                   (send object draw level-buffer))
                 game-objects))
                  

    
    (super-new)))


  
   
   
   
   
   
   