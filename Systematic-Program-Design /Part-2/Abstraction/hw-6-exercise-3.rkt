;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname hw-6-exercise-3) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; data definition
; A House is a (make-house String Number Number String Number)
(define-struct house [address bedrooms bathrooms style value])

(define H1 (make-house "tanauan" 2 2 "Colonial" 50000))
(define H2 (make-house "sto tomas" 1 2 "Colonial" 70000))
(define H3 (make-house "malvar" 3 1 "Modern" 100000))
(define H4 (make-house "Lipa" 5 3 "Contemporary" 120000))

(define LOH1  (list H1 H2 H3 H4))
(define (fn-for-house h)
  (... (house-address h)
       (hous-bedrooms h)
       (house-bathrooms h)
       (house-style h)
       (house-value h)))




;; Function
;; [Number->Number] House -> House
;; produce a new House with new value based on baths value
(check-expect (new-value-bybaths H1)(make-house "tanauan" 2 2 "Colonial" 50000))
(check-expect (new-value-bybaths H4)(make-house "Lipa" 5 3 "Contemporary" (* 1.1 120000)))
(define (new-value-bybaths h)
  (if (>(house-bathrooms h) 2.5)
        (make-house (house-address h)
                    (house-bedrooms h)
                    (house-bathrooms h)
                    (house-style h)
                    (* 1.1 (house-value h)))
        h))



;; [Number->Number] House -> House
;; produce a new House with new value based on bedroom value
(check-expect (new-value-bybedr H1)(make-house "tanauan" 2 2 "Colonial" (* 0.9 50000)))
(check-expect (new-value-bybedr H4)(make-house "Lipa" 5 3 "Contemporary" 120000))
(define (new-value-bybedr h)
  (if (<=(house-bathrooms h) 2)
        (make-house (house-address h)
                    (house-bedrooms h)
                    (house-bathrooms h)
                    (house-style h)
                    (* 0.9 (house-value h)))
        h))




;; [Number->Number] House -> House
;; produce a new House with new value based on style
(check-expect (new-value-bystyle H1)(make-house "tanauan" 2 2 "Colonial" (+ 500 50000)))
(check-expect (new-value-bystyle H4)(make-house "Lipa" 5 3 "Contemporary" 120000))
(define (new-value-bystyle h)
  (if (string=? (house-style h) "Colonial")
        (make-house (house-address h)
                    (house-bedrooms h)
                    (house-bathrooms h)
                    (house-style h)
                    (+ 500 (house-value h)))
        h))



;; [Number->Number] House -> House
;; produce a new House with new value based on predicate


(check-expect (new-value H1) (make-house "tanauan" 2 2 "Colonial" (+ 500 (* 0.9 50000))))
(check-expect (new-value H4) (make-house "Lipa" 5 3 "Contemporary" (* 1.1 120000)))
(define (new-value h)
  (local [;1. Update value based on baths
          (define VWBATHS  (new-value-bybaths h))
          ; 2. Update value based on bedrooms
          (define VWBEDS (new-value-bybedr VWBATHS))
          ; 3. Update value based on Style
          (define VWSTYL (new-value-bystyle VWBEDS))]

    VWSTYL))
(check-expect (update-homes LOH1)(list (make-house "tanauan" 2 2 "Colonial" 45500)
                                       (make-house "sto tomas" 1 2 "Colonial" 63500)
                                       (make-house "malvar" 3 1 "Modern" 90000)
                                       (make-house "Lipa" 5 3 "Contemporary" 132000)))

(define (update-homes loh)
  (map new-value loh))
