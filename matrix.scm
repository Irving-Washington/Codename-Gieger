;class: matrix
;superclass: object
;matrix defines the matrix representation used by the level layout.

(define matrix%
  
  (class object%
    
    ;rows and cloumns defines the amount of rows and columns in
    ;the matrix that is being created.
    (init-field rows
                columns)
    
    ;matrix-representation is the actual matrix that is created.
    (field (matrix-representation '()))
    
    ;sets a matrix representation to another matrix.
    (define/public (set-matrix-representation! new-matrix-representation)
      (set! matrix-representation new-matrix-representation))
    
    ;creates a matrix.
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
    
    ;Retrieves an element from a certain place in the matrix.
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
      
    ;Sets an element in the matrix to a chosen value.
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
    
    ;Retrieves the matrix representation.
    (define/public (get-matrix-representation)
      matrix-representation)
  
    (super-new)))