org 0h
ljmp main

org 000Bh
ljmp isr

org 13h
ljmp cekbutton

main:
	LED_PORT EQU P1               ; LED Port (Port 1)
	mov tmod, #00100001B         ; Set Timer 0 in mode 1 (16-bit mode) and Timer 1 in mode 2 (8-bit auto-reload mode)
	mov tl0, #0fdh               ; Set initial value for Timer 0 low byte
	mov th0, #04bh               ; Set initial value for Timer 0 high byte
	mov IE, #10000110B           ; Enable Timer 0 and Timer 1 interrupts
	mov IP, #00000100B           ; Set Timer 0 interrupt priority to high
	mov r0, #0
	mov r1, #5
	mov a, #1

here:
ceknilaiA1: cjne a, #1, ceknilaiA2
	mov r2, #0b6h
	mov r3, a
	mov a, #0
	setb tr0                    ; Start Timer 0
	sjmp here
ceknilaiA2: cjne a, #2, ceknilaiA3
	mov r2, #24h
	mov r3, a
	mov a, #0
	setb tr0                    ; Start Timer 0
	sjmp here
ceknilaiA3: cjne a, #3, ceknilaiA4
	mov r2, #6dh
	mov r3, a
	mov a, #0
	setb tr0                    ; Start Timer 0
	sjmp here
ceknilaiA4: cjne a, #4, ceknilaiA5
	mov r2, #0dbh
	mov r3, a
	mov a, #0
	setb tr0                    ; Start Timer 0
	sjmp here
ceknilaiA5: cjne a, #5, ceknilaiA1
	mov r2, #0b6h
	mov a, #1
	sjmp here

isr:
mov tl0, #0fdh				; Reload Timer 0 low byte with initial value
mov th0, #04bh				; Reload Timer 0 high byte with initial value
dec r1
cjne r1, #0, not_eq
MOV LED_PORT, r2			; Output the value of r2 to the LED port
Mov r1, #5
mov tl0, #0fdh				; Reload Timer 0 low byte with initial value
mov th0, #04bh				; Reload Timer 0 high byte with initial value
mov a, r3
inc a
reti

not_eq:
reti

cekbutton:
jb p2.7,  cekbutton
cekbutton7: jnb p2.7, cekbutton7
dec r3
acall munculinstatuslampu
setb tr0
ret

munculinstatuslampu:
mov th1, #-6                 ; Set Timer 1 to generate a 9600 baud rate at a 12MHz crystal frequency
mov scon, #50h               ; Set UART in mode 1 (8-bit UART with variable baud rate)
setb tr1                     ; Start Timer 1
ceknilaiR1: cjne r3, #1, ceknilaiR2
acall outputmerah
ret
ceknilaiR2: cjne r3, #2, ceknilaiR3
acall outputmerahkuning
ret
ceknilaiR3: cjne r3, #3, ceknilaiR4
acall outputkuning
ret
ceknilaiR4: cjne r3, #0, ceknilaiR1
acall outputhijau
ret

outputmerah:
mov sbuf, #52h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #44h
acall trans
ret

outputmerahkuning:
mov sbuf, #52h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #44h
acall trans
mov sbuf, #26h
acall trans
mov sbuf, #59h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #4Ch
acall trans
mov sbuf, #4Ch
acall trans
mov sbuf, #4Fh
acall trans
mov sbuf, #57h
acall trans
ret

outputkuning:
mov sbuf, #59h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #4Ch
acall trans
mov sbuf, #4Ch
acall trans
mov sbuf, #4Fh
acall trans
mov sbuf, #57h
acall trans
ret

outputhijau:
mov sbuf, #47h
acall trans
mov sbuf, #52h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #45h
acall trans
mov sbuf, #4Eh
acall trans
ret

trans:
cekti: jnb ti,cekti
clr ti
ret
end

