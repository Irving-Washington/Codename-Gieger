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

(define *level-loader* (new level-loader%))
(define *level* (new level% [tile-matrix (send *level-loader* load-level 1)]))
(send *level* draw-level-buffer)

(define *player* (new player%
                      [position (mcons 32 32)]
                      [image (read-bitmap "graphics/litvinenko-armed.png")]
                      [team 'kgb]
                      [animation-package (new animation-package%
                                              [idle-image (read-bitmap "graphics/litvinenko-still.png")]
                                              [move-image-pair (cons 
                                                                (read-bitmap "graphics/litvinenko-right-hand-forward.png")
                                                                (read-bitmap "graphics/litvinenko-left-hand-forward.png"))]
                                              [use-image (read-bitmap "graphics/litvinenko-still.png")])]))
                                              

(send *player*
      item-add!
      (new firearm%
           [ammunition 105]
           [base-damage 70]
           [current-agent *player*]
           [position (send *player* get-position)]
           [image (read-bitmap "graphics/gun-1.png")]))
      

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

  