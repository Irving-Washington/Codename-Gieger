(require racket/mpair)

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

(define *level-loader* (new level-loader%))
(define *level* (new level% [tile-matrix (send *level-loader* load-level 1)]))
(send *level* draw-level-buffer)

(define *player* (new player%
                      [position (mcons 32 32)]
                      [image (read-bitmap "graphics/player-unarmed-idle.png")]
                      [team 'kgb]
                      [animation-package (get-animation-package 'player-unarmed)]))

(define *gun1* (new firearm%
           [ammunition 7]
           [base-damage 70]
           [current-agent #f]
           [position (mcons 32 32)]
           [image (read-bitmap "graphics/pistol-1.png")]))  
(define *gun2* (new firearm%
           [ammunition 7]
           [base-damage 70]
           [current-agent #f]
           [position (mcons 510 100)]
           [image (read-bitmap "graphics/pistol-1.png")])) 
(define *gun3* (new firearm%
           [ammunition 100]
           [base-damage 70]
           [current-agent #f]
           [position (mcons 150 250)]
           [image (read-bitmap "graphics/pistol-1.png")])) 


      

(define *window* (new frame%
                      [width 1064]
                      [height 1064]
                      [label "The Exclusion Zone"]))

(define (*renderer* canvas dc)
  (send dc draw-bitmap (send *level* get-buffered-bitmap) 0 0))

(define *canvas* (new input-canvas%
                        [parent *window*]
                        [paint-callback *renderer*]))

(define *interaction* (new interaction%))

(send *window* show #t)

  