;Creates the world.
(require racket/mpair)

(define *level-size* (cons 24 48))

(load "game-object.scm")
(load "agent.scm")
(load "item.scm")
(load "weapon.scm")
(load "consumable.scm")
(load "projectile.scm")
(load "firearm.scm")
(load "magazine.scm")
;(load "grenade.scm")
(load "player.scm")
(load "level.scm")
(load "tile.scm")
(load "matrix.scm")
(load "interaction.scm")
(load "input-canvas.scm")
(load "level-loader.scm")
(load "animation-package.scm")
(load "animation-package-list.scm")
(load "decal.scm")
(load "ai.scm")
(load "npc.scm")



(define *level-loader* (new level-loader%))
(define *level* (new level% 
                     [tile-matrix (send *level-loader* get-level-data 1)]
                     [level-image (send *level-loader* get-level-image 1)]))
(send *level* draw-level-buffer)

(load "item-list.scm")

(define *player* (new player%
                      [position (mcons 800 120)]
                      [image (read-bitmap "graphics/kgb-unarmed-idle.png")]
                      [team 'kgb]
                      [animation-package (get-animation-package 'kgb-unarmed)]))

(spawn-item 'mp-133-magazine (mcons 500 400))
(spawn-item 'bread-clean (mcons 300 300))
(spawn-item 'irridated-bread (mcons 300 350))
(spawn-item 'makarov-pb (mcons 150 150))
(give-item 'mp-133 *player*)

(give-item 'makarov-pb (new npc%
                            [position (mcons 1000 100)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))
(give-item 'makarov-pb (new npc%
                            [position (mcons 200 600)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))
(give-item 'makarov-pb (new npc%
                            [position (mcons 1050 600)]
                            [image (read-bitmap "graphics/cia-unarmed-idle.png")]
                            [team 'cia]
                            [animation-package (get-animation-package 'cia-unarmed)]))

 

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