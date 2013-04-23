(define level%
  
  (class object%
    
    (init-field tile-matrix)
    
    (field (game-objects (mlist)))
    (field (object-count 0))
    
    (field (level-bitmap (make-bitmap 1024 1024)))
    (field (level-load (new bitmap-dc% [bitmap level-bitmap])))
    
    (field (buffered-bitmap (make-bitmap 1024 1024)))
    (field (objects-buffer (new bitmap-dc% [bitmap buffered-bitmap])))
    (send objects-buffer set-smoothing 'smoothed)
   
    (define/public (get-buffered-bitmap) buffered-bitmap)  
   
    ;Game objects methods
    (define/public (add-game-object! object)
      (set! game-objects (mcons object game-objects)))
    
    (define/public (object-counter) 
      (begin
        (set! object-count (+ 1 object-count))
        (- object-count 1)))
    
    (define/public (delete-game-object! object)
      (define (delete-helper old-game-objects new-game-objects)
        (cond
          ((null? old-game-objects) new-game-objects)
          ((equal? object (mcar old-game-objects))
           (delete-helper (mcdr old-game-objects) new-game-objects))
          (else
           (delete-helper (mcdr old-game-objects) (mcons (mcar old-game-objects) new-game-objects)))))
      (set! game-objects (delete-helper game-objects '())))  

    ;Load and draw level background
    (define/public (draw-level-buffer)
      (send level-load clear)
      (mfor-each (lambda (row)
                   (mfor-each (lambda (tile)
                                (send tile draw level-load))
                              row))
                 (send tile-matrix get-matrix-representation)))
        
    (define/public (draw-objects-buffer)
      (send objects-buffer draw-bitmap level-bitmap 0 0)
      (mfor-each (lambda (object)
                   (send object draw objects-buffer))
                 game-objects))
    
    (define/public (move-objects)
      (mfor-each (lambda (object)
                   (cond 
                     ((and (collision? object)
                           (is-a? object projectile%) 
                           (send object destroy-on-impact?))
                      (delete-game-object! object))
                     ((and (collision? object)
                           (is-a? object projectile%)
                           (not (send object destroy-on-impact?)))
                      (send object bounce!))
                     ((and (collision? object)
                           (is-a? object agent%))
                      (void))
                     (else
                      (send object move!))))
                 game-objects))
    
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    (define/public (collision? object)
      (let ((tile-pos (pixel-to-tile (send object get-future-position))))
        (if (send (send tile-matrix
                        get-element
                        (mcar tile-pos)
                        (mcdr tile-pos))
                  collidable?)
            #t
            #f)))
                 
      
    (super-new)))


  
   
   
   
   
   
   