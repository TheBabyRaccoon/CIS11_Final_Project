;CIS11
;Coding Final Project
;Goal of this program is to take 5 scores from the user and display the min, max, and avg score.
;Using a counter and pointer we are able to loop as many times as needed and point to any allocated index.
;Using presets like labels we are able to reduce the amount written.(Include: -48,48,100,10,...etc)

	.ORIG x3000	
PROMPT	.STRINGZ "Input 5 numbers from 0 - 100 using 3 separate single digits."
EXAMPLE	.STRINGZ "Ex: 1 would be expressed as inputting 001, and 21 as inputting 021."
						
	LEA R0, PROMPT		;Load prompt
	PUTS			;Display to screen
	AND R0, R0, x0		;Clear R0 
	LEA R0, NXT		;Nextline
	PUTS			;Display to screen
	AND R0, R0, x0		;Clear R0
	LEA R0, EXAMPLE		;Load example 
	PUTS			;Display to screen
	LD R3, POINTER		;Load pointer to R3
	LD R6, COUNTER		;Load counter to R6

START	IN			;Input first digit
	AND R2, R2, x0		;Clear R2
	AND R5, R5, x0		;Clear R5
	LD R5, HUNDRED		;Load 100 to R5
	LD R2, NEG48		;Basically check if inputed number is less than 0 (offset neg)
	ADD R0, R0, R2		;R0 = input - 48
	BRn ERROR	
	ADD R2, R0, x0		;COPY INPUT TO R2
	AND R0, R0, x0		;Clear R0
					
FIRST_N ;///FIRST DIGIT INPUT\\\
	ADD R0, R0, R2		;First digit
	ADD R5, R5, x-1		;Decrement counter
	BRp FIRST_N		;If pos, loop
	ADD R1, R0, x0		;copy R0(first digit) to R1
	AND R0, R0, x0		;Clear R0
	;///SECOND DIGIT INPUT\\\
	IN			;Next digit
	AND R2, R2, x0		;Clear R2
	AND R5, R5, x0		;Clear R5
	LD R5, TENS		;Load 10 to R5	
	LD R2, NEG48		;Check if inputed number is less than 0 (offset neg) 
	ADD R0, R0, R2		;R0 = input - 48
	BRn ERROR
	ADD R2, R0, x0		;COPY INPUT TO R2
	AND R0, R0, x0		;Clear R0

SECND_N	ADD R0, R0, R2		;Second digit
	ADD R5, R5, x-1		;Decrement counter
	BRp SECND_N		;If pos, loop 
	ADD R4, R0, x0		;Copy R0 to R4
	AND R0, R0, x0		;Clear R0 

THIRD_N IN			;Input third digit
	AND R2, R2, x0		;Clear R2
	LD R2, NEG48		;Check if inputed number is less than 0 (offset neg) 
	ADD R0, R0, R2		;R0 = input - 48
	BRn ERROR
	;///COMBINE ALL 3 INPUTED VALUES\\\
	AND R2, R2, x0		;Clear R2
	ADD R2, R1, R4		;R2 = input1 + input2
	ADD R2, R0, R2		;R2 = (input1 + input2) + input3
	STR R2, R3, x0		;Store num in R2 with R3 as pointer
	ADD R3, R3, x1		;Increase pointer
	ADD R6, R6, x-1		;Decrease counter
	BRp START		;If counter > 0, get next number
	;///FIND MINIMUM AND MAXIMUM VALUES\\\
	JSR SORT
	JSR MIN_MAX
	HALT
	
SORT	AND R3, R3, X0		;Clear R3
	LD R3, POINTER		;Load pointer
	AND R4, R4, X0		;Clear R4
	LD R4, COUNTER		;Load counter
	AND R5, R5, X0		;Clear R5
	LD R5, COUNTER		;Reset counter

LOOP1	ADD R4, R4, x-1		;Decrement counter by 1(R4), loop 5 times
	BRz QUIT1		;If counter = 0, return
	ADD R5, R4, x0		;Copy R4 to R5
	LD R3, POINTER		;Re-load pointer to R3

BIG	LDR R0, R3, x0		;Load first number using R3 as pointer, store to R0
	LDR R1, R3, x1		;Load second number using R3 as pointer, store to R1		
	AND R2, R2, x0		;Clear R2
	NOT R2, R1		
	ADD R2, R2, x1		;R2=-R1
	ADD R2, R0, R2		;R2 = First number - seccond number
	BRn BIGGER		;first input was smaller
	
	STR R1, R3, x0		;Second 3 digit number
	STR R0, R3, x1		;First 3 digit number(after 2nd) 
BIGGER	ADD R3, R3, x1		;Increase pointer
	ADD R5, R5, x-1		;Decrement counter
	BRp BIG			;If pos, continue
	BRzp LOOP1		;If pos or zero, go back to loop1
	RET			;Else, Return to calling program

MIN_MAX LEA R0, MIN		;Load min
	PUTS			;Display to screen
	AND R3, R3, X0		;Clear R3
	AND R6, R6, X0		;Clear R6
	LD R3, POINTER		;Load pointer to R3
	LD R6, COUNTER		;Load counter to R6

RESULTS	;///CLEAR REGISTERS\\\
	AND R1, R1, x0		;Clear R1
	AND R2, R2, x0		;Clear R2
	AND R4, R4, x0		;Clear R4
	AND R5, R5, x0		;Clear R5
	AND R0, R0, x0		;Clear R0
	LD R0, NXT		;Skip line
	OUT			;Display on console
	AND R0, R0, x0		;Clear R0
	LDR R0, R3, x0		;Load numbers
	LD R2, HUNDRED		;R2 = 100
	NOT R2, R2		;	
	ADD R2, R2, x1		;R2 = -100

NUM1;///ISOLATING FOR NUM1 VALUE\\\
	ADD R1, R1, x1		;fill R1 with value
	ADD R0, R0, R2		;R0 = Number - 100
	BRzp NUM1		;If pos, go back to NUM1
	
REMAIN1	;///Dividing by 100\\\
	AND R2, R2, x0		;Clear R2
	LD R2, HUNDRED		;R2 = 100
	ADD R0, R0, R2		;R0 = Result + 100	
	ADD R1, R1, x-1		;Decrement counter
	STI R1, FIRST		;R1 stored to FIRST					
	AND R2, R2, x0		;Clear R2  
	LD R2, TENS		;load R2 = 10
	NOT R2, R2		
	ADD R2, R2, x1		; R2 = -10
	
NUM2	;///Dividing by 10\\\
	ADD R4, R4, x1		;Increment counter
	ADD R0, R0, R2		;R0 = remainder - 10
	BRzp NUM2		;If pos or zero, go back to NUM2
						
REMAIN2	AND R2, R2, x0		;Clear R2
	LD R2, TENS		;R2 = 10
	ADD R5, R0, R2		;R5 = Remainder + 10
	STI R5, THIRD		;Store R5 in THIRD
	ADD R4, R4, x-1		;Decrement counter(R4)
	STI R4, SECOND		;Store to SECOND
	;///Display 1st Digit\\\
	AND R0, R0, x0		;Clear R0	
	LDI R0, FIRST		;Load  to R0
	AND R2, R2, x0		;Clear R2
	LD R2, POS48		;Load 48 to R2
	ADD R0, R0, R2		;R0 = first digit + 48
	OUT			;Display to screen
	;///Display 2nd Digit\\\
	AND R0, R0, x0		;Clear R0
	LDI R0, SECOND		;Load to R0
	AND R2, R2, x0		;Clear R2
	LD R2, POS48		;Load 48 to R2
	ADD R0, R0, R2		;R0 = second digit + 48
	OUT			;Display to screen					
	;///Display 3rd Digit\\\
	AND R0, R0, x0		;Clear R0
	LDI R0, THIRD		;Load to R0
	AND R2, R2, x0		;Clear R2
	LD R2, POS48		;Load 48 to R2
	ADD R0, R0, R2		;R0 = third digit + 48
	OUT			;Display to screen
	
	ADD R3, R3, x4		;Increment pointer
	ADD R6, R6, x-4		;Decrement counter
	BRp DIS2
	HALT
	BR  QUIT1	

DIS2	LEA R0, NXT		;Skip line
	PUTS			;Display on console
	AND R0, R0, x0		;Clear R0
	LEA R0, MAX		;Load MAX
	PUTS			;Display to screen
	AND R0, R0, X0		;Clear R0
	BR  RESULTS		;Go back to RESULTS to display max

ERROR	LEA R0, MESG
	PUTS
	HALT

QUIT1	RET

MIN	.STRINGZ "Minimum: "
MAX	.STRINGZ "Maximum: "
MESG	.STRINGZ "INVALID INPUT"	
NXT	.STRINGZ "\n"
POINTER	.FILL x4000
COUNTER	.FILL #5
TENS	.FILL x000A	
HUNDRED	.FILL x0064
NEG48	.FILL xFFD0
POS48	.FILL x0030
FIRST	.FILL x400A	
SECOND	.FILL x400B	
THIRD	.FILL x400C	
.END


