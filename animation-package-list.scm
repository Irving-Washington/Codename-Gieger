(define animation-package-list
  (list
   (cons 'kgb-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-unarmed-move1.png")
                                (read-bitmap "graphics/kgb-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'kgb-bread
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-bread-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-bread-move1.png")
                                (read-bitmap "graphics/kgb-bread-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-bread-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-bread-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'kgb-pistol
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-pistol-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-pistol-move1.png")
                                (read-bitmap "graphics/kgb-pistol-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-pistol-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-pistol-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   (cons 'kgb-shotgun
         (new animation-package%
              [idle-image (read-bitmap "graphics/kgb-shotgun-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/kgb-shotgun-move1.png")
                                (read-bitmap "graphics/kgb-shotgun-move2.png"))]
              [item-use-image (read-bitmap "graphics/kgb-shotgun-use.png")]
              [item-secondary-image (read-bitmap "graphics/kgb-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/kgb-dead1.png")
                                     (read-bitmap "graphics/kgb-dead2.png")
                                     (read-bitmap "graphics/kgb-dead3.png"))]))
   
   (cons 'cia-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-unarmed-move1.png")
                                (read-bitmap "graphics/cia-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-unarmed-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-death1.png")
                                     (read-bitmap "graphics/cia-death2.png")
                                     (read-bitmap "graphics/cia-death3.png"))]))))

(define (get-animation-package package-name)
  (cdr (assq package-name animation-package-list)))