;class: magazine
;superclass: item
;this class defines magazines, items that holds ammunition for firearms.

(define magazine%
  
  (class item%
    
    ;ammunition-capacity holds the number of maximum ammunition a magazine can hold.
    ;ammunition-type holds the information of what type of ammunition this magazine
    ;holds.
    (init-field ammunition-capacity
                ammunition-type)
    
    ;ammunition holds the amount of ammunition a magazine currently has.
    (field (ammunition ammunition-capacity))
    
    ;Ammunition methods
    
    ;Retrieves the ammunition capacity of a magazine.
    (define/public (get-ammunition-capacity) ammunition-capacity)
    
    ;Retrieves the ammunition type of a magazines ammunition.
    (define/public (get-ammunition-type) ammunition-type)
    
    ;Retrieves the amount of ammunition in a magazine.
    (define/public (get-ammunition) ammunition)
    
    ;Use
    (define/public (use)
      (void))

    (super-new)))