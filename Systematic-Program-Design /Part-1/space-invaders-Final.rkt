;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |space-invaders-starter - Final|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/universe)
(require 2htdp/image)

;; Space Invaders


;; Constants:

(define WIDTH  300)
(define HEIGHT 500)

(define INVADER-X-SPEED 1.5)  ;speeds (not velocities) in pixels per tick
(define INVADER-Y-SPEED 1.5)
(define TANK-SPEED 2)
(define MISSILE-SPEED 10)

(define HIT-RANGE 10)

(define INVADE-RATE 100)

(define BACKGROUND (empty-scene WIDTH HEIGHT))

(define INVADER
  (overlay/xy (ellipse 10 15 "outline" "blue")              ;cockpit cover
              -5 6
              (ellipse 20 10 "solid"   "blue")))            ;saucer

(define TANK
  (overlay/xy (overlay (ellipse 28 8 "solid" "black")       ;tread center
                       (ellipse 30 10 "solid" "green"))     ;tread outline
              5 -14
              (above (rectangle 5 10 "solid" "black")       ;gun
                     (rectangle 20 10 "solid" "black"))))   ;main body

(define TANK-HEIGHT/2 (/ (image-height TANK) 2))

(define MISSILE (ellipse 5 15 "solid" "red"))



;; Data Definitions:

(define-struct game (invaders missiles tank))
;; Game is (make-game  (listof Invader) (listof Missile) Tank)
;; interp. the current state of a space invaders game
;;         with the current invaders, missiles and tank position

;; Game constants defined below Missile data definition

#;
(define (fn-for-game s)
  (... (fn-for-loinvader (game-invaders s))
       (fn-for-lom (game-missiles s))
       (fn-for-tank (game-tank s))))



(define-struct tank (x dir))
;; Tank is (make-tank Number Integer[-1, 1])
;; interp. the tank location is x, HEIGHT - TANK-HEIGHT/2 in screen coordinates
;;         the tank moves TANK-SPEED pixels per clock tick left if dir -1, right if dir 1

(define T0 (make-tank (/ WIDTH 2) 1))   ;center going right
(define T1 (make-tank 50 1))            ;going right
(define T2 (make-tank 50 -1))           ;going left

#;
(define (fn-for-tank t)
  (... (tank-x t) (tank-dir t)))



(define-struct invader (x y dx))
;; Invader is (make-invader Number Number Number)
;; interp. the invader is at (x, y) in screen coordinates
;;         the invader along x by dx pixels per clock tick

(define I1 (make-invader 150 100 12))           ;not landed, moving right
(define I2 (make-invader 150 HEIGHT -10))       ;exactly landed, moving left
(define I3 (make-invader 150 (+ HEIGHT 10) 10)) ;> landed, moving right


#;
(define (fn-for-invader invader)
  (... (invader-x invader) (invader-y invader) (invader-dx invader)))


;; ListofInvader is one of:
;; empty
;; (cons Invader ListofInvader)
(define LOI0 empty)
(define LOI1 (list I1))
(define LOI2 (cons I2 LOI1))
(define LOI3 (cons I3 LOI2))

#;
(define (fn-for-loi loi)
  (cond [(empty? loi) (...)]
        [else
         (... (fn-for-invader(first loi))
              (fn-for-loi(rest loi)))]))
;; Template Rule Used
;; - One of: 2 cases
;; - Atomic Distinct: empty
;; - reference: (first loi)
;; - Self reference: (rest loi) is a ListofInvader

(define-struct missile (x y))
;; Missile is (make-missile Number Number)
;; interp. the missile's location is x y in screen coordinates

(define M1 (make-missile 150 300))                       ;not hit U1
(define M2 (make-missile (invader-x I1) (+ (invader-y I1) 10)))  ;exactly hit U1
(define M3 (make-missile (invader-x I1) (+ (invader-y I1)  5)))  ;> hit U1

#;
(define (fn-for-missile m)
  (... (missile-x m) (missile-y m)))


;; LisofMissile is one of:
;; - empty
;; (cons Missile ListofMissile)

(define LOM0 empty)
(define LOM1 (list M1))
(define LOM2 (list M1 M2))
(define LOM3 (list M1 M2 M3))

(define (fn-for-lom lom)
  (cond [(empty? lom) (...)]
        [else
         (... (fn-for-invader(first lom))
              (fn-for-loi(rest lom)))]))

;; Template Rule Used
;; - One of: 2 cases
;; - Atomic Distinct: empty
;; - reference: (first lom)
;; - Self reference: (rest lom) is a ListofInvader


(define G0 (make-game empty empty T0))
(define G1 (make-game empty empty T1))
(define G2 (make-game (list I1) (list M1) T1))
(define G3 (make-game (list I1 I2) (list M1 M2) T1))

;; =================
;; Functions:

;; Game -> Game
;; start the world with ...
;; 
(define (main ws)
  (big-bang ws                             ; Game
            (on-tick   next-game)          ; Game -> Game
            (to-draw   render-game)        ; Game -> Image
            (stop-when gameover? endmessage)          ; Game -> Boolean
            (on-key    game-handle-key)))  ; Game KeyEvent -> Game

;; Game -> Game
;; produce the current state of Game
; (define (next-game g) g)   ;stub
(define (next-game s)
  (make-game (next-invaders (destroy-invader (game-invaders s)(game-missiles s)))
             (setofMissile (destroy-missile(game-missiles s)(game-invaders s)))
             (next-tank (game-tank s))))



;; ListofInvaders ListofMissile -> ListofInvaders
;; Destroy Invader collided to Missile
(check-expect (destroy-invader (list (make-invader 10 50 10))empty) (list (make-invader 10 50 10)))
(check-expect (destroy-invader empty (list (make-missile 10 50))) empty)
(check-expect (destroy-invader (list(make-invader 10 50 10)) (list (make-missile 20 60)))empty)
(check-expect (destroy-invader (list(make-invader 10 50 10)) (list (make-missile 5 45)))empty)
(check-expect (destroy-invader (list(make-invader 10 50 10)(make-invader 100 100 10)) (list (make-missile 5 45)))
              (list(make-invader 100 100 10)))
(check-expect (destroy-invader (list(make-invader 10 50 10)(make-invader 100 100 10)) (list (make-missile 5 45) (make-missile 150 85) ))
              (list(make-invader 100 100 10)))


;(define (destroy-invader loi lom)loi)   ; stub
(define (destroy-invader loi lom)
  (cond [(empty? loi) empty]
        [else
         (if (destroy-invader?(first loi) lom)
             (destroy-invader(rest loi) lom)
              (cons (first loi) (destroy-invader(rest loi) lom)))]))


;; Invader ListofMissile-> Boolean
;; Return true if Invaders is on Hitrange of ListofMissile

;(define (destroy-invader? loi lom) true)   ; stub
(define (destroy-invader? loi lom)
  (cond [(empty? lom) false]
        [else
         (if (hit? loi (first lom))
             true
             (destroy-invader? loi (rest lom)))]))



;; Invader Missile -> Boolean
;; return True if the Invader is in hitrange of missile

(define (hit? i m)
  (if (and (<= (- (invader-x i) HIT-RANGE) (missile-x m) (+ (invader-x i) HIT-RANGE))
           (<= (- (invader-y i) HIT-RANGE) (missile-y m) (+ (invader-y i) HIT-RANGE)))
           true
           false))

;; ListofMissile ListofInvaders  -> ListofMissile
;; Destroy Missile collided to Invader
(check-expect (destroy-missile (list (make-missile 10 50))empty) (list (make-missile 10 50)))
(check-expect (destroy-missile empty (list (make-invader 100 150 12))) empty)
(check-expect (destroy-missile (list (make-missile 20 60)) (list(make-invader 10 50 10)) )empty)
(check-expect (destroy-missile (list (make-missile 5 45)) (list(make-invader 10 50 10)) )empty)
(check-expect (destroy-missile (list (make-missile 5 45) (make-missile 30 150)) (list(make-invader 10 50 10)(make-invader 100 100 10)) )
              (list(make-missile 30 150)))



;(define (destroy-missile lom loi)lom)   ; stub
(define (destroy-missile lom loi)
  (cond [(empty? lom) empty]
        [else
         (if (destroy-missile?(first lom) loi)
             (destroy-missile(rest lom) loi)
              (cons (first lom) (destroy-missile(rest lom) loi)))]))


;; Missile ListofInvader-> Boolean
;; Return true if Missile hit one of the ListofInvader

;(define (destroy-missile? lom loi) true)   ; stub
(define (destroy-missile? lom loi)
  (cond [(empty? loi) false]
        [else
         (if (disarm? lom (first loi))
             true
             (destroy-missile? lom (rest loi)))]))



;; Missile Invader -> Boolean
;; return True if the missile hit an Invader

(define (disarm? m i)
  (if (and (<= (- (invader-x i) HIT-RANGE) (missile-x m) (+ (invader-x i) HIT-RANGE))
           (<= (- (invader-y i) HIT-RANGE) (missile-y m) (+ (invader-y i) HIT-RANGE)))
           true
           false))


;; Game -> Image
;; Render the image of the current state of game

;(define (render-game g img) img)   ;stub

(define (render-game s)
  (render-loi (game-invaders s)
       (render-lom (game-missiles s)
       (render-tank (game-tank s)))))


;; ListofInvader -> ListofInvader
;; Add random Invaders on current ListofInvader

(define (next-invaders loi)
  (set_invaders (add_invaders loi)))


;; Generate random Invaders and add to ListofInvader

(define (add_invaders loi)
  (if (<(random INVADE-RATE)10)
      (cons (make-invader (random WIDTH) 0 (random-dx (random 15))) loi)
      loi))

(define (random-dx x)
  (if (= (random INVADE-RATE)1)
      (* -1 x)
      (* 1 x)))
  


;; ListofInvader -> ListofInvader
;; Produce list of (make-invaders x y dx) of the invaders movement

(check-expect (set_invaders LOI0)empty)
(check-expect (set_invaders (cons (make-invader 150 100 -12) LOI1))(list (make-invader (- 150 INVADER-X-SPEED)(+ 100 INVADER-Y-SPEED)  -12)
                                                                        (make-invader (+ 150 INVADER-X-SPEED)(+ 100 INVADER-Y-SPEED)  12)))
       
;(define (set_invaders loi)empty)      ; stub

(define (set_invaders loi)
  (cond [(empty? loi) empty]
        [else
         (cons(inMotionInvader(first loi))
              (set_invaders(rest loi)))]))


;; Invader -> Invader
(check-expect (inMotionInvader(make-invader 150 HEIGHT -12))(make-invader 150 HEIGHT -12))
(check-expect (inMotionInvader(make-invader 0 250 -12))(make-invader 0 (+ 250 INVADER-Y-SPEED) 12))
(check-expect (inMotionInvader(make-invader 0 250 12))(make-invader (+ 0 INVADER-X-SPEED) (+ 250 INVADER-Y-SPEED) 12))
(check-expect (inMotionInvader(make-invader WIDTH 250 12))(make-invader WIDTH (+ 250 INVADER-Y-SPEED) -12))
(check-expect (inMotionInvader(make-invader WIDTH 250 -12))(make-invader (- WIDTH INVADER-X-SPEED) (+ 250 INVADER-Y-SPEED) -12))


;(define (inMotionInvader invader) invader)   ;stub
(define (inMotionInvader invader)
  (cond [(>= (invader-y invader) HEIGHT) (make-invader (invader-x invader)
                                                       (invader-y invader) (invader-dx invader))]
        [(<= (invader-x invader) 0)
         (if (<(invader-dx invader) 0)
             (make-invader 0 (+ (invader-y invader) INVADER-Y-SPEED)
                                                       (-(invader-dx invader)))
             (make-invader (+ 0 INVADER-X-SPEED) (+ (invader-y invader) INVADER-Y-SPEED)
                           (invader-dx invader)))]
        [(>= (invader-x invader) WIDTH)
         (if (>(invader-dx invader) 0)
             (make-invader WIDTH (+ (invader-y invader) INVADER-Y-SPEED)
                                                       (-(invader-dx invader)))
             (make-invader (- WIDTH INVADER-X-SPEED) (+ (invader-y invader) INVADER-Y-SPEED)
                                                       (invader-dx invader)))]
        [else
         (if (<(invader-dx invader) 0)
             (make-invader (- (invader-x invader) INVADER-X-SPEED)
                           (+ (invader-y invader) INVADER-Y-SPEED) (invader-dx invader))
             (make-invader (+ (invader-x invader) INVADER-X-SPEED)
                           (+ (invader-y invader) INVADER-Y-SPEED) (invader-dx invader)))]))


; ListofImage -> Image
;; Render the images of Invaders with its position
(check-expect (render-loi LOI0 BACKGROUND)BACKGROUND)
(check-expect (render-loi LOI1 BACKGROUND)(place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))
(check-expect (render-loi LOI2 BACKGROUND)(place-image INVADER (invader-x I2) (invader-y I2)
                                                       (place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND)))
;(define (render-loi loi bkgrnd)bkgrnd)    ;stub

(define (render-loi loi img)
  (cond [(empty? loi) img]
        [else
         (render-invader(first loi)(render-loi(rest loi) img))]))



;; Invader ->Image
;; Render Image of an Invader
(check-expect (render-invader I1 BACKGROUND)(place-image INVADER (invader-x I1) (invader-y I1) BACKGROUND))
(define (render-invader invader img)
  (place-image INVADER (invader-x invader) (invader-y invader) img))



;;ListofMissile -> ListofMissile
;; Listof Missile fired

(check-expect (setofMissile LOM0)empty)
(check-expect (setofMissile LOM2) (list(make-missile 150 (- 300 MISSILE-SPEED ))(make-missile (invader-x I1) (+ (- (invader-y I1) 10) MISSILE-SPEED))))
;(define (setofMissile lom) lom)    ;stub

(define (setofMissile lom)
  (cond [(empty? lom) empty]
        [else
         (if (>= (missile-y (first lom)) HEIGHT)
             (setofMissile(rest lom))
             (cons (aMissile(first lom)) (setofMissile(rest lom))))]))



;;Missile -> Missile
(check-expect (aMissile M1) (make-missile (missile-x M1) (- (missile-y M1) MISSILE-SPEED)))
;(define (aMissile m) m)    ;stub
(define (aMissile m)
        (make-missile (missile-x m) (- (missile-y m)MISSILE-SPEED)))


;; ListofMissile -> Image
;; render the images of fire missile
(check-expect (render-lom LOM0 BACKGROUND)BACKGROUND)
(check-expect (render-lom LOM1 BACKGROUND)(place-image MISSILE (missile-x M1)(missile-y M1) BACKGROUND ))
(check-expect (render-lom LOM2 BACKGROUND)(place-image MISSILE (missile-x M2)(missile-y M2)
                                                       (place-image MISSILE (missile-x M1)(missile-y M1) BACKGROUND )))


;(define (render-lom lom img) img)  ; stub

(define (render-lom lom img)
  (cond [(empty? lom) img]
        [else
         (render-missile(first lom)
              (render-lom(rest lom) img))]))


;; Missile -> Image
;; Render Image
(check-expect (render-missile M1 BACKGROUND)(place-image MISSILE (missile-x M1)(missile-y M1) BACKGROUND))
;(define (render-missile m img)img)    ; stub

(define (render-missile m img)
  (place-image MISSILE (missile-x m) (missile-y m) img))


;; Tank-> Tank
;; Produce the next Tank

(check-expect (next-tank T0)(make-tank (+ (/ WIDTH 2) TANK-SPEED) 1))
(check-expect (next-tank T1)(make-tank (+ (tank-x T1) TANK-SPEED) (tank-dir T1)))
(check-expect (next-tank T2)(make-tank (- (tank-x T2) TANK-SPEED) (tank-dir T2)))
;;edge position
(check-expect (next-tank (make-tank 0 -1))(make-tank 0 1))
(check-expect (next-tank (make-tank WIDTH 1))(make-tank WIDTH -1))

;;starting position @edge 
(check-expect (next-tank (make-tank 0 1))(make-tank (+ 0 TANK-SPEED) 1))
(check-expect (next-tank (make-tank 300 -1))(make-tank (- 300 TANK-SPEED) -1))

;(define (next-tank t)t)    ; Stub 
(define (next-tank t)
  (cond [(<= (tank-x t) 0)
         (if (= (tank-dir t)-1)
             (make-tank 0 (-(tank-dir t)))
             (make-tank (+ 0 TANK-SPEED) (tank-dir t)))]
        [(>= (tank-x t) WIDTH)
         (if (= (tank-dir t)1)
             (make-tank WIDTH (-(tank-dir t)))
             (make-tank (- WIDTH TANK-SPEED) (tank-dir t)))]
        [else
         (if (= (tank-dir t)-1)
             (make-tank (- (tank-x t) TANK-SPEED) (tank-dir t))
             (make-tank (+ (tank-x t) TANK-SPEED) (tank-dir t)))]))


;; Tank -> Image
;; render the image of the moving Tank
(check-expect (render-tank T0) (place-image TANK (/ WIDTH 2) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))

;(define (render-tank t) BACKGROUND)  ; stub

(define (render-tank t)
  (place-image TANK (tank-x t) (- HEIGHT TANK-HEIGHT/2) BACKGROUND))


;; Game KeyEvent -> Game
;; Move the Tank Left and Right and fire the missile

;(define  (game-handle-key g ke)g)
(check-expect (game-handle-key G0 "left")(make-game (game-invaders G0) (game-missiles G0) (make-tank (/ WIDTH 2) -1)))
(check-expect (game-handle-key G1 "up") (make-game (game-invaders G1) (game-missiles G1) (game-tank G1)))
(check-expect (game-handle-key G1 "right")(make-game (game-invaders G0) (game-missiles G0) (make-tank 50 1)))

(check-expect (game-handle-key G1 " ")(make-game (game-invaders G0) (cons (make-missile 50 (- HEIGHT(* TANK-HEIGHT/2 2))) (game-missiles G0)) (game-tank G1)))

(define (game-handle-key g ke)
  (cond [(key=? ke "left") (make-game (game-invaders g) (game-missiles g) (make-tank (tank-x (game-tank g)) -1)) ]
        [(key=? ke "right") (make-game (game-invaders g) (game-missiles g) (make-tank (tank-x (game-tank g)) 1)) ]
        [(key=? ke " ") (make-game (game-invaders g) (cons (make-missile (tank-x (game-tank g)) (- HEIGHT(* TANK-HEIGHT/2 2))) (game-missiles g)) (game-tank g)) ]
        [else 
         g]))

;; Game -> Boolean
;; End the Game when Invader landed
(check-expect (gameover? G1)false)
(check-expect (gameover? G2)false)
(check-expect (gameover? G3)true)
;(define (gameover? g) false)  ;stub
(define (gameover? g)
  (end (game-invaders g)))

;; ListofInvader-> Boolean
;; Return True if the Invader landed

(define (end loi)
  (cond [(empty? loi) false]
        [else
         (if (>=(invader-y (first loi)) HEIGHT)
             true
             (end(rest loi)))]))

;; Game -> Image
;; Display the GAME OVER On screen
(define (endmessage g)
       (place-image (text "GAME OVER" 24 "red") (/ WIDTH 2) (/ HEIGHT 2)BACKGROUND))

