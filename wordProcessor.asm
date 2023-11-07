;; ============================================================================
;; CS 2110 - Fall 2023
;; Project 3 - wordProcessor
;; ============================================================================
;; Name: Alexis Wilmot
;; ============================================================================


;; =============================== Part 0: main ===============================
;; This is the starting point of the assembly program.
;; It sets up the stack pointer, and then calls the wordProcess() subroutine.
;; This subroutine has been provided for you. Change which subroutine is called
;; to debug your solutions!

.orig x3000
;LEA R0, RIGHTY
; LD R1, END_REG
; LD R2, LENGTH
;; Set Stack Pointer = xF000
LD R6, STACK_PTR
;; Call wordProcess(). Change the subroutine being called for your own debugging!
LD R5, SUBROUTINE_ADDR
JSRR R5
HALT
;; Use a different label above to test your subroutines. 
;; DO NOT CHANGE OR RENAME THESE!
STACK_PTR        .fill xF000
;; Change the value below to be the address you want to test! 
;; IMPORTANT: change it back to x7000 for the autograder to work!
SUBROUTINE_ADDR  .fill x7000
;START_REG .fill x4000
;LENGTH .fill 5
;END_REG .fill x4015
;WORD     .FILL x700D
;RIGHTY    .STRINGZ "testing 1 2 3       "
; FILLER .fill x6500
.end


;; ============================ Part 1: wordLength ============================
;; DESCRIPTION:
;; This function calculates the length of a word, given the starting address of
;; the word.
;; The starting address of the word should be passed in via register R0.
;; The length of the word should be returned in register R0.
;; A word is terminated by either a space bar, a null terminator, or a newline
;; character.

;; SUGGESTED PSEUDOCODE:
;; def wordLength(R0):
;;     addr = R0
;;     length = 0
;;     while (true):
;;         if (mem[addr] == '\0'):
;;             break
;;         if (mem[addr] == '\n'):
;;             break
;;         if (mem[addr] == ' '):
;;             break
;;         addr += 1
;;         length += 1
;;     R0 = length
;;     return
.orig x3800
;; YOUR CODE HERE!
ADD R6, R6, -1 ; save registers
STR R1, R6, 0
ADD R6, R6, -1
STR R2, R6, 0
ADD R6, R6, -1
STR R3, R6, 0

ADD R0, R0, 0 ; addr = R0
AND R1, R1, 0; length = 0
START LDR R2, R0, 0 ; this is mem[addr]
    BRz DONE ; if \0 then it's done
    LD R3, ASCII_NEWLINE_1 ; R3 = \n
    NOT R3, R3
    ADD R3, R3, 1
    ADD R3, R2, R3 ; subtract newline from currChar to see if it == newline
    BRz DONE ; if == \n, done
    LD R3, ASCII_SPACE_1 ; load space character into R3
    NOT R3, R3
    ADD R3, R3, 1
    ADD R3, R2, R3; subtract space character from currChar to see if it == space
    BRz DONE ; if == ' ' you are done
    ADD R1, R1, 1 ; add 1 to the length
    ADD R0, R0, 1 ; add 1 to the address
    BR START ; loop again

DONE AND R0, R0, 0
ADD R0, R0, R1 ; put answer in R0
;STR


LDR R3, R6, 0 ; restore clobbered registers
ADD R6, R6, 1
LDR R2, R6, 0
ADD R6, R6, 1
LDR R1, R6, 0
ADD R6, R6, 1



RET
ASCII_NEWLINE_1 .fill 10 
ASCII_SPACE_1   .fill 32 
.end 


;; ============================== Part 2: memcpy ==============================
;; DESCRIPTION: 
;; This function copies a block of memory from one location to another.
;; sourcePtr and destPtr are the starting addresses of the source and 
;; destination blocks of memory, respectively.
;; The length is the number of memory addresses to copy.
;; The sourcePtr, destPtr, and length should be passed in via registers R0, R1,
;; and R2 respectivley

;; SUGGESTED PSEUDOCODE:
;; def memcpy(R0, R1, R2):
;;     sourcePtr = R0
;;     destPtr = R1
;;     length = R2
;;     while (length > 0):
;;         mem[destPtr] = mem[sourcePtr]
;;         sourcePtr += 1
;;         destPtr += 1
;;         length -= 1
;;     return

.orig x4000
;; YOUR CODE HERE!
    ADD R6, R6, -1 ; save R1 in stack
    STR R3, R6, 0 
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R0, R6, 0
; R0, R1, and R2 are all taken already 
ADD R2, R2, 0 ; set the CC for length
LOOP BRnz END ; while length > 0
    LDR R3, R0, 0 ; load the data from the memory location into R3
    STR R3, R1, 0 ; store the data into the wanted register
    ADD R0, R0, 1 ; increment sourcePtr
    ADD R1, R1, 1 ; decrement destPtr
    ADD R2, R2, -1 ; decrement length
    BRp LOOP
    BRnz END ; if leng >= 0, go to end
END LDR R0, R6, 0 ; restore R0
    ADD R6, R6, 1
    LDR R1, R6, 0 ; restore R1
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R3, R6, 0
    ADD R6, R6, 1
RET
.end


;; ========================== Part 3: capitalizeLine ==========================
;; DESCRIPTION:
;; This subroutine capitalizes all the letters in a line of text. A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.
;; Keep in mind that ASCII characters that are not lowercase letters (i.e. 
;; symbols, number, etc) should not be modified!

;; SUGGESTED PSUEDOCODE:
;; def capitalizeLine(R0):
;;     addr = R0
;;     while (mem[addr] != '\0' and mem[addr] != '\n'):
;;         if (mem[addr] >= 'a' and mem[addr] <= 'z'): 
;;             mem[addr] = mem[addr] - 32 
;;         addr += 1
;;     return

.orig x4800
;; YOUR CODE HERE!
ADD R6, R6, -1 ; save registers
STR R0, R6, 0
ADD R6, R6, -1
STR R1, R6, 0
ADD R6, R6, -1
STR R2, R6, 0
ADD R6, R6, -1
STR R3, R6, 0

CHECK LDR R1, R0, 0 ; load the character from the address
BRz ENDING ; if it's null then go to end
LD R2, ASCII_NEWLINE_2 ; R2 has the newline character
NOT R2, R2 ; check if mem[add] == \n
ADD R2, R2, 1 ; make newline negative to subtract
ADD R3, R2, R1 ; subtract currChar - \n
BRz ENDING
LD R2, LOWER_A ; load 'a' into R2
NOT R2, R2
ADD R2, R2, 1 ; -'a'
ADD R3, R2, R1 ; see if it's greater than 'a'
BRn PROGRESS ; if it's less than 'a' then move on to next letter
LD R2, LOWER_Z ; now check if it's <= 'z'
NOT R2, R2
ADD R2, R2, 1 ; make negative
ADD R3, R2, R1 ; char - 'z' 
BRp PROGRESS ; if it's > 'z' then move on
LD R2, MINUS_32 ; load the -32 into R2
ADD R1, R2, R1; subtract 32 into it
STR R1, R0, 0 ; store in the place it went to
PROGRESS ADD R0, R0, 1 ; add 1 to the next address to increment
BR CHECK ; start again

ENDING LDR R3, R6, 0 ; restore registers
ADD R6, R6, 1
LDR R2, R6, 0
ADD R6, R6, 1
LDR R1, R6, 0
ADD R6, R6, 1
LDR R0, R6, 0
ADD R6, R6, 1


RET
LOWER_A         .fill 97
LOWER_Z         .fill 122
MINUS_32        .fill -32
ASCII_NEWLINE_2 .fill 10 
.end




;; =========================== Part 4: reverseWords ===========================
;; DESCRIPTION:
;; This subroutine reverses each individual word in a line of text.
;; For example, the line "Hello World" would become "olleH dlroW".
;; A line is terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def reverseWords(R0):
;;     i = R0
;;     while (true):
;;          if (mem[i] == '\0' or mem[i] == '\n'):
;;              break
;;          if (mem[i] == ' '):
;;              i++
;;              continue
;;          start = i
;;          count = 0
;;          while (mem[i] != ' ' and mem[i] != '\0' and mem[i] != '\n'):
;;              stack.push(mem[i])
;;              i++
;;              count++
;;          i = start
;;          while (count > 0):
;;              mem[i] = stack.pop()
;;              i++
;;              count--
;;     return

.orig x5000
;; YOUR CODE HERE!
REVERSE
    ADD R6, R6, -1 ; set stack pointer to -1
    STR R0, R6, 0  ; push starting address (R0) onto stack
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R3, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0
    
    ADD R0, R0, 0 ; i = R0, starting address
    AND R1, R1, 0
LOOOP   LDR R2, R0, 0 ; mem[i] = currChar
        BRz ENDY ; if it's null terminator
        
        LD R3, ASCII_NEWLINE_3 ; check if it's a new line
        NOT R3, R3
        ADD R3, R3, 1 ; -(newline)
        ADD R3, R3, R2 ; check if char == \n
        BRz ENDY ; if so, go to end
        
        LD R3, ASCII_SPACE_2
        NOT R3, R3
        ADD R3, R3, 1 ; -(space)
        ADD R3, R3, R2 ; check if it's a space
        BRnp INIT
        BRz SKIPP ; if so, i++ and continue
            SKIPP ADD R0, R0, 1 ; i++
            BR LOOOP ; continue
            
INIT    ADD R0, R0, 0 ; current address
        AND R5, R5, 0 
        ADD R5, R5, R0 ; start = i
        AND R4, R4, 0 ; count = 0
        
WHILE LD R3, ASCII_SPACE_2 
        ADD R2, R2, 0 ; make sure currChar isn't \0
        BRz ENDWHILE_2 ; if null, then go to i = start
        NOT R3, R3
        ADD R3, R3, 1 ; -(space)
        ADD R3, R3, R2 
        BRz ENDWHILE_2 ; if a space, then go to i = start
        LD R3, ASCII_NEWLINE_3
        NOT R3, R3
        ADD R3, R3, 1 ; -(\n)
        ADD R3, R3, R2 ; check if it's a new line
        BRz ENDWHILE_2 ; 
        ADD R6, R6, -1
        STR R2, R6, 0 ; push currChar (R2) onto stack
        ADD R0, R0, 1 ; i++
        ADD R4, R4, 1 ; count++
        BR WHILE ; go back to WHILE 
    ENDWHILE_2 AND R0, R0, 0 
    ADD R0, R0, R5 ; i = start
    ADD R4, R4, 0
    WHILE_3 BRnz LOOOP ; if count <= 0 go to end
        LDR R1, R6, 0 ; load char into R1
        ADD R6, R6, 1
        STR R1, R0, 0 ; store into register
        ADD R0, R0, 1
        ADD R4, R4, -1
        BRp WHILE_3
        BRnz LOOOP
        
ENDY LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R3, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R7, 1
    


    
    
RET
ASCII_NEWLINE_3 .fill 10 
ASCII_SPACE_2   .fill 32 
.end



;; =========================== Part 5: rightJustify ===========================
;; DESCRIPTION: 
;; This subroutine right justifies a line of text by padding with space bars.
;; For example, the line "CS2110   " would become "   CS2110". A line is 
;; terminated by either the null terminator or the newline character.
;; The starting address of the line should be passed in via register R0.

;; SUGGESTED PSEUDOCODE:
;; def rightJustify(R0):
;;    start = R0
;;    curr = start
;;    while (mem[curr] != '\n' and mem[curr] != '\0'):
;;        curr++
;;    curr--
;;    end = curr
;;    // This loop shifts over the entire string one spacebar at a time,
;;    // until it is no longer terminated by a spacebar!
;;    while (mem[end] == ' '):
;;        while (curr != start):
;;            mem[curr] = mem[curr - 1]
;;            curr--
;;        mem[curr] = ' '
;;        curr = end
;;    return

.orig x5800
;; YOUR CODE HERE!
ADD R0, R0, 0 ; start = R0
AND R1, R1, 0 
ADD R1, R1, R0 ; currAddress = start = R0
WHILE_4 LDR R2, R1, 0 ; R2 = mem[currAddress] 
    BRz NEXT ; if null, exit while
    LD R3, ASCII_NEWLINE_4 ; R3 = \n 
    NOT R3, R3
    ADD R3, R3, 1 ; -(\n)
    ADD R3, R3, R2 ; R3 = -(\n) + currChar
    BRz NEXT
    ADD R1, R1, 1 ; currAddress++
    BR WHILE_4

NEXT ADD R1, R1, -1 ; currAddress--
AND R4, R4, 0
ADD R4, R4, R1 ; R4 = end = curr

; shift over entire string one spacebar at a time
; until no longer terminated by a spacebar
    LDR R2, R4, 0 ; mem[end] 
SHIFT LD R3, ASCII_SPACE_3
    NOT R3, R3
    ADD R3, R3, 1 ; -(' ')
    ADD R3, R3, R2 ; check if it's a spacebar
    BRnp ENDD
    ; while (curr != start): 
    INNER NOT R1, R1
        ADD R1, R1, 1 ; -curr
        ADD R3, R1, R0 ; if curr == start, exit innerWhile
        BRz SPACE_BAR
        NOT R1, R1 ; curr - 1
        LDR R3, R1, 0 ; mem[curr - 1]
        ADD R1, R1, 1 ; get curr back to normal
        STR R3, R1, 0; mem[curr] = mem[curr - 1]
        ADD R1, R1, -1 ; curr--
        BR INNER
    
    SPACE_BAR LD R3, ASCII_SPACE_3 
        NOT R1, R1
        ADD R1, R1, 1 ; get R1 back to normal
        STR R3, R1, 0 ; mem[curr] = space
        AND R1, R1, 0 
        ADD R1, R1, R4 ; curr = end
    LDR R2, R4, 0 ; load mem[end] again
    BRnp SHIFT

ENDD RET
ASCII_SPACE_3   .fill 32
ASCII_NEWLINE_4 .fill 10
.end
;; ============================= Part 6: getInput =============================
;; DESCRIPTION: 
;; This function should read a string of characters from the keyboard and place
;; them in a buffer.
;; The address of the buffer should be passed in via register R0.
;; The string should be terminated by two consecutive '$' characters.
;; The '$' characters should not be placed in the buffer.
;; Remember to properly null-terminate your string, and to print out each 
;; character as it is typed!
;; You may assume that the user will always enter a valid input.

;; SUGGESTED PSEUDOCODE:
;; def getInput(R0):
;;      bufferPointer = R0
;;      while (true):
;;          input = GETC() 
;;          OUT(input)
;;          mem[bufferPointer] = input 
;;          if input == '$':
;;              if mem[bufferPointer - 1] == '$':
;;                  mem[bufferPointer - 1] = '\0'
;;                  break
;;          bufferPointer += 1

.orig x6000
;; YOUR CODE HERE!
STR R7, R6, 0
ADD R6, R6, -1
STR R5, R6, 0
ADD R6, R6, -1
STR R4, R6, 0
ADD R6, R6, -1
STR R3, R6, 0
ADD R6, R6, -1
STR R2, R6, 0
ADD R6, R6, -1
STR R1, R6, 0
ADD R6, R6, -1
STR R0, R6, 0
ADD R6, R6, -1

;; YOUR CODE HERE!
ADD R0, R0, 0 ; bufferPointer
AND R1, R1, 0
ADD R1, R0, R1 ; move bufferPointer to R1
WHILE_TRUE
GETC
OUT
STR R0, R1, 0
LD R2, ASCII_DOLLAR_SIGN
NOT R2, R2
ADD R2, R2, 1 ; -($)
ADD R2, R2, R0
BRnp BUFF ; if not $, then BR to buffPoint++
AND R3, R3, 0
ADD R3, R3, R1
ADD R3, R3, -1 ; R3 = bufferPointer - 1
LDR R0, R3, 0 ; mem[bufferPointer - 1]
LD R2, ASCII_DOLLAR_SIGN
NOT R2, R2
ADD R2, R2, 1 ; -($)
ADD R2, R2, R0
BRnp BUFF ; if not $, buff++
AND R0, R0, 0
STR R0, R3, 0
BR BREAK
BUFF ADD R1, R1, 1
BR WHILE_TRUE


BREAK
LDR, R0, R6, 0
ADD R6, R6, 1
LDR R1, R6, 0
ADD R6, R6, 1
LDR R2, R6, 0
ADD R6, R6, 1
LDR R3, R6, 0
ADD R6, R6, 1
LDR R4, R6, 0
ADD R6, R6, 1
LDR R5, R6, 0
ADD R6, R6, 1
LDR R7, R6, 0
ADD R6, R6, 1

RET
ASCII_DOLLAR_SIGN .fill 36
.end


;; ============================ Part 7: parseLines ============================
;; IMPORTANT: This method has already been implemented for you. It will help 
;; you when implementing wordProcessor!

;; Description: This subroutine parses a string of characters from an 
;; initial buffer and places the parsed string in a new buffer. 
;; This subroutine divides each line into 8 characters or less. If a word
;; cannot fully fit on the current line, trailing spaces will be added and it
;; will be placed on the next line instead.

;; The address of the buffer containing the unparsed string, as well as the 
;; address of the destination buffer should be passed in via registers R0 and
;; R1 respectively.

;; An example of what memory looks like before and after parsing:
;;  x3000 │ 'A' │               x6000 │ 'A' │  ───┐
;;  x3001 │ ' ' │               x6001 │ ' ' │     │
;;  x3002 │ 'q' │               x6002 │ 'q' │     │
;;  x3004 │ 'u' │               x6004 │ 'u' │     │ 8 characters
;;  x3005 │ 'i' │               x6005 │ 'i' │     │ (not including \n!)
;;  x3006 │ 'c' │               x6006 │ 'c' │     │
;;  x3007 │ 'k' │               x6007 │ 'k' │     │
;;  x3008 │ ' ' │               x6008 │ ' ' │  ───┘
;;  x3009 │ 'r' │               x6009 │ \n  │
;;  x300A │ 'e' │               x600A │ 'r' │  ───┐
;;  x300B │ 'd' │               x600B │ 'e' │     │
;;  x300C │ ' ' │               x600C │ 'd' │     │
;;  x300D │ 'k' │     ───>      x600D │ ' ' │     │ 8 characters
;;  x300E │ 'i' │               x600E │ ' ' │     │ (not including \n!)
;;  x300F │ 't' │               x600F │ ' ' │     │
;;  x3010 │ 't' │               x6010 │ ' ' │     │
;;  x3011 │ 'y' │               x6011 │ ' ' │  ───┘
;;  x3012 │ \0  │               x6012 │ \n  │
;;  x3013 │ \0  │               x6013 │ 'k' │  ───┐
;;  x3014 │ \0  │               x6014 │ 'i' │     │
;;  x3015 │ \0  │               x6015 │ 't' │     │
;;  x3016 │ \0  │               x6016 │ 't' │     │ 8 characters
;;  x3017 │ \0  │               x6017 │ 'y' │     │ (not including \0!)
;;  x3018 │ \0  │               x6018 │ ' ' │     │
;;  x3019 │ \0  │               x6019 │ ' ' │     │
;;  x301A │ \0  │               x601A │ ' ' │  ───┘
;;  x301B │ \0  │               x601B │ \0  │

;; PSEUDOCODE:
;; def parseLines(R0, R1):
;;      source = R0
;;      destination = R1
;;      currLineLen = 0
;;      while (mem[source] != '\0'):
;;          wordLen = wordLength(source)
;;          if (currLineLen + wordLen - 8 <= 0):
;;              memcpy(source, destination + currLineLen, wordLen)
;;              lineLen += wordLen
;;              if (mem[source + wordLen] == '\0'):
;;                  break 
;;              source += wordLen + 1 
;;              if (lineLen < 8):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;          else:
;;              while (lineLen - 8 < 0):
;;                  mem[destination + lineLen] = ' '
;;                  lineLen += 1
;;              mem[destination + lineLen] = '\n'
;;              destination += lineLen + 1
;;              lineLen = 0
;;      while (lineLen - 8 < 0):
;;          mem[destination + lineLen] = ' '   
;;      mem[destination + lineLen] = '\0'
.orig x6800
;; Save RA on the stack
ADD R6, R6, -1
STR R7, R6, 0
AND R2, R2, 0 ; currLineLen = 0
PARSE_LINES_WHILE
    LDR R3, R0, 0 
    BRz EXIT_PARSE_LINES_WHILE ; mem[source] == '\0'
    ; make a wordLength(source) call
    ; Save R0-R5 on the stack
    ADD R6, R6, -1
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0

    LD R3, WORDLENGTH_ADDR
    JSRR R3            
    ADD R3, R0, 0 ; wordLen (R3) = wordLength(source)

    ; Restore R0-R5 from the stack!
    LDR R5, R6, 0
    ADD R6, R6, 1
    LDR R4, R6, 0
    ADD R6, R6, 1
    LDR R2, R6, 0
    ADD R6, R6, 1
    LDR R1, R6, 0
    ADD R6, R6, 1
    LDR R0, R6, 0
    ADD R6, R6, 1

    ADD R4, R2, R3 ;; R4 = currLineLen + wordLen
    ADD R4, R4, -8
    BRp PARSE_LINES_ELSE
        ;; Save R0-R5 on the stack
        ADD R6, R6, -1
        STR R0, R6, 0
        ADD R6, R6, -1
        STR R1, R6, 0
        ADD R6, R6, -1
        STR R2, R6, 0
        ADD R6, R6, -1
        STR R3, R6, 0
        ADD R6, R6, -1
        STR R4, R6, 0
        ADD R6, R6, -1
        STR R5, R6, 0

        ADD R1, R1, R2 ;; destination + currLineLen
        ADD R2, R3, 0  ;; wordLen is in R3
        LD R5, MEMCPY_ADDR
        JSRR R5 ;; memcpy(source, destination + currLineLen, wordLen)

        ;; Restore R0-R5 from the stack
        LDR R5, R6, 0
        ADD R6, R6, 1
        LDR R4, R6, 0
        ADD R6, R6, 1
        LDR R3, R6, 0
        ADD R6, R6, 1
        LDR R2, R6, 0
        ADD R6, R6, 1
        LDR R1, R6, 0
        ADD R6, R6, 1
        LDR R0, R6, 0
        ADD R6, R6, 1

        ADD R2, R2, R3 ;; lineLen += wordLen

        ; if (mem[source + wordLen] == '\0'), 
        ADD R5, R0, R3 ;; R5 = source + wordLen
        LDR R5, R5, 0 ;; R5 = mem[source + wordLen]
        BRnp LINE_HASNT_ENDED
        BR FILL_WITH_SPACES
        LINE_HASNT_ENDED

        ADD R0, R0, R3 ;; source += wordLen
        ADD R0, R0, 1 ;; source += 1

        ADD R4, R2, -8 ; if (linelen < 8):
        BRzp DONT_ADD_SPACE
            ;; Add the spacebar
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            LD R4, ASCII_SPACE_4
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
        DONT_ADD_SPACE
        BRnzp PARSE_LINES_WHILE
    PARSE_LINES_ELSE
        ;; Else clause
        PARSE_LINES_WHILE2
            ADD R4, R2, -8
            BRzp EXIT_PARSE_LINES_WHILE2
            LD R4, ASCII_SPACE_4
            ADD R5, R1, R2 ;; R5 = destination + lineLen
            STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
            ADD R2, R2, 1 ;; lineLen += 1
            BRnzp PARSE_LINES_WHILE2
        EXIT_PARSE_LINES_WHILE2
        LD R4, ASCII_NEWLINE_5
        ADD R5, R1, R2 ;; R5 = destination + lineLen
        STR R4, R5, 0 ;; mem[destination + lineLen] = '\n'
        ADD R1, R1, R2 ;; destination += lineLen
        ADD R1, R1, 1 ;; destination += 1
        AND R2, R2, 0 ;; lineLen = 0
        BRnzp PARSE_LINES_WHILE
EXIT_PARSE_LINES_WHILE

;; while (lineLen - 5 < 0):
;;    mem[destination + lineLen] = ' ' 
FILL_WITH_SPACES
    ADD R4, R2, -8
    BRzp EXIT_FILL_WITH_SPACES
    LD R4, ASCII_SPACE_4
    ADD R5, R1, R2 ;; R5 = destination + lineLen
    STR R4, R5, 0 ;; mem[destination + lineLen] = ' '
    ADD R2, R2, 1 ;; lineLen += 1
BRnzp FILL_WITH_SPACES
EXIT_FILL_WITH_SPACES

AND R4, R4, 0 ;; '\0'
ADD R5, R1, R2 ;; R5 = destination + lineLen
STR R4, R5, 0 ;; mem[destination + lineLen] = '\0'

; Pop RA from the stack
LDR R7, R6, 0
ADD R6, R6, 1

RET

WORDLENGTH_ADDR .fill x3800
MEMCPY_ADDR     .fill x4000
ASCII_SPACE_4   .fill 32
ASCII_NEWLINE_5 .fill 10
.end


;; ========================== Part 8: wordProcessor ===========================
;; Implement this subroutine LAST! It will use all the other subroutines.
;; This subroutine should read in a string of characters from the keyboard and
;; write it into the buffer provided at x8000. It should then parse the string
;; into lines of 8 characters or less, and write the parsed string to the 
;; buffer provided at x8500. Finally, for each line, the user should be able to
;; select between leaving the line as is, capitalizing the line, reversing the 
;; words in the line, or right justifying the line. The final parsed string 
;; should be written to the buffer at x8500 and printed out to the console.

;; You may assume that the input will always be valid - it will not exceed the 
;; length of the buffer, no word will be longer than 8 characters, and there 
;; will not be any leading / trailing spaces!

;; An example of what correct console output looks like if the sentence typed
;; is "The quick brown fox jumps over the lazy dog", and the options entered
;; are 0, 1, 2, 3, 0, 1, 2, 3
;; Note that any characters that are not 0, 1, 2, or 3 should be ignored!

;; Expected console output:

;; The quick brown fox jumps over the lazy dog$$
;; Enter modifier options:
;; The 
;; QUICK
;; nworb
;;     fox
;; jumps
;; OVER THE
;; yzal god

;; SUGGESTED PSEUDOCODE:
;; def WordProcess():
;;      GetInput(x8000)
;;      OUT(\n)
;;      ParseLines(x8000, x8500)
;;      startOfCurrLine = x8500
;;      PUTS("Enter modifier options.\n")
;;      while (true):
;;          option = GETC()
;;          if (option == '0'):
;;              pass
;;          elif (option == '1'):
;;              CapitalizeLine(startOfCurrLine)
;;          elif (option == '2'):
;;              ReverseWords(startOfCurrLine)
;;          elif (option == '3'):
;;              RightJustify(startOfCurrLine)
;;          else:
;;              // Input is not valid, just try again:
;;              continue
;;          // Print the line after it is modified
;;          i = 0
;;          while (i < 9):
;;              OUT(mem[startOfCurrLine])
;;              startOfCurrLine++
;;              i++
;;          if (mem[startOfCurrLine - 1] == '\0'):
;;              break
;;      return
.orig x7000
;; YOUR CODE HERE!
ADD R6, R6, -1
STR R7, R6, 0
    ADD R6, R6, -1 ; save clobbered
    STR R0, R6, 0
    ADD R6, R6, -1
    STR R1, R6, 0
    ADD R6, R6, -1
    STR R2, R6, 0
    ADD R6, R6, -1
    STR R3, R6, 0
    ADD R6, R6, -1
    STR R4, R6, 0
    ADD R6, R6, -1
    STR R5, R6, 0


LD R0, BUFFER_1
LD R1, GETINPUT_ADDR
JSRR R1 ; getInput
OUT
LD R0, BUFFER_1 ; address of unparsed string
LD R1, BUFFER_2 ; address of parsed string
LD R3, PARSELINES_ADDR
JSRR R3
LD R4, BUFFER_2 ; startOfCurrentLine
LD R0, OPTIONS_MSG
PUTS
WHILE_TRU
    GETC ;  R0 = GETC = option
    LD R5, ASCII_ZERO
    NOT R5, R5
    ADD R5, R5, 1 ; -ZERO
    ADD R5, R5, R0 ; INPUT - ZERO
        BRz PART_2 ; if 0, pass
    LD R5, ASCII_ONE ; check if 1
    NOT R5, R5
    ADD R5, R5, 1 ; -1
    ADD R5, R5, R0 ; INPUT - ONE
    BRnp CHECK2
        AND R0, R0, 0 ; if INPUT == 1
        ADD R0, R0, R4 ; startOfCurrentLine
        LD R1, CAPITALIZE_ADDR
        JSRR R1 ; capitalize line, option 1
        BR PART_2
    CHECK2 LD R5, ASCII_TWO
        NOT R5, R5
        ADD R5, R5, 1 ; -TWO
        ADD R5, R5, R0 ; INPUT - TWO
    BRnp CHECK3 ; if not two, check if 3
        AND R0, R0, 0 ; if input == two , reverse words
        ADD R0, R0, R4 
        LD R1, REVERSE_ADDR 
        JSRR R1 ; reverseWords, option 2
        BR PART_2
    CHECK3 LD R5, ASCII_THREE
        NOT R5, R5
        ADD R5, R5, 1 ; -THREE
        ADD R5, R5, R0 ; INPUT - THREE
    BRnp PART_2
        AND R0, R0, 0 ; if INPUT == THREE
        ADD R0, R0, R4 ; startOfCurrentLine
        LD R1, RIGHT_JUSTIFY_ADDR
        JSRR R1 ; right justify
        BR PART_2
    CONT BR WHILE_TRU ; continue to next iteration
    
    PART_2 AND R5, R5, 0 ; i = 0
    ; figure out if i < 9
    WHILE_I9 AND R1, R1, 0
        ADD R1, R1, 9 ; R1 = 9
        NOT, R1, R1
        ADD R1, R1, 1 ; -9
        ADD R1, R1, R5 ; i - 9
        BRzp IF_ENDER ; if i > 9, exit while loop
        LDR R2, R4, 0 ; mem[startOfCurrentLine]
        AND R0, R0, 0 ; move to R0 for OUT
        ADD R0, R0, R2
        OUT
        ADD R4, R4, 1 ; startOfCurrentLine++
        ADD R5, R5, 1 ; i++
        BR WHILE_I9
        
    IF_ENDER ADD R4, R4, -1 ; startOfCurrLine - 1
        LDR R2, R4, 0 ; mem[startOfCurrLine - 1]
        BRz ENDINGG
        ADD R4, R4, 1 ; get startOfCurrLine back
        BR WHILE_TRU ; continue to next iteration
        

ENDINGG LDR R5, R6, 0
        ADD R6, R6, 1
        LDR R4, R6, 0
        ADD R6, R6, 1
        LDR R3, R6, 0
        ADD R6, R6, 1
        LDR R2, R6, 0
        ADD R6, R6, 1
        LDR R1, R6, 0
        ADD R6, R6, 1
        LDR R0, R6, 0
        ADD R6, R6, 1
        LDR R7, R6, 0
        ADD R6, R6, 1
RET
BUFFER_1           .fill x8000
BUFFER_2           .fill x8500
GETINPUT_ADDR      .fill x6000
PARSELINES_ADDR    .fill x6800
CAPITALIZE_ADDR    .fill x4800
REVERSE_ADDR       .fill x5000
RIGHT_JUSTIFY_ADDR .fill x5800
ASCII_ZERO         .fill 48
ASCII_ONE          .fill 49
ASCII_TWO          .fill 50
ASCII_THREE        .fill 51
ASCII_NEWLINE_6    .fill 10
OPTIONS_MSG        .stringz "Enter modifier options:\n"
.end


;; x8000 Buffer
.orig x8000
.blkw 100
.end


;; x8500 Buffer
.orig x8500
.blkw 100
.end