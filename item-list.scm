(define (create-item item-name item-position item-agent)
  (cond
    ((eq? item-name 'makarov-pb)
     (new firearm%
          [ammunition 80]
          [ammunition-type 'bullet]
          [base-damage 70]
          [current-agent item-agent]
          [animation-package (get-animation-package 'kgb-pistol)]
          [position item-position]
          [image (read-bitmap "graphics/makarov-pb.png")]))
    ((eq? item-name 'mp-133)
     (new firearm%
          [ammunition 6]
          [ammunition-type 'pellets]
          [base-damage 30]
          [current-agent item-agent]
          [animation-package (get-animation-package 'kgb-shotgun)]
          [position item-position]
          [image (read-bitmap "graphics/mp-133.png")]))
    (else
     (error "Invalid item name: " item-name))))


(define (spawn-item item-name item-position)
  (create-item item-name item-position #f))

(define (give-item item-name agent)
  (let ((new-item (create-item item-name (mcons 0 0) #f)))
    (send agent item-add! new-item)))