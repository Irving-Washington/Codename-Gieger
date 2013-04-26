(define animation-package-list
  (list
   (cons 'player-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/player-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/player-unarmed-move1.png")
                                (read-bitmap "graphics/player-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/player-unarmed-idle.png")]
              [item-secondary-image (read-bitmap "graphics/player-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/player-death1.png")
                                     (read-bitmap "graphics/player-death2.png")
                                     (read-bitmap "graphics/player-death3.png"))]))
   (cons 'player-pistol
         (new animation-package%
              [idle-image (read-bitmap "graphics/player-pistol-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/player-pistol-idle.png")
                                (read-bitmap "graphics/player-pistol-move.png"))]
              [item-use-image (read-bitmap "graphics/player-pistol-use.png")]
              [item-secondary-image (read-bitmap "graphics/player-pistol-idle.png")]
              [death-animation (list (read-bitmap "graphics/player-death1.png")
                                     (read-bitmap "graphics/player-death2.png")
                                     (read-bitmap "graphics/player-death3.png"))]))))

(define (get-animation-package package-name)
  (cdr (assq package-name animation-package-list)))