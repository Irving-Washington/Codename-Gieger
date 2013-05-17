;This file contains all the animation packages that
;are used by the agents.

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
   
   (cons 'kgb-magazine
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
   (cons 'cia-pistol
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-pistol-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-pistol-move1.png")
                                (read-bitmap "graphics/cia-pistol-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-pistol-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-pistol-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))
   
   (cons 'cia-shotgun
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-shotgun-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-shotgun-move1.png")
                                (read-bitmap "graphics/cia-shotgun-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-shotgun-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-shotgun-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))
   
   (cons 'cia-unarmed
         (new animation-package%
              [idle-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [move-image-pair (cons 
                                (read-bitmap "graphics/cia-unarmed-move1.png")
                                (read-bitmap "graphics/cia-unarmed-move2.png"))]
              [item-use-image (read-bitmap "graphics/cia-unarmed-use.png")]
              [item-secondary-image (read-bitmap "graphics/cia-unarmed-idle.png")]
              [death-animation (list (read-bitmap "graphics/cia-dead1.png")
                                     (read-bitmap "graphics/cia-dead2.png")
                                     (read-bitmap "graphics/cia-dead3.png"))]))))

(define (get-animation-package package-name)
  (cdr (assq package-name animation-package-list)))