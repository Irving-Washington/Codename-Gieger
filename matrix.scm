(define matrix%
  
  (class object%
    
    (init-field rows
                columns)
    
    (field (matrix-representation '()))
    
    (define/private (create-matrix-representation)
      
      (define (create-row-helper current-column-num row)
        (if (= current-column-num columns)
            row
            (create-row-helper (+ current-column-num 1) (mcons #f row))))
      
      (define (create-matrix-rep-helper current-row-num matrix-rep)
        (if (= current-row-num rows)
            matrix-rep
            (create-matrix-rep-helper (+ current-row-num 1) (mcons (create-row-helper 0 '()) matrix-rep))))
      
      (set! matrix-representation (create-matrix-rep-helper 0 '())))
    
    (create-matrix-representation)
    
    (define/public (get-element row column)
      
      (define (get-row-helper current-row-num matrix)
        (if (= current-row-num row)
            (mcar matrix)
            (get-row-helper (+ current-row-num 1) (mcdr matrix))))
      
      (define (get-element-helper current-column-num row)
        (if (= current-column-num column)
            (mcar row)
            (get-element-helper (+ current-column-num 1) (mcdr row))))
      
      (get-element-helper 0
                          (get-row-helper 0
                                          matrix-representation)))
      
    
    (define/public (set-element! row column value)
      
      (define (get-row-helper current-row-num matrix)
        (if (= current-row-num row)
            (mcar matrix)
            (get-row-helper (+ current-row-num 1) (mcdr matrix))))
      
      (define (set-element-helper current-column-num row)
        (if (= current-column-num column)
            (set-mcar! row value)
            (set-element-helper (+ current-column-num 1) (mcdr row))))
      
      (set-element-helper 0
                          (get-row-helper 0
                                          matrix-representation)))
    
    (define/public (get-matrix-representation)
      matrix-representation)
  
    (super-new)))
    
    
    
    