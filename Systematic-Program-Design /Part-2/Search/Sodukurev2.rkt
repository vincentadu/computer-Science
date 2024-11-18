;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname Sodukurev2) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require racket/list) ;gets list-ref, take and drop
;; =================
;; Data definitions:

;; Val is a Natural [1, 9]
;; Board is a (listof Val/False)
;; Pos is a Natural [0,80]
;; Convert 0-based row and column to Pos
(define (r-c->pos r c) (+ (* r 9) c))  ;helpful for writing tests
;; Unit is a (listof Pos) with length iof 9

;; =================
;; Constant

(define ALL-VALS (list 1 2 3 4 5 6 7 8 9))

(define B false) ;B stands for blank

(define BD1 
  (list B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD2 
  (list 1 2 3 4 5 6 7 8 9 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B 
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B
        B B B B B B B B B))

(define BD3 
  (list 1 B B B B B B B B
        2 B B B B B B B B
        3 B B B B B B B B
        4 B B B B B B B B
        5 B B B B B B B B
        6 B B B B B B B B
        7 B B B B B B B B
        8 B B B B B B B B
        9 B B B B B B B B))

(define BD4                ;easy
  (list 2 7 4 B 9 1 B B 5
        1 B B 5 B B B 9 B
        6 B B B B 3 2 8 B
        B B 1 9 B B B B 8
        B B 5 1 B B 6 B B
        7 B B B 8 B B B 3
        4 B 2 B B B B B 9
        B B B B B B B 7 B
        8 B B 3 4 9 B B B))

(define BD4s               ;solution to 4
  (list 2 7 4 8 9 1 3 6 5
        1 3 8 5 2 6 4 9 7
        6 5 9 4 7 3 2 8 1
        3 2 1 9 6 4 7 5 8
        9 8 5 1 3 7 6 4 2
        7 4 6 2 8 5 9 1 3
        4 6 2 7 5 8 1 3 9
        5 9 3 6 1 2 8 7 4
        8 1 7 3 4 9 5 2 6))

(define BD5                ;hard
  (list 5 B B B B 4 B 7 B
        B 1 B B 5 B 6 B B
        B B 4 9 B B B B B
        B 9 B B B 7 5 B B
        1 8 B 2 B B B B B 
        B B B B B 6 B B B 
        B B 3 B B B B B 8
        B 6 B B 8 B B B 9
        B B 8 B 7 B B 3 1))

(define BD5s               ;solution to 5
  (list 5 3 9 1 6 4 8 7 2
        8 1 2 7 5 3 6 9 4
        6 7 4 9 2 8 3 1 5
        2 9 6 4 1 7 5 8 3
        1 8 7 2 3 5 9 4 6
        3 4 5 8 9 6 1 2 7
        9 2 3 5 4 1 7 6 8
        7 6 1 3 8 2 4 5 9
        4 5 8 6 7 9 2 3 1))

(define BD6                ;hardest ever? (Dr Arto Inkala)
  (list B B 5 3 B B B B B 
        8 B B B B B B 2 B
        B 7 B B 1 B 5 B B 
        4 B B B B 5 3 B B
        B 1 B B 7 B B B 6
        B B 3 2 B B B 8 B
        B 6 B 5 B B B B 9
        B B 4 B B B B 3 B
        B B B B B 9 7 B B))

(define BD7                 ; no solution 
  (list 1 2 3 4 5 6 7 8 B 
        B B B B B B B B 2 
        B B B B B B B B 3 
        B B B B B B B B 4 
        B B B B B B B B 5
        B B B B B B B B 6
        B B B B B B B B 7
        B B B B B B B B 8
        B B B B B B B B 9))

;; Positions of all the rows, columns and boxes:

(define ROWS
  (list (list  0  1  2  3  4  5  6  7  8)
        (list  9 10 11 12 13 14 15 16 17)
        (list 18 19 20 21 22 23 24 25 26)
        (list 27 28 29 30 31 32 33 34 35)
        (list 36 37 38 39 40 41 42 43 44)
        (list 45 46 47 48 49 50 51 52 53)
        (list 54 55 56 57 58 59 60 61 62)
        (list 63 64 65 66 67 68 69 70 71)
        (list 72 73 74 75 76 77 78 79 80)))

(define COLS
  (list (list 0  9 18 27 36 45 54 63 72)
        (list 1 10 19 28 37 46 55 64 73)
        (list 2 11 20 29 38 47 56 65 74)
        (list 3 12 21 30 39 48 57 66 75)
        (list 4 13 22 31 40 49 58 67 76)
        (list 5 14 23 32 41 50 59 68 77)
        (list 6 15 24 33 42 51 60 69 78)
        (list 7 16 25 34 43 52 61 70 79)
        (list 8 17 26 35 44 53 62 71 80)))

(define BOXES
  (list (list  0  1  2  9 10 11 18 19 20)
        (list  3  4  5 12 13 14 21 22 23)
        (list  6  7  8 15 16 17 24 25 26)
        (list 27 28 29 36 37 38 45 46 47)
        (list 30 31 32 39 40 41 48 49 50)
        (list 33 34 35 42 43 44 51 52 53)
        (list 54 55 56 63 64 65 72 73 74)
        (list 57 58 59 66 67 68 75 76 77)
        (list 60 61 62 69 70 71 78 79 80)))

(define UNITS (append ROWS COLS BOXES))

;; =================
;; Function

;; Board Pos -> Val or false
;; Produce value at given position on board.
(check-expect (read-square BD2 (r-c->pos 0 5)) 6)
(check-expect (read-square BD3 (r-c->pos 7 0)) 8)

(define (read-square bd p)
  (list-ref bd p))

;; Board Pos Val -> Board
;; produce new board with val at given position
(check-expect (fill-square BD1 (r-c->pos 0 0) 1)
              (cons 1 (rest BD1)))

(define (fill-square bd p nv)
  (append (take bd p)
          (list nv)
          (drop bd (add1 p))))
;; Board -> Board or false
;; Produce the solution board or false if board has no solution
(check-expect (solve BD7) false)
(check-expect (solve BD4) BD4s)
(check-expect (solve BD5) BD5s)

;(define (solve bd) false)    ; stub
(define (solve bd)
  (local [(define (solve--bd bd)
            (if (solved? bd)
                bd
                (solve--lobd (next-bd bd))))

          (define (solve--lobd lobd)
            (cond [(empty? lobd) false]
                  [else
                   (local [(define try (solve--bd (first lobd))) ]
                     (if (not (false? try))
                         try
                         (solve--lobd(rest lobd))))]))]
    (solve--bd bd)))



    
 
;; Board -> Boolean
;; produce true if the board is full
;; Assume board is a valid board and full means no empty square
(check-expect (solved? BD4) false)
(check-expect (solved? BD4s) true)

;(define (solved? bd) false)   ; stub
(define (solved? bd)
  (andmap number? bd))



;; Board -> (listof Board)
;; produce the next valid list of board
;; Valid Board means no same number show on the same units of the board
(check-expect (next-bd (cons 1 (rest BD1)))
              (list (cons 1 (cons 2 (rest (rest BD1))))
                    (cons 1 (cons 3 (rest (rest BD1))))
                    (cons 1 (cons 4 (rest (rest BD1))))
                    (cons 1 (cons 5 (rest (rest BD1))))
                    (cons 1 (cons 6 (rest (rest BD1))))
                    (cons 1 (cons 7 (rest (rest BD1))))
                    (cons 1 (cons 8 (rest (rest BD1))))
                    (cons 1 (cons 9 (rest (rest BD1))))))
                    
                    
;(define (next-bd bd) empty)  ; false
(define (next-bd bd)
  (filt-valid(create-lobd (find-blank bd) bd)))


;; Board -> Posn
;; Produce the position of the first empty square
(check-expect(find-blank BD1)0)
(check-expect(find-blank (cons 1 (rest BD1)))1)
(check-expect(find-blank (cons 1 (cons 1 (rest (rest BD1)))))2)

;(define (find-blank bd) 0)  ; stub
(define (find-blank bd)
  (cond [(empty? bd) (error "no empty square")]
        [else
         (if  (false? (first bd))
              0
              (+ 1 (find-blank(rest bd))))]))

;; Pos Board -> (Listof Board)
;; produce the list with 9 set of board of new value inputted on the first empty square
(check-expect (create-lobd 0 BD1)
              (list (cons 1 (rest BD1))
                    (cons 2 (rest BD1))
                    (cons 3 (rest BD1))
                    (cons 4 (rest BD1))
                    (cons 5 (rest BD1))
                    (cons 6 (rest BD1))
                    (cons 7 (rest BD1))
                    (cons 8 (rest BD1))
                    (cons 9 (rest BD1))))
;(define (create-lobd p bd) empty)   ; stub
(define (create-lobd p bd)
  (local [(define (build-one n)
            (fill-square bd p (+ 1 n)))]
  (build-list 9 build-one)))


;; (Listof Board) -> (Lisfof Board)
;; Produce the valid list of Board
(check-expect (filt-valid (list (cons 1 (cons 1 (rest (rest BD1)))))) empty)
;(define (filt-valid lobd) empty)    ; stub
(define (filt-valid lobd)
  (filter isvalid-bd? lobd))

;; Board -> Boolean
;; Produce true if board is a valid board
(check-expect (isvalid-bd? BD1) true)
(check-expect (isvalid-bd? BD2) true)
(check-expect (isvalid-bd? BD3) true)
(check-expect (isvalid-bd? BD4) true)
(check-expect (isvalid-bd? (cons 2 (rest BD2))) false)
(check-expect (isvalid-bd? (cons 2 (rest BD3))) false)
(check-expect (isvalid-bd? (fill-square BD4 1 1)) false)

;(define (isvalid-bd? bd) false)   ; stub
(define (isvalid-bd? bd)
  (local [(define (valid-units? lou)
            (andmap valid-unit? lou))
          (define (valid-unit? lou)
            (isvalid-bd? (filt-val(read-unit lou))))

          (define (read-unit u)
            (map read-pos u))

          (define (read-pos p)
            (read-square bd p))
          
          (define (filt-val lovf)
            (filter number? lovf))

          (define (isvalid-bd? lov)
            (cond [(empty? lov) true]
                  [else
                   (if (member  (first lov) (rest lov))
                       false
                        (isvalid-bd?(rest lov)))]))]
    (valid-units? UNITS)))


  



