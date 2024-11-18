;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname hw-6-exercise-7) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; (Listof X) (X -> K) (K K -> Boolean) -> (Listof (cons K (Listof X)))
;; Creates a grouping of items by a specified key.
(define (create-grouping items key-extractor key-equal?)
  (define (group-helper items groups)
    (cond
      [(empty? items) groups]  ; If there are no more items, return the groups
      [else
       (let* ([current (first items)]                               ; Get the current item
              [key (key-extractor current)]                        ; Extract the key
              [existing-group (find-group key groups)])          ; Find if the key already exists
         (if existing-group
             (group-helper (rest items)                          ; If it exists, add current to that group
                            (add-to-group existing-group current))
             (group-helper (rest items)                          ; If it doesn't exist, create a new group
                            (cons (cons key (list current)) groups))))])) ; Add new group
  (define (find-group key groups)
    (cond
      [(empty? groups) #f]  ; If no groups, return false
      [(key-equal? key (car (car groups))) (car groups)] ; If the key matches the head, return the group
      [else (find-group key (cdr groups))]))  ; Recur to find the group
  (define (add-to-group group item)
    (cons (car group) (cons item (cdr group)))) ; Add item to existing group
  (reverse (group-helper items '()))  ; Call the helper and reverse the result for correct order
)

;; Example usage
(define CUPS
  (list
   (make-cup 10 "brown" "wood")
   (make-cup 8 "brown" "ceramic")
   (make-cup 10 "red" "plastic")
   (make-cup 6 "clear" "plastic")))

;; Group by capacity
(define group-by-capacity
  (create-grouping CUPS
                   cup-oz
                   =))

;; Group by color
(define group-by-color
  (create-grouping CUPS
                   cup-color
                   string=?))

; Test cases
(check-expect group-by-capacity
              (list (cons 10 (list (make-cup 10 "brown" "wood")
                                   (make-cup 10 "red" "plastic")))
                    (cons 8 (list (make-cup 8 "brown" "ceramic")))
                    (cons 6 (list (make-cup 6 "clear" "plastic")))))

(check-expect group-by-color
              (list (cons "brown" (list (make-cup 10 "brown" "wood")
                                         (make-cup 8 "brown" "ceramic")))
                    (cons "red" (list (make-cup 10 "red" "plastic")))
                    (cons "clear" (list (make-cup 6 "clear" "plastic")))))
