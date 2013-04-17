(define matrix%
  
  (class object%
    
    (init-field rows
                columns)
    
    (field (matrix-representation '()))
    
    (define/private (create-matrix-representation)
      
      (define (create-row-helper current-column-num row)
        (if (= current-column-num column-num)
            row
            (create-row-helper (+ current-column-num 1) (mcons #f row))))
      
      (define (create-matrix-rep-helper current-row-num matrix-rep)
        (if (= current-row-num row-num)
            matrix-rep
            (create-matrix-rep-helper (+ current-row-num 1) (mcons (create-row-helper 0 '()) matrix-rep))))
      
      (define (get-row-helper current-row-num matrix-rows)
        (if (= current-row-num row-num)
            (mcar matrix-rows)
            (get-row-helper (+ current-row-num 1) (mcdr matrx-rows))))
      
      (define (get-element-helper current-column-num row)
        (if (= current-column-num column-num)
            (mcar row)
            (get-element-helper (+ current-column-num 1) (mcdr row))))
      
      (set! matrix-representation 
            (get-element-helper 0
                          (get-row-helper 0
                                          matrix-representation))))
    
    
    
    (define/public (get-element row column)
      (define (get-row-helper current-row-num matrix)
        (if (= current-row-num row)
            (car matrix)
            (get-row-helper (+ current-row-num 1) (cdr matrix))))
      
    
    (define/public (set-element! row column value)
      (void))
    (super-new)))
    
    
    
    