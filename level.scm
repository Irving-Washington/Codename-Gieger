(define level%
  
  (class object%
    
    (init-field tile-matrix
                level-image)
    
    (field (game-objects (mlist))
           (ai-list (mlist))
           (object-count 0)
           (level-bitmap (make-bitmap 1536 768))
           (level-load (new bitmap-dc% [bitmap level-bitmap]))
           (buffered-bitmap (make-bitmap 1536 768))
           (objects-buffer (new bitmap-dc% [bitmap buffered-bitmap])))
    (send objects-buffer set-smoothing 'smoothed)
   
    (define/public (get-buffered-bitmap) buffered-bitmap)  
   
    ;Game objects methods
    (define/public (add-game-object! object)
      (set! game-objects (mcons object game-objects)))
    
    (define/public (get-game-objects) game-objects)
    
    (define/public (add-ai! ai)
      (set! ai-list (mcons ai ai-list)))
    
    (define/public (update-ai)
      (mfor-each (lambda (ai)
                   (send ai scan-level)
                   (send ai update-agent))
                 ai-list))
    
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
        (cond ((is-a? proximity-object item%)
               (send agent item-add! proximity-object)
               (delete-game-object! proximity-object))
              (else (void)))))

    ;Load and draw level background
    (define/public (draw-level-buffer)
      (send level-load draw-bitmap level-image 0 0))
        
    
    (define/public (draw-objects-buffer)
      (send objects-buffer draw-bitmap level-bitmap 0 0)
      (mfor-each (lambda (object)
                   (send object draw objects-buffer))
                 game-objects))
    
    (define/public (draw-decals-to-background)
      (mfor-each (lambda (game-object)
                  (when (is-a? game-object decal%)
                    (send game-object draw level-load)
                    (delete-game-object! game-object)))
                game-objects))
    
    (define/public (draw-corpses-to-background)
      (mfor-each (lambda (game-object)
                   (when (and (is-a? game-object agent%) (send game-object death-animation-complete?))
                     (send game-object draw level-load)
                     (delete-game-object! game-object)))
                 game-objects))
    
    (define/public (draw-pause-menu)
      (send objects-buffer set-text-foreground "white")
      (send objects-buffer set-scale 2 2)
      (send objects-buffer draw-text "Game paused." 350 180)
      (send objects-buffer set-scale 1 1))
    
    ;Movement and collision
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
        (when (null? (filter (lambda (corner) (> (send tile-matrix
                                                        get-element
                                                        (quotient (cdr corner) 32)
                                                        (quotient (car corner) 32))
                                                  2))
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
            (if (> collision-target 2)
                #t
                (begin
                  (set! collision-target (get-proximity-object future-position 32 excluded-collisions game-objects))
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


  
   
   
   
   
   
   