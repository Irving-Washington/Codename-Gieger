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
    
    (define/public (get-game-objects) game-objects)
    
    (define/public (object-counter) 
      (begin
        (set! object-count (+ 1 object-count))
        (- object-count 1)))
    
    (define/public (get-proximity-object agent-coordinates game-objects)
      (cond 
        ((null? game-objects) #f)
        ((and (not (is-a? (mcar game-objects) player%))
                  (< (abs (- (mcar (send (mcar game-objects) get-position)) (mcar agent-coordinates))) 32)
                  (< (abs (- (mcdr (send (mcar game-objects) get-position)) (mcdr agent-coordinates))) 32))
             (mcar game-objects))
        (else (get-proximity-object agent-coordinates (mcdr game-objects)))))
    
    (define/public (delete-game-object! object)
      (define (delete-helper old-game-objects new-game-objects)
        (cond
          ((null? old-game-objects) new-game-objects)
          ((equal? object (mcar old-game-objects))
           (delete-helper (mcdr old-game-objects) new-game-objects))
          (else
           (delete-helper (mcdr old-game-objects) (mcons (mcar old-game-objects) new-game-objects)))))
      (set! game-objects (delete-helper game-objects '())))
    
    (define/public (agent-interact agent)
      (let ((proximity-object (get-proximity-object (send agent get-position) game-objects)))
        (cond ((is-a? proximity-object firearm%) 
               (send agent item-add! proximity-object)
               (delete-game-object! proximity-object))
              (else (void)))))

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
                   (unless (send object get-stationary)
                     (cond 
                       ((is-a? object projectile%)
                        (projectile-collision object))
                       ((is-a? object agent%)
                        (agent-collision object))
                       (else
                        (send object move!)))))
                 game-objects))

    
    (define/private (pixel-to-tile pixel-position)
      (mcons
       (quotient (mcdr pixel-position) 32)
       (quotient (mcar pixel-position) 32)))
    
    (define/private (agent-collision agent)
      (let ((future-corners (send agent get-future-corner-positions)))
        (unless (not (null? (filter (lambda (corner) (send (send tile-matrix
                                                                 get-element
                                                                 (quotient (cdr corner) 32)
                                                                 (quotient (car corner) 32))
                                                           collidable?))
                                    future-corners)))
          (send agent move!))))
    
    
    (define/private (projectile-collision projectile) 
      
      (define (projectile-collision-helper divisor)
        (let ((future-position (send projectile get-future-position divisor)))
          (send (send tile-matrix
                      get-element
                      (quotient (mcdr future-position) 32)
                      (quotient (mcar future-position) 32))
                collidable?)))

      (cond
        ((not (projectile-collision-helper 1))
         (send projectile move!))
        ((not (projectile-collision-helper 2))
         (send projectile set-position! (send projectile get-future-position 2)))
        ((not (projectile-collision-helper 4))
         (send projectile set-position! (send projectile get-future-position 4)))
        (else
         (if (send projectile destroy-on-impact?)
             (delete-game-object! projectile)
             (send projectile bounce!)))))
    
    

    
    (define/public (collision? object)
      (let ((tile-pos (pixel-to-tile (send object get-future-position))))
        (display tile-pos)
        (send (send tile-matrix
                    get-element
                    (mcar tile-pos)
                    (mcdr tile-pos))
              collidable?)))
    
    
    (super-new)))


  
   
   
   
   
   
   