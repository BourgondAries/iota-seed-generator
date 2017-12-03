#! /usr/bin/env racket
#lang racket

(define seed
  (with-input-from-file "/dev/random"
    (lambda ()
      (list->string
        (map integer->char
          (let loop ([lst '()])
            ; This seems rather obscure, but there's a reason for this:
            ; /dev/random creates 2^n bit sized characters, and our range is
            ; only 27 (A-Z and 9). So to fairly distribute the 2^n bits, we modulo
            ; by 32, which is closest to and still above 27.
            ; Then we add 65 for convenience and make 91 the '9' character.
            ; This gives a completely fair distribution and discards a few
            ; random numbers that could not be fairly fitted into the range.
            (define t (+ (modulo (char->integer (read-char)) 32) 65))
            (define t* (if (= t 91) 57 t))
            (define ratio (/ (length lst) 81))
            (displayln (format "Progress: ~a%" (real->decimal-string (* ratio 100) 1)))
            (cond
              ([= ratio 1] lst)
              ([or (= t* 57) (and (>= t* 65) (<= t* 90))] (loop (cons t* lst)))
              (else (loop lst))
            )))))))
(display "Your seed is: ")
(displayln seed)
