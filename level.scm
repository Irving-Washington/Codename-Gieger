(define level%
  
  (class object%
    
    (init-field tile-matrix)
    
    (field (game-objects (mlist)))
    
    (field (object-count 0))
    
    (field (level-bitmap (make-bitmap 1536 768)))
    (field (level-load (new bitmap-dc% [bitmap level-bitmap])))
    
    (field (buffered-bitmap (make-bitmap 1536 768)))
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
    
    
    (define/public (get-proximity-object coordinates size exclusion-types object-list)
      (if (null? object-list)
          #f
          (let* ((current-object (mcar object-list))
                (delta-x (- (mcar coordinates) (mcar (send current-object get-position))))
                (delta-y (- (mcdr coordinates) (mcdr (send current-object get-position)))))
            
            
            (if (and (not (is-a? current-object (car exclusion-types)))
                     (not (is-a? current-object (cdr exclusion-types)))
                     (>= delta-x 0)
                     (<= delta-x size)
                     (>= delta-y 0)
                     (<= delta-y size))
                current-object   
                (get-proximity-object coordinates size exclusion-types (mcdr object-list))))))
    
    
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
      (let ((proximity-object (get-proximity-object (send agent get-center-position) 32 (cons agent% decal%) game-objects)))
        (cond ((or (is-a? proximity-object firearm%) (is-a? proximity-object consumable%))
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
        (when (null? (filter (lambda (corner) (send (send tile-matrix
                                                          get-element
                                                          (quotient (cdr corner) 32)
                                                          (quotient (car corner) 32))
                                                    collidable?))
                             future-corners))
          (send agent move!))))
    
    
    (define/private (projectile-collision projectile)
      (let ((collision-target #f)
            (excluded-collisions (send projectile get-excluded-collisions)))
        
        (define (projectile-collision-helper divisor)
          (let ((future-position (send projectile get-future-position divisor)))
            (set! collision-target (send tile-matrix
                                         get-element
                                         (quotient (mcdr future-position) 32)
                                         (quotient (mcar future-position) 32)))
            (if (send collision-target collidable?)
                #t
                (begin
                  (set! collision-target (get-proximity-object future-position 32 excluded-collisions game-objects))
                  ;(display collision-target)
                  (if collision-target
                      #t
                      #f)))))
                  
        
        (cond
          ((not (projectile-collision-helper 1))
           (send projectile move!))
          ((and #f (not (projectile-collision-helper 2)))
           (send projectile set-position! (send projectile get-future-position 2))
           (send projectile collide-with collision-target))
          ((and #f (not (projectile-collision-helper 4)))
           (send projectile set-position! (send projectile get-future-position 4))
           (send projectile collide-with collision-target))
          (else
           (send projectile collide-with collision-target)))))
    
    (super-new)))


  
   
   
   
   
   
   