(define level-loader%
  (class object%
    (super-new)
    (define/public (load-level level-num)
      ;Helper method to create the correct tile corresponding to the level data
      (define (create-tile tile-type pos-x pos-y)
        (cond
          ((eq? 0 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/grass-2.png")]))
          ((eq? 1 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #f]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/bwall-1.bmp")]))
          ((eq? 3 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/dirt-1.png")]))
          ((eq? 4 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/roadside-1.png")]))
          ((eq? 5 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/road-1.png")]))
          ((eq? 6 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/roadcenter.png")]))
          ((eq? 7 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/roadside-2.png")]))
          ((eq? 8 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-1.png")]))
          ((eq? 9 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-2.png")]))
          ((eq? 10 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-3.png")]))
          ((eq? 11 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-4.png")]))
          ((eq? 12 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-5.png")]))
          ((eq? 13 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #t]
                                  [image (read-bitmap "graphics/roadblock-6.png")]))
          ((eq? 14 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/road-crack-1.png")]))
          ((eq? 15 tile-type) (new tile%
                                  [position (cons (* pos-x 32) (* pos-y 32))]
                                  [seethrough #t]
                                  [collidable #f]
                                  [image (read-bitmap "graphics/road-hole-1.png")]))
          (else (error "No such tile: " tile-type))))                                        
      
      (let ((tile-matrix (new matrix% [rows (car *level-size*)] [columns (cdr *level-size*)]))
            (tile-num 0))
        (for-each (lambda (tile)
                    (begin
                      (send tile-matrix set-element!
                            (quotient tile-num (cdr *level-size*))
                            (remainder tile-num (cdr *level-size*))
                            (create-tile tile (remainder tile-num (cdr *level-size*)) (quotient tile-num (cdr *level-size*))))
                      (set! tile-num (+ tile-num 1))))
                  (get-level-data level-num))
        tile-matrix))
    
    (define/private (get-level-data num)
      (cdr (assq num level-list)))
    

    
    
    
    
    
    (define level-list
      (list
       (cons 1
             (list 1  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
                   1  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 1 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 1 1 0 0 1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 8 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  4 4 4 4 4 4 4 4 4 4 4 4 9 4 4 4 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 5 5 5 5 14 5 5 5 5 5 5 5 10 5 5 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 6 6 6 6 6 6 6 6 6 6 6 6 11 6 6 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 5 5 5 5 5 5 5 5 15 5 5 5 12 5 5 5 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 7 7 7 7 7 7 7 7 7 7 7 7 13 7 7 7 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1  1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))
       
       
       
       
       (cons 2
             (list 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 1 0 0 0 1 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 1 0 1 0 0 0 0 0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 1 0 0 0 0 1 1 1 1 0 0 1 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 1 0 0 0 0 1 0 0 1 0 0 1 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 1 0 0 0 0 1 1 1 1 0 0 1 0 0 1 1 1 1 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1
                   1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1))))))
    