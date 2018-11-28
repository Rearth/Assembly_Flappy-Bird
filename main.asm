;  ___ _                                             
; / __) |                                            
;| |__| | ____ ____  ____  _   _     ____  ___ ____  
;|  __) |/ _  |  _ \|  _ \| | | |   / _  |/___)    \ 
;| |  | ( ( | | | | | | | | |_| |  ( ( | |___ | | | |
;|_|  |_|\_||_| ||_/| ||_/ \__  |   \_||_(___/|_|_|_|
;             |_|   |_|   (____/                     

; Autor:
; -> David Waidner
; -> Matthias Häfele

; DHBW Karlsruhe
;
;Anleitungen:
;
; Zeitgeber/Zähler-Steuerregister (TCON):
; hhttp://www.self8051.de/zeitgeber_z%C3%A4hler-steuerregister_(tcon),18155.html
;
; Port 0 bis 3
; http://www.self8051.de/port_0_bis_3,18218.html
;
; Alle Befehle
; http://www.self8051.de/alle_Befehle_des_8051_Mikrocontroller,13290.html
;
org 000H
jmp main ; Springt zu main

; Einsprungpunkt für die Interrupt Servic Routine (ISR) (Hardware)
org 003H
	ljmp interrupt0 ; Springt zur interrupt0 Marke
	

org 013H
	ljmp interrupt1 ; Springt zur interrupt0 Marke
	RETI

main:
	setb EA 	; Aktiviert Interrupt System (Enable All)
	setb EX0	; Aktiviert den External Interrupt 0 (Port 3.2)
	setb IT0	; Internal Timer 0 aktivieren. EI0 reagiert somit auf die negativ Flanke


	; Zu beginn das Bird setzen. ()linke Reihe mittig)
	mov A,#01H
	mov P0,A

	mov A,#08H
	mov P1,A

	jmp loop

; Endlosschleife
loop:
	nop
	jmp loop

; ISR 1
interrupt0:

	; Hier irgandwas machen!!!!

	mov A,#04H ; Das da ist irgendwas!
	mov P0,A ; Das da ist irgendwas!

	clr IE0	; Kennzeichnungsbit für externen Interrupt wird gesetzt (=1) bei bei einem Interrupt und gelöscht (=0) nach Ausführung des Interrupts.

	RETI

; ISR 2
interrupt1:

	; Hier irgandwas machen!!!!



