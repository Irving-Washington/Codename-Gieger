(require racket/mpair)

(define *level-size* (cons 24 48))

(load "game-object.scm")
(load "agent.scm")
(load "item.scm")
(load "weapon.scm")
;(load "consumable.scm")
(load "projectile.scm")
(load "firearm.scm")
;(load "magazine.scm")
(load "player.scm")
(load "level.scm")
(load "tile.scm")
(load "matrix.scm")
(load "interaction.scm")
(load "input-listener.scm")
(load "level-loader.scm")
(load "animation-package.scm")
(load "animation-package-list.scm")
(load "decal.scm")
(load "npc.scm")



(define *level-loader* (new level-loader%))
(define *level* (new level% [tile-matrix (send *level-loader* load-level 1)]))
(send *level* draw-level-buffer)

(load "item-list.scm")

(define *player* (new player%
                      [position (mcons 32 32)]
                      [image (read-bitmap "graphics/kgb-unarmed-idle.png")]
                      [team 'kgb]
                      [animation-package (get-animation-package 'kgb-unarmed)]))

(spawn-item 'mp-133 (mcons 150 150))
(give-item 'makarov-pb *player*)

(new npc%
     [position (mcons 440 64)]
     [image (read-bitmap "graphics/cia-unarmed-idle.png")]
     [team 'cia]
     [animation-package (get-animation-package 'cia-unarmed)])
(new npc%
     [position (mcons 200 600)]
     [image (read-bitmap "graphics/cia-unarmed-idle.png")]
     [team 'cia]
     [animation-package (get-animation-package 'cia-unarmed)])
(new npc%
     [position (mcons 1050 600)]
     [image (read-bitmap "graphics/cia-unarmed-idle.png")]
     [team 'cia]
     [animation-package (get-animation-package 'cia-unarmed)])
(new npc%
     [position (mcons 550 300)]
     [image (read-bitmap "graphics/cia-unarmed-idle.png")]
     [team 'cia]
     [animation-package (get-animation-package 'cia-unarmed)])


(define *window* (new frame%
                      [width 1550]
                      [height 805]
                      [label "The Exclusion Zone"]))

(define (*renderer* canvas dc)
  (send dc draw-bitmap (send *level* get-buffered-bitmap) 0 0))

(define *canvas* (new input-canvas%
                        [parent *window*]
                        [paint-callback *renderer*]))

(define *interaction* (new interaction%))

(send *window* show #t)

  