(load "world-initiation.scm")

(define *game-loop*
  (new timer%
       [notify-callback (lambda ()
                          (begin
                            (send *level* move-objects)
                            (send *level* draw-objects-buffer)
                            (send *canvas* refresh)))]))
(send *game-loop* start 16)