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


main:
	setb EA 	; Aktiviert Interrupt System (Enable All)

	setb EX0	; Aktiviert den External Interrupt 0 (Port 3.2)
	setb IT0	; Internal Timer 0 aktivieren. reagiert somit auf die negativ Flanke

	setb EX1	; Aktiviert den External Interrupt 1 (Port 3.3)
	setb IT1	; Internal Timer 1 aktivieren. reagiert somit auf die negativ Flanke

	; Wandmuster initialisieren und im Registerspeicher ablegen
	mov R0,#00AH
	mov @R0,#11001111b
	inc R0
	mov @R0,#11100111b
	inc R0
	mov @R0,#11110011b
	inc R0
	mov @R0,#11100111b
	inc R0
	mov @R0,#11111100b
	inc R0
	mov @R0,#11110011b


	; Vogel Initialisieren
	mov A,#008H
	mov P2,A
	mov R2,#03H

	; Panel für Wand initialisieren
	mov A,#00000001b
	mov P0,A

	mov A,@R0
	mov P1,A

	; In Endlosschleife springen
	jmp loop

; Endlosschleife
loop:
	; Lässt den Vogel alle drei mal fallen
	mov A,R2
	dec A
	mov R2,A
	jz vogeldrop ; Vogel fällt

	mov R1,#00AH ; Länge der Pause
	
	jmp animationspause


; ISR 1
interrupt0:

	; Dividiert den Inhalt von P2 durch 2 und lädt ihn wieder in P1 (Punkt nach oben)
	mov A,P2
	mov B,#02H
	div AB
	mov P2,A

	clr IE0	; Kennzeichnungsbit für externen Interrupt wird gesetzt (=1) bei bei einem Interrupt und gelöscht (=0) nach Ausführung des Interrupts.

	RETI

; ISR 2
interrupt1:

	; Multipliziert den Inhalt von P2 mit 2 und lädt ihn wieder in P1 (Punkt nach unten)
	mov A,P2
	mov B,#02H
	mul AB
	mov P2,A

	clr IE1	; Kennzeichnungsbit für externen Interrupt wird gesetzt (=1) bei bei einem Interrupt und gelöscht (=0) nach Ausführung des Interrupts.

	RETI

animationspause:
	djnz R1,$
	jmp animation

; Bewegt die Wand nach links
animation:
	; Wenn der Vogel weg ist
	mov A,P2
	jz gameover1

	; Multipliziere Port 2 mit 2. Bewegt die Wand nach links
	mov A,P0
	mov B,#02H
	mul AB
	mov P0,A
	subb A,#080H

	jz neuewand

	jmp loop

; Eine neue Wand aus dem Array
neuewand:
	; Kollisionserkennung
	mov A,P1
	mov R3,A
	mov A,P2
	anl A,R3
	jnz gameover1

	; Wand zurück nach links schieben
	mov A,#00000001b
	mov P0,A


	; Ein Wandmuster weiterschalten
	dec R0
	mov A,@R0
	mov P1,A

	; Schauen ob das Array zu ende ist
	mov A,#0AH
	subb A,R0
	jz wandreset

	jmp loop

; Setzt das Wand Array auf die Startposition zurück
wandreset:
	mov R0,#0FH
	jmp loop

; Lässt Vogel fallen
vogeldrop:
	mov R2,#04H

	; Multipliziert den Inhalt von P2 mit 2 und lädt ihn wieder in P1 (Punkt nach unten)
	mov A,P2
	mov B,#02H
	mul AB
	mov P2,A

	jmp loop

; Matrix blinkt
gameover1:
	mov A,#0FFH
	mov P0,A
	mov P1,A
	jmp gameover2

gameover2:
	mov A,#000H
	mov P0,A
	mov P1,A
	jmp gameover1
