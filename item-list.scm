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
    ((eq? item-name 'bread-clean)
     (new consumable%
          [consumable-health 40]
          [consumable-radiation 0]
          [current-agent item-agent]
          [animation-package (get-animation-package 'kgb-bread)]
          [position item-position]
          [image (read-bitmap "graphics/bread-1.png")]))
    ((eq? item-name 'irridated-bread)
     (new consumable%
          [consumable-health 30]
          [consumable-radiation 30]
          [current-agent item-agent]
          [animation-package (get-animation-package 'kgb-bread)]
          [position item-position]
          [image (read-bitmap "graphics/irridated-bread1.png")]))
    ((eq? item-name 'mp-133-magazine)
     (new magazine%
          [ammunition-capacity 6]
          [ammunition-type 'pellets]
          [current-agent item-agent]
          [animation-package (get-animation-package 'kgb-magazine)]
          [position item-position]
          [image (read-bitmap "graphics/magazine-1.png")]))
          
          
    (else
     (error "Invalid item name: " item-name))))


(define (spawn-item item-name item-position)
  (create-item item-name item-position #f))

(define (give-item item-name agent)
  (let ((new-item (create-item item-name (mcons 0 0) #f)))
    (send agent item-add! new-item)))