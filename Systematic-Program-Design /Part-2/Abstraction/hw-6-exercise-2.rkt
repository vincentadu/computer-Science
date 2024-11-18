;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname hw-6-exercise-2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; A GC (GroceryCatalogue) is one of:
; - '()
; - (cons CE GC)
; where each catalogue entry has a unique name



; A CE (CatalogueEntry) is a
; (make-ce String Cost)
(define-struct ce [name cost])
; and represents the name of a food and how much it costs
; A Cost is one of:
; - (make-unit Number)
; - (make-lb Number)
; and represents either the cost per unit or per lb of an item
(define-struct unit [cost])
(define-struct lb [cost])
(define CE1 (make-ce "egg"(make-unit 1)))
(define CE2 (make-ce "sardines" (make-unit 2)))
(define CE3 (make-ce "corned-beef" (make-unit 3)))
(define CE4 (make-ce "rice"      (make-lb 5)))
(define CE5 (make-ce "pork"      (make-lb 10)))
(define CE6 (make-ce "chicken"      (make-lb 10)))

(define GC0 empty)
(define GC1 (list CE1 CE2 CE3))
(define GC2 (list CE4 CE5 CE6))


 
; A Checkout is one of:
; - '()
; - (cons Order Checkout)
 
; A Order is one of:
; - String
; - (make-weight String Number)
(define-struct weight [name lb])
; and represents either one unit of food or its name and weight in lbs


;; Function for GC


#;
(define (fn-for-ce ce)
  (... (ce-name ce)
       (fn-for-c (ce-cost ce))

       (define (fn-for-c ce)
         (cond [(= ce (make-unit ce)(... (unit-number)))]
               [else
                (...(lb-number))]))


       (define (fn-for-gc gc)
         (cond [(empty? gc) (...)]
               [else
                (... (fn-for-c (first gc))
                     (fn-for-gc(rest gc)))]))))




      

(define (fn-for-ce gc s np)
  (make-ce (ce-name gc) (fn-for-c(ce-cost gc)s np)))

(define (fn-for-c gc s np)
  (if (unit? gc )
      (make-unit np)
      (make-lb  np)))
          

(define (fn-for-gc gc s np)
  (cond [(empty? gc) empty]
        [else
         (if (string=? s (ce-name (first gc)))
             (cons (fn-for-ce (first gc) s np)(fn-for-gc(rest gc) s np))
             (cons (first gc) (fn-for-gc(rest gc) s np)))])) 
          
     


 

;
;(define (update-price gc s np)
;  (local [(define (fn-for-ce gc)
;            (make-ce (ce-name gc) (fn-for-c(ce-cost gc))))
;
;          (define (fn-for-c gc)
;            (if (unit? gc )
;                (make-unit np)
;                (make-lb  np)))
;          
;
;          (define (fn-for-gc gc)
;            (cond [(empty? gc) empty]
;                  [else
;                   (if (string=? s (ce-name (first gc)))
;                       (cons (fn-for-ce (first gc) s np)(fn-for-gc(rest gc)))
;                       (cons (first gc) (fn-for-gc(rest gc))))]))]
;    
;    (fn-for-gc gc)))

;; Abstract fold function for CG
(define (foldr2 c1 c2 c3 c4 b gc)
  (local [(define (fn-for-ce gc)
            (c2 (ce-name gc) (fn-for-c(ce-cost gc))))

          (define (fn-for-c gc)
            (if (unit? gc )
                (c3 gc)
                (c4  gc)))
          

          (define (fn-for-gc gc)
            (cond [(empty? gc) empty]
                  [else
                   (c1 (fn-for-ce(first gc))
                       (fn-for-gc(rest gc))
                       (first gc))]))]
    
    (fn-for-gc gc)))


(check-expect (update-price GC1 "eggplant" 2)GC1)
(check-expect (update-price GC1 "egg" 2)(list (make-ce "egg" (make-unit 2)) CE2 CE3))
(check-expect (update-price GC2 "beef" 2)GC2)
(check-expect (update-price GC2 "chicken" 25)(list CE4 CE5 (make-ce "chicken" (make-lb 25))))
(define (update-price gc s np)
  (local [(define (c1 f r f1) (if (string=? s (ce-name f))
                               (cons f r)
                               (cons f1 r))) 
          (define (c2 name cost) (make-ce name cost))
          (define (c3 cost) (make-unit np))
          (define (c4 cost) (make-lb np))]
    (foldr2 c1 c2 c3 c4 empty gc)))
                               





 (update-price GC2 "beef" 2)