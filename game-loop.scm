(load "world-initiation.scm")
;Loads the world.

(define *game-loop*
  (new timer%
       [notify-callback (lambda ()
                          (begin
                            (send *level* move-objects)
                            (send *level* update-ai)
                            (send *level* draw-decals-to-background)
                            (send *level* draw-corpses-to-background)
                            (send *level* draw-objects-buffer)
                            (send *player* radiate!)
                            (send *canvas* refresh)))]))
(send *game-loop* start 16)

;Launches the game