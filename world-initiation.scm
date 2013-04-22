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

(define *level-loader* (new level-loader%))
(define *level* (new level% [tile-matrix (send *level-loader* load-level 1)]))
(send *level* draw-level-buffer)

(define *player* (new player% [position (mcons 32 32)] [image (read-bitmap "player.bmp")][team 'kgb]))

(send *player*
      item-add!
      (new firearm%
           [ammunition 105]
           [base-damage 70]
           [current-agent *player*]
           [position (send *player* get-position)]
           [image (read-bitmap "gun.bmp")]))
      

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

  