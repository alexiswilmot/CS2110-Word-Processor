;; ============================================================================
;; CS 2110 - Fall 2023
;; Project 3 - wordProcessor
;; ============================================================================
;; Name:
;; ============================================================================

;; =============================== absoluteSum ===============================
;; DESCRIPTION:
;; This function calculates the sum of the absolute values of an array of 
;; integers.
;; The starting address of the array and the length of the array are provided
;; in memory The answer should also be stored in memory at x3050 (ANSWER)

;; SUGGESTED PSUEDOCODE:
;; answer = 0
;; currNum = 0
;; i = 0
;; arrLength = ARR.length()
;; while (arrLength > 0)
;;    currNum = ARR[i]
;;    if (currNum < 0):
;;        currNum = -(currNum); 
;;    answer += currNum;
;;    i++
;;    arrLength--
;; return

.orig x3000
;; YOUR CODE HERE!

AND R0, R0, 0 ; answer = 0 into R0
LD R2, ANSWER
STR R0, R2, 0

LD R2, ARR ; counter (i) in R2 for what array index you are at
AND R3, R3, 0 ; currNum = 0

LD R1, LEN ; load length into R1

LOOP BRnz END ; while length is over 0
    LDR R3, R2, 0 ; load the index of the array into R3
    BRzp ADDER
    
    NOT R3, R3 ; if the array value is negative
    ADD R3, R3, 1 ; make positive
    
    ADDER ADD R0, R0, R3 ; add currNum to R0 (total)
    
    ADD R2, R2, 1 ; increment array index by 1
   ; NOT R1, R1 ; subtract 1 from length
    ADD R1, R1, -1
    BRp LOOP
; loop is over, store answer in ANSWER
LD R2, ANSWER
END STR R0, R2, 0
HALT

;; Do not rename or remove any existing labels
LEN      .fill 5
ARR      .fill x6000
ANSWER   .fill x3050
.end

;; Answer needs to be stored here
.orig x3050
.blkw 1
.end

;; Array. Change values here for debugging!
    .orig x6000
    .fill -3
    .fill 4
    .fill -1
    .fill 10
    .fill -20
.end