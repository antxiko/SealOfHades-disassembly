; ==========================================================================
; The Seal of Hades (Yami no Ryuuou Hadesu no Monshou) - ROM de 32 KB en 0x4000
; ==========================================================================
; Generado por tools/mkasm.py a partir del trazado de flujo real.
; Los comentarios provienen de tools/../src/*.notes y estan anclados a
; direccion, de modo que sobreviven a un retrazado.
; ==========================================================================

	org 0x04000


; ----------------------------------------------------------------------
; DATOS cabecera: La cabecera del cartucho: "AB", INIT 0x4010, sin STATEMENT,
;   DEVICE ni TEXT; la demostracion lee sus mandos desde aqui (0x4000), como
;   si fuera su lista
;   0x4000..0x4010  (16 bytes)
DATA_cabecera:
	defb 041h,042h,010h,040h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4000  AB.@............

; ======================================================================
; CODIGO 0x4010..0x4066  (86 bytes)
; ======================================================================


init:		; INIT: busca The Stone of Wisdom en otro slot (RDSLT en 0x92E1 de los slots 0-3 y 0x80-0x8F: su "S" de STONE, 0x23) y lo apunta en 0xE000; pone el slot del cartucho tambien en la pagina 2 y salta al codigo
	di			;4010   ; sin interrupciones
	call 00041h		;4011   ; DISSCR
	ld hl,092e1h		;4014   ; 0x92E1: en Stone of Wisdom, la S de "THE STONE OF WISDOM" (0x92DD)
	ld bc,00400h		;4017   ; cuatro slots, desde el 0
init_slot:		; RDSLT en el slot C: 0x23?
	ld a,c			;401a   ; el slot
	push bc			;401b
	call 0000ch		;401c   ; RDSLT: el byte de 0x92E1 en ese slot
	cp 023h		;401f   ; la "S" (0x23)?
	jr z,init_esta		;4021   ; si: esta
	pop bc			;4023
	inc c			;4024   ; el slot siguiente
	djnz init_slot		;4025
	ld bc,01080h		;4027   ; y los 16 expandidos (0x80-0x8F)
init_slot_exp:		; Lo mismo en los expandidos
	ld a,c			;402a
	push bc			;402b
	call 0000ch		;402c   ; RDSLT
	cp 023h		;402f   ; 0x23?
	jr z,init_esta		;4031
	pop bc			;4033
	inc c			;4034
	djnz init_slot_exp		;4035
	jr init_no_esta		;4037   ; no esta
init_esta:		; Esta: 0xE000 = 1
	pop bc			;4039
	ld a,001h		;403a
	jr L_403F		;403c
init_no_esta:		; No esta: 0xE000 = 0
	xor a			;403e   ; no esta: 0xE000 = 0
L_403F:
	ld (0e000h),a		;403f   ; 0xE000 (el arranque no lo borra)
	call 00138h		;4042   ; RSLREG: los slots de las paginas
	rrca			;4045   ; el de la pagina 1 (bits 2-3)...
	rrca			;4046
	and 003h		;4047   ; ...sus dos bits
	ld c,a			;4049
	ld b,000h		;404a
	ld hl,0fcc1h		;404c   ; ...expandido? (EXPTBL, 0xFCC1)
	add hl,bc			;404f
	ld c,a			;4050
	ld a,(hl)			;4051
	and 080h		;4052   ; el bit de expandido
	or c			;4054
	ld c,a			;4055
	inc hl			;4056
	inc hl			;4057
	inc hl			;4058
	inc hl			;4059
	ld a,(hl)			;405a   ; el secundario (SLTTBL)
	and 00ch		;405b
	or c			;405d
	ld h,080h		;405e   ; la pagina 2
	call 00024h		;4060   ; ENASLT
	jp arranque_nop		;4063   ; al codigo

; ----------------------------------------------------------------------
; DATOS sobra_4066: 0x4068 (la direccion de la tabla de detras): nadie lo lee
;   0x4066..0x4068  (2 bytes)
DATA_sobra_4066:
	defb 068h,040h	; 4066

; ----------------------------------------------------------------------
; DATOS escenas: Las tablas de pantallas de las seis escenas (0xE050), de la 0
;   a la 5: 0x40E2, 0x40CC, 0x40B6, 0x40A0, 0x408A y 0x4074
;   0x4068..0x4074  (12 bytes)
DATA_escenas:
	defb 0e2h,040h,0cch,040h,0b6h,040h,0a0h,040h,08ah,040h,074h,040h	; 4068  .@.@.@.@.@t@

; ----------------------------------------------------------------------
; DATOS pantallas: Las pantallas de cada escena: once punteros (0-10, por
;   0xE053); la escena 5 repite la mayoria de las de la 1
;   0x4074..0x40f8  (132 bytes)
DATA_pantallas:
	defb 024h,046h,0fbh,045h,0cdh,045h,09fh,045h,071h,045h,04dh,045h,024h,045h,04dh,046h	; 4074  $F.E.E.EqEME$EMF
	defb 02ah,041h,0f8h,040h,0f8h,040h,0c6h,044h,088h,044h,053h,044h,027h,044h,0e9h,043h	; 4084  *A.@.@.D.DSD'D.C
	defb 0afh,043h,071h,043h,037h,043h,001h,043h,022h,043h,001h,043h,087h,049h,05eh,049h	; 4094  .CqC7C.C"C.C.I^I
	defb 030h,049h,007h,049h,0deh,048h,0b5h,048h,08ch,048h,05eh,048h,0b0h,049h,045h,041h	; 40a4  0I.I.H.H.H^H.IEA
	defb 0b0h,049h,01bh,048h,0d9h,047h,09ch,047h,055h,047h,014h,047h,0d2h,046h,08ch,046h	; 40b4  .I.H.G.GUG.G.F.F
	defb 053h,046h,058h,048h,012h,043h,058h,048h,024h,046h,0fbh,045h,0cdh,045h,09fh,045h	; 40c4  SFXH.CXH$F.E.E.E
	defb 071h,045h,04dh,045h,024h,045h,0fbh,044h,04dh,046h,05dh,041h,04dh,046h,0e0h,042h	; 40d4  qEME$E.DMF]AMF.B
	defb 0b6h,042h,090h,042h,05fh,042h,030h,042h,005h,042h,0cch,041h,097h,041h,001h,043h	; 40e4  .B.B_B0B.B.A.A.C
	defb 007h,043h,001h,043h	; 40f4

; ----------------------------------------------------------------------
; DATOS pantallas_desc: Las descripciones de las pantallas: el juego de
;   casillas, rectangulos, rellenos de cuatro, el borde (0xFF, 1 o 2), dibujos
;   (sitio y puntero) y objetos (tipo, fila, columna y dibujo), cada lista con
;   su 0xFF
;   0x40f8..0x49b6  (2238 bytes)
DATA_pantallas_desc:
	defb 004h,0ffh,000h,000h,018h,018h,0fch,000h,000h,018h,006h,076h,0ffh,0ffh,006h,002h	; 40f8  ...........v....
	defb 062h,04bh,0ffh,005h,00fh,00ch,084h,04ah,009h,010h,010h,084h,04ah,009h,00ah,006h	; 4108  bK.....J....J...
	defb 084h,04ah,009h,012h,00ch,084h,04ah,009h,00ch,00eh,084h,04ah,009h,011h,008h,084h	; 4118  .J....J....J....
	defb 04ah,0ffh,000h,0ffh,000h,000h,018h,018h,076h,0ffh,0ffh,008h,000h,048h,04bh,000h	; 4128  J.......v....HK.
	defb 000h,000h,04ah,000h,008h,000h,04ah,000h,010h,000h,04ah,0ffh,0ffh,002h,0ffh,0ffh	; 4138  ..J...J...J.....
	defb 001h,007h,003h,0a7h,04ch,007h,00eh,0a7h,04ch,0ffh,008h,00ah,005h,019h,04dh,008h	; 4148  ....L...L.....M.
	defb 00ah,010h,019h,04dh,0ffh,003h,008h,000h,018h,010h,0d5h,0ffh,0ffh,0ffh,000h,000h	; 4158  ...M............
	defb 000h,04ah,000h,008h,000h,04ah,000h,010h,000h,04ah,002h,000h,03dh,04dh,002h,007h	; 4168  .J...J...J..=M..
	defb 0c5h,04dh,002h,00eh,0a8h,04dh,002h,011h,03dh,04dh,008h,00bh,0e2h,04dh,0ffh,007h	; 4178  .M...M..=M...M..
	defb 00ch,003h,084h,04ah,007h,00ch,013h,084h,04ah,005h,008h,00bh,084h,04ah,0ffh,000h	; 4188  ...J....J....J..
	defb 0ffh,0ffh,001h,004h,000h,0f2h,04ah,010h,000h,0f2h,04ah,006h,014h,014h,04bh,0ffh	; 4198  ......J...J...K.
	defb 001h,00dh,004h,08ah,04ah,001h,002h,012h,08ah,04ah,001h,012h,00ah,08ah,04ah,002h	; 41a8  ....J....J....J.
	defb 00ah,00eh,084h,04ah,002h,010h,015h,084h,04ah,003h,00dh,001h,084h,04ah,004h,006h	; 41b8  ...J....J....J..
	defb 00dh,036h,04bh,0ffh,000h,0ffh,0ffh,001h,002h,000h,0f2h,04ah,00fh,000h,0f2h,04ah	; 41c8  .6K........J...J
	defb 000h,014h,014h,04bh,00ch,014h,014h,04bh,0ffh,001h,009h,010h,08ah,04ah,001h,014h	; 41d8  ...K...K.....J..
	defb 00ch,08ah,04ah,002h,00ch,001h,084h,04ah,002h,009h,015h,084h,04ah,003h,00dh,00ah	; 41e8  ..J....J....J...
	defb 084h,04ah,004h,009h,009h,036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh	; 41f8  .J...6K....J....
	defb 001h,000h,000h,0f2h,04ah,00ch,000h,0f2h,04ah,008h,014h,014h,04bh,0ffh,001h,00dh	; 4208  ....J...J...K...
	defb 00dh,08ah,04ah,002h,00dh,00bh,084h,04ah,002h,012h,015h,084h,04ah,004h,006h,00bh	; 4218  ..J....J....J...
	defb 036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,00ch,000h,0f2h,04ah	; 4228  6K....J........J
	defb 000h,014h,014h,04bh,008h,014h,014h,04bh,010h,014h,014h,04bh,0ffh,001h,00eh,008h	; 4238  ...K...K...K....
	defb 08ah,04ah,001h,00eh,00fh,08ah,04ah,002h,003h,00bh,084h,04ah,002h,009h,001h,084h	; 4248  .J....J....J....
	defb 04ah,002h,015h,001h,084h,04ah,0ffh,000h,0ffh,0ffh,001h,004h,000h,0f2h,04ah,00eh	; 4258  J....J........J.
	defb 000h,0f2h,04ah,0ffh,001h,00bh,011h,08ah,04ah,001h,00bh,014h,08ah,04ah,002h,00eh	; 4268  ..J.....J....J..
	defb 012h,084h,04ah,002h,014h,006h,084h,04ah,003h,011h,012h,084h,04ah,004h,001h,012h	; 4278  ..J....J....J...
	defb 036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,005h,000h,0f2h,04ah	; 4288  6K....J........J
	defb 00fh,000h,0f2h,04ah,00ch,014h,014h,04bh,0ffh,001h,00fh,00bh,08ah,04ah,002h,011h	; 4298  ...J...K.....J..
	defb 007h,084h,04ah,002h,015h,013h,084h,04ah,002h,008h,015h,084h,04ah,0ffh,000h,0ffh	; 42a8  ..J....J....J...
	defb 0ffh,001h,000h,000h,0f2h,04ah,010h,000h,0f2h,04ah,004h,014h,014h,04bh,010h,014h	; 42b8  .....J...J...K..
	defb 014h,04bh,0ffh,001h,00ah,004h,08ah,04ah,001h,010h,00dh,08ah,04ah,003h,00dh,012h	; 42c8  .K.....J....J...
	defb 084h,04ah,004h,009h,00fh,036h,04bh,0ffh,000h,0ffh,0ffh,001h,005h,000h,0f2h,04ah	; 42d8  .J...6K........J
	defb 010h,000h,0f2h,04ah,00ah,014h,014h,04bh,0ffh,001h,00eh,007h,08ah,04ah,001h,014h	; 42e8  ...J...K.....J..
	defb 006h,08ah,04ah,002h,014h,015h,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,0ffh,000h	; 42f8  ..J....J........
	defb 0ffh,0ffh,001h,0ffh,006h,00bh,008h,090h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,006h	; 4308  ........J.......
	defb 00bh,003h,090h,04ah,006h,00bh,00dh,090h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,006h	; 4318  ...J....J.......
	defb 00bh,000h,090h,04ah,006h,00bh,008h,090h,04ah,006h,00bh,010h,090h,04ah,0ffh,000h	; 4328  ...J....J....J..
	defb 0ffh,0ffh,001h,004h,000h,0f2h,04ah,010h,000h,0f2h,04ah,006h,014h,014h,04bh,0ffh	; 4338  ......J...J...K.
	defb 001h,002h,009h,08ah,04ah,001h,002h,00bh,08ah,04ah,002h,002h,00dh,084h,04ah,002h	; 4348  ....J....J....J.
	defb 014h,011h,084h,04ah,004h,005h,006h,036h,04bh,004h,00ah,008h,036h,04bh,004h,00fh	; 4358  ...J...6K...6K..
	defb 00bh,036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,002h,000h,0f2h	; 4368  .6K....J........
	defb 04ah,00fh,000h,0f2h,04ah,000h,014h,014h,04bh,00ch,014h,014h,04bh,0ffh,002h,004h	; 4378  J...J...K...K...
	defb 00fh,084h,04ah,002h,014h,005h,084h,04ah,003h,012h,010h,084h,04ah,004h,00ah,004h	; 4388  ..J....J....J...
	defb 036h,04bh,004h,004h,009h,036h,04bh,004h,010h,009h,036h,04bh,004h,00ah,00eh,036h	; 4398  6K...6K...6K...6
	defb 04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,000h,000h,0f2h,04ah,00ch	; 43a8  K....J........J.
	defb 000h,0f2h,04ah,008h,014h,014h,04bh,0ffh,001h,014h,005h,08ah,04ah,002h,00fh,010h	; 43b8  ..J...K.....J...
	defb 084h,04ah,004h,005h,006h,036h,04bh,004h,00eh,007h,036h,04bh,004h,008h,00dh,036h	; 43c8  .J...6K...6K...6
	defb 04bh,004h,002h,010h,036h,04bh,004h,012h,011h,036h,04bh,00ah,000h,00bh,084h,04ah	; 43d8  K...6K...6K....J
	defb 0ffh,000h,0ffh,0ffh,001h,00ch,000h,0f2h,04ah,000h,014h,014h,04bh,008h,014h,014h	; 43e8  ........J...K...
	defb 04bh,010h,014h,014h,04bh,0ffh,002h,00dh,00ch,084h,04ah,003h,003h,011h,084h,04ah	; 43f8  K...K.....J....J
	defb 004h,002h,002h,036h,04bh,004h,006h,002h,036h,04bh,004h,008h,009h,036h,04bh,004h	; 4408  ...6K...6K...6K.
	defb 008h,00eh,036h,04bh,004h,010h,009h,036h,04bh,004h,010h,00fh,036h,04bh,0ffh,000h	; 4418  ..6K...6K...6K..
	defb 0ffh,0ffh,001h,004h,000h,0f2h,04ah,00eh,000h,0f2h,04ah,0ffh,001h,01dh,00ch,08ah	; 4428  ......J...J.....
	defb 04ah,002h,00bh,00ah,084h,04ah,004h,006h,00dh,036h,04bh,004h,00eh,009h,036h,04bh	; 4438  J....J...6K...6K
	defb 004h,00dh,010h,036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,005h	; 4448  ...6K....J......
	defb 000h,0f2h,04ah,00fh,000h,0f2h,04ah,00ch,014h,014h,04bh,0ffh,001h,013h,00ch,08ah	; 4458  ..J...J...K.....
	defb 04ah,002h,015h,006h,084h,04ah,002h,003h,009h,084h,04ah,002h,004h,010h,084h,04ah	; 4468  J....J....J....J
	defb 004h,00bh,006h,036h,04bh,004h,008h,00bh,036h,04bh,004h,00fh,00fh,036h,04bh,0ffh	; 4478  ...6K...6K...6K.
	defb 000h,0ffh,0ffh,001h,000h,000h,0f2h,04ah,010h,000h,0f2h,04ah,004h,014h,014h,04bh	; 4488  .......J...J...K
	defb 010h,014h,014h,04bh,0ffh,001h,009h,00ah,08ah,04ah,001h,014h,009h,08ah,04ah,002h	; 4498  ...K.....J....J.
	defb 013h,00fh,084h,04ah,004h,004h,006h,036h,04bh,004h,004h,00bh,036h,04bh,004h,004h	; 44a8  ...J...6K...6K..
	defb 010h,036h,04bh,004h,00dh,006h,036h,04bh,004h,00ch,00dh,036h,04bh,0ffh,000h,0ffh	; 44b8  .6K...6K...6K...
	defb 0ffh,001h,005h,000h,0f2h,04ah,010h,000h,0f2h,04ah,00ah,014h,014h,04bh,0ffh,001h	; 44c8  .....J...J...K..
	defb 00fh,00fh,08ah,04ah,001h,005h,014h,08ah,04ah,002h,006h,00eh,084h,04ah,002h,00fh	; 44d8  ...J....J....J..
	defb 00ch,084h,04ah,004h,005h,006h,036h,04bh,004h,00ah,00bh,036h,04bh,004h,011h,006h	; 44e8  ..J...6K...6K...
	defb 036h,04bh,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,009h,006h,08ah,04ah,001h,009h,010h	; 44f8  6K..........J...
	defb 08ah,04ah,001h,012h,007h,08ah,04ah,001h,012h,010h,08ah,04ah,001h,00fh,00bh,08ah	; 4508  .J....J....J....
	defb 04ah,002h,009h,00bh,084h,04ah,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,002h	; 4518  J....J....J.....
	defb 0ffh,001h,005h,009h,08ah,04ah,001h,005h,00fh,08ah,04ah,001h,011h,00ah,08ah,04ah	; 4528  .....J....J....J
	defb 001h,011h,00eh,08ah,04ah,002h,007h,00bh,084h,04ah,002h,007h,00dh,084h,04ah,003h	; 4538  ....J....J....J.
	defb 011h,00ch,084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,002h,013h,08ah,04ah,001h	; 4548  ...J..........J.
	defb 009h,00ch,08ah,04ah,001h,012h,010h,08ah,04ah,001h,014h,004h,08ah,04ah,002h,00bh	; 4558  ...J....J....J..
	defb 005h,084h,04ah,003h,006h,005h,084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,00eh	; 4568  ..J....J........
	defb 008h,08ah,04ah,001h,00eh,010h,08ah,04ah,001h,00ah,00ch,08ah,04ah,002h,008h,00ah	; 4578  ..J....J....J...
	defb 084h,04ah,002h,008h,00eh,084h,04ah,002h,00ch,00ah,084h,04ah,002h,00ch,00eh,084h	; 4588  .J....J....J....
	defb 04ah,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,003h,00ah,08ah	; 4598  J....J..........
	defb 04ah,001h,003h,00ch,08ah,04ah,002h,00ah,006h,084h,04ah,002h,00ah,008h,084h,04ah	; 45a8  J....J....J....J
	defb 002h,00ah,00ah,084h,04ah,003h,010h,00ch,084h,04ah,003h,010h,00eh,084h,04ah,002h	; 45b8  ....J....J....J.
	defb 010h,010h,084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,009h,00bh,08ah,04ah,001h	; 45c8  ...J..........J.
	defb 009h,00dh,08ah,04ah,001h,009h,00fh,08ah,04ah,001h,009h,011h,08ah,04ah,001h,009h	; 45d8  ...J....J....J..
	defb 013h,08ah,04ah,002h,00ch,004h,084h,04ah,002h,013h,00ch,084h,04ah,00ah,000h,00bh	; 45e8  ..J....J....J...
	defb 084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,001h,007h,00bh,08ah,04ah,001h,00fh,012h	; 45f8  .J..........J...
	defb 08ah,04ah,002h,007h,004h,084h,04ah,002h,00ah,007h,084h,04ah,002h,00eh,00ch,084h	; 4608  .J....J....J....
	defb 04ah,002h,012h,00fh,084h,04ah,003h,007h,014h,084h,04ah,0ffh,000h,0ffh,0ffh,002h	; 4618  J....J....J.....
	defb 0ffh,001h,00eh,004h,08ah,04ah,001h,00eh,008h,08ah,04ah,001h,00eh,00ch,08ah,04ah	; 4628  .....J....J....J
	defb 001h,00eh,010h,08ah,04ah,002h,007h,007h,084h,04ah,002h,007h,00fh,084h,04ah,002h	; 4638  ....J....J....J.
	defb 014h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,002h,0ffh,0ffh,000h,0ffh,0ffh,002h,000h	; 4648  ...J............
	defb 000h,0f2h,04ah,008h,000h,0f2h,04ah,010h,000h,0f2h,04ah,008h,014h,014h,04bh,0ffh	; 4658  ..J...J...J...K.
	defb 001h,011h,007h,08ah,04ah,001h,00fh,00fh,08ah,04ah,002h,004h,008h,084h,04ah,003h	; 4668  ....J....J....J.
	defb 006h,015h,084h,04ah,004h,002h,014h,036h,04bh,004h,009h,00ah,036h,04bh,004h,011h	; 4678  ...J...6K...6K..
	defb 00eh,036h,04bh,0ffh,000h,0ffh,0ffh,002h,000h,000h,0f2h,04ah,008h,000h,0f2h,04ah	; 4688  .6K........J...J
	defb 010h,000h,0f2h,04ah,000h,014h,014h,04bh,008h,014h,014h,04bh,010h,014h,014h,04bh	; 4698  ...J...K...K...K
	defb 0ffh,001h,013h,007h,08ah,04ah,001h,013h,011h,08ah,04ah,002h,003h,009h,084h,04ah	; 46a8  .....J....J....J
	defb 002h,00eh,00ah,084h,04ah,004h,008h,005h,036h,04bh,004h,008h,00ah,036h,04bh,004h	; 46b8  ....J...6K...6K.
	defb 003h,010h,036h,04bh,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,002h,000h,000h	; 46c8  ..6K....J.......
	defb 0f2h,04ah,008h,000h,0f2h,04ah,010h,000h,0f2h,04ah,004h,014h,014h,04bh,010h,014h	; 46d8  .J...J...J...K..
	defb 014h,04bh,0ffh,002h,006h,007h,084h,04ah,002h,00bh,009h,084h,04ah,002h,010h,00dh	; 46e8  .K.....J....J...
	defb 084h,04ah,002h,014h,010h,084h,04ah,004h,002h,006h,036h,04bh,004h,006h,00ah,036h	; 46f8  .J....J...6K...6
	defb 04bh,004h,00ah,00eh,036h,04bh,004h,00fh,007h,036h,04bh,0ffh,000h,0ffh,0ffh,002h	; 4708  K...6K...6K.....
	defb 000h,000h,0f2h,04ah,008h,000h,0f2h,04ah,010h,000h,0f2h,04ah,000h,014h,014h,04bh	; 4718  ...J...J...J...K
	defb 008h,014h,014h,04bh,010h,014h,014h,04bh,0ffh,001h,013h,008h,08ah,04ah,001h,013h	; 4728  ...K...K.....J..
	defb 00eh,08ah,04ah,002h,00dh,005h,084h,04ah,002h,00dh,011h,084h,04ah,004h,009h,004h	; 4738  ..J....J....J...
	defb 036h,04bh,004h,009h,00ah,036h,04bh,004h,009h,010h,036h,04bh,0ffh,000h,0ffh,0ffh	; 4748  6K...6K...6K....
	defb 002h,004h,000h,0f2h,04ah,00eh,000h,0f2h,04ah,000h,014h,014h,04bh,008h,014h,014h	; 4758  ....J...J...K...
	defb 04bh,010h,014h,014h,04bh,0ffh,001h,00dh,007h,08ah,04ah,001h,00dh,00bh,08ah,04ah	; 4768  K...K.....J....J
	defb 002h,008h,006h,084h,04ah,002h,015h,009h,084h,04ah,003h,008h,00fh,084h,04ah,00ah	; 4778  ....J....J....J.
	defb 000h,00bh,084h,04ah,004h,003h,00eh,036h,04bh,004h,007h,00ah,036h,04bh,004h,00bh	; 4788  ...J...6K...6K..
	defb 00eh,036h,04bh,0ffh,000h,0ffh,0ffh,002h,000h,000h,0f2h,04ah,008h,000h,0f2h,04ah	; 4798  .6K........J...J
	defb 010h,000h,0f2h,04ah,000h,014h,014h,04bh,010h,014h,014h,04bh,0ffh,001h,00fh,00ah	; 47a8  ...J...K...K....
	defb 08ah,04ah,001h,00fh,00eh,08ah,04ah,002h,00ch,005h,084h,04ah,002h,009h,00bh,084h	; 47b8  .J....J....J....
	defb 04ah,002h,009h,015h,084h,04ah,004h,005h,006h,036h,04bh,004h,005h,00ah,036h,04bh	; 47c8  J....J...6K...6K
	defb 0ffh,000h,0ffh,0ffh,002h,000h,000h,0f2h,04ah,008h,000h,0f2h,04ah,010h,000h,0f2h	; 47d8  ........J...J...
	defb 04ah,004h,014h,014h,04bh,010h,014h,014h,04bh,0ffh,001h,00dh,00eh,08ah,04ah,001h	; 47e8  J...K...K.....J.
	defb 00dh,010h,08ah,04ah,002h,00ah,006h,084h,04ah,003h,00ah,00bh,084h,04ah,004h,005h	; 47f8  ...J....J....J..
	defb 007h,036h,04bh,004h,011h,007h,036h,04bh,004h,00fh,00eh,036h,04bh,00ah,000h,00bh	; 4808  .6K...6K...6K...
	defb 084h,04ah,0ffh,000h,0ffh,0ffh,002h,002h,000h,0f2h,04ah,00ah,000h,0f2h,04ah,000h	; 4818  .J........J...J.
	defb 014h,014h,04bh,008h,014h,014h,04bh,010h,014h,014h,04bh,0ffh,001h,00ah,00eh,08ah	; 4828  ..K...K...K.....
	defb 04ah,001h,00fh,009h,08ah,04ah,001h,014h,001h,08ah,04ah,002h,003h,00ah,08ah,04ah	; 4838  J....J....J....J
	defb 002h,014h,00bh,08ah,04ah,004h,009h,008h,036h,04bh,004h,00eh,00dh,036h,04bh,0ffh	; 4848  ....J...6K...6K.
	defb 000h,0ffh,0ffh,002h,0ffh,0ffh,000h,0ffh,0ffh,001h,0ffh,001h,00ah,006h,08ah,04ah	; 4858  ...............J
	defb 001h,00ah,00eh,08ah,04ah,001h,00fh,003h,08ah,04ah,001h,00fh,011h,08ah,04ah,002h	; 4868  ....J....J....J.
	defb 00ah,008h,084h,04ah,002h,00ah,00ch,084h,04ah,003h,00ah,00ah,084h,04ah,00ah,000h	; 4878  ...J....J....J..
	defb 00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,001h,007h,007h,08ah,04ah,001h,007h	; 4888  ..J..........J..
	defb 011h,08ah,04ah,002h,010h,004h,084h,04ah,002h,010h,006h,084h,04ah,002h,010h,008h	; 4898  ..J....J....J...
	defb 084h,04ah,002h,010h,00ah,084h,04ah,002h,010h,00ch,084h,04ah,0ffh,000h,0ffh,0ffh	; 48a8  .J....J....J....
	defb 001h,0ffh,001h,006h,006h,08ah,04ah,001h,014h,00bh,08ah,04ah,001h,010h,010h,08ah	; 48b8  ......J....J....
	defb 04ah,002h,006h,010h,084h,04ah,002h,010h,006h,084h,04ah,002h,006h,010h,084h,04ah	; 48c8  J....J....J....J
	defb 00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,001h,003h,002h,08ah,04ah	; 48d8  ....J..........J
	defb 001h,003h,011h,08ah,04ah,001h,00dh,002h,08ah,04ah,001h,00dh,011h,08ah,04ah,001h	; 48e8  ....J....J....J.
	defb 015h,003h,08ah,04ah,002h,009h,00bh,084h,04ah,002h,014h,013h,084h,04ah,0ffh,000h	; 48f8  ...J....J....J..
	defb 0ffh,0ffh,001h,0ffh,001h,00bh,002h,08ah,04ah,001h,006h,015h,08ah,04ah,001h,012h	; 4908  ........J....J..
	defb 015h,08ah,04ah,002h,00bh,005h,084h,04ah,002h,008h,00fh,084h,04ah,002h,013h,007h	; 4918  ..J....J....J...
	defb 084h,04ah,00ah,000h,00bh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,001h,00ch,006h	; 4928  .J....J.........
	defb 08ah,04ah,001h,00ch,008h,08ah,04ah,001h,00ch,00ah,08ah,04ah,001h,00ch,00ch,08ah	; 4938  .J....J....J....
	defb 04ah,001h,00ch,00eh,08ah,04ah,001h,00ch,010h,08ah,04ah,002h,010h,008h,084h,04ah	; 4948  J....J....J....J
	defb 002h,010h,00eh,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,001h,00dh,009h,08ah,04ah	; 4958  ....J..........J
	defb 001h,00dh,00eh,08ah,04ah,002h,005h,005h,084h,04ah,002h,005h,012h,084h,04ah,003h	; 4968  ....J....J....J.
	defb 00ah,001h,084h,04ah,003h,00ah,015h,084h,04ah,00ah,000h,00bh,084h,04ah,0ffh,000h	; 4978  ...J....J....J..
	defb 0ffh,0ffh,001h,0ffh,001h,005h,006h,08ah,04ah,001h,005h,010h,08ah,04ah,001h,00bh	; 4988  ........J....J..
	defb 00bh,08ah,04ah,001h,010h,006h,08ah,04ah,001h,010h,010h,08ah,04ah,002h,00bh,003h	; 4998  ..J....J....J...
	defb 084h,04ah,002h,00bh,014h,084h,04ah,0ffh,000h,0ffh,0ffh,001h,0ffh,0ffh	; 49a8  .J....J.......

; ----------------------------------------------------------------------
; DATOS bordes: Los dos bordes (0x49B6 y 0x49DB): dibujos (sitio y puntero)
;   hasta 0xFF
;   0x49b6..0x4a00  (74 bytes)
DATA_bordes:
	defb 000h,000h,042h,04ah,000h,008h,042h,04ah,000h,010h,042h,04ah,008h,000h,042h,04ah	; 49b6  ..BJ..BJ..BJ..BJ
	defb 008h,008h,042h,04ah,008h,010h,042h,04ah,010h,000h,042h,04ah,010h,008h,042h,04ah	; 49c6  ..BJ..BJ..BJ..BJ
	defb 010h,010h,042h,04ah,0ffh,000h,000h,000h,04ah,000h,008h,000h,04ah,000h,010h,000h	; 49d6  ..BJ....J...J...
	defb 04ah,008h,000h,000h,04ah,008h,008h,000h,04ah,008h,010h,000h,04ah,010h,000h,000h	; 49e6  J...J...J...J...
	defb 04ah,010h,008h,000h,04ah,010h,010h,000h,04ah,0ffh	; 49f6  J...J...J.

; ----------------------------------------------------------------------
; DATOS dibujos: Los dibujos de casillas de las pantallas (ancho, alto y
;   casillas): los de las descripciones y, desde el codigo, la pieza del
;   guardian (0x4A90 y 0x4DE8; rota, 0x4E4A) y la boca (0x4D19 y 0x4D2B)
;   0x4a00..0x4eac  (1196 bytes)
DATA_dibujos:
	defb 008h,008h,05eh,05eh,05eh,053h,054h,055h,05ch,065h,04ch,04dh,04eh,04fh,050h,058h	; 4a00  ..^^^STU\eLMNOPX
	defb 051h,052h,046h,058h,058h,047h,048h,049h,04ah,04bh,041h,042h,056h,044h,045h,058h	; 4a10  QRFXXGHIJKABVDEX
	defb 058h,058h,068h,069h,058h,06ah,06bh,06ch,040h,043h,061h,062h,063h,064h,058h,058h	; 4a20  XXhiXjkl@CabcdXX
	defb 066h,067h,05bh,05bh,058h,05dh,05eh,05eh,05fh,060h,058h,058h,058h,057h,058h,058h	; 4a30  fg[[X]^^_`XXXWXX
	defb 059h,05ah,008h,008h,06bh,06ch,06dh,06eh,040h,040h,06fh,040h,065h,066h,040h,053h	; 4a40  YZ..klmn@@o@ef@S
	defb 067h,068h,069h,06ah,040h,05eh,05fh,060h,061h,062h,063h,064h,057h,058h,040h,059h	; 4a50  ghij@^_`abcdWX@Y
	defb 05ah,05bh,05ch,05dh,055h,040h,040h,040h,056h,040h,040h,040h,04fh,050h,040h,051h	; 4a60  Z[\]U@@@V@@@OP@Q
	defb 052h,040h,040h,054h,047h,048h,049h,04ah,04bh,04ch,04dh,04eh,040h,041h,042h,043h	; 4a70  R@@TGHIJKLMN@ABC
	defb 044h,045h,046h,040h,002h,002h,000h,000h,000h,000h,002h,002h,082h,083h,080h,081h	; 4a80  DEF@............
	defb 008h,00ch,084h,085h,084h,085h,084h,085h,084h,085h,085h,010h,010h,010h,010h,010h	; 4a90  ................
	defb 010h,086h,087h,010h,0bch,0bdh,0beh,0bfh,010h,084h,085h,010h,0b8h,0b9h,0bah,0bbh	; 4aa0  ................
	defb 010h,086h,087h,010h,0b4h,0b5h,0b6h,0b7h,010h,084h,085h,010h,0b0h,0b1h,0b2h,0b3h	; 4ab0  ................
	defb 010h,086h,087h,010h,0ach,0adh,0aeh,0afh,010h,084h,085h,010h,0a8h,0a9h,0aah,0abh	; 4ac0  ................
	defb 010h,086h,087h,010h,0a4h,0a5h,0a6h,0a7h,010h,084h,085h,010h,0a0h,0a1h,0a2h,0a3h	; 4ad0  ................
	defb 010h,086h,087h,010h,010h,010h,010h,010h,010h,084h,086h,087h,086h,087h,086h,087h	; 4ae0  ................
	defb 086h,087h,004h,008h,0dah,0deh,073h,074h,0d6h,0d6h,0e1h,0eah,0d9h,0ddh,0e3h,0e9h	; 4af0  ......st........
	defb 0d8h,0d8h,0d8h,0e8h,0d7h,0dch,0e2h,0e7h,0d6h,0d6h,0e1h,0e6h,0d5h,0dbh,0e0h,0e5h	; 4b00  ................
	defb 0d4h,0d4h,0dfh,0e4h,004h,008h,05eh,070h,0f7h,0f2h,071h,0fch,0f6h,0f1h,0ffh,0d6h	; 4b10  ......^p..q.....
	defb 0f5h,0f0h,0feh,0fbh,0f4h,0efh,0fdh,0fah,0efh,0eeh,072h,0f9h,0edh,0edh,05bh,0f8h	; 4b20  ..........r...[.
	defb 0ech,0ech,058h,058h,0f3h,0ebh,004h,004h,07ch,07bh,07ah,07fh,07dh,010h,010h,079h	; 4b30  ..XX....|{z.}..y
	defb 07eh,010h,010h,078h,074h,075h,076h,077h,018h,001h,072h,075h,074h,073h,072h,071h	; 4b40  ~..xtuvw..rutsrq
	defb 070h,070h,072h,075h,074h,073h,072h,071h,070h,070h,072h,075h,074h,073h,072h,071h	; 4b50  pprutsrqpprutsrq
	defb 070h,070h,013h,011h,0fdh,0feh,0fdh,0f7h,0f3h,0f3h,0f3h,0f3h,0f3h,0f3h,0f3h,0f3h	; 4b60  pp..............
	defb 0f3h,0f8h,0fdh,0feh,0fdh,0feh,0fdh,0fch,0ffh,0f7h,0fbh,0fbh,0fbh,0b3h,0b4h,0b5h	; 4b70  ................
	defb 0b6h,0fbh,0fbh,0fbh,010h,0f3h,0f3h,0f3h,0ffh,0fch,0fdh,0f7h,0fbh,0fbh,0a8h,0afh	; 4b80  ................
	defb 0b0h,0b1h,0b2h,0b7h,0fbh,0c1h,0c2h,0c1h,0b5h,010h,010h,0f8h,0fdh,0fch,0f9h,0a4h	; 4b90  ................
	defb 0a5h,0a6h,0a7h,0ach,0adh,0aeh,0b8h,0afh,0d3h,09ah,0c7h,0c4h,0b5h,0c6h,0f4h,0fch	; 4ba0  ................
	defb 0fdh,0f6h,0a1h,0a2h,097h,0a3h,093h,0eeh,0eeh,0b9h,0e6h,0c7h,0f2h,08eh,0bdh,0b2h	; 4bb0  ................
	defb 08ch,0fbh,0f4h,0fch,0f6h,09fh,093h,0eeh,0a0h,0a9h,0aah,0abh,0edh,0d4h,08eh,0e9h	; 4bc0  ................
	defb 0eah,0bdh,0b2h,0d0h,0d1h,0f4h,0f7h,010h,0f1h,093h,09dh,09eh,0dch,0e1h,0edh,0edh	; 4bd0  ................
	defb 0e5h,0e0h,0e8h,0d5h,0cdh,0ceh,0c3h,0cfh,0f4h,0f6h,0c1h,0b5h,0dbh,0edh,0edh,0deh	; 4be0  ................
	defb 0dfh,0e0h,0e2h,0e4h,0edh,0e8h,0edh,0edh,0bch,0beh,097h,0f4h,0f6h,0c7h,0c4h,0c5h	; 4bf0  ................
	defb 0c6h,0dah,0ddh,0e0h,0edh,0edh,0e3h,0d5h,0e6h,0edh,0edh,0d2h,093h,0eeh,0f4h,0f6h	; 4c00  ................
	defb 010h,088h,089h,08ch,0d9h,0d8h,0edh,0edh,0d4h,0edh,0edh,0d5h,0d6h,0ech,0a9h,093h	; 4c10  ................
	defb 0f0h,0f4h,0fdh,0f6h,084h,093h,085h,0d4h,0d5h,0d6h,0d7h,0d6h,0edh,0edh,0edh,0e8h	; 4c20  ................
	defb 0ebh,0c1h,0c2h,0c6h,0f4h,0fch,0f6h,0efh,093h,082h,0edh,0edh,0d4h,0edh,0edh,0d5h	; 4c30  ................
	defb 0e7h,0e8h,0bfh,0c0h,0c3h,09ah,08ch,0fah,0fdh,0f5h,0bbh,093h,0c4h,0c5h,0c8h,0c9h	; 4c40  ................
	defb 0cah,0cbh,0cch,0e8h,0edh,0bdh,0a2h,0beh,097h,08dh,0fdh,0fch,0ffh,0fch,0f5h,088h	; 4c50  ................
	defb 089h,08ah,08bh,08ch,099h,09ah,09bh,09ch,0bch,093h,0eeh,083h,0ffh,0fch,0fdh,0feh	; 4c60  ................
	defb 0fdh,0ffh,084h,093h,086h,087h,08dh,095h,096h,097h,098h,0bbh,093h,083h,0fdh,0feh	; 4c70  ................
	defb 0fdh,0fch,0ffh,0fch,0ffh,080h,081h,093h,083h,0fdh,092h,093h,0eeh,094h,0feh,0bah	; 4c80  ................
	defb 0ffh,0fch,0ffh,0fch,0fdh,0feh,0fdh,0feh,0fdh,0feh,0fdh,0feh,0fdh,08fh,090h,091h	; 4c90  ................
	defb 0fdh,0feh,0fdh,0feh,0fdh,0feh,0fdh,007h,010h,0fch,0fdh,0feh,0ffh,0dch,0ddh,0deh	; 4ca0  ................
	defb 0f8h,0f9h,0fah,0fbh,0d8h,0d9h,0dah,0f4h,0f5h,0f6h,0f7h,0d4h,0d5h,0d6h,0f0h,0f1h	; 4cb0  ................
	defb 0f2h,0f3h,0d0h,0d1h,0d2h,0ech,0edh,0eeh,0efh,0cch,0cdh,0ceh,040h,0e9h,0eah,0ebh	; 4cc0  ............@...
	defb 0c8h,0c9h,0cah,041h,0e5h,0e6h,0e7h,0c4h,0c5h,0c6h,042h,0e1h,0e2h,0e3h,0c0h,0c1h	; 4cd0  ...A......B.....
	defb 0c2h,043h,0bdh,0beh,0bfh,09ch,09dh,09eh,044h,0b9h,0bah,0bbh,098h,099h,09ah,045h	; 4ce0  .C......D......E
	defb 0b5h,0b6h,0b7h,094h,095h,096h,046h,0b1h,0b2h,0b3h,090h,091h,092h,047h,0adh,0aeh	; 4cf0  ......F......G..
	defb 0afh,08ch,08dh,08eh,048h,0a9h,0aah,0abh,088h,089h,08ah,049h,0a5h,0a6h,0a7h,084h	; 4d00  ....H......I....
	defb 085h,086h,04ah,0a1h,0a2h,0a3h,0a0h,0a4h,087h,004h,004h,0f2h,0f3h,0d0h,0d1h,0eeh	; 4d10  ..J.............
	defb 0efh,0cch,0cdh,0eah,0ebh,0c8h,0c9h,0e6h,0e7h,0c4h,0c5h,004h,004h,0f2h,0b8h,09bh	; 4d20  ................
	defb 0d1h,0a8h,0b4h,097h,08bh,0a8h,0b0h,093h,08bh,082h,0ach,08fh,083h,007h,00fh,0b0h	; 4d30  ................
	defb 0b1h,04ch,04dh,04bh,0bah,0bbh,0ach,0b2h,0b7h,0b8h,0b8h,0b9h,0ach,0cfh,0b3h,0b6h	; 4d40  .LMK............
	defb 0c9h,0c9h,0cfh,0cfh,0ach,0b3h,0b5h,0c9h,0cfh,0cfh,0d3h,0ach,0b4h,0c9h,0cah,0c9h	; 4d50  ................
	defb 0cah,0d4h,0ach,0ach,0cfh,0c9h,0cah,0cbh,0d3h,0cbh,0c9h,0cch,0cah,0cch,0cch,0d2h	; 4d60  ................
	defb 0ach,0ach,0ach,0cfh,0cbh,0c9h,0d1h,0a6h,0ceh,0cbh,0c7h,0c8h,0cdh,0c6h,09fh,0a0h	; 4d70  ................
	defb 0a1h,0a2h,0a3h,0a4h,0a5h,098h,099h,09ah,09bh,09ch,09dh,09eh,091h,092h,093h,094h	; 4d80  ................
	defb 095h,096h,097h,08ah,08bh,08ch,08dh,08eh,08fh,090h,0d5h,085h,086h,087h,088h,089h	; 4d90  ................
	defb 0d5h,0d5h,080h,081h,082h,083h,084h,0d5h,003h,009h,0aeh,0afh,0afh,048h,0adh,0ach	; 4da0  .............H..
	defb 047h,041h,0ach,048h,042h,0abh,047h,043h,0aah,048h,044h,0a9h,0d5h,0d5h,0c0h,0d5h	; 4db0  GA.HB.GC.HD.....
	defb 0d5h,0a8h,0d5h,0d5h,0a7h,003h,009h,0bbh,0bch,0bdh,0ach,0beh,049h,0bfh,045h,04ah	; 4dc0  ............I.EJ
	defb 0c1h,046h,049h,0c2h,047h,04ah,0c3h,048h,049h,0d0h,0d5h,0d5h,0c4h,0d5h,0d5h,0c5h	; 4dd0  .FI.GJ.HI.......
	defb 0d5h,0d5h,002h,002h,010h,010h,0d7h,0dah,008h,00ch,084h,085h,084h,085h,084h,085h	; 4de0  ................
	defb 084h,085h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,0bch,0bdh,0beh,0bfh	; 4df0  ................
	defb 010h,084h,085h,010h,0b8h,0b9h,0bah,0bbh,010h,086h,087h,010h,0b4h,0b5h,0b6h,0b7h	; 4e00  ................
	defb 010h,084h,085h,010h,0b0h,0b1h,0b2h,0b3h,010h,086h,087h,010h,0cch,0cdh,0ceh,0cfh	; 4e10  ................
	defb 010h,084h,085h,010h,0c8h,0c9h,0cah,0cbh,010h,086h,087h,010h,0c4h,0c5h,0c6h,0c7h	; 4e20  ................
	defb 010h,084h,085h,010h,0c0h,0c1h,0c2h,0c3h,010h,086h,087h,010h,010h,010h,010h,010h	; 4e30  ................
	defb 010h,084h,086h,087h,086h,087h,086h,087h,086h,087h,008h,00ch,084h,085h,084h,085h	; 4e40  ................
	defb 084h,085h,084h,085h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,010h,010h	; 4e50  ................
	defb 010h,010h,010h,084h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,010h,010h	; 4e60  ................
	defb 010h,010h,010h,084h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,010h,010h	; 4e70  ................
	defb 010h,010h,010h,084h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,010h,010h	; 4e80  ................
	defb 010h,010h,010h,084h,085h,010h,010h,010h,010h,010h,010h,086h,087h,010h,010h,010h	; 4e90  ................
	defb 010h,010h,010h,084h,086h,087h,086h,087h,086h,087h,086h,087h	; 4ea0  ............

; ----------------------------------------------------------------------
; DATOS fuente_sobra: 340 bytes que nadie lee: el final de una fuente de
;   letras de 8 x 8 (cifras y signos) y ceros
;   0x4eac..0x5000  (340 bytes)
DATA_fuente_sobra:
	defb 07eh,007h,007h,07eh,000h,03eh,063h,060h,07eh,063h,067h,03eh,000h,07fh,047h,003h	; 4eac  ~..~.>c`~cg>..G.
	defb 006h,00ch,018h,018h,000h,03eh,063h,067h,03eh,063h,067h,03eh,000h,03eh,063h,067h	; 4ebc  .....>cg>cg>.>cg
	defb 03fh,003h,047h,03eh,000h,000h,00ch,00ch,000h,00ch,00ch,000h,000h,000h,000h,000h	; 4ecc  ?.G>............
	defb 000h,000h,060h,060h,000h,006h,00ch,018h,030h,018h,00ch,006h,000h,000h,000h,07eh	; 4edc  ..``....0......~
	defb 000h,07eh,000h,000h,000h,008h,01ch,036h,07fh,07fh,05dh,008h,000h,03eh,067h,003h	; 4eec  .~.....6..]..>g.
	defb 01eh,018h,000h,018h,000h,000h,000h,000h,000h,000h,000h,000h,000h,01ch,03eh,063h	; 4efc  ..............>c
	defb 063h,073h,06fh,063h,000h,07eh,063h,073h,06eh,063h,063h,07eh,000h,03eh,063h,063h	; 4f0c  csoc.~csncc~.>cc
	defb 070h,073h,073h,03eh,000h,07eh,063h,063h,073h,073h,073h,07eh,000h,07fh,060h,07ch	; 4f1c  pss>.~ccsss~..`|
	defb 063h,060h,060h,07fh,000h,07fh,060h,07ch,063h,060h,060h,060h,000h,03eh,073h,073h	; 4f2c  c``...`|c```.>ss
	defb 070h,067h,067h,03fh,000h,063h,063h,07bh,067h,063h,063h,063h,000h,018h,018h,018h	; 4f3c  pgg?.cc{gccc....
	defb 01ch,01ch,01ch,01ch,000h,007h,007h,007h,003h,063h,063h,03fh,000h,063h,063h,064h	; 4f4c  .........cc?.ccd
	defb 078h,074h,073h,073h,000h,060h,060h,060h,070h,070h,073h,07fh,000h,07eh,07bh,07bh	; 4f5c  xtss.```pps..~{{
	defb 06bh,06bh,06bh,06bh,000h,066h,07bh,073h,063h,063h,063h,063h,000h,03eh,06bh,06fh	; 4f6c  kkkk.f{scccc.>ko
	defb 063h,07bh,06bh,03eh,000h,07eh,063h,063h,063h,066h,078h,060h,000h,03eh,073h,073h	; 4f7c  c{k>.~cccfx`.>ss
	defb 073h,06bh,067h,03eh,000h,07eh,063h,063h,067h,07ch,067h,063h,000h,03eh,073h,070h	; 4f8c  skg>.~ccg|gc.>sp
	defb 03eh,007h,067h,03eh,000h,07fh,018h,018h,018h,01ch,01ch,01ch,000h,063h,063h,063h	; 4f9c  >.g>.........ccc
	defb 073h,073h,073h,03eh,000h,077h,063h,063h,077h,036h,036h,01ch,000h,06bh,06bh,06bh	; 4fac  sss>.wccw66..kkk
	defb 06bh,06fh,06fh,07eh,000h,063h,027h,03eh,01ch,038h,07ch,067h,000h,043h,026h,01ch	; 4fbc  koo~.c'>.8|g.C&.
	defb 018h,018h,01ch,01ch,000h,07fh,063h,004h,018h,018h,023h,07fh,000h,000h,000h,000h	; 4fcc  ......c...#.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4fdc  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 4fec  ................
	defb 000h,000h,000h,000h	; 4ffc

; ----------------------------------------------------------------------
; DATOS titulo_dibujos: Los dibujos de las casillas 0x30-0x8F del titulo
;   0x5000..0x5300  (768 bytes)
DATA_titulo_dibujos:
	defb 0feh,0ffh,030h,0f7h,0ffh,000h,0ffh,0c0h,0ffh,0f7h,0c6h,0dfh,0fbh,003h,0f7h,037h	; 5000  ..0............7
	defb 0ffh,0ffh,00ch,0fdh,0fdh,0fdh,0ffh,0ffh,0e8h,0ech,00eh,0ffh,0ffh,0f0h,030h,0d0h	; 5010  ..............0.
	defb 0fdh,0c7h,0d8h,0ffh,006h,0feh,0ffh,0f8h,0f7h,0f7h,037h,0f7h,007h,0fbh,0fbh,002h	; 5020  ..........7.....
	defb 00ch,0fdh,0fdh,0fdh,0fdh,0ffh,0ffh,000h,010h,0f0h,0f0h,0ffh,0ffh,0eeh,0ech,008h	; 5030  ................
	defb 077h,077h,077h,000h,0f8h,0f8h,000h,000h,000h,000h,03fh,03fh,03fh,03fh,000h,000h	; 5040  www.......????..
	defb 000h,000h,0ffh,0ffh,0ffh,0ffh,007h,00fh,000h,000h,000h,080h,080h,080h,080h,080h	; 5050  ................
	defb 000h,0fch,0fch,0fch,0fch,000h,000h,000h,000h,000h,000h,000h,001h,003h,007h,00fh	; 5060  ................
	defb 01fh,03fh,07fh,0feh,0fch,0f8h,0f4h,0eeh,080h,080h,000h,000h,000h,000h,000h,000h	; 5070  .?..............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,01fh,03fh,07fh,0feh,07ch,038h,010h,000h	; 5080  .........?..|8..
	defb 0dfh,0bfh,01fh,00fh,007h,003h,001h,000h,000h,080h,0c0h,0e0h,0c0h,080h,000h,000h	; 5090  ................
	defb 030h,038h,038h,0ffh,0ffh,000h,003h,087h,000h,000h,007h,087h,080h,000h,01fh,09fh	; 50a0  088.............
	defb 00ch,00eh,0ffh,0ffh,061h,0e1h,0ffh,0ffh,000h,018h,0fch,0fch,0c0h,086h,0ffh,0ffh	; 50b0  ....a...........
	defb 0c7h,0c7h,0ceh,06eh,07ch,07ch,038h,038h,080h,000h,003h,003h,003h,003h,003h,003h	; 50c0  ...n||88........
	defb 000h,000h,0ffh,080h,0ffh,0ffh,080h,0ffh,000h,060h,0f8h,038h,0f8h,0f8h,038h,0f8h	; 50d0  .........`.8..8.
	defb 03ch,07ch,06eh,0cfh,087h,087h,003h,000h,000h,01fh,01fh,000h,0c0h,0c0h,080h,000h	; 50e0  <|n.............
	defb 00eh,0ffh,0ffh,00eh,00eh,00fh,00fh,006h,006h,0ffh,0ffh,000h,000h,000h,000h,000h	; 50f0  ................
	defb 01fh,038h,07fh,0f8h,0ffh,008h,00bh,00ah,0bfh,0b8h,0bfh,0b8h,0afh,020h,0fdh,089h	; 5100  .8........... ..
	defb 0bfh,0bfh,0bfh,0bfh,0b8h,0b3h,0a7h,0aeh,0ffh,0ffh,0ffh,0ffh,0e7h,0b2h,01bh,07bh	; 5110  ...............{
	defb 00bh,008h,00bh,0fbh,0fbh,07bh,03bh,012h,0feh,000h,0fdh,005h,0fdh,005h,0fdh,001h	; 5120  .....{;.........
	defb 0aeh,0ach,0b9h,0a3h,0bfh,0bfh,0bfh,03fh,0fbh,0fbh,0f3h,0c7h,01fh,0ffh,0ffh,0ffh	; 5130  .......?........
	defb 000h,000h,007h,007h,007h,007h,007h,007h,000h,000h,09eh,09eh,09eh,09eh,09eh,09eh	; 5140  ................
	defb 000h,000h,001h,001h,001h,001h,000h,000h,000h,000h,0ffh,0ffh,0ffh,0ffh,000h,000h	; 5150  ................
	defb 007h,007h,007h,00fh,00fh,01fh,01fh,03eh,09eh,09eh,09eh,09fh,09fh,00fh,00fh,007h	; 5160  .......>........
	defb 000h,007h,007h,007h,007h,080h,080h,0c0h,000h,0ffh,0ffh,0ffh,0ffh,00fh,00fh,00fh	; 5170  ................
	defb 03eh,07ch,07ch,0f8h,078h,030h,010h,000h,007h,003h,003h,001h,001h,000h,000h,000h	; 5180  >||.x0..........
	defb 0c0h,0e0h,0e0h,0f0h,0e0h,0c0h,080h,000h,01fh,01fh,03eh,07eh,03ch,01ch,008h,000h	; 5190  ..........>~<...
	defb 000h,01fh,030h,06ch,0d4h,0a4h,0bfh,0bfh,000h,0f8h,00ch,09eh,097h,093h,0ffh,0ffh	; 51a0  ..0l............
	defb 000h,000h,001h,003h,003h,001h,000h,000h,040h,0e0h,0c0h,091h,0d9h,0fch,0f8h,0f1h	; 51b0  ........@.......
	defb 0b8h,0b3h,0a7h,0aeh,0aeh,0ach,0b9h,0a3h,0e7h,0b3h,01bh,07bh,0fbh,0fbh,0f3h,0c7h	; 51c0  ...........{....
	defb 001h,005h,007h,007h,007h,006h,000h,004h,0e3h,0c8h,08ch,0feh,0feh,0ech,0e0h,0e8h	; 51d0  ................
	defb 0bfh,0bfh,0a4h,0d4h,06ch,03fh,01fh,000h,01fh,0ffh,093h,097h,09eh,0fch,0f8h,000h	; 51e0  ....l?..........
	defb 006h,006h,006h,00ch,008h,000h,000h,000h,0ech,0eeh,0eeh,0e6h,0e4h,0e1h,0c3h,000h	; 51f0  ................
	defb 000h,000h,03fh,07fh,0ffh,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0ffh,07fh,03fh,000h	; 5200  ..?...........?.
	defb 000h,000h,0e0h,0f0h,0f8h,078h,000h,000h,000h,000h,039h,079h,0f9h,0f3h,0e3h,000h	; 5210  .....x....9y....
	defb 000h,000h,03eh,03eh,07fh,077h,077h,0e3h,0e3h,0e3h,0ffh,0ffh,0c1h,080h,080h,000h	; 5220  ..>>.ww.........
	defb 000h,000h,003h,007h,00fh,00fh,00fh,08fh,087h,083h,0c0h,0cfh,0cfh,0e7h,0e3h,000h	; 5230  ................
	defb 000h,000h,0feh,0ffh,0ffh,007h,000h,0feh,0ffh,0ffh,007h,007h,0ffh,0ffh,0feh,000h	; 5240  ................
	defb 000h,000h,038h,039h,0bbh,0bbh,03bh,03bh,03bh,0bbh,0bbh,0bbh,0bbh,039h,038h,000h	; 5250  ..89..;;;....98.
	defb 000h,000h,0ffh,0ffh,0ffh,0c1h,080h,080h,080h,080h,080h,0c1h,0ffh,0ffh,0ffh,000h	; 5260  ................
	defb 000h,000h,080h,0c0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0c0h,080h,000h	; 5270  ................
	defb 000h,00fh,010h,010h,00fh,000h,010h,00fh,000h,01ch,0a2h,022h,022h,0a2h,0a2h,01ch	; 5280  ...........""...
	defb 000h,0fbh,080h,080h,0f0h,080h,080h,080h,000h,0e8h,088h,089h,089h,089h,089h,086h	; 5290  ................
	defb 000h,027h,028h,028h,02fh,028h,028h,0c8h,000h,09eh,051h,051h,0deh,052h,051h,051h	; 52a0  .'((/((...QQ.RQQ
	defb 000h,07ch,040h,040h,078h,040h,040h,07ch,000h,000h,000h,000h,000h,000h,000h,000h	; 52b0  .|@@x@@|........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,03ch,042h,099h,0a1h,0a1h,099h,042h,03ch	; 52c0  ........<B....B<
	defb 07fh,080h,080h,080h,080h,080h,080h,07fh,003h,004h,008h,008h,00fh,008h,008h,008h	; 52d0  ................
	defb 0c0h,020h,010h,010h,0f0h,010h,010h,010h,07fh,080h,080h,07eh,001h,001h,001h,0feh	; 52e0  . .........~....
	defb 010h,010h,010h,010h,010h,010h,010h,010h,07eh,081h,081h,081h,081h,081h,081h,07eh	; 52f0  ........~......~

; ----------------------------------------------------------------------
; DATOS casillas_dibujos: Los dibujos de las casillas del juego: 0x5300
;   (0x30-0x7F), 0x5380 (0x40-0x6F), 0x5500 (0x70-0x7F) y 0x5580 (0x40-0x7F),
;   que se solapan
;   0x5300..0x5780  (1152 bytes)
DATA_casillas_dibujos:
	defb 000h,06ch,0feh,0beh,0deh,07ch,038h,010h,000h,06ch,0eeh,0c6h,0c6h,0c6h,0eeh,06ch	; 5300  .l...|8..l.....l
	defb 000h,060h,0e0h,0c0h,0c0h,0c0h,0e0h,060h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5310  .`.....`........
	defb 000h,0ffh,07fh,07fh,07fh,07fh,07fh,0ffh,000h,0ffh,03fh,03fh,03fh,03fh,03fh,0ffh	; 5320  ..........?????.
	defb 000h,0ffh,01fh,01fh,01fh,01fh,01fh,0ffh,000h,0ffh,00fh,00fh,00fh,00fh,00fh,0ffh	; 5330  ................
	defb 000h,0ffh,007h,007h,007h,007h,007h,0ffh,000h,0ffh,003h,003h,003h,003h,003h,0ffh	; 5340  ................
	defb 000h,0ffh,001h,001h,001h,001h,001h,0ffh,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5350  ................
	defb 003h,00fh,01eh,03eh,03eh,076h,068h,06fh,0c0h,0f0h,0f8h,0fch,07ch,06eh,016h,0f6h	; 5360  ...>>vho....|n..
	defb 061h,06bh,06fh,06eh,067h,073h,071h,060h,086h,0d6h,076h,076h,0e6h,0ceh,08eh,006h	; 5370  akongsq`..vv....
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0fdh,0fdh,0fch,0feh,0feh,0feh,0ffh	; 5380  ................
	defb 01ch,0feh,0ffh,0ffh,07fh,07fh,03fh,00fh,07fh,03fh,01fh,09fh,0dfh,0cfh,0cfh,083h	; 5390  ......?..?......
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0feh,0fch,0ffh,0ffh,0ffh,0ffh,01fh,003h,000h,0e0h	; 53a0  ................
	defb 0e3h,0e3h,0e1h,0e1h,0e1h,0c4h,00ch,00ch,0ffh,0ffh,0ffh,0ffh,07fh,00fh,000h,0e0h	; 53b0  ................
	defb 0ffh,0ffh,0ffh,0feh,0fch,0fch,030h,000h,000h,03ch,07eh,06eh,000h,01eh,03fh,07fh	; 53c0  ......0..<~n..?.
	defb 000h,03fh,07fh,07fh,07fh,07fh,07fh,03fh,001h,003h,0f1h,0f8h,0feh,0feh,0feh,0fch	; 53d0  .?.....?........
	defb 0e3h,0c7h,08fh,01fh,01fh,01fh,01fh,03fh,0c0h,0f0h,0fch,0fch,0fch,0feh,0ffh,0ffh	; 53e0  .......?........
	defb 07fh,03fh,03fh,003h,001h,008h,01eh,09fh,0e7h,0c7h,0c7h,08fh,00fh,00fh,00fh,087h	; 53f0  .??.............
	defb 0c3h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01fh,007h,001h,0f8h,0feh,0ffh,0ffh,0ffh	; 5400  ................
	defb 0fch,0fch,0f8h,071h,003h,087h,0c7h,0e7h,03fh,007h,001h,0f8h,0feh,0ffh,0ffh,0ffh	; 5410  ...q....?.......
	defb 0dfh,0c7h,0e7h,0e3h,0f0h,0fch,0feh,0ffh,0c7h,0f3h,0f1h,0f9h,0f9h,0e1h,0e1h,0c3h	; 5420  ................
	defb 0cfh,08fh,09fh,01fh,01fh,00fh,007h,000h,0cfh,0cfh,00fh,007h,0f1h,0f8h,0feh,0ffh	; 5430  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,03fh,01fh,08fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h	; 5440  .....?..........
	defb 080h,083h,08fh,09fh,09fh,0bfh,03fh,03fh,01fh,0cfh,0e7h,0f3h,0f3h,0f1h,0f8h,0fch	; 5450  ......??........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00eh,0ffh,0ffh,0feh,0fch,0f1h,0e3h,087h,00fh	; 5460  ................
	defb 0c7h,0c3h,0e3h,0f3h,0f0h,0f0h,0e0h,0e0h,0feh,0fch,0fch,0f8h,060h,00fh,00fh,01fh	; 5470  ............`...
	defb 03fh,07fh,07fh,07fh,03fh,080h,0e0h,0f8h,0bfh,09fh,0cfh,0cfh,08fh,007h,000h,000h	; 5480  ?...?...........
	defb 0fch,0fch,0fch,0fch,0f8h,0f3h,003h,01fh,000h,030h,07eh,07fh,0ffh,0ffh,0ffh,0ffh	; 5490  .........0~.....
	defb 00fh,01fh,01fh,01fh,09fh,08fh,08fh,007h,0ffh,0ffh,03fh,038h,000h,081h,0c1h,0e1h	; 54a0  ..........?8....
	defb 0e0h,0e1h,08fh,01fh,0ffh,0ffh,0ffh,0ffh,0fch,0feh,0feh,09eh,000h,0c0h,0ffh,0ffh	; 54b0  ................
	defb 03fh,07fh,07fh,01fh,007h,000h,0f0h,0f8h,0f8h,0f0h,0c3h,08fh,01fh,03fh,07fh,07fh	; 54c0  ?............?..
	defb 007h,003h,080h,0f0h,0fch,0feh,0ffh,0ffh,0f0h,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 54d0  ................
	defb 07fh,03fh,09fh,09fh,0cfh,0cfh,0e7h,0f0h,0ffh,0ffh,0ffh,0ffh,0feh,0fch,0f8h,000h	; 54e0  .?..............
	defb 0fch,0feh,0feh,0feh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,07fh,03fh,03fh,01fh,08fh,0c7h	; 54f0  ...........??...
	defb 0dfh,0fdh,0bfh,0ebh,0d9h,095h,020h,000h,0e0h,060h,01dh,044h,020h,0ech,0deh,0ffh	; 5500  ...... ..`.D ...
	defb 0efh,0abh,0c9h,08ah,000h,03fh,07fh,0ffh,0e6h,092h,002h,000h,0f8h,0fch,0feh,0feh	; 5510  .....?..........
	defb 0ddh,085h,020h,000h,0f7h,0fbh,0f9h,0f7h,0eah,0f0h,020h,000h,0ffh,0ffh,0ffh,0ffh	; 5520  .. ....... .....
	defb 0ffh,0efh,0ffh,0ffh,0dfh,0ffh,0efh,0ffh,0ffh,0ffh,0fbh,0dfh,0f7h,0bfh,0fdh,0ffh	; 5530  ................
	defb 0ffh,0ffh,0fdh,0ffh,0dfh,0bfh,0ffh,0ffh,0ffh,0ffh,0ffh,0f7h,0ffh,0bfh,0ffh,0ffh	; 5540  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5550  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5560  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5570  ................
	defb 01fh,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5580  ................
	defb 07fh,07fh,03fh,01fh,000h,03fh,07fh,0ffh,0ffh,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh	; 5590  ..?..?..........
	defb 0efh,0efh,0cfh,08fh,00fh,00fh,00fh,00fh,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0fch	; 55a0  ................
	defb 0fch,0f0h,000h,0f0h,0f8h,0fch,0fch,0fch,00fh,007h,003h,000h,03ch,07eh,07eh,07eh	; 55b0  ............<~~~
	defb 0fch,0f8h,0f0h,000h,03fh,07fh,0ffh,0ffh,07fh,03fh,000h,000h,0ffh,0ffh,0ffh,0ffh	; 55c0  ....?....?......
	defb 0ffh,0ffh,000h,000h,0fch,0feh,0ffh,0ffh,0ffh,0ffh,000h,00fh,01fh,03fh,03fh,03fh	; 55d0  .............???
	defb 0fch,0fch,0fch,0f8h,0f0h,000h,03fh,07fh,0ffh,0ffh,07fh,03fh,000h,000h,0ffh,0ffh	; 55e0  ......?....?....
	defb 0ffh,0ffh,0feh,0fch,000h,000h,0ffh,0ffh,07eh,07eh,07eh,07eh,03ch,000h,0f8h,0fch	; 55f0  ........~~~~<...
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh	; 5600  ................
	defb 03fh,03fh,03fh,01fh,00fh,000h,07ch,07ch,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5610  ???...||........
	defb 03fh,000h,03fh,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,0fch,0feh,0ffh,0ffh,0ffh,0ffh	; 5620  ?.?.............
	defb 0ffh,0ffh,0ffh,0ffh,000h,0fch,0feh,0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5630  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,01fh,03fh,07fh,07fh,07fh,07fh	; 5640  ...........?....
	defb 000h,000h,0f0h,0f8h,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,03fh	; 5650  ...............?
	defb 0fch,000h,000h,03fh,07fh,07fh,07fh,03fh,0feh,0feh,0feh,0feh,0feh,0feh,0fch,0f8h	; 5660  ...?...?........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,07fh,07fh,07fh,07fh,07fh,03fh,01fh	; 5670  ..............?.
	defb 0fch,0fch,0fch,0fch,0fch,0fch,0f8h,0f0h,000h,0fch,0feh,0ffh,0ffh,0ffh,0ffh,0feh	; 5680  ................
	defb 000h,000h,01fh,03fh,07fh,07fh,07fh,07fh,000h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 5690  ...?............
	defb 000h,00eh,08eh,0ceh,0eeh,0eeh,0eeh,0eeh,07ch,07ch,000h,0fch,0feh,0feh,0feh,0fch	; 56a0  ........||......
	defb 000h,01fh,03fh,07fh,07fh,07fh,07fh,03fh,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 56b0  ..?....?........
	defb 0fch,000h,000h,0f8h,0fch,0feh,0feh,0feh,07fh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; 56c0  ................
	defb 0eeh,0eeh,0e0h,0e0h,0e3h,0e7h,0efh,0efh,07fh,03fh,000h,000h,0f0h,0f8h,0fch,0fch	; 56d0  .........?......
	defb 0feh,0fch,000h,03fh,07fh,0ffh,0ffh,0ffh,001h,0fch,0feh,0ffh,0ffh,0ffh,0ffh,0ffh	; 56e0  ...?............
	defb 0ffh,0ffh,0ffh,0ffh,0c7h,0ffh,0e1h,003h,0ffh,0bfh,0ffh,0ffh,0edh,0ffh,0bfh,0ffh	; 56f0  ................
	defb 0fch,0fch,0fch,0feh,0feh,0ffh,0ffh,0ffh,0f5h,082h,0e0h,0f8h,0f0h,0ffh,03fh,07fh	; 5700  ..............?.
	defb 0ffh,0fch,0feh,0ffh,0ffh,0feh,0feh,0feh,0a2h,05fh,0ffh,007h,07fh,07fh,07fh,03fh	; 5710  ........._.....?
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f7h,0d3h,0c2h,0cfh,0c7h,081h,000h,000h	; 5720  ................
	defb 0c3h,0d1h,0f3h,0e1h,0c0h,000h,000h,000h,07bh,03eh,0feh,01ch,001h,03fh,000h,003h	; 5730  ........{>...?..
	defb 003h,00fh,00fh,00fh,01fh,03fh,03fh,07fh,07fh,03fh,01fh,00fh,00fh,01fh,03fh,07fh	; 5740  .....??..?....?.
	defb 000h,0ffh,062h,06dh,07ch,0bfh,07fh,0ffh,000h,00fh,00fh,005h,023h,087h,00fh,06fh	; 5750  ..bm|.......#..o
	defb 000h,0e0h,0f0h,002h,020h,077h,07fh,03eh,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0c0h,000h	; 5760  .... w.>........
	defb 0feh,0fch,080h,0f0h,0f8h,0f8h,0f8h,0f0h,004h,021h,0b3h,03ah,01fh,06fh,0ffh,0ffh	; 5770  .........!.:.o..

; ----------------------------------------------------------------------
; DATOS sobra_5780: 128 bytes (8 de dibujo y ceros) que nadie lee
;   0x5780..0x5800  (128 bytes)
DATA_sobra_5780:
	defb 0ffh,0f7h,0f3h,0f1h,0f5h,0d8h,082h,0e7h,000h,000h,000h,000h,000h,000h,000h,000h	; 5780  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5790  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57a0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57b0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57c0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57d0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57e0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 57f0  ................

; ----------------------------------------------------------------------
; DATOS titulo_colores: Los colores de las casillas 0x30-0x8F del titulo
;   0x5800..0x5b00  (768 bytes)
DATA_titulo_colores:
	defb 0b0h,0bfh,0b0h,0b0h,0bfh,0f0h,0bfh,0f0h,0bfh,0b0h,0b0h,0b0h,0b0h,0f0h,0b0h,0f0h	; 5800  ................
	defb 0bfh,0bfh,0b0h,0b0h,0b0h,0f0h,0bfh,0ffh,0b0h,0b0h,0b0h,0bfh,0bfh,0f0h,0f0h,0f0h	; 5810  ................
	defb 0b0h,0f0h,0a0h,0afh,0a0h,0a0h,0afh,0a0h,0b0h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h	; 5820  ................
	defb 0b0h,0f0h,0a0h,0a0h,0a0h,0afh,0afh,0f0h,0b0h,0f0h,0a0h,0afh,0afh,0a0h,0a0h,0a0h	; 5830  ................
	defb 070h,070h,070h,0f0h,050h,050h,0f0h,0f0h,0f0h,0f0h,050h,050h,050h,050h,0f0h,0f0h	; 5840  ppp.PP....PPPP..
	defb 0f0h,0f0h,05fh,05fh,05fh,05fh,050h,050h,0f0h,0f0h,0f0h,050h,050h,050h,050h,050h	; 5850  ..____PP...PPPPP
	defb 0f0h,050h,050h,050h,050h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,050h,050h,050h,050h	; 5860  .PPPP.......PPPP
	defb 050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5870  PPPPPPPPPP......
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,050h,050h,050h,050h,050h,050h,050h,0f0h	; 5880  ........PPPPPPP.
	defb 050h,050h,050h,050h,050h,050h,050h,0f0h,0f0h,050h,050h,050h,050h,050h,0f0h,0f0h	; 5890  PPPPPPP..PPPPP..
	defb 050h,050h,050h,05fh,05fh,0f0h,050h,050h,0f0h,0f0h,050h,050h,050h,0f0h,050h,050h	; 58a0  PPP__.PP..PPP.PP
	defb 050h,050h,05fh,05fh,050h,050h,05fh,05fh,0f0h,050h,050h,050h,050h,050h,05fh,05fh	; 58b0  PP__PP__.PPPPP__
	defb 050h,050h,050h,050h,050h,050h,050h,050h,050h,0f0h,050h,050h,050h,050h,050h,050h	; 58c0  PPPPPPPPP.PPPPPP
	defb 0f0h,0f0h,05fh,050h,05fh,05fh,050h,05fh,0f0h,050h,050h,050h,050h,050h,050h,050h	; 58d0  .._P__P_.PPPPPPP
	defb 050h,050h,050h,050h,050h,050h,050h,0f0h,0f0h,050h,050h,0f0h,050h,050h,050h,0f0h	; 58e0  PPPPPPP..PP.PPP.
	defb 050h,05fh,05fh,050h,050h,050h,050h,050h,050h,05fh,05fh,0f0h,0f0h,0f0h,0f0h,0f0h	; 58f0  P__PPPPPP__.....
	defb 0b0h,0b0h,0b0h,0b0h,0bfh,0f0h,0b0h,0f0h,0b0h,0b0h,0b0h,0b0h,0b0h,0f0h,0b0h,0f0h	; 5900  ................
	defb 0b0h,0b0h,0b0h,0b0h,0b0h,0f0h,0b0h,0f0h,0bfh,0bfh,0bfh,0bfh,0b0h,0f0h,0b0h,0f0h	; 5910  ................
	defb 0b0h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0b0h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h	; 5920  ................
	defb 0b0h,0f0h,0a0h,0a0h,0a0h,0a0h,0a0h,0a0h,0b0h,0f0h,0a0h,0a0h,0a0h,0afh,0afh,0afh	; 5930  ................
	defb 0f0h,0f0h,050h,050h,050h,050h,050h,050h,0f0h,0f0h,050h,050h,050h,050h,050h,050h	; 5940  ..PPPPPP..PPPPPP
	defb 0f0h,0f0h,050h,050h,050h,050h,0f0h,0f0h,0f0h,0f0h,05fh,05fh,05fh,05fh,0f0h,0f0h	; 5950  ..PPPP....____..
	defb 050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h	; 5960  PPPPPPPPPPPPPPPP
	defb 0f0h,050h,050h,050h,050h,050h,050h,050h,0f0h,05fh,05fh,05fh,05fh,050h,050h,050h	; 5970  .PPPPPPP.____PPP
	defb 050h,050h,050h,050h,050h,050h,050h,0f0h,050h,050h,050h,050h,050h,0f0h,0f0h,0f0h	; 5980  PPPPPPP.PPPPP...
	defb 050h,050h,050h,050h,050h,050h,050h,0f0h,050h,050h,050h,050h,050h,050h,050h,0f0h	; 5990  PPPPPPP.PPPPPPP.
	defb 0f0h,060h,060h,060h,060h,060h,090h,060h,0f0h,060h,060h,060h,060h,060h,09fh,06fh	; 59a0  .`````.`.`````.o
	defb 0f0h,0f0h,050h,050h,050h,050h,0f0h,0f0h,050h,050h,050h,050h,050h,050h,050h,050h	; 59b0  ..PPPP..PPPPPPPP
	defb 090h,060h,090h,060h,060h,060h,060h,090h,090h,060h,090h,060h,060h,060h,060h,090h	; 59c0  .`.````..`.````.
	defb 050h,050h,050h,050h,050h,050h,0f0h,050h,050h,050h,050h,050h,050h,050h,050h,050h	; 59d0  PPPPPP.PPPPPPPPP
	defb 060h,090h,060h,060h,060h,060h,060h,0f0h,060h,09fh,060h,060h,060h,060h,060h,0f0h	; 59e0  `.`````.`.`````.
	defb 050h,050h,050h,050h,050h,0f0h,0f0h,0f0h,050h,050h,050h,050h,050h,050h,050h,0f0h	; 59f0  PPPPP...PPPPPPP.
	defb 0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h	; 5a00  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a10  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h	; 5a20  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a30  ................
	defb 0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h	; 5a40  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a50  ................
	defb 0f0h,0f0h,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0ffh,0f0h	; 5a60  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5a90  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5aa0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5ab0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5ac0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5ad0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5ae0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5af0  ................

; ----------------------------------------------------------------------
; DATOS casillas_colores: Sus colores: 0x5B00, 0x5B80, 0x5D00 y 0x5D80; 0x5B80
;   tambien son los dibujos de los sprites de la pausa (0x100 bytes)
;   0x5b00..0x5f80  (1152 bytes)
DATA_casillas_colores:
	defb 0f0h,090h,090h,090h,090h,090h,090h,090h,0f0h,030h,030h,030h,030h,030h,030h,030h	; 5b00  .........0000000
	defb 0f0h,030h,030h,030h,030h,030h,030h,030h,0f0h,0ffh,0bfh,0bfh,0bfh,0bfh,0bfh,0ffh	; 5b10  .0000000........
	defb 0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh,0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh	; 5b20  ................
	defb 0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh,0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh	; 5b30  ................
	defb 0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh,0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh	; 5b40  ................
	defb 0f0h,0ffh,0b4h,0b4h,0b4h,0b4h,0b4h,0ffh,0f0h,0ffh,04fh,04fh,04fh,04fh,04fh,0ffh	; 5b50  ..........OOOOO.
	defb 0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h	; 5b60  ................
	defb 0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h,0b0h,0f0h	; 5b70  ................
	defb 000h,007h,00fh,01fh,01fh,01bh,01bh,04dh,066h,040h,006h,007h,022h,03ah,000h,000h	; 5b80  .......Mf@..":..
	defb 000h,0e0h,0f0h,0b8h,0d8h,0d8h,0f8h,0f2h,066h,002h,060h,0e0h,044h,05ch,000h,000h	; 5b90  ........f.`.D\..
	defb 000h,000h,000h,000h,000h,004h,004h,002h,018h,03fh,019h,018h,00dh,005h,00fh,006h	; 5ba0  .........?......
	defb 000h,000h,000h,000h,000h,000h,000h,000h,018h,0fch,098h,018h,0b0h,0a0h,0f0h,060h	; 5bb0  ...............`
	defb 003h,003h,002h,002h,002h,002h,002h,002h,03dh,07dh,0fdh,0cfh,06fh,03fh,000h,000h	; 5bc0  ........=}..o?..
	defb 000h,0c0h,070h,010h,018h,008h,00ch,004h,004h,086h,0c2h,0c2h,083h,001h,001h,001h	; 5bd0  ..p.............
	defb 000h,003h,00eh,008h,018h,010h,030h,020h,020h,061h,043h,043h,0c1h,080h,080h,080h	; 5be0  ......0  aCC....
	defb 0c0h,0c0h,040h,040h,040h,040h,040h,040h,0bch,0beh,0bfh,0f3h,0f6h,0fch,000h,000h	; 5bf0  ..@@@@@@........
	defb 060h,070h,0dch,07ch,078h,03eh,00ch,008h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c00  `p.|x>..........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c10  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c20  ................
	defb 006h,00eh,03bh,03eh,01eh,07ch,030h,010h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c30  ..;>.|0.........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c40  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c50  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c60  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5c70  ................
	defb 000h,07eh,063h,063h,063h,066h,078h,060h,000h,03eh,073h,073h,073h,06bh,067h,03eh	; 5c80  .~cccfx`.>ssskg>
	defb 000h,07eh,063h,063h,067h,07ch,067h,063h,000h,03eh,073h,070h,03eh,007h,067h,03eh	; 5c90  .~ccg|gc.>sp>.g>
	defb 000h,07fh,018h,018h,018h,01ch,01ch,01ch,000h,063h,063h,063h,073h,073h,073h,03eh	; 5ca0  .........cccsss>
	defb 000h,077h,063h,063h,077h,036h,036h,01ch,000h,06bh,06bh,06bh,06bh,06fh,06fh,07eh	; 5cb0  .wccw66..kkkkoo~
	defb 000h,063h,027h,03eh,01ch,038h,07ch,067h,000h,043h,026h,01ch,018h,018h,01ch,01ch	; 5cc0  .c'>.8|g.C&.....
	defb 000h,07fh,063h,004h,018h,018h,023h,07fh,000h,000h,000h,000h,000h,000h,000h,000h	; 5cd0  ..c...#.........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5ce0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 5cf0  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0ech,0ech,0c0h,0c0h,0e0h,0e0h,0e0h,0efh	; 5d00  ................
	defb 0c0h,0c0h,0c0h,0c0h,0f0h,0e0h,0e0h,0efh,0c0h,0c0h,0c0h,0f0h,0e0h,0e0h,0e0h,0e0h	; 5d10  ................
	defb 0c0h,0c0h,0c0h,0f0h,0e0h,0e0h,0e0h,0e0h,0c0h,0c0h,0c0h,0f0h,0efh,0efh,0efh,0efh	; 5d20  ................
	defb 0cfh,0cah,0cfh,0cfh,0c3h,0cfh,0c3h,0cfh,0cfh,0cfh,0cah,0c3h,0c3h,0c3h,0cah,0cfh	; 5d30  ................
	defb 0cfh,0cfh,0cah,0cfh,0cah,0c3h,0cfh,0cfh,0cfh,0cfh,0cfh,0c3h,0cfh,0c3h,0cfh,0cfh	; 5d40  ................
	defb 0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh	; 5d50  ................
	defb 0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh	; 5d60  ................
	defb 0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh,0efh	; 5d70  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5d80  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5d90  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5da0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5db0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5dc0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5dd0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5de0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5df0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e00  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e10  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e20  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e30  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e40  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e50  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e60  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e70  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e80  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5e90  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5ea0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5eb0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5ec0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5ed0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5ee0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 5ef0  ................
	defb 0feh,0feh,0feh,0feh,0feh,0ffh,0ffh,0ffh,0e7h,0feh,0feh,0feh,0feh,0efh,0feh,0feh	; 5f00  ................
	defb 0efh,0feh,0feh,0ffh,0ffh,0feh,0feh,0feh,0feh,0e7h,0efh,0feh,0feh,0feh,0feh,0feh	; 5f10  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0feh,0feh,0e0h,0e0h,0e0h,0f0h,0f0h	; 5f20  ................
	defb 0feh,0feh,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h,0feh,0feh,0feh,0feh,0feh,0e0h,0f0h,0e0h	; 5f30  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 5f40  ................
	defb 0f0h,0efh,0feh,0feh,0feh,0feh,0feh,0ffh,0f0h,0e0h,0e0h,0feh,0feh,0feh,0feh,0feh	; 5f50  ................
	defb 0f0h,0e0h,0e0h,0feh,0feh,0feh,0feh,0feh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h	; 5f60  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0feh,0feh,0feh,0feh,0feh,0feh,0ffh,0ffh	; 5f70  ................

; ----------------------------------------------------------------------
; DATOS sobra_5f80: 128 bytes (0xFF, 0xFE... 0xF0) que nadie lee
;   0x5f80..0x6000  (128 bytes)
DATA_sobra_5f80:
	defb 0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5f80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5f90  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5fa0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5fb0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5fc0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5fd0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5fe0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 5ff0  ................

; ----------------------------------------------------------------------
; DATOS casillas_juegos: Los otros juegos de casillas 0x80-0xFF (0xE1BE):
;   dibujos en 0x6000, 0x6400, 0x7000 y 0x7400 y colores en 0x6800, 0x6C00,
;   0x7800 y 0x7C00; las letras (0x7D00, 0x180 bytes) estan dentro de los
;   ultimos colores: los mismos bytes sirven para las dos cosas
;   0x6000..0x8000  (8192 bytes)
DATA_casillas_juegos:
	defb 0ffh,0ffh,0ffh,0ffh,07fh,03fh,01fh,007h,0ffh,0ffh,0ffh,0ffh,0feh,0fch,0f8h,0e0h	; 6000  .....?..........
	defb 0ffh,0efh,0ffh,0bfh,0ffh,0f8h,0f0h,0f0h,0ffh,0efh,0ffh,0ffh,0fdh,03fh,00fh,00fh	; 6010  .............?..
	defb 0feh,0ffh,0ffh,0ffh,0ffh,0ffh,07fh,0ffh,0fch,0dch,0f8h,0fch,0fch,0ech,0fch,0fch	; 6020  ................
	defb 00bh,003h,003h,00bh,003h,003h,003h,003h,0ffh,03fh,01fh,00fh,00fh,00fh,007h,003h	; 6030  .........?......
	defb 0ffh,0ffh,0fdh,0ffh,000h,000h,000h,0c0h,074h,0fch,0b8h,0ffh,001h,000h,000h,000h	; 6040  ........t.......
	defb 003h,007h,00fh,003h,001h,0ffh,07fh,07fh,00fh,00fh,00fh,00fh,00fh,00fh,00fh,00fh	; 6050  ................
	defb 0e0h,0f0h,080h,0c8h,0cch,046h,0cfh,0c7h,000h,000h,0ffh,0ffh,0ffh,0f8h,0ech,0fch	; 6060  .....F..........
	defb 03fh,03fh,0f7h,0f7h,0f7h,0ffh,0ffh,0f7h,0ffh,0efh,0ffh,0fdh,0ffh,0ffh,000h,000h	; 6070  ??..............
	defb 0c7h,0c7h,0c7h,0c3h,0c7h,087h,0c7h,0c3h,078h,0fch,0fch,0ech,0fch,0fch,0fch,0f8h	; 6080  ........x.......
	defb 0ffh,001h,0f7h,0f7h,0f7h,0ffh,001h,0f7h,000h,040h,000h,000h,040h,002h,020h,080h	; 6090  .........@..@. .
	defb 0c7h,0c7h,047h,0c7h,0c3h,0c6h,0c7h,0c7h,07ch,0ech,0fch,0fch,0fch,07ch,0fch,0f4h	; 60a0  ..G.....|....|..
	defb 0f7h,0ffh,0f7h,0ffh,0f7h,0ffh,0f7h,0ffh,080h,020h,000h,040h,000h,008h,000h,000h	; 60b0  ......... .@....
	defb 0c3h,0c3h,082h,0c3h,0c3h,0c1h,0c3h,0c3h,0fch,0fch,0fch,0feh,0bah,0feh,0feh,0feh	; 60c0  ................
	defb 0ffh,0ffh,0f7h,0f7h,0ffh,001h,0f7h,0ffh,0b7h,0ffh,0fch,0ffh,003h,0ffh,003h,0ffh	; 60d0  ................
	defb 0c3h,0c3h,0c3h,0c1h,0c3h,0c3h,0c2h,0c3h,0f6h,07ch,0fah,0feh,0feh,0deh,0fch,0f6h	; 60e0  .........|......
	defb 0f7h,0f7h,001h,001h,0f7h,0ffh,0f7h,0f7h,00fh,00fh,00fh,00fh,00fh,00fh,00fh,00fh	; 60f0  ................
	defb 050h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0dfh,0ffh,0fch,0f8h,0f0h,0f0h,0f0h,0e0h,0c0h	; 6100  P...............
	defb 012h,0ffh,0ffh,07fh,01fh,03fh,037h,03fh,0c0h,0ffh,0ffh,0fbh,0ffh,0bfh,0ffh,0ffh	; 6110  .....?7?........
	defb 032h,0ffh,0ffh,0feh,078h,0dch,0fch,0fch,0c0h,0c0h,0d0h,0c0h,0c0h,0c0h,0d0h,0c0h	; 6120  2...x...........
	defb 05fh,037h,03fh,01bh,07fh,02fh,01fh,03bh,0fdh,0ffh,07fh,0ffh,0efh,0ffh,0ffh,0ffh	; 6130  _7?../.;........
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0c0h,0e0h,0f0h,0c0h,080h,0ffh,0feh,0feh	; 6140  ................
	defb 01fh,07bh,01fh,0ffh,080h,000h,000h,000h,07bh,0ffh,0ffh,0ffh,000h,000h,000h,003h	; 6150  .{......{.......
	defb 0ffh,0ffh,0dfh,0ffh,0ffh,0efh,000h,000h,0fch,0fch,0efh,0ffh,0ffh,0efh,0efh,0ffh	; 6160  ................
	defb 000h,000h,0ffh,0ffh,0ffh,015h,03fh,037h,007h,00fh,001h,013h,033h,0e3h,0f3h,063h	; 6170  ......?7....3..c
	defb 000h,000h,000h,010h,002h,000h,004h,001h,0efh,0ffh,080h,080h,080h,0ffh,0efh,0ffh	; 6180  ................
	defb 03fh,03fh,02fh,03fh,03dh,03fh,03fh,03fh,0e3h,0e3h,0e3h,0c3h,0e3h,0e3h,0e3h,0e3h	; 6190  ??/?=???........
	defb 001h,004h,040h,002h,000h,000h,002h,000h,0ffh,0ffh,080h,0efh,0ffh,080h,0ffh,080h	; 61a0  ..@.............
	defb 01fh,03fh,03fh,03fh,03dh,03fh,03fh,03fh,0c3h,0e3h,0e3h,0e3h,0e3h,0e3h,0e3h,0e3h	; 61b0  .???=???........
	defb 0efh,0ffh,03fh,0ffh,0f0h,0ffh,0e0h,0ffh,0efh,0efh,0efh,0ffh,0ffh,0efh,0ffh,0ffh	; 61c0  ..?.............
	defb 03fh,03fh,07fh,07fh,07fh,05fh,07fh,03fh,0c3h,0c3h,0c1h,0c3h,043h,0c3h,083h,0c3h	; 61d0  ??..._.?....C...
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0efh,0efh,0ffh,0efh,0ffh,0efh,080h,0efh	; 61e0  ................
	defb 07fh,05fh,07fh,07fh,07fh,07fh,05fh,07fh,0c3h,0c3h,083h,0c3h,0c3h,0c3h,003h,0c3h	; 61f0  ._...._.........
	defb 0c3h,0c3h,0c3h,0c7h,00fh,01fh,0fbh,0ffh,0feh,0fch,0deh,0fah,0feh,0fch,0f6h,0feh	; 6200  ................
	defb 0f7h,0ffh,0f7h,0ffh,0f7h,0ffh,0ffh,0ffh,0ffh,010h,0ffh,0ebh,0dfh,004h,0ffh,0ffh	; 6210  ................
	defb 0ffh,0feh,0dfh,0ffh,0ffh,0ffh,000h,0fbh,0feh,0ffh,0feh,0feh,0f6h,07eh,00fh,06fh	; 6220  .............~.o
	defb 001h,0f7h,001h,001h,0f7h,0f7h,0ffh,001h,0ffh,0ffh,008h,0ffh,0ffh,020h,0ffh,0ffh	; 6230  ............. ..
	defb 0ffh,0ffh,0feh,0ffh,0ffh,0ffh,001h,00fh,0feh,0feh,0feh,0feh,0eeh,0feh,0feh,0fch	; 6240  ................
	defb 001h,003h,00fh,00fh,00fh,00fh,00fh,00fh,0ffh,0ffh,0ffh,004h,0ffh,0ffh,001h,0ffh	; 6250  ................
	defb 0ffh,0ffh,0ffh,0ffh,0efh,0ffh,0ffh,0ffh,0feh,0fch,0feh,0feh,0feh,0feh,0deh,0feh	; 6260  ................
	defb 00fh,00fh,00fh,01fh,01fh,01fh,01fh,03fh,0ffh,0fdh,0ffh,010h,0ffh,040h,0ffh,0ffh	; 6270  .......?.....@..
	defb 0ffh,0ffh,0ffh,0efh,0ffh,0ffh,0ffh,0ffh,0feh,0deh,0fch,0feh,0feh,0fch,0f8h,060h	; 6280  ...............`
	defb 03fh,07fh,07fh,0ffh,00fh,007h,001h,003h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6290  ?...............
	defb 000h,000h,000h,000h,0adh,0bah,06fh,0ffh,00eh,01dh,016h,0b0h,08bh,09dh,01fh,03ah	; 62a0  ......o........:
	defb 077h,057h,037h,07bh,02bh,053h,059h,051h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 62b0  wW7{+SYQ........
	defb 0dfh,0ffh,0ffh,0ffh,0feh,0fch,0f9h,0f3h,03fh,03ah,01fh,05fh,00fh,07ah,0fch,0feh	; 62c0  ........?:._.z..
	defb 0d5h,017h,05ah,047h,099h,02fh,052h,0b9h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 62d0  ..ZG./R.........
	defb 003h,047h,0f5h,0fdh,0efh,06fh,0abh,0f2h,0feh,0feh,0fch,0feh,0fah,0ffh,0deh,0c9h	; 62e0  .G...o..........
	defb 0ebh,0fbh,003h,001h,007h,00fh,03fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 62f0  ......?.........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0efh,0ffh,0ffh,0efh,0efh,0ffh,0ffh	; 6300  ................
	defb 0efh,0ffh,0ffh,07fh,0f7h,0ffh,0ffh,0ffh,0c3h,0c3h,043h,0e3h,0f0h,0f8h,0ffh,0ffh	; 6310  ..........C.....
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0efh,0efh,080h,0efh,0ffh,080h,0ffh,090h	; 6320  ................
	defb 07fh,0dfh,0fbh,0ffh,0ffh,0d8h,0f0h,0f6h,0ffh,0ffh,0ffh,0ffh,0ffh,0efh,000h,0fch	; 6330  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,080h,0c0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 6340  ................
	defb 07fh,07fh,07fh,03fh,07fh,07fh,07fh,03fh,0ffh,0ffh,03fh,0ffh,0ffh,0ffh,080h,0f0h	; 6350  ...?...?..?.....
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,080h,0f0h,0f0h,0f0h,0f8h,0f8h,007h,003h,003h	; 6360  ................
	defb 07fh,07dh,07fh,037h,07fh,07fh,07fh,07fh,0efh,0ffh,0ffh,0ffh,0ffh,07fh,0ffh,0ffh	; 6370  .}.7............
	defb 008h,000h,010h,000h,000h,000h,000h,080h,003h,003h,001h,000h,00ch,03ch,03ch,07eh	; 6380  .............<<~
	defb 07fh,07fh,02fh,07fh,07fh,03fh,01fh,007h,0ffh,0ffh,0ffh,0fbh,0ffh,0ffh,0ffh,09bh	; 6390  ../..?..........
	defb 080h,080h,080h,088h,0c0h,0e0h,0f0h,0f8h,0d6h,027h,089h,057h,0ddh,0d3h,09fh,0d6h	; 63a0  .........'.W....
	defb 000h,000h,0c0h,000h,020h,068h,058h,06ch,000h,000h,000h,000h,076h,05fh,0adh,057h	; 63b0  .... hXl....v_.W
	defb 0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f8h,09ch,0d5h,0c1h,059h,0cbh,09bh,0b8h,0ach	; 63c0  ...........Y....
	defb 0b6h,0ech,0feh,0f8h,0fbh,0f3h,0f3h,023h,0fdh,05fh,03fh,01fh,0dfh,0c7h,0e3h,0f1h	; 63d0  .......#._?.....
	defb 0fah,0f8h,0f8h,0f8h,0fch,0fch,0fch,0ffh,0b5h,099h,0f3h,07fh,03fh,01fh,00fh,003h	; 63e0  ............?...
	defb 097h,0f7h,0f7h,0f7h,0f3h,07dh,0b8h,0aah,0f8h,0f9h,0fbh,0f9h,0fbh,0b3h,0f7h,00eh	; 63f0  .....}..........
	defb 0efh,0efh,0fch,007h,0f8h,0f0h,0f0h,01fh,0e0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6400  ................
	defb 0ffh,0ffh,0ffh,0fbh,0d9h,0e4h,0fch,0f4h,007h,0ffh,0feh,0ffh,0feh,0fbh,07eh,0efh	; 6410  ..............~.
	defb 0efh,0efh,03fh,0e0h,01fh,00fh,00fh,0f0h,0e0h,0c0h,0c0h,03fh,080h,0f3h,0f1h,0e1h	; 6420  ..?........?....
	defb 0ffh,0feh,0ffh,0fbh,0fch,0ffh,0c1h,03fh,03ch,0f4h,07ch,0b8h,000h,0c1h,020h,0ffh	; 6430  .......?<.|... .
	defb 0edh,0edh,0edh,0abh,05ah,0b6h,002h,0feh,007h,0bch,07ch,06ch,0ceh,0cbh,08bh,08bh	; 6440  ....Z.....|l....
	defb 0feh,0fch,0fch,007h,0f8h,0f0h,0f0h,01fh,0e1h,0c1h,0c1h,09dh,0b7h,02dh,029h,033h	; 6450  .............-)3
	defb 0ffh,0c0h,0beh,0e9h,0c0h,0e0h,0f8h,0feh,0c0h,0e0h,03ch,03ch,03ch,03ch,03ch,07ch	; 6460  ..........<<<<<|
	defb 0ffh,003h,07dh,097h,003h,007h,01fh,07fh,00bh,08ah,081h,0b9h,0edh,0b4h,094h,0cch	; 6470  ..}.............
	defb 07fh,03fh,03fh,0e0h,01fh,00fh,00fh,0f0h,0e0h,0c0h,0c0h,03fh,080h,080h,0feh,0fch	; 6480  .??........?....
	defb 099h,09fh,069h,0cdh,0a0h,0f0h,0a8h,0e8h,0ffh,0fdh,0ffh,0dfh,0cfh,0ffh,0ffh,07fh	; 6490  ..i.............
	defb 0fdh,0fdh,0fdh,0f9h,0c1h,081h,0c3h,0c0h,0f0h,0f8h,0f8h,0f8h,0e0h,0ffh,0ffh,0feh	; 64a0  ................
	defb 099h,0f8h,0d0h,0b1h,000h,000h,000h,001h,007h,003h,003h,0fch,001h,001h,09fh,017h	; 64b0  ................
	defb 0fch,0f8h,0fch,0f4h,07fh,07fh,03fh,01fh,054h,0fch,0aah,0f4h,0a4h,0d4h,0e2h,080h	; 64c0  ......?.T.......
	defb 07fh,07eh,07ch,07fh,07fh,07fh,077h,078h,081h,000h,0ffh,0b1h,0c3h,0fch,0f0h,0ffh	; 64d0  .~|...wx........
	defb 0feh,07ch,03ch,0f8h,0f8h,0f0h,0e0h,000h,002h,001h,000h,000h,001h,012h,001h,010h	; 64e0  .|<.............
	defb 0bfh,0ffh,097h,02fh,001h,001h,003h,0f8h,0f0h,0f8h,0fch,00fh,0f0h,0f0h,0f0h,000h	; 64f0  .../............
	defb 01fh,07fh,05fh,0ffh,0f7h,07eh,03ah,080h,07ch,07ch,0fch,07eh,0feh,0cbh,060h,07fh	; 6500  .._..~:.||.~..`.
	defb 000h,000h,0dfh,0bch,0eeh,0ffh,0fdh,0efh,002h,000h,000h,080h,084h,084h,000h,080h	; 6510  ................
	defb 023h,005h,081h,0feh,07fh,03fh,09fh,022h,00fh,00fh,02fh,0e0h,07fh,03fh,00fh,000h	; 6520  #....?."../..?..
	defb 0e0h,0c0h,080h,0ffh,0ffh,0cfh,0dfh,0fdh,0efh,0efh,0efh,000h,0feh,0fch,0f8h,00fh	; 6530  ................
	defb 0e0h,0e0h,0e0h,03fh,0c0h,0c0h,0c0h,03fh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 6540  ...?...?........
	defb 0e0h,0e0h,0e0h,0e0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,080h,080h,080h,080h,080h,080h	; 6550  ................
	defb 0ffh,0ffh,0ffh,09eh,0ffh,0ffh,0efh,0ffh,0fch,0f0h,0c0h,080h,0ffh,0ffh,0ffh,0fdh	; 6560  ................
	defb 0fch,0fch,0fch,0fch,0fch,001h,001h,003h,0f9h,0f3h,0f3h,0f7h,0e7h,000h,0ffh,0ffh	; 6570  ................
	defb 0efh,09fh,0dfh,09fh,0bfh,000h,0ffh,0ffh,000h,003h,007h,01fh,07fh,0ffh,0ffh,0ffh	; 6580  ................
	defb 080h,0c0h,0a0h,0c0h,080h,080h,080h,000h,0f0h,0f0h,0d0h,0c0h,0e0h,0b0h,0f0h,0e0h	; 6590  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,0f9h,0f9h,07fh,03fh,03fh,07fh,000h,000h,07fh,07fh	; 65a0  .........??.....
	defb 07fh,03fh,03fh,023h,000h,000h,01fh,00fh,007h,000h,037h,07fh,000h,07fh,000h,000h	; 65b0  .??#......7.....
	defb 0ffh,000h,0fbh,0ffh,000h,0dbh,000h,0ffh,0c3h,003h,005h,0c3h,001h,0c0h,001h,0c0h	; 65c0  ................
	defb 0e0h,0f0h,0f8h,0fch,0feh,0ffh,0ffh,0ffh,0f3h,0fbh,0f9h,0fdh,0fdh,000h,0ffh,0ffh	; 65d0  ................
	defb 0efh,0efh,0e7h,0e7h,0e7h,000h,0ffh,0ffh,03fh,03fh,03fh,03fh,03fh,03fh,0e0h,070h	; 65e0  ........??????.p
	defb 03fh,00fh,02fh,003h,001h,009h,080h,0e0h,080h,0c0h,0c0h,080h,0e0h,080h,060h,0c0h	; 65f0  ?./...........`.
	defb 0e0h,0e0h,0e0h,01fh,0e0h,0e0h,0e0h,01fh,003h,003h,001h,001h,001h,001h,001h,001h	; 6600  ................
	defb 007h,007h,007h,007h,003h,003h,003h,003h,007h,007h,007h,007h,007h,007h,007h,007h	; 6610  ................
	defb 00fh,00fh,00fh,0f0h,007h,007h,007h,000h,0efh,0efh,0efh,080h,07fh,03fh,01fh,0f0h	; 6620  .............?..
	defb 007h,003h,001h,090h,0c0h,0e0h,0c0h,0e8h,0b7h,0bdh,0adh,0c5h,084h,0c0h,0e0h,0f8h	; 6630  ................
	defb 00fh,00fh,00fh,00fh,00fh,00fh,01fh,01fh,0edh,0f9h,0ffh,001h,000h,0feh,0eeh,0bfh	; 6640  ................
	defb 0b5h,0fbh,09fh,004h,000h,03fh,01fh,0f7h,0e7h,0f7h,0bfh,0fch,0fch,000h,0ffh,0cfh	; 6650  .....?..........
	defb 0fbh,0dfh,007h,007h,07eh,000h,0ffh,0ffh,0f7h,0ffh,01dh,03fh,02fh,03fh,07fh,0ffh	; 6660  ....~......?/?..
	defb 0e2h,0feh,0dfh,09fh,0ffh,0ffh,0ffh,0f7h,0bch,0ffh,0f7h,0dfh,0ffh,0bfh,0f4h,0feh	; 6670  ................
	defb 007h,007h,007h,0f8h,007h,007h,007h,0f8h,0f0h,0fch,0f8h,0fch,000h,000h,0ffh,0f4h	; 6680  ................
	defb 0f8h,0fch,0c8h,0f4h,0fch,0f8h,0c0h,0c0h,0f4h,000h,08fh,0dfh,0f8h,000h,0ffh,0ffh	; 6690  ................
	defb 0f8h,0eeh,0c0h,0e0h,000h,072h,0ffh,0ffh,0efh,0efh,0efh,000h,0feh,0feh,0feh,000h	; 66a0  .....r..........
	defb 000h,000h,000h,000h,0feh,0feh,0feh,000h,0efh,0efh,0e8h,000h,0c0h,0c0h,080h,000h	; 66b0  ................
	defb 0e0h,000h,000h,000h,000h,000h,000h,000h,007h,000h,000h,000h,000h,000h,000h,000h	; 66c0  ................
	defb 0efh,0efh,02fh,000h,003h,003h,001h,000h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 66d0  ../.............
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 66e0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h,000h,000h,000h	; 66f0  ................
	defb 0f7h,0d3h,0c2h,0cfh,0c7h,081h,000h,000h,0c3h,0d1h,0f3h,0e1h,0c0h,000h,000h,000h	; 6700  ................
	defb 07bh,03eh,0feh,01ch,001h,03fh,000h,003h,003h,00fh,00fh,00fh,01fh,03fh,03fh,07fh	; 6710  {>...?.......??.
	defb 07fh,03fh,01fh,00fh,00fh,01fh,03fh,07fh,000h,0ffh,062h,06dh,07ch,0bfh,07fh,0ffh	; 6720  .?....?...bm|...
	defb 000h,00fh,00fh,005h,023h,087h,00fh,06fh,000h,0e0h,0f0h,002h,020h,077h,07fh,03eh	; 6730  ....#..o.... w.>
	defb 0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0c0h,000h,0feh,0fch,080h,0f0h,0f8h,0f8h,0f8h,0f0h	; 6740  ................
	defb 004h,021h,0b3h,03ah,01fh,06fh,0ffh,0ffh,0ffh,0f7h,0f3h,0f1h,0f5h,0d8h,082h,0e7h	; 6750  .!.:.o..........
	defb 007h,01dh,039h,086h,0ebh,0bbh,0adh,016h,0a9h,0e9h,056h,0b9h,054h,0afh,046h,0b9h	; 6760  ..9.......V.T.F.
	defb 006h,0f9h,01fh,0f8h,001h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,007h,03fh,0fdh	; 6770  ..............?.
	defb 0ffh,0ffh,0ffh,080h,0c0h,0c0h,0c0h,0e0h,0e0h,060h,0e0h,0e0h,060h,060h,0e0h,060h	; 6780  .........`..``.`
	defb 060h,0e0h,0e0h,060h,09fh,0e0h,0f0h,08fh,070h,070h,0f0h,070h,0e0h,0e0h,0e1h,0f3h	; 6790  `..`....pp.p....
	defb 0f8h,0f8h,0fdh,0fdh,0fdh,0fdh,0f8h,0fch,0fch,0fch,0f8h,0fch,0feh,0b6h,018h,044h	; 67a0  ...............D
	defb 05bh,0ach,073h,07fh,0a3h,0f8h,070h,0e0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 67b0  [.s...p.........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 67c0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 67d0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 67e0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 67f0  ................
	defb 09fh,09fh,09fh,09fh,090h,090h,090h,090h,09fh,09fh,09fh,09fh,090h,090h,090h,090h	; 6800  ................
	defb 09fh,096h,09fh,096h,09fh,096h,090h,090h,09fh,098h,09fh,09fh,098h,098h,090h,090h	; 6810  ................
	defb 098h,09fh,09fh,09fh,09fh,09fh,096h,09fh,098h,098h,098h,098h,098h,098h,098h,098h	; 6820  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0afh,0a9h,0a9h,0a8h,0a8h,0a8h,0a8h,0a8h	; 6830  ................
	defb 09fh,09fh,098h,08fh,0f0h,0f0h,0f0h,080h,098h,098h,098h,08fh,080h,0f0h,0f0h,0f0h	; 6840  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,08fh,080h,080h,090h,090h,090h,090h,090h,090h,090h,090h	; 6850  ................
	defb 080h,080h,098h,098h,098h,098h,098h,098h,0f0h,0f0h,08fh,08fh,08fh,098h,098h,098h	; 6860  ................
	defb 080h,080h,080h,080h,080h,08fh,08fh,080h,09fh,098h,09fh,098h,09fh,08fh,0f0h,0f0h	; 6870  ................
	defb 098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h	; 6880  ................
	defb 08fh,0c8h,080h,080h,080h,08fh,0c8h,080h,0f0h,0d0h,0f0h,0f0h,0b0h,0d0h,0b0h,0f0h	; 6890  ................
	defb 098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h	; 68a0  ................
	defb 086h,08fh,080h,08fh,080h,08fh,080h,08fh,0f0h,0b0h,0f0h,0b0h,0f0h,0d0h,0f0h,0f0h	; 68b0  ................
	defb 098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h	; 68c0  ................
	defb 08fh,08fh,080h,080h,08fh,0c8h,080h,08fh,090h,09fh,096h,06fh,086h,08fh,098h,09fh	; 68d0  ...........o....
	defb 098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h	; 68e0  ................
	defb 080h,080h,0c8h,0c8h,080h,08fh,080h,080h,090h,090h,090h,090h,090h,090h,090h,090h	; 68f0  ................
	defb 0c9h,09fh,09fh,09fh,09fh,09fh,09fh,096h,0cfh,0c9h,0c9h,0c6h,0c6h,0c6h,0c6h,0c6h	; 6900  ................
	defb 0c9h,09fh,09fh,096h,096h,096h,096h,096h,0c9h,09fh,09fh,096h,09fh,096h,09fh,09fh	; 6910  ................
	defb 0c9h,09fh,09fh,098h,098h,098h,098h,098h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h	; 6920  ................
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,09fh,096h,09fh,096h,09fh,09fh,09fh	; 6930  ................
	defb 090h,090h,090h,090h,090h,090h,090h,090h,0c6h,0c6h,0c6h,0c6h,0c6h,06fh,060h,060h	; 6940  .............o``
	defb 096h,096h,096h,06fh,060h,0f0h,0f0h,0f0h,096h,09fh,09fh,06fh,0f0h,0f0h,0f0h,060h	; 6950  ...o`......o...`
	defb 09fh,09fh,096h,09fh,09fh,060h,0f0h,0f0h,060h,060h,060h,06fh,06fh,060h,060h,06fh	; 6960  .....`..```oo``o
	defb 0f0h,0f0h,06fh,06fh,06fh,096h,096h,096h,060h,060h,096h,096h,096h,096h,096h,096h	; 6970  ..ooo...``......
	defb 0f0h,0f0h,0f0h,0d0h,0b0h,0f0h,0b0h,0f0h,060h,06fh,086h,0c6h,0c6h,06fh,060h,06fh	; 6980  ........`o...o`o
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h	; 6990  ................
	defb 0f0h,0b0h,0d0h,0b0h,0f0h,0f0h,0d0h,0f0h,06fh,06fh,0c6h,060h,06fh,086h,06fh,0c6h	; 69a0  ........oo.`o.o.
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h	; 69b0  ................
	defb 090h,09fh,096h,06fh,086h,08fh,098h,09fh,060h,060h,060h,06fh,06fh,060h,06fh,06fh	; 69c0  ...o....```oo`oo
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h	; 69d0  ................
	defb 090h,090h,090h,090h,090h,090h,090h,090h,060h,060h,06fh,060h,06fh,060h,086h,060h	; 69e0  ........``o`o`.`
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h,096h	; 69f0  ................
	defb 098h,098h,098h,098h,098h,096h,098h,09fh,098h,098h,098h,098h,098h,098h,098h,098h	; 6a00  ................
	defb 080h,08fh,080h,08fh,080h,08fh,08fh,08fh,0afh,0eah,0afh,0a0h,0a0h,0eah,0afh,0afh	; 6a10  ................
	defb 09fh,098h,098h,09fh,09fh,06fh,0f0h,090h,098h,09fh,098h,098h,098h,098h,090h,090h	; 6a20  .....o..........
	defb 0c8h,080h,0c8h,0c8h,080h,080h,08fh,0c8h,0afh,0afh,0eah,0afh,0afh,0eah,0afh,0afh	; 6a30  ................
	defb 09fh,09fh,096h,06fh,06fh,08fh,098h,098h,098h,098h,098h,098h,098h,098h,098h,098h	; 6a40  ...oo...........
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0afh,0afh,0afh,0eah,0afh,0afh,0eah,0afh	; 6a50  ................
	defb 09fh,09fh,09fh,09fh,098h,09fh,09fh,09fh,098h,098h,098h,098h,098h,098h,098h,098h	; 6a60  ................
	defb 0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0c8h,0afh,0a0h,0afh,0eah,0afh,0eah,0afh,0afh	; 6a70  ................
	defb 09fh,09fh,09fh,098h,09fh,09fh,09fh,09fh,098h,098h,098h,096h,096h,096h,096h,096h	; 6a80  ................
	defb 0c8h,0c8h,0c6h,0cfh,0c6h,0c6h,0c6h,0c6h,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 6a90  ................
	defb 0f0h,0f0h,0f0h,0f0h,060h,060h,060h,06fh,060h,060h,060h,060h,060h,060h,060h,060h	; 6aa0  ....```o````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 6ab0  ````````........
	defb 060h,06fh,06fh,06fh,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 6ac0  `ooo````````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 6ad0  ````````........
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,06fh,060h,060h	; 6ae0  `````````````o``
	defb 060h,060h,086h,0c6h,0c6h,0c6h,0c6h,0cfh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh	; 6af0  ``..............
	defb 0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,06fh,060h,06fh,06fh,060h,060h,06fh,06fh	; 6b00  ........o`oo``oo
	defb 096h,09fh,09fh,096h,096h,09fh,09fh,09fh,096h,096h,096h,096h,096h,096h,09fh,09fh	; 6b10  ................
	defb 0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,060h,060h,0c6h,060h,06fh,0c6h,06fh,0c6h	; 6b20  ........``.`o.o.
	defb 096h,096h,096h,09fh,09fh,096h,090h,090h,09fh,09fh,09fh,09fh,09fh,060h,0f0h,090h	; 6b30  .............`..
	defb 0afh,0afh,0afh,0afh,0afh,0afh,0afh,0afh,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h,0c6h	; 6b40  ................
	defb 096h,096h,096h,096h,096h,096h,096h,096h,09fh,09fh,096h,06fh,06fh,08fh,098h,098h	; 6b50  ...........oo...
	defb 0cfh,0cfh,0cfh,0cfh,0cfh,0cfh,0c0h,0c0h,0c6h,0c6h,0c6h,0c6h,0c6h,060h,060h,060h	; 6b60  .............```
	defb 096h,096h,096h,096h,096h,096h,096h,096h,096h,09fh,09fh,09fh,09fh,096h,09fh,09fh	; 6b70  ................
	defb 0c0h,0f0h,0c0h,0f0h,0f0h,0f0h,0f0h,0c0h,060h,060h,060h,0f0h,060h,060h,060h,060h	; 6b80  ........```.````
	defb 096h,096h,096h,096h,090h,090h,090h,090h,09fh,09fh,09fh,098h,09fh,09fh,09fh,090h	; 6b90  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,060h,060h,060h,060h,060h,060h,060h,060h	; 6ba0  ........````````
	defb 0f0h,0f0h,060h,0f0h,060h,060h,060h,060h,0f0h,0f0h,0f0h,0f0h,060h,060h,060h,060h	; 6bb0  ..`.````....````
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,060h,060h,060h,060h,060h,060h,060h,060h	; 6bc0  ........````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 6bd0  ````````````````
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0cfh,060h,060h,060h,060h,060h,060h,060h,060h	; 6be0  ........````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 6bf0  ````````````````
	defb 0f0h,0e0h,0e5h,050h,0f5h,0e5h,0e5h,050h,0f5h,05fh,05fh,05fh,05fh,05fh,05fh,05fh	; 6c00  ...P...P._______
	defb 05fh,05fh,05fh,050h,050h,050h,050h,050h,0f5h,05fh,054h,05fh,054h,054h,054h,050h	; 6c10  ___PPPPP._T_TTTP
	defb 0f0h,0e0h,0e4h,040h,0f4h,0e4h,0e4h,040h,0f5h,0e5h,0e5h,050h,0f5h,050h,050h,050h	; 6c20  ...@...@...P.PPP
	defb 05fh,050h,05fh,050h,050h,05fh,050h,050h,050h,050h,050h,050h,0f0h,040h,040h,04fh	; 6c30  _P_PP_PPPPPP.@@O
	defb 040h,040h,040h,040h,040h,040h,040h,040h,0f4h,040h,040h,040h,050h,040h,050h,040h	; 6c40  @@@@@@@@.@@@P@P@
	defb 0f5h,0e5h,0e5h,050h,0f5h,0e5h,0e5h,050h,050h,050h,050h,050h,050h,050h,050h,050h	; 6c50  ...P...PPPPPPPPP
	defb 05fh,050h,050h,050h,050h,050h,050h,050h,054h,054h,050h,050h,050h,050h,050h,050h	; 6c60  _PPPPPPPTTPPPPPP
	defb 04fh,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h,040h	; 6c70  O@@@@@@@@@@@@@@@
	defb 0f4h,0e4h,0e4h,040h,0f4h,0e4h,0e4h,040h,0f5h,0e5h,0e5h,050h,0f5h,0e5h,054h,054h	; 6c80  ...@...@...P..TT
	defb 050h,050h,050h,040h,040h,040h,040h,040h,05fh,054h,05fh,054h,054h,05fh,05fh,050h	; 6c90  PPP@@@@@_T_TT__P
	defb 050h,050h,050h,050h,050h,040h,040h,054h,054h,054h,054h,054h,054h,04fh,04fh,040h	; 6ca0  PPPPP@@TTTTTTOO@
	defb 040h,040h,040h,040h,0f0h,0f0h,0f0h,040h,0f4h,0e4h,0e4h,040h,0f4h,0e4h,040h,040h	; 6cb0  @@@@...@...@..@@
	defb 054h,054h,054h,054h,050h,050h,050h,050h,040h,040h,040h,040h,040h,040h,040h,040h	; 6cc0  TTTTPPPP@@@@@@@@
	defb 050h,050h,050h,050h,050h,050h,050h,050h,050h,0f0h,05fh,050h,050h,054h,054h,04fh	; 6cd0  PPPPPPPPP._PPTTO
	defb 040h,040h,040h,040h,040h,040h,040h,0f0h,040h,040h,0f0h,0f0h,040h,040h,040h,040h	; 6ce0  @@@@@@@.@@..@@@@
	defb 040h,04fh,040h,040h,0e4h,0e4h,0e4h,040h,0f5h,0e5h,0e0h,050h,0f5h,0e5h,0e0h,0f0h	; 6cf0  @O@@...@...P....
	defb 050h,050h,050h,05fh,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h,050h	; 6d00  PPP_PPPPPPPPPPPP
	defb 0f0h,0f0h,050h,050h,050h,05fh,050h,050h,050h,0f0h,0f0h,050h,050h,050h,0f0h,050h	; 6d10  ..PPP_PPP..PPP.P
	defb 040h,040h,040h,050h,050h,050h,050h,050h,0f4h,0e4h,0e4h,040h,0f4h,0e4h,0e4h,0f0h	; 6d20  @@@PPPPP...@....
	defb 0f5h,0e5h,0e5h,05fh,05fh,054h,054h,054h,0f0h,0e0h,0e0h,0f0h,0f5h,0e5h,0e5h,050h	; 6d30  ...__TTT.......P
	defb 0f5h,0e5h,0e5h,050h,0f5h,0e5h,0e5h,050h,065h,065h,065h,065h,065h,065h,085h,085h	; 6d40  ...P...Peeeeee..
	defb 085h,085h,085h,085h,085h,065h,065h,065h,065h,065h,065h,065h,085h,065h,065h,065h	; 6d50  .....eeeeeee.eee
	defb 05fh,05fh,05fh,054h,05fh,05fh,054h,05fh,065h,065h,065h,065h,05fh,05fh,05fh,050h	; 6d60  ___T__T_eeee___P
	defb 065h,065h,065h,065h,060h,086h,086h,086h,050h,050h,050h,050h,050h,0f0h,06fh,06fh	; 6d70  eeee`...PPPPP.oo
	defb 050h,050h,050h,050h,050h,0f0h,06fh,06fh,0f0h,060h,060h,060h,060h,06fh,06fh,06fh	; 6d80  PPPPP.oo.````ooo
	defb 050h,050h,050h,050h,050h,050h,050h,0f0h,050h,050h,050h,050h,050h,050h,050h,050h	; 6d90  PPPPPPP.PPPPPPPP
	defb 05fh,05fh,05fh,05fh,05fh,050h,050h,050h,054h,054h,054h,050h,0f0h,0f0h,040h,050h	; 6da0  _____PPPTTTP..@P
	defb 050h,050h,050h,050h,0f0h,0f0h,040h,050h,050h,0f0h,040h,040h,0f0h,040h,0f0h,0f0h	; 6db0  PPPP..@PP.@@.@..
	defb 05fh,0f0h,040h,04fh,0f0h,040h,0f0h,06fh,050h,050h,050h,050h,050h,040h,050h,060h	; 6dc0  _.@O.@.oPPPPP@P`
	defb 060h,060h,060h,060h,060h,06fh,06fh,06fh,050h,050h,050h,050h,050h,0f0h,06fh,06fh	; 6dd0  `````oooPPPPP.oo
	defb 050h,050h,050h,050h,050h,0f0h,06fh,06fh,065h,065h,065h,065h,065h,060h,086h,086h	; 6de0  PPPPP.ooeeeee`..
	defb 084h,084h,064h,064h,064h,064h,054h,054h,054h,054h,054h,054h,054h,054h,054h,054h	; 6df0  ..ddddTTTTTTTTTT
	defb 0f5h,0e5h,0e5h,050h,0f5h,0e5h,0e5h,050h,064h,064h,060h,064h,064h,060h,080h,084h	; 6e00  ...P...Pdd`dd`..
	defb 064h,064h,064h,064h,064h,060h,084h,084h,064h,064h,064h,064h,060h,064h,064h,064h	; 6e10  ddddd`..dddd`ddd
	defb 0f4h,0e4h,0e0h,040h,0f4h,0e4h,0e4h,0f0h,0f0h,0e0h,0e0h,040h,0f4h,0e4h,0e4h,040h	; 6e20  ...@.......@...@
	defb 0f4h,0e4h,0e4h,054h,054h,054h,054h,054h,050h,050h,050h,050h,050h,050h,050h,050h	; 6e30  ...TTTTTPPPPPPPP
	defb 040h,040h,040h,040h,040h,040h,040h,040h,054h,054h,05fh,050h,0f0h,040h,054h,054h	; 6e40  @@@@@@@@TT_P.@TT
	defb 054h,054h,050h,050h,0f0h,040h,054h,054h,054h,054h,054h,050h,054h,0f0h,04fh,054h	; 6e50  TTPP.@TTTTTPT.OT
	defb 054h,054h,050h,054h,054h,0f0h,04fh,05fh,040h,04fh,054h,054h,054h,054h,054h,05fh	; 6e60  TTPTT.O_@OTTTTT_
	defb 050h,050h,054h,054h,05fh,05fh,05fh,054h,054h,05fh,054h,054h,05fh,054h,054h,054h	; 6e70  PPTT___TT_TT_TTT
	defb 0f4h,0e0h,0e0h,040h,0f4h,0e4h,0e4h,040h,054h,054h,054h,054h,0f0h,0f0h,04fh,054h	; 6e80  ...@...@TTTT..OT
	defb 054h,054h,054h,054h,054h,054h,050h,054h,054h,0f0h,040h,040h,054h,0f0h,04fh,04fh	; 6e90  TTTTTTPTT.@@T.OO
	defb 054h,054h,050h,054h,0f0h,040h,04fh,05fh,0f0h,0e0h,0e0h,0f0h,0f0h,0e0h,0e0h,0f0h	; 6ea0  TTPT.@O_........
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0f0h,0f0h,0e0h,0e0h,0f0h,0f0h,0e0h,0e0h,0f0h	; 6eb0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 6ec0  ................
	defb 0f0h,0e0h,0e0h,0f0h,0f0h,0e0h,0e0h,0f0h,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh	; 6ed0  ........oooooooo
	defb 06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh	; 6ee0  oooooooooooooooo
	defb 06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 6ef0  oooooooo........
	defb 0feh,0feh,0feh,0e0h,0e0h,0e0h,0f0h,0f0h,0feh,0feh,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h	; 6f00  ................
	defb 0feh,0feh,0feh,0feh,0feh,0e0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 6f10  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0efh,0feh,0feh,0feh,0feh,0feh,0ffh	; 6f20  ................
	defb 0f0h,0e0h,0e0h,0feh,0feh,0feh,0feh,0feh,0f0h,0e0h,0e0h,0feh,0feh,0feh,0feh,0feh	; 6f30  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 6f40  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0ffh,0ffh,0ffh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 6f50  ................
	defb 0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0feh,0e7h,0feh,0e7h	; 6f60  ................
	defb 0feh,0e7h,0e7h,0feh,0e7h,07fh,0ffh,07fh,07fh,07fh,0ffh,0ffh,0feh,0e7h,0e7h,0e7h	; 6f70  ................
	defb 05fh,05fh,05fh,075h,075h,075h,075h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h,0e5h	; 6f80  ___uuuu.........
	defb 0e5h,0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0e5h,0e5h,0e5h,0e5h,0e5h,075h,075h	; 6f90  ..............uu
	defb 075h,075h,075h,075h,075h,075h,0f5h,075h,075h,075h,075h,0e5h,0e5h,0e5h,0feh,0feh	; 6fa0  uuuuuu.uuuu.....
	defb 0e7h,0feh,0e7h,0e7h,0feh,0e7h,0e7h,0e7h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6fb0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6fc0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6fd0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6fe0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 6ff0  ................
	defb 0ffh,0ffh,0ffh,0ffh,007h,01fh,01fh,06fh,0ffh,001h,01fh,0ffh,0ffh,0ffh,010h,0ffh	; 7000  .......o........
	defb 0ffh,0ffh,0ffh,0feh,0fdh,0fdh,0fbh,0f7h,0c0h,0e0h,0f0h,0f8h,0feh,0ffh,0ffh,0ffh	; 7010  ................
	defb 06fh,077h,077h,07bh,07dh,03dh,01eh,00fh,0eeh,0eeh,0dch,0dch,0bch,070h,074h,06ch	; 7020  oww{}=.......ptl
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0f1h,08fh,0ffh,0ffh,0feh,0f9h,0e7h,01fh,0ffh,0ffh	; 7030  ................
	defb 007h,01bh,01bh,01dh,01eh,01fh,01fh,01fh,0bfh,0c0h,01fh,01fh,01eh,0c9h,0f7h,0ffh	; 7040  ................
	defb 0ffh,0ffh,0ffh,0feh,0c0h,080h,0c0h,0c0h,0e6h,0deh,0b6h,03dh,03eh,036h,03dh,03eh	; 7050  ...........=>6=>
	defb 0e0h,0f0h,0e0h,0f0h,0f0h,0f0h,0f0h,0f0h,040h,080h,080h,040h,0c0h,0b0h,0f0h,0ffh	; 7060  ........@..@....
	defb 03fh,03fh,03fh,07fh,038h,07eh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,003h,01fh	; 7070  ???.8~..........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,07fh,02fh,007h,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0ffh,0ffh	; 7080  ....../.........
	defb 03fh,07fh,07fh,07fh,07fh,07fh,07fh,01fh,017h,01fh,00fh,02fh,007h,01eh,00fh,037h	; 7090  ?........../...7
	defb 0c0h,0e0h,0f0h,0f0h,0f8h,0fch,0f8h,0f4h,0dfh,0e7h,079h,01eh,08fh,0a3h,0d4h,067h	; 70a0  ..........y....g
	defb 027h,01fh,00fh,07fh,09fh,0e0h,07fh,080h,0ffh,0ffh,0feh,0e1h,01fh,0feh,0fdh,003h	; 70b0  '...............
	defb 0d6h,036h,0f6h,0f6h,0efh,00fh,070h,07fh,0a6h,0d6h,076h,02eh,01eh,01eh,01eh,01eh	; 70c0  .6....p...v.....
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,08fh,08fh,00fh,00fh,00fh,00fh,007h,003h	; 70d0  ................
	defb 07fh,07fh,07fh,07eh,07fh,07eh,03ch,070h,0c0h,0e0h,0f0h,0f0h,0fch,0feh,0feh,0ffh	; 70e0  ...~.~<p........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0ech,000h,07fh,09fh,0efh,073h,03ch,09eh,0c7h,0f3h	; 70f0  ...........s<...
	defb 0c0h,0c0h,0e0h,0e0h,0e0h,0c0h,0e0h,0e0h,0fdh,0f8h,0f8h,0f8h,0fdh,0f4h,0f5h,06eh	; 7100  ...............n
	defb 01fh,0e7h,0fbh,03dh,09eh,04fh,0a7h,051h,0e7h,0e7h,0cfh,0cfh,087h,001h,04eh,0c7h	; 7110  ...=.O.Q......N.
	defb 077h,076h,036h,00eh,000h,000h,000h,000h,0f7h,0c7h,007h,007h,007h,00fh,00fh,003h	; 7120  wv6.............
	defb 003h,003h,007h,007h,003h,003h,003h,003h,0c0h,0c0h,0c0h,0c0h,0e0h,0e0h,0c0h,0c0h	; 7130  ................
	defb 003h,003h,07eh,018h,000h,000h,000h,000h,000h,00eh,01fh,03fh,07fh,0ffh,0ffh,0ffh	; 7140  ..~........?....
	defb 0c7h,0dfh,0fch,01fh,037h,05fh,03fh,0ffh,0ffh,0ffh,0ffh,0c0h,0f8h,0fch,0feh,0ffh	; 7150  ....7_?.........
	defb 080h,0ffh,07fh,003h,0c0h,0dch,0dch,0ddh,0ffh,0ffh,00fh,0f0h,0ffh,03fh,00fh,0c1h	; 7160  .............?..
	defb 0ffh,0fch,0fbh,0c7h,03eh,0f8h,0e3h,0cfh,003h,003h,003h,007h,007h,007h,007h,003h	; 7170  ....>...........
	defb 0bdh,0b5h,0bdh,0bdh,0bdh,0aeh,0aeh,0beh,06bh,0dbh,0ebh,07bh,0b3h,0fbh,0f3h,0c3h	; 7180  ........k..{....
	defb 01fh,01fh,00fh,00fh,00fh,00fh,00fh,00fh,0ffh,003h,000h,000h,000h,000h,000h,000h	; 7190  ................
	defb 0c7h,087h,00fh,007h,001h,000h,000h,000h,00fh,01fh,01fh,01fh,01fh,0fch,000h,000h	; 71a0  ................
	defb 0c0h,0c0h,0c0h,080h,000h,000h,000h,000h,0c0h,0c0h,0c0h,0c0h,0e0h,0e0h,0e0h,0e0h	; 71b0  ................
	defb 0e0h,080h,000h,040h,0c0h,0c0h,0c0h,0c0h,080h,080h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h	; 71c0  ...@............
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,038h,07eh,01fh,03dh,00fh,001h,003h,003h,007h,00fh,00fh	; 71d0  .....8~.=.......
	defb 03fh,01fh,00fh,00fh,007h,00bh,00dh,006h,01fh,01fh,01fh,01fh,01fh,01fh,01fh,01fh	; 71e0  ?...............
	defb 0bfh,07fh,03fh,07fh,0ffh,078h,07fh,0ffh,00fh,007h,007h,003h,003h,0f0h,0e1h,0cfh	; 71f0  ..?..x..........
	defb 06bh,0d6h,078h,040h,000h,0c0h,0f0h,0fch,0feh,0feh,07eh,03eh,006h,000h,000h,000h	; 7200  k.x@......~>....
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0f8h,000h,000h,07ch,000h,0d7h,0ffh,0ffh,0ffh,0ffh,0ffh	; 7210  ........|.......
	defb 01fh,01fh,01fh,00fh,003h,0e0h,0e0h,0fch,07fh,07fh,03fh,07fh,03fh,07fh,07eh,078h	; 7220  ..........?.?.~x
	defb 0f0h,0e0h,0c0h,080h,000h,000h,000h,000h,07fh,07fh,03fh,01fh,01fh,00fh,007h,003h	; 7230  ..........?.....
	defb 080h,0c0h,0c0h,0c0h,0c0h,0fch,0feh,0ffh,03eh,01eh,00eh,007h,03fh,07fh,07fh,07fh	; 7240  ........>...?...
	defb 0f0h,0e0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c3h,07fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7250  ................
	defb 0f0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,001h,007h,00fh,00fh,00fh,00fh,01fh	; 7260  ................
	defb 01fh,0e0h,0f0h,0f0h,0fch,0feh,07fh,03fh,0ffh,0ffh,0feh,0fch,0fch,0fch,0feh,0feh	; 7270  .......?........
	defb 0dfh,0dfh,0dfh,0dfh,0efh,0efh,0efh,0efh,0fch,0fch,0fch,0fch,0fch,0f0h,0e0h,000h	; 7280  ................
	defb 0ffh,0ffh,07fh,0bfh,0dfh,0efh,0efh,0efh,0ffh,008h,0ffh,0ffh,002h,048h,0ffh,002h	; 7290  .............H..
	defb 03fh,09fh,0cfh,0e7h,0e7h,0f3h,0f0h,0f0h,0ffh,0ffh,0ffh,0fch,0f1h,0c3h,00fh,00fh	; 72a0  ?...............
	defb 0f3h,0c7h,09fh,07fh,0ffh,0ffh,0ffh,0ffh,07fh,03fh,09eh,0c8h,0c3h,0e1h,0f0h,0feh	; 72b0  .........?......
	defb 03fh,0bfh,0bfh,0bfh,0bfh,03fh,03fh,03fh,007h,01fh,03fh,03fh,07fh,07fh,03fh,01fh	; 72c0  ?....???..??..?.
	defb 02fh,06fh,077h,03bh,07dh,07ch,0feh,0ffh,001h,003h,007h,00fh,00fh,007h,007h,003h	; 72d0  /ow;}|..........
	defb 0f8h,0fch,0f8h,0f8h,0e2h,0c7h,00fh,03fh,09fh,09fh,003h,01bh,038h,03eh,09fh,0dfh	; 72e0  .......?....8>..
	defb 09fh,0dfh,0cfh,0eeh,0e0h,0e0h,0f0h,0f8h,0e0h,0cch,0ceh,01eh,01fh,03fh,0ffh,0ffh	; 72f0  .............?..
	defb 0ffh,07fh,03fh,000h,0d8h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,03fh,0cfh,0cfh	; 7300  ..?.........??..
	defb 0ffh,0fch,0f1h,003h,00fh,0ffh,0ffh,0ffh,07fh,03fh,09fh,0dfh,0deh,0c8h,0c0h,0c0h	; 7310  .........?......
	defb 0c3h,007h,00fh,087h,0e3h,0f3h,0f9h,0f1h,0f8h,0fch,0fch,0fch,0fch,0fch,0fch,0fch	; 7320  ................
	defb 00fh,03fh,03fh,07fh,07fh,07fh,01fh,007h,0c4h,09eh,03eh,03eh,03eh,0b0h,087h,0ffh	; 7330  .??.......>>>...
	defb 003h,083h,087h,0c7h,0c7h,0e1h,0e1h,0c0h,0feh,0feh,0feh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7340  ................
	defb 003h,003h,03fh,03fh,03fh,03fh,03fh,03fh,0ffh,0ffh,0ffh,0fch,0fch,0e0h,000h,000h	; 7350  ..??????........
	defb 0c0h,0f0h,0f0h,0f8h,0f8h,0feh,0feh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7360  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,00fh,01fh,03fh,03fh,03fh,01fh,01fh	; 7370  ...........???..
	defb 000h,0c0h,0f0h,0f8h,0f8h,0fch,0ffh,0ffh,000h,001h,00fh,07fh,0ffh,0ffh,0ffh,0ffh	; 7380  ................
	defb 080h,0e0h,0e0h,0f0h,0f8h,0f8h,0feh,0ffh,000h,000h,000h,001h,005h,08bh,023h,0c7h	; 7390  ..............#.
	defb 007h,003h,007h,009h,002h,020h,003h,01fh,0feh,0ffh,0fbh,0deh,0f4h,0e6h,070h,0e0h	; 73a0  ..... ........p.
	defb 0b8h,0e0h,088h,0e0h,0a0h,0c0h,080h,0e0h,0e8h,0d0h,0a0h,080h,0a0h,0e5h,0dah,0f7h	; 73b0  ................
	defb 00fh,003h,002h,009h,016h,041h,053h,0dfh,0e8h,094h,0d0h,040h,0a0h,0c0h,000h,000h	; 73c0  .....AS....@....
	defb 0dfh,0bbh,0beh,0a7h,019h,017h,003h,003h,000h,000h,000h,000h,000h,000h,000h,000h	; 73d0  ................
	defb 0f7h,0ffh,0efh,0feh,0bfh,0fdh,0f7h,07fh,0ffh,0fbh,0ffh,0ffh,0ffh,0bfh,0ffh,0fdh	; 73e0  ................
	defb 0f7h,0ffh,0bfh,0ffh,0dfh,09fh,0feh,0ffh,0ffh,0ffh,0ebh,0ffh,0bdh,0ffh,0ffh,0ffh	; 73f0  ................
	defb 080h,0ffh,0ffh,070h,0e8h,064h,0e2h,071h,001h,0ffh,0ffh,00eh,017h,026h,047h,08eh	; 7400  ...p.d.q.....&G.
	defb 071h,0e2h,064h,0e8h,070h,0ffh,0ffh,080h,08eh,047h,026h,017h,00eh,0ffh,0ffh,001h	; 7410  q.d.p....G&.....
	defb 0ffh,070h,0f8h,0f0h,0a8h,084h,082h,080h,0feh,00fh,01fh,00fh,015h,021h,041h,001h	; 7420  .p...........!A.
	defb 080h,082h,084h,0a8h,0f0h,0f8h,0f0h,07fh,001h,041h,021h,015h,00fh,01fh,00fh,0feh	; 7430  .........A!.....
	defb 07fh,0ffh,0e3h,0c1h,0c0h,088h,080h,088h,0feh,0ffh,0c7h,083h,003h,001h,001h,001h	; 7440  ................
	defb 0c8h,0c4h,0e0h,0f0h,0f8h,0fch,0feh,07fh,003h,003h,007h,00fh,01fh,03fh,07fh,0feh	; 7450  .............?..
	defb 07fh,0f3h,0f9h,0e8h,0f2h,0a3h,0cfh,0a7h,0feh,0dfh,09fh,01bh,08bh,0b7h,0f3h,0e5h	; 7460  ................
	defb 0cfh,0e7h,0c6h,0a0h,0f9h,0fah,0f7h,07fh,0e3h,0f7h,0e3h,0abh,01fh,0cdh,09fh,0feh	; 7470  ................
	defb 07fh,0e0h,0f0h,0b0h,0c9h,087h,0c6h,08dh,0feh,007h,00fh,00dh,093h,0e1h,0e3h,0f1h	; 7480  ................
	defb 08dh,0c7h,087h,0c9h,0b0h,0f0h,0e0h,07fh,0f1h,0e3h,0e1h,093h,00dh,00fh,007h,0feh	; 7490  ................
	defb 07fh,0e0h,0f0h,0b0h,0c9h,087h,0c6h,08dh,0feh,007h,00fh,00dh,093h,0e1h,0e3h,0f1h	; 74a0  ................
	defb 08dh,0c7h,087h,0c9h,0b0h,0f0h,0e0h,07fh,0f1h,0e3h,0e1h,093h,00dh,00fh,007h,0feh	; 74b0  ................
	defb 07dh,0e0h,0f0h,0b0h,0c9h,087h,0c6h,08dh,0feh,007h,00fh,00dh,093h,0e1h,0e3h,0f1h	; 74c0  }...............
	defb 08dh,0c7h,087h,0c9h,0b0h,0f0h,0e0h,07fh,0f1h,0e3h,0e1h,093h,00dh,00fh,007h,0feh	; 74d0  ................
	defb 07fh,01fh,0f0h,0b0h,0c9h,087h,0c6h,08dh,0feh,0f8h,00fh,00dh,093h,0e1h,0e3h,0f1h	; 74e0  ................
	defb 08dh,0c7h,087h,0c9h,0b0h,0f0h,01fh,07fh,0f1h,0e3h,0e1h,093h,00dh,00fh,0f8h,0feh	; 74f0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,001h,001h,001h,000h	; 7500  ................
	defb 00ch,038h,070h,0e0h,0c0h,040h,0a0h,0f0h,000h,000h,000h,000h,000h,000h,000h,000h	; 7510  .8p..@..........
	defb 000h,00ch,00eh,00eh,01fh,01fh,03fh,03bh,000h,000h,000h,000h,000h,000h,080h,080h	; 7520  ......?;........
	defb 058h,038h,02ch,01ch,01ch,00ch,01dh,01dh,000h,030h,070h,070h,0f8h,0f8h,0fch,0dch	; 7530  X8,......0pp....
	defb 031h,030h,02ah,02ah,06ah,04bh,057h,056h,080h,080h,0c0h,0c0h,060h,021h,092h,0fbh	; 7540  10**jKWV....`!..
	defb 02dh,03dh,05bh,0fbh,0b6h,074h,0e9h,05fh,08ch,00ch,054h,054h,056h,0d2h,0eah,06ah	; 7550  -=[..t._..TTV..j
	defb 076h,0feh,0ech,0cch,0c8h,080h,080h,080h,0d4h,09fh,027h,073h,05fh,0afh,05fh,097h	; 7560  v.........'s_._.
	defb 02bh,0f9h,0e4h,0eeh,0feh,0ffh,0ffh,0ffh,06eh,07fh,037h,033h,013h,001h,001h,001h	; 7570  +.......n.73....
	defb 01ch,03eh,02eh,03fh,02fh,03fh,02fh,03bh,04fh,025h,04ah,011h,022h,003h,0a5h,083h	; 7580  .>.?/?/;O%J."...
	defb 0efh,0efh,0ffh,0efh,0eeh,0deh,0ddh,0cfh,078h,07ch,074h,0fch,0f4h,0fch,0f4h,0dch	; 7590  ........x|t.....
	defb 01fh,017h,00eh,00bh,037h,003h,0fdh,007h,0c5h,0d3h,0d1h,0dbh,059h,059h,01dh,09ch	; 75a0  ....7.......YY..
	defb 0c7h,0d7h,097h,0b7h,0b7h,036h,074h,071h,0f8h,0e8h,070h,0d0h,0ech,0c0h,0ffh,000h	; 75b0  .....6tq..p.....
	defb 07fh,000h,000h,000h,00ch,012h,002h,001h,0cfh,04fh,00bh,01dh,01fh,01fh,017h,00bh	; 75c0  .........O......
	defb 0e3h,0e2h,0e0h,0f0h,0f0h,0f0h,0d0h,0a1h,0feh,000h,000h,000h,060h,090h,080h,000h	; 75d0  ............`...
	defb 000h,000h,000h,000h,000h,000h,000h,000h,089h,087h,055h,007h,00dh,00fh,007h,000h	; 75e0  ..........U.....
	defb 022h,0c2h,0d4h,0c0h,0e0h,0e0h,0c0h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 75f0  "...............
	defb 080h,0c0h,040h,060h,060h,030h,038h,058h,030h,01ch,00eh,007h,003h,002h,005h,00fh	; 7600  ..@``08X0.......
	defb 000h,000h,000h,000h,080h,080h,080h,000h,001h,003h,002h,006h,006h,00ch,01ch,01ah	; 7610  ................
	defb 06ch,06fh,037h,039h,00eh,057h,07bh,03bh,01ah,00ch,0e4h,0f0h,0f8h,038h,0b8h,0c8h	; 7620  lo79.W{;.....8..
	defb 000h,000h,007h,00fh,01fh,01ch,01dh,013h,036h,0f6h,0ech,0dch,030h,0eah,0deh,0dch	; 7630  ........6...0...
	defb 00ch,067h,03dh,00eh,003h,01fh,000h,003h,0d8h,028h,0cah,07bh,089h,05bh,0a9h,0fah	; 7640  .g=......(.{.[..
	defb 01bh,014h,013h,01eh,011h,09ah,0d5h,0dfh,030h,0e6h,0bch,070h,0c0h,0f8h,000h,0c0h	; 7650  ........0..p....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,034h,01fh,027h,073h,05fh,0afh,05fh,09fh	; 7660  ........4.'s_._.
	defb 02ch,0f8h,0e4h,0eeh,0feh,0ffh,0ffh,0ffh,000h,000h,000h,000h,000h,000h,000h,000h	; 7670  ,...............
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7680  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7690  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,003h,0ffh	; 76a0  ................
	defb 0a2h,055h,055h,088h,075h,055h,028h,0ffh,03eh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 76b0  .UU.uU(.>.......
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 76c0  ................
	defb 0d5h,0aah,05dh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,03fh,0ffh,00ah	; 76d0  ..]..........?..
	defb 007h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,01fh	; 76e0  ................
	defb 0d7h,0a2h,055h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,00fh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 76f0  ..U.............
	defb 007h,01dh,039h,086h,0ebh,0bbh,0adh,016h,0a9h,0e9h,056h,0b9h,054h,0afh,046h,0b9h	; 7700  ..9.......V.T.F.
	defb 006h,0f9h,01fh,0f8h,001h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,007h,03fh,0fdh	; 7710  ..............?.
	defb 0ffh,0ffh,0ffh,07fh,03fh,03fh,03fh,03fh,0ffh,09ch,01fh,01fh,01fh,09fh,01fh,01fh	; 7720  ....????........
	defb 09fh,01fh,01fh,09fh,09fh,01fh,00fh,08fh,08fh,0ffh,07fh,08fh,01fh,01fh,01fh,00fh	; 7730  ................
	defb 007h,007h,003h,003h,003h,003h,0ffh,003h,003h,003h,007h,003h,003h,049h,018h,0bbh	; 7740  .............I..
	defb 05bh,0ach,073h,081h,023h,0ffh,08fh,01fh,0ffh,0ffh,0f0h,080h,0ffh,0ffh,0ffh,0ffh	; 7750  [.s.#...........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7760  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7770  ................
	defb 051h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh	; 7780  Q...............
	defb 0bah,0bah,055h,0abh,0aah,011h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0feh,0f8h,0c0h,0ffh	; 7790  ..U.............
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,0dfh,028h,0d5h,0dfh,0ffh,0e0h,0c0h,080h,0ffh	; 77a0  ........(.......
	defb 0ffh,080h,080h,03fh,0f0h,0beh,060h,097h,097h,0d5h,02ah,09dh,0f5h,0c2h,0f0h,0fch	; 77b0  ...?..`...*.....
	defb 0f8h,0e0h,0c0h,080h,0ffh,07fh,0ffh,0ffh,07fh,0e0h,0f8h,0beh,097h,068h,09fh,0bch	; 77c0  .............h..
	defb 0e0h,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0c0h,0ffh,0bfh	; 77d0  ................
	defb 06ah,095h,0f5h,002h,0ffh,0ffh,0feh,0feh,0feh,0ffh,0f8h,0e0h,0c0h,080h,0ffh,0ffh	; 77e0  j...............
	defb 0ffh,080h,0e0h,003h,0beh,097h,068h,095h,095h,068h,097h,0b5h,00ah,0d5h,06ah,0d7h	; 77f0  ......h..h....j.
	defb 0cfh,0cfh,0cfh,0cfh,0ech,0ech,0ech,0ech,0cfh,0ech,0ech,0efh,0efh,0efh,0feh,0efh	; 7800  ................
	defb 0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0fch,0fch,0fch,0fch,0fch,0ffh,0ffh,0ffh	; 7810  ................
	defb 0ech,0ech,0ech,0ech,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7820  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh	; 7830  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0feh,0feh,0f0h,0f0h,0f0h,0ffh	; 7840  ................
	defb 0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7850  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0fch,0fch,0fch,0fch,0fch,0fch,0fch,0cfh	; 7860  ................
	defb 060h,060h,060h,060h,0f6h,0f6h,0ffh,0ffh,0cfh,0cfh,0cfh,0cfh,0cfh,0cfh,0ech,0ech	; 7870  ````............
	defb 0cfh,0cfh,0cfh,0cfh,0cfh,0ech,0feh,0feh,0cfh,0cfh,0cfh,0cfh,0cfh,0ech,0ffh,0ffh	; 7880  ................
	defb 0ech,0ech,0ech,0ech,0ech,0ech,0ech,0ech,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 7890  ................
	defb 0fch,0fch,0fch,0fch,0fch,0fch,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 78a0  ................
	defb 0feh,0feh,0feh,0f0h,0e0h,0e0h,0f0h,0e0h,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h	; 78b0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 78c0  ................
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 78d0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0ffh	; 78e0  ................
	defb 06fh,06fh,06fh,06fh,06fh,060h,060h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 78f0  ooooo``.........
	defb 0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0f6h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7900  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7910  ................
	defb 0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7920  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7930  ................
	defb 0feh,0feh,0e0h,0e0h,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0efh,0efh,0efh	; 7940  ................
	defb 060h,060h,0f6h,0feh,0feh,0feh,0feh,0ffh,06fh,06fh,06fh,0f6h,0f6h,0f6h,0f6h,0ffh	; 7950  ``......ooo.....
	defb 0e0h,0efh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0ffh,0ffh,0f0h,0e0h,0efh,0e0h,0e0h,0e0h	; 7960  ................
	defb 0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7970  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7980  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0efh,0e0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7990  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h,0feh,0feh,0feh,0feh,0feh,0e0h,0f0h,0f0h	; 79a0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 79b0  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f6h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 79c0  ................
	defb 0cfh,0cfh,0cfh,0cfh,0cfh,0fch,0fch,0feh,0c0h,0c0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 79d0  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e6h,0e6h,0e6h,0e6h,0e6h,0e6h	; 79e0  ................
	defb 0feh,0feh,0feh,0feh,0ffh,0f0h,0feh,0ffh,0e6h,0e6h,0e6h,0e6h,0e6h,060h,060h,060h	; 79f0  .............```
	defb 0e0h,0e0h,0e0h,0e0h,0f0h,060h,060h,060h,0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h	; 7a00  .....```........
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0f0h,0f0h,0f0h,0e0h,0f0h,0e0h,0efh,0efh,0efh,0efh,0efh	; 7a10  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0f0h,0f0h,0f0h,0feh,0feh,0feh,0feh,0feh,0feh,0f6h,0f6h	; 7a20  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 7a30  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,060h,060h,06fh,0e0h,0e0h,0e0h,060h,060h,060h,060h,060h	; 7a40  .....``o...`````
	defb 0f0h,0f6h,06fh,06fh,06fh,06fh,06fh,06fh,0e6h,060h,06fh,06fh,06fh,06fh,06fh,06fh	; 7a50  ..oooooo.`oooooo
	defb 0f6h,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,0f6h,0f6h,0f6h,0e6h,0e0h,0e0h,0e0h	; 7a60  .oooooooo.......
	defb 0e0h,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0ffh,0ffh,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7a70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7a80  ................
	defb 0efh,0efh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0efh,0feh,0efh,0efh,0feh,0feh,0efh,0feh	; 7a90  ................
	defb 060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh,06fh,060h,060h,060h,060h,060h	; 7aa0  ````````ooo`````
	defb 060h,060h,060h,060h,06fh,06fh,06fh,06fh,060h,060h,060h,060h,060h,060h,060h,060h	; 7ab0  ````oooo````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 7ac0  ````````````````
	defb 060h,060h,060h,060h,060h,060h,060h,06fh,060h,060h,060h,060h,060h,060h,060h,060h	; 7ad0  ```````o````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 7ae0  ````````````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh	; 7af0  ``````````````oo
	defb 06fh,060h,060h,0f0h,060h,06fh,06fh,06fh,06fh,06fh,06fh,06fh,060h,060h,060h,060h	; 7b00  o``.`ooooooo````
	defb 06fh,060h,060h,060h,060h,06fh,06fh,06fh,060h,060h,060h,060h,060h,060h,060h,060h	; 7b10  o````ooo````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h	; 7b20  ````````````````
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,06fh	; 7b30  ```````````````o
	defb 060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh,06fh,06fh,06fh	; 7b40  ```````````ooooo
	defb 060h,060h,060h,060h,060h,060h,060h,060h,06fh,06fh,06fh,060h,060h,060h,0f0h,0f0h	; 7b50  ````````ooo```..
	defb 060h,060h,060h,060h,060h,060h,060h,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh,06fh	; 7b60  ```````ooooooooo
	defb 0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0ffh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7b70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0ffh,0ffh,0f0h,0e0h,0e0h,0e0h,0efh,0efh,0efh,0efh	; 7b80  ................
	defb 0f6h,0f6h,0f6h,0f6h,0f0h,0f0h,0f0h,0ffh,0f0h,0f0h,0f0h,0c0h,0c0h,0c0h,0c0h,0c0h	; 7b90  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0cfh,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h	; 7ba0  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h	; 7bb0  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0f0h	; 7bc0  ................
	defb 0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7bd0  ................
	defb 0c2h,0cfh,0c3h,0c3h,0c0h,0c2h,0c0h,0c3h,0cfh,0c0h,0cfh,0cfh,0cfh,0c3h,0cfh,0c3h	; 7be0  ................
	defb 0c3h,0cfh,0c2h,0cfh,0c0h,0c0h,0c3h,0cfh,0cfh,0cfh,0c3h,0cfh,0c3h,0cfh,0cfh,0cfh	; 7bf0  ................
	defb 0feh,0efh,0efh,0e5h,0e5h,0e4h,0e7h,0e7h,0feh,0efh,0efh,0e5h,0e5h,0e4h,0e7h,0e7h	; 7c00  ................
	defb 0e7h,0e7h,0e4h,0e5h,0e5h,0efh,0efh,0feh,0e7h,0e7h,0e4h,0e5h,0e5h,0efh,0efh,0feh	; 7c10  ................
	defb 0efh,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7c20  ................
	defb 0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h,0e0h	; 7c30  ................
	defb 0e0h,0efh,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0e0h,0efh,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h	; 7c40  ................
	defb 0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0e0h,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0e9h,0e0h	; 7c50  ................
	defb 0e0h,0e3h,0e6h,0e2h,0e2h,0e2h,0e2h,0e2h,0e0h,0e6h,0e3h,0e2h,0e2h,0e2h,0e2h,0e2h	; 7c60  ................
	defb 0e2h,0e2h,0e2h,0e2h,0e6h,0e3h,0e3h,0e0h,0e2h,0e2h,0e2h,0e2h,0e2h,0e3h,0e6h,0e0h	; 7c70  ................
	defb 0c0h,0c2h,0c0h,0c0h,0c0h,030h,030h,030h,0c0h,0c2h,0c0h,0c0h,0c0h,030h,030h,030h	; 7c80  .....000.....000
	defb 030h,030h,030h,0c0h,0c0h,0c0h,0c2h,0c0h,030h,030h,030h,0c0h,0c0h,0c0h,0c2h,0c0h	; 7c90  000.....000.....
	defb 0f0h,0feh,0f0h,0f0h,0f0h,0b0h,0b0h,0b0h,0f0h,0feh,0f0h,0f0h,0f0h,0b0h,0b0h,0b0h	; 7ca0  ................
	defb 0b0h,0b0h,0b0h,0f0h,0f0h,0f0h,0feh,0f0h,0b0h,0b0h,0b0h,0f0h,0f0h,0f0h,0feh,0f0h	; 7cb0  ................
	defb 050h,054h,050h,050h,050h,070h,070h,070h,050h,054h,050h,050h,050h,070h,070h,070h	; 7cc0  PTPPPpppPTPPPppp
	defb 070h,070h,070h,050h,050h,050h,054h,050h,070h,070h,070h,050h,050h,050h,054h,050h	; 7cd0  pppPPPTPpppPPPTP
	defb 060h,086h,060h,060h,060h,090h,090h,090h,060h,086h,060h,060h,060h,090h,090h,090h	; 7ce0  `.```...`.```...
	defb 090h,090h,090h,060h,060h,060h,086h,060h,090h,090h,090h,060h,060h,060h,086h,060h	; 7cf0  ...```.`...```.`
	defb 000h,03eh,063h,063h,073h,073h,073h,03eh,000h,00ch,01ch,02ch,00ch,00ch,00ch,03fh	; 7d00  .>ccsss>...,...?
	defb 000h,03eh,047h,003h,00eh,030h,060h,07fh,000h,03eh,047h,003h,01eh,003h,047h,03eh	; 7d10  .>G..0`..>G...G>
	defb 000h,00eh,016h,026h,046h,04eh,07fh,006h,000h,07fh,070h,060h,07eh,007h,007h,07eh	; 7d20  ...&FN....p`~..~
	defb 000h,03eh,063h,060h,07eh,063h,067h,03eh,000h,07fh,047h,003h,006h,00ch,018h,018h	; 7d30  .>c`~cg>..G.....
	defb 000h,03eh,063h,067h,03eh,063h,067h,03eh,000h,03eh,063h,067h,03fh,003h,047h,03eh	; 7d40  .>cg>cg>.>cg?.G>
	defb 000h,000h,00ch,00ch,000h,00ch,00ch,000h,000h,000h,000h,000h,000h,000h,060h,060h	; 7d50  ..............``
	defb 000h,006h,00ch,018h,030h,018h,00ch,006h,000h,000h,000h,07eh,000h,07eh,000h,000h	; 7d60  ....0......~.~..
	defb 000h,008h,01ch,036h,07fh,07fh,05dh,008h,000h,03eh,067h,003h,01eh,018h,000h,018h	; 7d70  ...6..]..>g.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,01ch,03eh,063h,063h,073h,06fh,063h	; 7d80  ..........>ccsoc
	defb 000h,07eh,063h,073h,06eh,063h,063h,07eh,000h,03eh,063h,063h,070h,073h,073h,03eh	; 7d90  .~csncc~.>ccpss>
	defb 000h,07eh,063h,063h,073h,073h,073h,07eh,000h,07fh,060h,07ch,063h,060h,060h,07fh	; 7da0  .~ccsss~..`|c``.
	defb 000h,07fh,060h,07ch,063h,060h,060h,060h,000h,03eh,073h,073h,070h,067h,067h,03fh	; 7db0  ..`|c```.>sspgg?
	defb 000h,063h,063h,07fh,067h,063h,063h,063h,000h,018h,018h,018h,01ch,01ch,01ch,01ch	; 7dc0  .cc.gccc........
	defb 000h,007h,007h,007h,003h,063h,063h,03fh,000h,063h,063h,064h,078h,074h,073h,073h	; 7dd0  .....cc?.ccdxtss
	defb 000h,060h,060h,060h,070h,070h,073h,07fh,000h,07eh,07bh,07bh,06bh,06bh,06bh,06bh	; 7de0  .```pps..~{{kkkk
	defb 000h,066h,07bh,073h,063h,063h,063h,063h,000h,03eh,06bh,06fh,063h,07bh,06bh,03eh	; 7df0  .f{scccc.>koc{k>
	defb 000h,07eh,063h,063h,063h,066h,078h,060h,000h,03eh,073h,073h,073h,06bh,067h,03eh	; 7e00  .~cccfx`.>ssskg>
	defb 000h,07eh,063h,063h,067h,07ch,067h,063h,000h,03eh,073h,070h,03eh,007h,067h,03eh	; 7e10  .~ccg|gc.>sp>.g>
	defb 000h,07fh,018h,018h,018h,01ch,01ch,01ch,000h,063h,063h,063h,073h,073h,073h,03eh	; 7e20  .........cccsss>
	defb 000h,077h,063h,063h,077h,036h,036h,01ch,000h,06bh,06bh,06bh,06bh,06fh,06fh,07eh	; 7e30  .wccw66..kkkkoo~
	defb 000h,063h,027h,03eh,01ch,038h,07ch,067h,000h,043h,026h,01ch,018h,018h,01ch,01ch	; 7e40  .c'>.8|g.C&.....
	defb 000h,07fh,063h,004h,018h,018h,023h,07fh,000h,000h,000h,000h,000h,000h,000h,000h	; 7e50  ..c...#.........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7e60  ................
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 7e70  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e80  ................
	defb 0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h,0f0h	; 7e90  ................
	defb 07fh,07fh,07fh,0ffh,07fh,0ffh,0ffh,07fh,07fh,07fh,07fh,0ffh,07fh,07fh,0e7h,0efh	; 7ea0  ................
	defb 0feh,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0efh,0e7h,07fh,07fh,0ffh,07fh,07fh,0ffh,07fh	; 7eb0  ................
	defb 07fh,07fh,07fh,07fh,07fh,07fh,0ffh,07fh,07fh,07fh,0ffh,0ffh,0ffh,07fh,07fh,07fh	; 7ec0  ................
	defb 0e7h,0feh,0e7h,0efh,0efh,0ffh,0ffh,0ffh,07fh,07fh,07fh,0ffh,07fh,0e7h,0efh,0feh	; 7ed0  ................
	defb 0e7h,07fh,07fh,0ffh,07fh,07fh,0ffh,07fh,07fh,07fh,0ffh,0ffh,07fh,07fh,07fh,0e7h	; 7ee0  ................
	defb 0e7h,0feh,0e7h,0efh,0efh,0ffh,0ffh,0ffh,0ffh,0f7h,07fh,0ffh,07fh,0ffh,0ffh,07fh	; 7ef0  ................
	defb 0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0feh,0e7h,0feh,0e7h	; 7f00  ................
	defb 0feh,0e7h,0e7h,0feh,0e7h,07fh,0ffh,07fh,07fh,07fh,0ffh,0ffh,0feh,0e7h,0e7h,0e7h	; 7f10  ................
	defb 0ffh,0ffh,0ffh,0f7h,0f7h,0f7h,0f7h,0feh,0efh,0feh,0feh,0feh,0feh,0feh,0feh,0feh	; 7f20  ................
	defb 0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0feh,0efh,0e7h,0feh,0feh,0feh,0f7h,0f7h	; 7f30  ................
	defb 0f7h,0f7h,0f7h,0f7h,0f7h,0f7h,0ffh,0f7h,0f7h,0f7h,0e7h,0feh,0feh,0feh,0feh,0e7h	; 7f40  ................
	defb 0e7h,0feh,0e7h,0feh,0feh,0efh,0feh,0feh,0ffh,0ffh,0f7h,0f7h,07fh,07fh,07fh,07fh	; 7f50  ................
	defb 07fh,07fh,07fh,07fh,07fh,0ffh,0ffh,07fh,0ffh,07fh,07fh,07fh,07fh,07fh,07fh,07fh	; 7f60  ................
	defb 07fh,0ffh,07fh,07fh,07fh,07fh,07fh,07fh,0ffh,07fh,07fh,0ffh,07fh,07fh,07fh,0efh	; 7f70  ................
	defb 0feh,0efh,0efh,07fh,07fh,07fh,07fh,0ffh,0ffh,07fh,07fh,0ffh,07fh,07fh,07fh,0efh	; 7f80  ................
	defb 0e7h,0e7h,0feh,0e7h,0e7h,0feh,0efh,0efh,0ffh,0ffh,0ffh,0ffh,0f7h,0f7h,0f7h,07fh	; 7f90  ................
	defb 0ffh,07fh,07fh,0ffh,07fh,07fh,0e7h,0e7h,0feh,0e7h,0e7h,0efh,0e7h,0e7h,0e7h,0ffh	; 7fa0  ................
	defb 0ffh,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0feh,0feh	; 7fb0  ................
	defb 0f7h,0f7h,0f7h,0f7h,07fh,0f7h,0ffh,07fh,0feh,0e7h,0e7h,0e7h,0e7h,0feh,0e7h,0e7h	; 7fc0  ................
	defb 0e7h,0ffh,07fh,07fh,07fh,07fh,07fh,07fh,0ffh,07fh,07fh,0ffh,07fh,0e7h,0efh,0e7h	; 7fd0  ................
	defb 0feh,0e7h,0e7h,0feh,0efh,0efh,0feh,0feh,0feh,0efh,0e7h,0f7h,0f7h,0f7h,07fh,07fh	; 7fe0  ................
	defb 0ffh,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0e7h,0feh,0e7h,0feh,0e7h	; 7ff0  ................

; ======================================================================
; CODIGO 0x8000..0x880f  (2063 bytes)
; ======================================================================


arranque_nop:		; 16 "nop": INIT (0x4035) salta a 0x8010, detras
	nop			;8000   ; 16 "nop": INIT salta aqui (0x4035)
	nop			;8001   ; nop
	nop			;8002
	nop			;8003
	nop			;8004
	nop			;8005
	nop			;8006
	nop			;8007
	nop			;8008
	nop			;8009
	nop			;800a
	nop			;800b
	nop			;800c
	nop			;800d
	nop			;800e
	nop			;800f   ; el ultimo nop
arranque:		; El arranque: la RAM de 0xE001 a cero (0xE000, lo de INIT, pasa a 0xE060), la pila, la interrupcion en H.TIMI (0x8B09), SCREEN 2 en negro, las letras (0x7D00), los colores, los sprites, el registro 1 y el record a 50.000
	call 00041h		;8010   ; DISSCR
	ld hl,0e001h		;8013   ; la RAM desde 0xE001...
	ld bc,0137fh		;8016   ; ...0x137F bytes
arranque_borra:
	ld (hl),000h		;8019   ; a cero
	inc hl			;801b   ; la siguiente
	dec c			;801c
	jr nz,arranque_borra		;801d
	djnz arranque_borra		;801f   ; 0x13 vueltas de 256
	ld a,(0e000h)		;8021   ; Stone of Wisdom en otro slot (lo de INIT)...
	ld (0e060h),a		;8024   ; ...en 0xE060
	xor a			;8027   ; 0xE000 = 0: no se juega
	ld (0e000h),a		;8028
	ld sp,0f380h		;802b   ; la pila
	ld hl,08b09h		;802e   ; la interrupcion: 0x8B09...
	ld (0fda0h),hl		;8031   ; ...en H.TIMI...
	ld a,0c3h		;8034   ; ...con su "jp"
	ld (0fd9fh),a		;8036   ; ...0xFD9F
	call 0007eh		;8039   ; SETGRP: SCREEN 2
	xor a			;803c   ; fondo y borde negros...
	ld (0f3eah),a		;803d   ; BAKCLR = 0
	ld (0f3ebh),a		;8040   ; BDRCLR = 0
	dec a			;8043   ; ...letras blancas (0xFF)
	ld (0f3e9h),a		;8044   ; FORCLR = 0xFF
	call 00062h		;8047   ; CHGCLR
	call letras_pon		;804a   ; las letras (0x7D00) en los tres tercios
	ld hl,02000h		;804d   ; la tabla de colores entera...
	ld bc,01800h		;8050   ; ...0x1800 bytes...
	ld a,0f0h		;8053   ; ...blanco sobre negro
	call 00056h		;8055   ; FILVRM
	call sprites_dibujos		;8058   ; los dibujos de los sprites
	ld hl,0fbf0h		;805b   ; 0xFBF0...
	ld (0f3f8h),hl		;805e   ; ...en 0xF3F8 y 0xF3FA (el buffer del teclado vacio)
	ld (0f3fah),hl		;8061   ; (KEYBUF: el teclado vacio)
	ld bc,0a201h		;8064   ; el registro 1: 0xA2 (sprites de 16 x 16)
	call 00047h		;8067   ; WRTVDP
	ld a,005h		;806a   ; el record: 0xE030 = 5...
	ld (0e030h),a		;806c
	ld a,050h		;806f   ; ...y 0xE035 = 0x50: 050000
	ld (0e035h),a		;8071
	ei			;8074   ; con interrupciones
titulo:		; El titulo: el sonido a cero, la pantalla, las casillas del titulo, la presentacion de CASIO; TAB (0xE03A = 2) y CAPS (0xE039 = 2) sostenidas; el nombre (0x8F47), CASIO, PUSH TRIG:1 OR SPACE, el copyright y GAME START, la musica 8; con el boton, la partida; si no, la demostracion
	call sonido_reinicia		;8075   ; el sonido a cero
	call pantalla_limpia		;8078   ; la pantalla limpia
	call titulo_casillas		;807b   ; las casillas del titulo
	call 00044h		;807e   ; ENASCR
	call presentacion		;8081   ; la presentacion de CASIO
	ld a,007h		;8084   ; la fila 7...
	call 00141h		;8086   ; SNSMAT
	bit 3,a		;8089   ; TAB (bit 3)?
	jr nz,L_8092		;808b   ; suelta
	ld a,002h		;808d   ; pulsada: 0xE03A = 2
	ld (0e03ah),a		;808f
L_8092:
	ld a,006h		;8092   ; la fila 6...
	call 00141h		;8094
	bit 3,a		;8097   ; CAPS (bit 3)?
	jr nz,titulo_textos		;8099   ; suelta
	ld a,002h		;809b   ; pulsada: 0xE039 = 2
	ld (0e039h),a		;809d
titulo_textos:		; El nombre en kanji, CASIO (0x8DEB) en la fila 5, PUSH TRIG:1 OR SPACE (0x8E04) en la 20, COPYRIGHT 1986 (0x8E18) en la 16 y GAME START (0x8DE1) en la 18; la musica 8 y su espera (el boton la corta)
	call nombre_pon		;80a0   ; el nombre
	ld hl,08debh		;80a3   ; CASIO
	ld de,018adh		;80a6   ; en la fila 5, columna 13
	ld bc,00006h		;80a9
	call 0005ch		;80ac
	ld hl,08e04h		;80af   ; PUSH TRIG:1 OR SPACE
	ld de,01a86h		;80b2   ; en la fila 20, columna 6
	ld bc,00014h		;80b5
	call 0005ch		;80b8
	ld hl,08e18h		;80bb   ; COPYRIGHT 1986 (c) CASIO
	ld de,01a05h		;80be   ; en la fila 16, columna 5
	ld bc,00016h		;80c1
	call 0005ch		;80c4
	ld de,01a4bh		;80c7   ; en la fila 18, columna 11
	ld hl,08de1h		;80ca   ; GAME START
	ld bc,0000ah		;80cd
	call 0005ch		;80d0
	call 00044h		;80d3   ; ENASCR
	xor a			;80d6   ; la cuenta a 0
	ld (0e010h),a		;80d7
	ld a,008h		;80da   ; la musica 8
	call musica_pide		;80dc
	call espera_musica		;80df   ; hasta que acabe (o el boton)
	ld a,(0e026h)		;80e2   ; el boton?
	and a			;80e5
	jr nz,partida_nueva		;80e6   ; si: la partida
demostracion:		; La demostracion: todo a cero, la lista de mandos desde 0x4000 (0xE037), AIR y POWER a 8 y una escena al azar (0-3)
	ld (0e03ah),a		;80e8   ; todo a cero
	ld (0e039h),a		;80eb
	ld (0e028h),a		;80ee
	ld (0e027h),a		;80f1
	ld (0e053h),a		;80f4
	ld hl,04000h		;80f7   ; los mandos de la demostracion: desde 0x4000
	ld (0e037h),hl		;80fa
	ld a,008h		;80fd   ; AIR...
	ld (0e057h),a		;80ff
	ld (0e058h),a		;8102   ; ...y POWER a 8
	ld a,r		;8105   ; al azar...
	and 003h		;8107   ; ...0-3...
	ld (0e003h),a		;8109   ; ...la escena
	jp escena_empieza		;810c   ; a jugarla
partida_nueva:		; La partida: jugando (0xE000 = 1), LEON a 2 (0xE001), 0xE003-0xE021 y 0xE040-0xE05F a cero, AIR a 0x30 y POWER a 0x10; con Stone of Wisdom en otro slot (0xE060), POWER a 0x20 y 0xE05A = 1
	xor a			;810f   ; la primera vez (0xE03D = 0)
	ld (0e03dh),a		;8110
	inc a			;8113   ; jugando...
	ld (0e000h),a		;8114   ; ...0xE000 = 1
	ld a,002h		;8117   ; LEON: 2...
	ld (0e001h),a		;8119   ; ...en 0xE001 (BCD)
	ld hl,0e003h		;811c   ; 0xE003-0xE021 a cero
	ld b,01fh		;811f
L_8121:
	ld (hl),000h		;8121
	inc hl			;8123
	djnz L_8121		;8124
	ld hl,0e040h		;8126   ; 0xE040-0xE05F a cero
	ld b,020h		;8129
L_812B:
	ld (hl),000h		;812b
	inc hl			;812d
	djnz L_812B		;812e
	ld a,030h		;8130   ; AIR a 0x30
	ld (0e057h),a		;8132
	ld a,010h		;8135   ; POWER a 0x10
	ld (0e058h),a		;8137
	ld a,(0e060h)		;813a   ; con Stone of Wisdom?
	and a			;813d
	jr z,escena_empieza		;813e   ; no
	ld a,020h		;8140   ; si: POWER a 0x20...
	ld (0e058h),a		;8142
	ld a,001h		;8145   ; ...y el arma 1 (0xE05A)
	ld (0e05ah),a		;8147
escena_empieza:		; Una escena (0xE003): la pantalla, el protagonista (0xE320) con su arma (0xE059, 0xE05A), el marcador, el mapa, los colores de la escena, la musica 2 (la primera vez) y la 3, y al bucle
	ld a,(0e003h)		;814a   ; la escena...
	ld (0e050h),a		;814d   ; ...en 0xE050
	call pantalla_limpia		;8150   ; la pantalla
	ld ix,0e320h		;8153   ; el protagonista
	ld a,(0e059h)		;8157   ; el arma (0xE059)...
	ld (ix+00eh),a		;815a
	ld a,(0e05ah)		;815d   ; ...y 0xE05A
	ld (ix+01eh),a		;8160
	call marcador		;8163   ; el marcador
	call pantalla_borde		;8166   ; el mapa
	ld (ix+000h),090h		;8169   ; en la Y 0x90...
	ld (ix+001h),058h		;816d   ; ...X 0x58...
	ld (ix+002h),000h		;8171   ; ...el dibujo 0...
	ld (ix+003h),005h		;8175   ; ...color 5
	ld (ix+012h),004h		;8179   ; el segundo sprite: 4...
	ld (ix+013h),007h		;817d   ; ...color 7
	ld (ix-00eh),00ch		;8181   ; los sprites de 0xE300 y 0xE310: 0x0C color 1 y 8 color 9
	ld (ix-00dh),001h		;8185
	ld (ix-01eh),008h		;8189
	ld (ix-01dh),009h		;818d
	call prota_sprites		;8191   ; los sprites
	call puntos_pon		;8194   ; los puntos
	call prota_vram		;8197   ; los sprites del protagonista
	ld a,0feh		;819a   ; el color 0xFE...
	call casillas_color		;819c   ; ...en las casillas 0x40-0x6F
	ld a,(0e003h)		;819f   ; la escena 2, 3 o 5...
	cp 002h		;81a2
	jr z,L_81AE		;81a4
	cp 003h		;81a6
	jr z,L_81AE		;81a8
	cp 005h		;81aa
	jr nz,L_81B1		;81ac
L_81AE:
	call casillas_5580		;81ae   ; ...otros dibujos (0x5580)
L_81B1:
	ld a,(0e003h)		;81b1   ; la escena...
	cp 001h		;81b4   ; 1: color 0x68
	jr z,L_81CB		;81b6
	cp 003h		;81b8   ; 3: 0xC3
	jr z,L_81C7		;81ba
	cp 005h		;81bc   ; 5: 0xE0 y mas dibujos (0x5500)
	jr nz,L_81D0		;81be
	call casillas_5500		;81c0
	ld a,0e0h		;81c3
	jr L_81CD		;81c5
L_81C7:
	ld a,0c3h		;81c7
	jr L_81CD		;81c9
L_81CB:
	ld a,068h		;81cb
L_81CD:
	call casillas_color		;81cd
L_81D0:
	ld a,(0e003h)		;81d0   ; el color de las casillas 0xA0-0xCF: 0x60 en la 0...
	ld b,060h		;81d3
	and a			;81d5
	jr z,L_81E4		;81d6
	ld b,030h		;81d8   ; ...0x30 en la 2...
	cp 002h		;81da
	jr z,L_81E4		;81dc
	ld b,0f0h		;81de   ; ...0xF0 en la 4
	cp 004h		;81e0
	jr nz,L_8200		;81e2
L_81E4:
	ld a,b			;81e4   ; en los tres tercios
	ld hl,02500h		;81e5
	ld bc,00180h		;81e8
	call 00056h		;81eb
	ld hl,02d00h		;81ee
	ld bc,00180h		;81f1
	call 00056h		;81f4
	ld hl,03500h		;81f7
	ld bc,00180h		;81fa
	call 00056h		;81fd
L_8200:
	call 00044h		;8200   ; ENASCR
	ld a,(0e03dh)		;8203   ; la primera vez?
	and a			;8206
	jr nz,L_8212		;8207
	inc a			;8209   ; ya no
	ld (0e03dh),a		;820a
	ld a,002h		;820d   ; la musica 2
	call musica_pide		;820f
L_8212:
	ld a,003h		;8212   ; la musica 3
	call musica_pide		;8214
	call espera_musica		;8217   ; hasta que acabe
	call sonido_fondo		;821a   ; el sonido de fondo
	xor a			;821d   ; las cuentas y los botones a cero
	ld (0e010h),a		;821e
	ld (0e022h),a		;8221
	ld (0e020h),a		;8224
	ld (0e026h),a		;8227
	ld (0e180h),a		;822a
	ld (0e013h),a		;822d
	ld a,(0e000h)		;8230   ; jugando?
	and a			;8233
	jr nz,bucle		;8234
	inc a			;8236   ; no: la demostracion (0xE027 = 1)
	ld (0e027h),a		;8237
bucle:		; El bucle: 0xE184, la escena acabada; 0xE183, la muerte; 0xE1B0 (F1), la muerte; 0xE1B2 (STOP), la pausa; y una vez por cuadro todo lo demas
	ld a,(0e184h)		;823a   ; la escena acabada?
	and a			;823d
	jp nz,escena_acabada		;823e
	ld a,(0e183h)		;8241   ; sin AIR?
	and a			;8244
	jp nz,muerte		;8245
	ld a,(0e1b0h)		;8248   ; F1?
	and a			;824b
	jp nz,muerte_va		;824c
	ld a,(0e1b2h)		;824f   ; STOP?
	and a			;8252
	jp nz,pausa		;8253
bucle_cuadro:		; Un cuadro: los sprites, el marcador; sin pausa (0xE1B4), el sonido de fondo, el parpadeo, el protagonista y todo lo demas
	ld a,(0e011h)		;8256   ; un cuadro?
	cp 001h		;8259
	jp c,bucle_sigue		;825b
	xor a			;825e   ; la cuenta a 0
	ld (0e011h),a		;825f
	call prota_vram		;8262   ; los sprites del protagonista
	call sprites_rota		;8265
	ld a,(0e1b4h)		;8268   ; en pausa?
	and a			;826b
	jr nz,pausa_cuadro		;826c
	call sonido_fondo		;826e
	call parpadeo		;8271
	call prota_coge		;8274
	call prota_mueve		;8277
	call prota_sprites		;827a
	call nada		;827d
	call disparo		;8280
	call puntos_pon		;8283
	call enemigos		;8286
	call objetos		;8289
	call casillas_cambia		;828c
	call air_tiempo		;828f
	call enemigos_salen		;8292
bucle_sigue:		; Jugando, al bucle; en la demostracion, el boton vuelve al titulo
	ld a,(0e000h)		;8295   ; jugando?
	and a			;8298
	jr nz,bucle		;8299
	ld a,(0e026h)		;829b   ; la demostracion: el boton?
	and a			;829e
	jr z,bucle		;829f
	jp titulo		;82a1   ; al titulo
pausa_cuadro:		; En pausa: el sprite de 0xE310 se ve 0x20 de cada 0x100 cuadros
	ld a,(0e017h)		;82a4   ; la cuenta de la pausa...
	cp 0e0h		;82a7   ; ...de 0xE0 en adelante...
	jr c,L_82B4		;82a9
	ld a,(ix-020h)		;82ab   ; ...el sprite de 0xE300...
	ld (ix-010h),a		;82ae   ; ...se ve
	jp pausa_sprites		;82b1
L_82B4:
	ld (ix-010h),0ech		;82b4   ; si no, fuera
	jp pausa_sprites		;82b8
pausa:		; STOP: la pausa (0xE1B4) cambia; al entrar, otros dibujos de sprites (0x5B80) y un marco de sprites alrededor del protagonista; al salir, los de siempre
	xor a			;82bb   ; STOP atendido
	ld (0e1b2h),a		;82bc
	ld a,(0e1b4h)		;82bf   ; la pausa...
	cpl			;82c2   ; ...al reves
	ld (0e1b4h),a		;82c3
	and a			;82c6
	jr nz,pausa_entra		;82c7
	call sprites_dibujos		;82c9   ; sale: los dibujos de siempre
	xor a			;82cc
	ld (0e017h),a		;82cd
	ld (ix+013h),007h		;82d0
	ld (ix-00dh),001h		;82d4
	ld (ix-01dh),009h		;82d8
	jr bucle_sigue		;82dc
pausa_entra:		; Entra: los dibujos de 0x5B80 y 0xE100-0xE14F a cero
	call sprites_pausa		;82de   ; los dibujos de la pausa
	ld hl,0e100h		;82e1
	ld b,050h		;82e4
L_82E6:
	ld (hl),000h		;82e6   ; a cero
	inc hl			;82e8   ; el siguiente
	djnz L_82E6		;82e9   ; 0x50 bytes
	ld a,(ix+000h)		;82eb   ; la Y del protagonista...
	ld (ix+010h),a		;82ee   ; ...en el segundo sprite
	sub 00ch		;82f1   ; 12 por encima...
	ld (ix-020h),a		;82f3   ; ...el sprite de 0xE300
	ld (ix+013h),009h		;82f6   ; color 9
	ld (ix+002h),000h		;82fa   ; el dibujo 0...
	ld (ix+012h),004h		;82fe   ; ...y 4
	ld (ix-010h),0ech		;8302   ; 0xE310 fuera
	ld (ix-00dh),00dh		;8306   ; color 13
	ld a,(ix+001h)		;830a   ; la X...
	cp 058h		;830d   ; ...a la derecha de 0x58?
	jr c,pausa_der		;830f
	sub 00ch		;8311   ; si: 12 a la izquierda
	ld (ix-01fh),a		;8313
	ld (ix-00fh),a		;8316
	ld (ix-01eh),008h		;8319
	ld (ix-01dh),001h		;831d
	ld (ix-00eh),010h		;8321
	jr pausa_sprites		;8325
pausa_der:		; A la izquierda de 0x58: 12 a la derecha
	add a,00ch		;8327   ; 12 a la derecha
	ld (ix-01fh),a		;8329
	ld (ix-00fh),a		;832c
	ld (ix-01eh),00ch		;832f
	ld (ix-01dh),001h		;8333
	ld (ix-00eh),014h		;8337
pausa_sprites:		; Los cuatro sprites de 0xE300 a la tabla
	ld hl,0e300h		;833b
	ld de,0e100h		;833e
	ld b,004h		;8341
	call sprites_vram_uno		;8343
	jp bucle_sigue		;8346
sonido_fondo:		; El sonido de fondo de la escena (efecto de B y C): 5 en la escena 1, 4 en la 3, 3 en la 5 y 6 en las demas; con 0xE18D, el 2, pero nadie pone 0xE18D (solo se borra con la RAM)
	ld a,(0e18dh)		;8349   ; 0xE18D (siempre 0)?
	and a			;834c
	jr z,L_8353		;834d
	ld a,002h		;834f   ; el 2
	jr L_8370		;8351
L_8353:
	ld a,(0e003h)		;8353   ; la escena
	cp 001h		;8356
	jr z,L_8366		;8358
	cp 003h		;835a
	jr z,L_836A		;835c
	cp 005h		;835e
	jr z,L_836E		;8360
	ld a,006h		;8362   ; las demas: el 6
	jr L_8370		;8364
L_8366:
	ld a,005h		;8366   ; la 1: el 5
	jr L_8370		;8368
L_836A:
	ld a,004h		;836a   ; la 3: el 4
	jr L_8370		;836c
L_836E:
	ld a,003h		;836e   ; la 5: el 3
L_8370:
	call efecto_pide		;8370
	ret			;8373
muerte:		; La muerte (0xE183: un enemigo, una bala, sin AIR o un agujero): con TAB en el titulo (0xE03A), nada (sigue); si no, el arma a 0, POWER - 8 (si pasa de 0x10) y la muerte
	ld a,(0e03ah)		;8374   ; TAB en el titulo?
	and a			;8377
	jr z,L_8381		;8378
	xor a			;837a   ; si: no muere
	ld (0e183h),a		;837b
	jp bucle_cuadro		;837e
L_8381:
	call sonido_reinicia		;8381   ; el sonido a cero
	xor a			;8384
	ld (0e010h),a		;8385
	ld (0e059h),a		;8388   ; el arma a 0
	ld (0e05ah),a		;838b
	ld a,(0e058h)		;838e   ; POWER...
	cp 010h		;8391   ; ...por debajo de 0x10: se queda
	jr c,muerte_va		;8393
	sub 008h		;8395   ; ...si no, 8 menos
	ld (0e058h),a		;8397
muerte_va:		; La muerte (o F1): el sonido 1 de B y C y el protagonista parpadeando 0x80 cuadros (dibujos 0xA8/0xAC y 0xB0/0xB4)
	ld a,(0e010h)		;839a   ; 2 cuadros
	cp 002h		;839d
	jr c,muerte_va		;839f
	ld a,001h		;83a1   ; el sonido 1 de B y C
	call efecto_pide		;83a3
	ld (ix-010h),0efh		;83a6   ; los sprites de 0xE300 y 0xE310 fuera
	ld (ix-020h),0efh		;83aa
	ld a,(ix+000h)		;83ae
	add a,008h		;83b1
	ld (ix+010h),a		;83b3
	ld (ix+003h),005h		;83b6   ; color 5...
	ld (ix+013h),001h		;83ba   ; ...y 1
muerte_cuadro:
	ld a,(0e010h)		;83be   ; un cuadro
	cp 001h		;83c1
	jr c,muerte_cuadro		;83c3
	xor a			;83c5   ; a cero
	ld (0e010h),a		;83c6
	ld a,(0e012h)		;83c9   ; cada 8 cuadros...
	and 008h		;83cc
	rrca			;83ce
	add a,0a8h		;83cf   ; ...0xA8 o 0xAC
	ld (ix+002h),a		;83d1
	ld a,(0e012h)		;83d4   ; cada 4...
	and 004h		;83d7
	add a,0b0h		;83d9   ; ...0xB0 o 0xB4
	ld (ix+012h),a		;83db
	call prota_vram		;83de   ; los sprites
	inc (ix+01eh)		;83e1   ; un cuadro mas
	ld a,(ix+01eh)		;83e4
	cp 080h		;83e7   ; 0x80?
	jr c,muerte_cuadro		;83e9
	ld a,(0e053h)		;83eb   ; 0xE053 como mucho 8
	cp 009h		;83ee
	jr c,L_83F4		;83f0
	ld a,008h		;83f2
L_83F4:
	ld (0e053h),a		;83f4
	ld a,(0e001h)		;83f7   ; LEON?
	and a			;83fa
	jr z,game_over_mira		;83fb   ; ninguno: GAME OVER
	sub 001h		;83fd   ; uno menos...
	daa			;83ff   ; ...en BCD
	ld (0e001h),a		;8400
	ld a,020h		;8403   ; AIR a 0x20
	ld (0e057h),a		;8405
	jp escena_empieza		;8408   ; la escena otra vez
game_over_mira:		; Sin LEON: con CAPS en el titulo (0xE039), LEON a 3 y otra vez; si no, GAME OVER
	ld a,(0e039h)		;840b   ; CAPS en el titulo?
	and a			;840e
	jp z,game_over		;840f   ; no: GAME OVER
	ld a,003h		;8412   ; si: LEON a 3
	ld (0e001h),a		;8414
	jp escena_empieza		;8417
game_over:		; GAME OVER (0x8E36) en la fila 11, columna 8, la musica 1 y al titulo
	call sprites_fuera		;841a   ; todo fuera
	call pantalla_cierra		;841d   ; la pantalla se cierra
	ld de,01968h		;8420   ; en la fila 11, columna 8
	ld hl,08e36h		;8423   ; GAME OVER
	ld bc,00009h		;8426
	call 0005ch		;8429
	ld a,001h		;842c   ; la musica 1
	call musica_pide		;842e
	call espera_musica		;8431   ; hasta que acabe
	xor a			;8434   ; ya no se juega
	ld (0e028h),a		;8435
	ld (0e000h),a		;8438
	ld (0e026h),a		;843b
	jp titulo		;843e   ; al titulo
escena_acabada:		; La escena acabada (0xE184), cuando acaba el parpadeo (0xE1C0): el arma guardada, todo fuera y la escena siguiente; tras la 5, el final
	ld a,(0e1c0h)		;8441   ; parpadeando?
	and a			;8444
	jp nz,bucle_cuadro		;8445   ; si: sigue
	xor a			;8448   ; atendida
	ld (0e184h),a		;8449
	ld (0e053h),a		;844c
	ld a,(ix+00eh)		;844f   ; el arma...
	ld (0e059h),a		;8452
	ld a,(ix+01eh)		;8455   ; ...guardada
	ld (0e05ah),a		;8458
	call todo_fuera		;845b   ; todo fuera
	ld a,(0e003h)		;845e   ; la escena + 1...
	add a,001h		;8461   ; ...en BCD
	daa			;8463
	ld (0e003h),a		;8464
	cp 006h		;8467   ; la 6?
	jp c,escena_siguiente		;8469   ; no: la siguiente
final:		; El final: la escena 0 y una vuelta mas (0xE004), la musica 7, cuatro sprites (0xFC, 0xF8, 0xF4 y 0xF0) que bajan de la Y 0xE0/0xF0 a la 0x40 de 1 en 1 cada 3 cuadros; el texto de 0x8E50 y la musica 7 una y otra vez hasta el boton
	xor a			;846c   ; la escena 0
	ld (0e003h),a		;846d
	ld a,(0e004h)		;8470   ; una vuelta mas (0xE004: nadie la lee)
	inc a			;8473
	ld (0e004h),a		;8474
	ld a,007h		;8477   ; la musica 7
	call musica_pide		;8479
	ld iy,0e380h		;847c   ; cuatro sprites en 0xE380...
	ld (iy+000h),0f0h		;8480   ; ...el primero: Y 0xF0, X 0x58, 0xFC, color 5
	ld (iy+001h),058h		;8484
	ld (iy+002h),0fch		;8488
	ld (iy+003h),005h		;848c
	ld (iy+004h),001h		;8490
	ld (iy+010h),0e0h		;8494   ; ...0xE0, 0xF8, color 5
	ld (iy+011h),058h		;8498
	ld (iy+012h),0f8h		;849c
	ld (iy+013h),005h		;84a0
	ld (iy+014h),001h		;84a4
	ld (iy+020h),0e0h		;84a8   ; ...0xE0, 0xF4, color 11
	ld (iy+021h),058h		;84ac
	ld (iy+022h),0f4h		;84b0
	ld (iy+023h),00bh		;84b4
	ld (iy+024h),001h		;84b8
	ld (iy+030h),0e0h		;84bc   ; ...0xE0, 0xF0, color 9
	ld (iy+031h),058h		;84c0
	ld (iy+032h),0f0h		;84c4
	ld (iy+033h),009h		;84c8
	ld (iy+034h),001h		;84cc
	xor a			;84d0   ; la cuenta a 0
	ld (0e010h),a		;84d1
final_baja:		; Cada 3 cuadros, los cuatro, 1 abajo, hasta la Y 0x40
	ld a,(0e010h)		;84d4   ; 3 cuadros
	cp 003h		;84d7
	jr c,final_baja		;84d9
	xor a			;84db
	ld (0e010h),a		;84dc
	call sprites_vram		;84df   ; los sprites
	inc (iy+000h)		;84e2   ; 1 abajo
	inc (iy+010h)		;84e5
	inc (iy+020h)		;84e8
	inc (iy+030h)		;84eb
	ld a,(iy+000h)		;84ee   ; el primero...
	cp 040h		;84f1   ; ...en la Y 0x40?
	jr nz,final_baja		;84f3
	ld a,007h		;84f5   ; la musica 7
	call musica_pide		;84f7
	call pantalla_cierra		;84fa   ; la pantalla se cierra
	call final_letras		;84fd   ; el marcador
	ld hl,08e50h		;8500   ; el texto del final (0x8E50): 16, 16, 14, 18, 5, 18 y 20 casillas en las filas 11-19
	ld de,01963h		;8503
	ld bc,00010h		;8506
	call 0005ch		;8509
	ex de,hl			;850c
	ld de,01983h		;850d
	ld bc,00010h		;8510
	call 0005ch		;8513
	ex de,hl			;8516
	ld de,019a3h		;8517
	ld bc,0000eh		;851a
	call 0005ch		;851d
	ex de,hl			;8520
	ld de,019c3h		;8521
	ld bc,00012h		;8524
	call 0005ch		;8527
	ex de,hl			;852a
	ld de,01a03h		;852b
	ld bc,00005h		;852e
	call 0005ch		;8531
	ex de,hl			;8534
	ld de,01a43h		;8535
	ld bc,00012h		;8538
	call 0005ch		;853b
	ex de,hl			;853e
	ld de,01a63h		;853f
	ld bc,00014h		;8542
	call 0005ch		;8545
	xor a			;8548   ; el boton a 0
	ld (0e026h),a		;8549
	ld (0e000h),a		;854c   ; ya no se juega
final_espera:		; La musica 7 una y otra vez hasta el boton; y al titulo
	ld a,007h		;854f   ; la musica 7
	call musica_pide		;8551
	call espera_musica		;8554   ; hasta que acabe
	ld a,(0e026h)		;8557   ; el boton?
	and a			;855a
	jr z,final_espera		;855b
	jp titulo		;855d   ; al titulo
escena_siguiente:		; Una escena mas: la musica 6, el marcador, todo fuera y AIR + 0x10 (hasta 0x30)
	ld a,006h		;8560   ; la musica 6
	call musica_pide		;8562
	call espera_musica		;8565
	call escena_pon		;8568   ; la escena en el marcador
	call todo_fuera		;856b   ; todo fuera
	ld a,(0e057h)		;856e   ; AIR...
	cp 030h		;8571   ; ...0x30 o mas: se queda
	jp nc,escena_empieza		;8573
	add a,010h		;8576   ; + 0x10...
	cp 030h		;8578
	jr c,L_857E		;857a   ; ...hasta 0x30
	ld a,030h		;857c
L_857E:
	ld (0e057h),a		;857e
	jp escena_empieza		;8581   ; a la escena
parpadeo:		; 0xE1C0: cada 2 cuadros, el borde (registro 7) blanco o negro, hasta acabar la cuenta
	ld a,(0e1c0h)		;8584   ; parpadeando?
	and a			;8587
	ret z			;8588
	ld a,(0e015h)		;8589   ; 2 cuadros?
	cp 002h		;858c
	ret c			;858e
	xor a			;858f
	ld (0e015h),a		;8590
	ld a,(0e1c0h)		;8593   ; uno menos
	dec a			;8596
	ld (0e1c0h),a		;8597
	and 001h		;859a   ; par o impar
	and a			;859c
	jr nz,borde_blanco		;859d
borde_negro:		; El registro 7 a 0: el borde negro
	ld bc,00007h		;859f
	jp 00047h		;85a2
borde_blanco:		; El registro 7 a 0x0F: blanco
	ld bc,00f07h		;85a5
	jp 00047h		;85a8
todo_fuera:		; 0xE340-0xE4FF a cero y sus 28 sprites fuera (Y 0xEC)
	ld hl,0e340h		;85ab   ; 0xE340...
	ld bc,001c0h		;85ae   ; ...0x1C0 bytes
L_85B1:
	ld (hl),000h		;85b1
	inc hl			;85b3
	dec bc			;85b4
	ld a,c			;85b5
	or b			;85b6
	jr nz,L_85B1		;85b7
	ld hl,0e340h		;85b9   ; los 28...
	ld de,00010h		;85bc
	ld b,01ch		;85bf
L_85C1:
	ld (hl),0ech		;85c1   ; ...fuera
	add hl,de			;85c3
	djnz L_85C1		;85c4
	jp sprites_vram		;85c6
otro_borra_va:
	push iy		;85c9   ; sus 16 bytes...
	pop hl			;85cb   ; su principio
	ld b,010h		;85cc   ; 16 bytes
otro_borra_byte:
	ld (hl),000h		;85ce   ; ...a cero
	inc hl			;85d0
	djnz otro_borra_byte		;85d1
	ld (iy+000h),0ech		;85d3   ; fuera (Y 0xEC)
	ret			;85d7   ; listo
cerca_y:		; ¿Toca en Y? A = la Y de IY menos la del protagonista (IX): C (toca) si, con signo, queda entre C - 0x100 y B - 1 (B, el margen por un lado; C, 0x100 menos el del otro)
	ld a,(iy+000h)		;85d8   ; la Y del otro...
	sub (ix+000h)		;85db   ; ...menos la del protagonista
cerca_mira:
	cp b			;85de   ; menos que B (de 0 a B - 1)...
	ret c			;85df   ; ...toca: C
	cp c			;85e0   ; C o mas (de C - 0x100 a -1)?
	jr c,L_85E5		;85e1   ; no: a NC
	scf			;85e3   ; si: toca (C)
	ret			;85e4   ; C
L_85E5:
	xor a			;85e5   ; no toca: NC
	ret			;85e6
cerca_x:		; ¿Toca en X? A = la X de IY menos la del protagonista (IX): C si queda entre C - 0x100 y B - 1, como cerca_y
	ld a,(iy+001h)		;85e7   ; la X de IY...
	sub (ix+001h)		;85ea   ; ...menos la de IX
	jr cerca_mira		;85ed   ; a comparar
pantalla_limpia:		; La pantalla apagada, el registro 2 a 6, el borde negro, la tabla de nombres en blanco, la RAM a cero, los botones a 0 y los dibujos y colores de la escena
	call 00041h		;85ef   ; DISSCR
	ld bc,00602h		;85f2   ; el registro 2 (la tabla de nombres) a 6
	call 00047h		;85f5
	call borde_negro		;85f8   ; el borde negro
	call nombres_borra		;85fb   ; la tabla de nombres en blanco
	call ram_escena		;85fe   ; la RAM
	xor a			;8601   ; los botones a 0
	ld (0e026h),a		;8602   ; los botones a 0
	ld (0e020h),a		;8605   ; el boton 2
	ld (0e022h),a		;8608   ; el boton 1
	ld (0e024h),a		;860b   ; 0xE024
	ld (0e180h),a		;860e   ; la palanca
casillas_escena:		; Los dibujos (0x5300) y colores (0x5B00) de las casillas 0x30-0x7F; los de 0x80-0xFF; 0x5580 y 0x5380 en las 0x40-0x7F; los sprites
	ld hl,05300h		;8611   ; los dibujos de 0x5300...
	ld de,00180h		;8614   ; ...a la casilla 0x30...
	ld bc,00280h		;8617   ; ...0x280 bytes
	call tercios_va		;861a
	ld hl,05b00h		;861d   ; sus colores (0x5B00)
	ld de,02180h		;8620
	ld bc,00280h		;8623
	call tercios_va		;8626
	call casillas_altas		;8629   ; las casillas 0x80-0xFF
	call casillas_5580		;862c   ; las 0x40-0x7F (0x5580)
	call casillas_5380		;862f   ; las 0x40-0x6F (0x5380)
	jp sprites_dibujos		;8632   ; los sprites
casillas_cambia:		; Con 0xE1BE (1-4), otro juego de dibujos para las casillas 0x80-0xFF: 1, el de la escena; 2, 0x6000; 3, 0x6400; 4, 0x7000
	ld a,(0e1beh)		;8635   ; 0xE1BE?
	and a			;8638   ; nada?
	ret z			;8639
	cp 001h		;863a   ; 1: los de la escena
	jr z,casillas_1		;863c
	cp 002h		;863e   ; 2
	jr z,casillas_2		;8640
	cp 003h		;8642   ; 3
	jr z,casillas_3		;8644
	cp 004h		;8646   ; 4
	jr z,casillas_4		;8648
casillas_altas:		; Las casillas 0x80-0xFF: dibujos de 0x7400 y colores de 0x7C00
	ld hl,07400h		;864a   ; los dibujos (0x7400)...
	ld de,00400h		;864d   ; ...a la casilla 0x80
	ld bc,00400h		;8650   ; 0x400 bytes
	call tercios_va		;8653   ; en los tres tercios
	ld hl,07c00h		;8656   ; los colores (0x7C00)
casillas_altas_col:		; Los colores de HL a las casillas 0x80-0xFF y 0xE1BE a 0
	ld de,02400h		;8659   ; a los colores de la casilla 0x80
	ld bc,00400h		;865c   ; 0x400 bytes
	call tercios_va		;865f   ; en los tres tercios
	xor a			;8662   ; atendido
	ld (0e1beh),a		;8663
	ret			;8666
casillas_4:		; 4: 0x7000 y 0x7800
	ld hl,07000h		;8667   ; los dibujos de 0x7000
	ld de,00400h		;866a
	ld bc,00400h		;866d
	call tercios_va		;8670
	ld hl,07800h		;8673   ; los colores de 0x7800
	jr casillas_altas_col		;8676
casillas_3:		; 3: 0x6400 y 0x6C00
	ld hl,06400h		;8678   ; los dibujos de 0x6400
	ld de,00400h		;867b
	ld bc,00400h		;867e
	call tercios_va		;8681
	ld hl,06c00h		;8684   ; los colores de 0x6C00
	jr casillas_altas_col		;8687
casillas_2:		; 2: 0x6000 y 0x6800
	ld hl,06000h		;8689   ; los dibujos de 0x6000
	ld de,00400h		;868c
	ld bc,00400h		;868f
	call tercios_va		;8692
	ld hl,06800h		;8695   ; los colores de 0x6800
	jr casillas_altas_col		;8698
casillas_1:		; 1: los de la escena
	xor a			;869a
	ld (0e1beh),a		;869b
	jp casillas_escena		;869e
casillas_5380:		; Las casillas 0x40-0x6F: 0x5380 y sus colores 0x5B80
	ld hl,05380h		;86a1   ; los dibujos de 0x5380...
	ld de,00200h		;86a4   ; ...a la casilla 0x40
	ld bc,00180h		;86a7   ; 0x180 bytes
	call tercios_va		;86aa   ; en los tres tercios
	ld hl,05b80h		;86ad   ; sus colores (0x5B80)
	ld de,02200h		;86b0
	ld bc,00180h		;86b3
	call tercios_va		;86b6
	xor a			;86b9   ; atendido
	ld (0e1beh),a		;86ba
	ret			;86bd
casillas_5500:		; Las casillas 0x70-0x7F: 0x5500 y 0x5D00
	ld hl,05500h		;86be   ; los dibujos de 0x5500...
	ld de,00380h		;86c1   ; ...a la casilla 0x70
	ld bc,00080h		;86c4   ; 0x80 bytes
	call tercios_va		;86c7
	ld hl,05d00h		;86ca   ; sus colores (0x5D00)
	ld de,02380h		;86cd
	ld bc,00080h		;86d0
	jp tercios_va		;86d3
casillas_5580:		; Las casillas 0x40-0x7F: 0x5580 y 0x5D80
	ld hl,05580h		;86d6   ; los dibujos de 0x5580...
	ld de,00200h		;86d9   ; ...a la casilla 0x40
	ld bc,00200h		;86dc   ; 0x200 bytes
	call tercios_va		;86df
	ld hl,05d80h		;86e2   ; sus colores (0x5D80)
	ld de,02200h		;86e5
	ld bc,00200h		;86e8
	call tercios_va		;86eb
	xor a			;86ee   ; atendido
	ld (0e1beh),a		;86ef
	ret			;86f2
casillas_color:		; El color A en las casillas 0x40-0x6F de los tres tercios
	ld hl,02200h		;86f3   ; los colores de la casilla 0x40...
	ld bc,00180h		;86f6   ; ...0x180 bytes
	call 00056h		;86f9   ; FILVRM
	ld hl,02a00h		;86fc   ; el segundo tercio
	ld bc,00180h		;86ff
	call 00056h		;8702
	ld hl,03200h		;8705   ; el tercero
	ld bc,00180h		;8708
	jp 00056h		;870b
marcador:		; El marcador: HISCORE: (0x8E2E), SCORE (0x8E30), el 0 fijo de los dos, AIR (0x8DD4... ENERGY), POWER, las barras, los corazones, LEON y SCENE
	ld de,01818h		;870e   ; HISCORE en la fila 0, columna 24
	ld hl,08e2eh		;8711   ; HISCORE
	ld bc,00007h		;8714   ; siete
	call 0005ch		;8717
	ld de,0187ah		;871a   ; SCORE en la fila 3, columna 26
	ld hl,08e30h		;871d   ; SCORE
	ld bc,00005h		;8720   ; cinco
	call 0005ch		;8723
	ld hl,0183eh		;8726   ; el 0 fijo del record...
	xor a			;8729
	call 0004dh		;872a
	ld hl,0189eh		;872d   ; ...y de los puntos
	xor a			;8730
	call 0004dh		;8731
	ld de,01939h		;8734   ; POWER (0x8DD4) en la fila 9, columna 25
	ld hl,08dd4h		;8737
	ld bc,00005h		;873a
	call 0005ch		;873d
	ld de,018d9h		;8740   ; AIR (0x8DD9) en la fila 6
	ld hl,08dd9h		;8743
	ld bc,00004h		;8746
	call 0005ch		;8749
	call air_barra		;874c   ; la barra de AIR
	call power_barra		;874f   ; la de POWER
	call corazones_marca		;8752   ; los corazones
	call leon_pon		;8755   ; LEON
	call escena_pon		;8758   ; SCENE
	ret			;875b
corazones_marca:		; El corazon (0x30) y "=" en la fila 12, columna 25; y las dos cifras de 0xE054
	ld hl,01999h		;875c   ; en la fila 12, columna 25
	ld a,030h		;875f   ; el corazon
	call 0004dh		;8761
	inc hl			;8764
	ld a,00dh		;8765   ; el "="
	call 0004dh		;8767
corazones_cifras:		; Las dos cifras BCD de los corazones (0xE054)
	ld hl,0199bh		;876a   ; en la fila 12, columna 27
	ld a,(0e054h)		;876d   ; los corazones...
	and 0f0h		;8770   ; ...la cifra alta
	rrca			;8772
	rrca			;8773
	rrca			;8774
	rrca			;8775
	call 0004dh		;8776   ; WRTVRM
	inc hl			;8779
	ld a,(0e054h)		;877a   ; la baja
	and 00fh		;877d
	call 0004dh		;877f   ; WRTVRM
	ret			;8782
corazon_suma:		; Un corazon mas (0xE054 en BCD hasta 99, 0xE055 en binario)
	ld a,(0e054h)		;8783   ; los corazones
	cp 099h		;8786   ; 99: no hay mas
	ret z			;8788
	add a,001h		;8789   ; + 1...
	daa			;878b   ; ...en BCD
	ld (0e054h),a		;878c
	ld a,(0e055h)		;878f   ; y en binario
	inc a			;8792
	ld (0e055h),a		;8793
	jr corazones_cifras		;8796
corazon_resta:		; Un corazon menos (si hay)
	ld a,(0e054h)		;8798
	and a			;879b   ; ninguno: nada
	ret z			;879c
	sub 001h		;879d
	daa			;879f
	ld (0e054h),a		;87a0
	ld a,(0e055h)		;87a3
	dec a			;87a6
	ld (0e055h),a		;87a7
	jr corazones_cifras		;87aa
air_barra:		; La barra de AIR (0xE057) en la fila 7, columna 24
	ld hl,018f8h		;87ac
	ld a,032h		;87af   ; su punta (0x32)
	call barra_vacia		;87b1
	ld hl,018f8h		;87b4
	ld a,(0e057h)		;87b7   ; AIR
	jp barra_llena		;87ba
power_barra:		; La barra de POWER (0xE058) en la fila 10; el arma por POWER: 0x20 o mas, 0xE05A = 1; 0x28, el arma 1; 0x30, la 2; 0x38, la 3
	ld hl,01959h		;87bd
	ld a,010h		;87c0
	call barra_siete		;87c2
	ld hl,01959h		;87c5
	ld a,(0e058h)		;87c8   ; POWER
	cp 020h		;87cb   ; 0x20 o mas?
	jr c,L_87D7		;87cd
	ld a,001h		;87cf   ; si: 0xE05A = 1
	ld (0e05ah),a		;87d1
	ld (ix+01eh),a		;87d4
L_87D7:
	ld a,(0e058h)		;87d7
	cp 038h		;87da   ; 0x38: el arma 3
	jr z,L_87EB		;87dc
	cp 030h		;87de   ; 0x30: la 2
	jr nc,L_87EF		;87e0
	cp 028h		;87e2   ; 0x28: la 1
	jr nc,L_87FA		;87e4
	ld a,(ix+00eh)		;87e6   ; menos: la que tenga
	jr L_8803		;87e9
L_87EB:
	ld a,003h		;87eb
	jr L_8803		;87ed
L_87EF:
	ld a,(ix+00eh)		;87ef
	cp 003h		;87f2
	jr nc,L_8803		;87f4
	ld a,002h		;87f6
	jr L_8803		;87f8
L_87FA:
	ld a,(ix+00eh)		;87fa
	cp 002h		;87fd
	jr nc,L_8803		;87ff
	ld a,001h		;8801
L_8803:
	ld (ix+00eh),a		;8803   ; el arma, en +0x0E...
	ld (0e059h),a		;8806   ; ...y en 0xE059
	ld a,(0e058h)		;8809   ; la barra
	jp barra_power		;880c

; ----------------------------------------------------------------------
; DATOS sobra_880f: 3 bytes que nadie ejecuta (call WRTVRM detras de un jp);
;   sin uso por lectura estatica y por la medida de cobertura
;   0x880f..0x8812  (3 bytes)
DATA_sobra_880f:
	defb 0cdh,04dh,000h	; 880f

; ======================================================================
; CODIGO 0x8812..0x885e  (76 bytes)
; ======================================================================


barra_vacia:		; La punta A+1 y siete casillas A
	inc hl			;8812
	inc a			;8813
barra_siete:		; Siete casillas A
	ld b,007h		;8814   ; siete
L_8816:
	call 0004dh		;8816
	inc hl			;8819
	djnz L_8816		;881a
	ret			;881c
barra_llena:		; A en octavos: A / 8 casillas llenas (0x3B) y una con el resto (0x33 + resto)
	ld b,000h		;881d
L_881F:
	sub 008h		;881f   ; 8 menos
	jr c,L_8826		;8821
	inc b			;8823   ; una llena mas
	jr L_881F		;8824
L_8826:
	add a,008h		;8826   ; el resto
	ld c,a			;8828
	ld a,b			;8829   ; llenas?
	and a			;882a
	jr z,L_8835		;882b
	ld a,03bh		;882d   ; la llena
L_882F:
	call 0004dh		;882f
	inc hl			;8832
	djnz L_882F		;8833
L_8835:
	ld a,c			;8835
	add a,033h		;8836
	call 0004dh		;8838
	ret			;883b
barra_power:		; POWER en octavos: llenas 0x31 y media (0x32) si el resto llega a 4
	ld b,000h		;883c
L_883E:
	sub 008h		;883e   ; 8 menos
	jr c,L_8845		;8840
	inc b			;8842   ; una llena mas
	jr L_883E		;8843
L_8845:
	add a,008h		;8845   ; el resto
	ld c,a			;8847
	ld a,b			;8848
	and a			;8849
	jr z,L_8854		;884a
	ld a,031h		;884c   ; la llena
L_884E:
	call 0004dh		;884e
	inc hl			;8851
	djnz L_884E		;8852
L_8854:
	ld a,c			;8854
	cp 004h		;8855   ; menos de 4: nada
	ret c			;8857
	ld a,032h		;8858   ; la media
	call 0004dh		;885a
	ret			;885d

; ----------------------------------------------------------------------
; DATOS sobra_885e: 18 bytes de codigo que nadie ejecuta (POWER - 1 con el
;   sonido 4); ningun salto llega y la medida de cobertura no pasa
;   0x885e..0x8870  (18 bytes)
DATA_sobra_885e:
	defb 03eh,004h,0cdh,05eh,0adh,03ah,058h,0e0h,03dh,0feh,0ffh,0c8h,032h,058h,0e0h,0c3h	; 885e  >..^.:X.=...2X..
	defb 0bdh,087h	; 886e

; ======================================================================
; CODIGO 0x8870..0x8890  (32 bytes)
; ======================================================================


power_suma8:		; POWER + 8 (hasta 0x38), el sonido 1 y la barra
	ld a,(0e058h)		;8870
	add a,008h		;8873
power_pon:		; POWER = A, hasta 0x38
	ld (0e058h),a		;8875
	cp 038h		;8878
	jr c,L_8881		;887a
	ld a,038h		;887c
	ld (0e058h),a		;887e
L_8881:
	ld a,001h		;8881
	call sonido_a_pide		;8883
	jp power_barra		;8886
power_suma2:		; POWER + 2
	ld a,(0e058h)		;8889
	add a,002h		;888c
	jr power_pon		;888e

; ----------------------------------------------------------------------
; DATOS sobra_8890: 5 bytes que nadie ejecuta (el sonido 4)
;   0x8890..0x8895  (5 bytes)
DATA_sobra_8890:
	defb 03eh,004h,0cdh,05eh,0adh	; 8890

; ======================================================================
; CODIGO 0x8895..0x8948  (179 bytes)
; ======================================================================


air_resta:		; AIR - 1; acabado, 0xE183 = 1 (la muerte)
	ld a,(0e057h)		;8895
	dec a			;8898   ; menos 1
	cp 0ffh		;8899   ; pasa de 0?
	jr z,air_acabado		;889b
	ld (0e057h),a		;889d
	jp air_barra		;88a0
air_acabado:		; Sin AIR: la muerte
	ld a,001h		;88a3
	ld (0e183h),a		;88a5
	ret			;88a8
air_suma:		; AIR + 2 (hasta 0x37) con el sonido 2
	ld a,(0e057h)		;88a9   ; AIR...
	inc a			;88ac   ; ...+ 1
	ld (0e057h),a		;88ad
	ld a,(0e057h)		;88b0   ; y otra vez...
	inc a			;88b3   ; ...+ 1
	cp 038h		;88b4   ; llena?
	ret nc			;88b6
	ld (0e057h),a		;88b7   ; apuntado
	ld a,002h		;88ba   ; el sonido 2
	call sonido_a_pide		;88bc
	jp air_barra		;88bf   ; en el marcador
air_tiempo:		; Cada 0xF0 cuadros (0xE013), AIR - 1
	ld a,(0e013h)		;88c2   ; 0xF0 cuadros?
	cp 0f0h		;88c5   ; 0xF0?
	ret c			;88c7
	xor a			;88c8   ; la cuenta a 0
	ld (0e013h),a		;88c9   ; a cero
	jp air_resta		;88cc   ; AIR - 1
leon_pon:		; LEON (0x8E46) en la fila 14 y sus dos cifras (0xE001) en la 15
	ld de,019d9h		;88cf   ; en la fila 14, columna 25
	ld hl,08e46h		;88d2   ; LEON
	ld bc,00005h		;88d5
	call 0005ch		;88d8
	ld a,(0e001h)		;88db   ; las vidas, la cifra alta
	and 0f0h		;88de
	rrca			;88e0
	rrca			;88e1
	rrca			;88e2
	rrca			;88e3
	ld hl,019fbh		;88e4
	call 0004dh		;88e7
	inc hl			;88ea
	ld a,(0e001h)		;88eb   ; la baja
	and 00fh		;88ee
	call 0004dh		;88f0
	ret			;88f3
escena_pon:		; SCENE (0x8E4B) en la fila 17 y la escena + 1 en la 18
	ld de,01a39h		;88f4   ; en la fila 17, columna 25
	ld hl,08e4bh		;88f7   ; SCENE
	ld bc,00005h		;88fa
	call 0005ch		;88fd
	ld a,(0e003h)		;8900   ; la escena...
	add a,001h		;8903   ; ...+ 1
	daa			;8905
	ld c,a			;8906
	and 0f0h		;8907
	rrca			;8909
	rrca			;890a
	rrca			;890b
	rrca			;890c
	ld b,a			;890d
	ld hl,01a5bh		;890e
	call 0004dh		;8911
	inc hl			;8914
	ld a,c			;8915
	and 00fh		;8916
	ld c,a			;8918
	call 0004dh		;8919
	ret			;891c
leon_suma:		; Un LEON mas (BCD)
	ld a,(0e001h)		;891d
	add a,001h		;8920
	daa			;8922
	ld (0e001h),a		;8923
	jp leon_pon		;8926
ram_escena:		; 0xE100-0xF2FF (0x1200 bytes) a cero; los cuatro primeros sprites fuera y lo demas tambien
	ld hl,0e100h		;8929
	ld bc,01200h		;892c   ; 0x1200 bytes
L_892F:
	ld (hl),000h		;892f   ; a cero
	inc hl			;8931
	dec bc			;8932
	ld a,c			;8933
	or b			;8934
	jr nz,L_892F		;8935   ; 0x1200 bytes
sprites_fuera:		; Los sprites de 0xE300-0xE330 fuera y todo_fuera
	ld a,0ech		;8937   ; Y 0xEC: fuera
	ld (0e300h),a		;8939   ; fuera
	ld (0e310h),a		;893c
	ld (0e320h),a		;893f
	ld (0e330h),a		;8942
	jp todo_fuera		;8945

; ----------------------------------------------------------------------
; DATOS sobra_8948: 11 bytes de codigo que nadie ejecuta (0xE500 a cero)
;   0x8948..0x8953  (11 bytes)
DATA_sobra_8948:
	defb 021h,000h,0e5h,006h,000h,036h,000h,023h,010h,0fbh,0c9h	; 8948  !....6.#...

; ======================================================================
; CODIGO 0x8953..0x8d74  (1057 bytes)
; ======================================================================


pantalla_cierra:		; La zona de juego (24 x 24) se borra columna a columna, de izquierda a derecha, cada 2 cuadros
	ld hl,01800h		;8953   ; la fila 0, columna 0
	ld (0e1a0h),hl		;8956
	ld b,018h		;8959   ; 24 columnas
	xor a			;895b
	ld (0e010h),a		;895c
	ld de,00020h		;895f
L_8962:
	ld c,018h		;8962
	ld hl,(0e1a0h)		;8964
pantalla_cierra_espera:
	ld a,(0e010h)		;8967
	cp 002h		;896a   ; 2 cuadros?
	jr c,pantalla_cierra_espera		;896c
	xor a			;896e   ; la cuenta a 0
	ld (0e010h),a		;896f
pantalla_cierra_fila:
	ld a,010h		;8972   ; el espacio
	call 0004dh		;8974   ; WRTVRM
	add hl,de			;8977   ; la fila siguiente
	dec c			;8978   ; una fila menos
	jr nz,pantalla_cierra_fila		;8979
	ld hl,(0e1a0h)		;897b   ; la columna...
	inc hl			;897e   ; la columna siguiente
	ld (0e1a0h),hl		;897f   ; ...apuntada
	djnz L_8962		;8982
	ret			;8984
nombres_borra:		; La tabla de nombres llena de la casilla 0x10 (el espacio)
	ld a,010h		;8985   ; el espacio...
	ld hl,01800h		;8987   ; ...en la tabla de nombres...
	ld bc,00800h		;898a   ; ...0x300 casillas
	jp 00056h		;898d
letras_pon:		; Las letras (0x7D00, 0x180 bytes) a la casilla 0 de los tres tercios
	ld hl,07d00h		;8990
	ld de,00000h		;8993
	ld bc,00180h		;8996
tercios_va:		; HL y BC apuntados, y a tercios_copia
	ld (0e1a0h),hl		;8999
	ld (0e1a2h),bc		;899c
tercios_copia:		; 0xE1A2 bytes de 0xE1A0 a la VRAM DE y a los otros dos tercios (+0x800)
	ld b,003h		;89a0   ; tres tercios
tercios_copia_uno:
	push bc			;89a2
	ld hl,(0e1a0h)		;89a3   ; desde
	ld bc,(0e1a2h)		;89a6   ; cuantos
	call 0005ch		;89aa   ; LDIRVM
	ld bc,00800h		;89ad   ; el tercio siguiente
	add hl,bc			;89b0
	ex de,hl			;89b1
	pop bc			;89b2
	djnz tercios_copia_uno		;89b3
	ret			;89b5
titulo_casillas:		; Las casillas del titulo: 0x300 bytes de 0x5000 a los dibujos de las casillas 0x30-0x8F y 0x300 de 0x5800 a sus colores, en los tres tercios
	ld hl,05000h		;89b6   ; los dibujos de 0x5000...
	ld de,00180h		;89b9
	ld bc,00300h		;89bc
	call tercios_va		;89bf
	ld hl,05800h		;89c2
	ld de,02180h		;89c5
	ld bc,00300h		;89c8
	call tercios_va		;89cb
	ret			;89ce
sprites_dibujos:		; Los dibujos de los sprites (0x9000, 0x800 bytes) a 0x3800
	ld de,03800h		;89cf
	ld hl,09000h		;89d2
	ld bc,00800h		;89d5
	jp 0005ch		;89d8
sprites_pausa:		; Los de la pausa (0x5B80, 0x100 bytes) a 0x3800
	ld de,03800h		;89db
	ld hl,05b80h		;89de
	ld bc,00100h		;89e1
	jp 0005ch		;89e4
sonido_reinicia:		; 0xE002 = 0xFF: la interrupcion pone el sonido a cero
	ld a,0ffh		;89e7
	ld (0e002h),a		;89e9
	ret			;89ec
sprites_vram:		; Los 32 sprites de 0xE300 (16 bytes cada uno: los 4 primeros son sus atributos) a 0xE100 y a la VRAM (0x1B00, 0x58 bytes)
	ld hl,0e300h		;89ed   ; desde 0xE300
	ld de,0e100h		;89f0   ; a 0xE100
	ld b,020h		;89f3   ; 32
sprites_vram_uno:
	push bc			;89f5
	ld bc,00004h		;89f6   ; cuatro bytes
	ldir		;89f9   ; los atributos
	ld bc,0000ch		;89fb   ; el siguiente (+16)
	add hl,bc			;89fe
	pop bc			;89ff
	djnz sprites_vram_uno		;8a00
	ld de,01b00h		;8a02   ; la tabla de atributos
	ld hl,0e100h		;8a05
	ld bc,00058h		;8a08   ; 0x40 bytes
	jp 0005ch		;8a0b   ; LDIRVM
prota_vram:		; Solo los cuatro primeros sprites (0xE300-0xE330: el protagonista y sus dos sprites de mas)
	ld hl,0e300h		;8a0e
	ld de,0e100h		;8a11
	ld b,004h		;8a14
	jr sprites_vram_uno		;8a16
puntos_pon:		; Las cinco cifras de los puntos (0xE007) en la fila 4, columna 25, y las del record (0xE02F) en la fila 1
	ld hl,0e007h		;8a18
	ld de,01899h		;8a1b
	ld bc,00005h		;8a1e
	call 0005ch		;8a21
	ld hl,0e02fh		;8a24
	ld de,01839h		;8a27
	ld bc,00005h		;8a2a
	jp 0005ch		;8a2d   ; LDIRVM
puntos_suma:		; Jugando, los puntos + A (BCD, las dos ultimas cifras, 0xE00E) con su acarreo; al pasar de 999999 el record se queda con los puntos; desde 3.000 (0xE00D 0x30 o mas; en pantalla 30.000), 0xE03A = 1 una vez; y las cifras, el record y el marcador
	ld b,a			;8a30   ; lo que se suma
	ld a,(0e000h)		;8a31   ; jugando?
	and a			;8a34
	ret z			;8a35   ; no: nada
	ld a,(0e00eh)		;8a36   ; las dos ultimas
	add a,b			;8a39
	daa			;8a3a   ; en BCD
	ld (0e00eh),a		;8a3b   ; apuntadas
	jr nc,puntos_mira		;8a3e   ; sin acarreo
	ld a,001h		;8a40   ; acarreo
puntos_suma_cien:
	ld b,a			;8a42
	ld a,(0e00dh)		;8a43   ; las centenas
	add a,b			;8a46
	daa			;8a47
	ld (0e00dh),a		;8a48   ; apuntadas
	jr nc,puntos_mira		;8a4b
	ld a,001h		;8a4d   ; acarreo
	ld b,a			;8a4f   ; 1
	ld a,(0e00ch)		;8a50   ; las decenas de millar
	add a,b			;8a53
	daa			;8a54   ; en BCD
	ld (0e00ch),a		;8a55   ; apuntadas
	jr nc,puntos_mira		;8a58
	ld a,(0e00eh)		;8a5a   ; se pasa: el record = los puntos
	ld (0e036h),a		;8a5d   ; el record: los puntos
	ld a,(0e00dh)		;8a60   ; el record: los puntos
	ld (0e035h),a		;8a63
	ld a,(0e00ch)		;8a66
	ld (0e034h),a		;8a69
puntos_mira:
	ld a,(0e00dh)		;8a6c   ; 0x3000 (30.000 en pantalla)?
	cp 030h		;8a6f   ; 0x30
	jr c,L_8A80		;8a71
	ld a,(0e02dh)		;8a73   ; ya dado?
	and a			;8a76
	jr nz,L_8A80		;8a77
	inc a			;8a79   ; una vez
	ld (0e02dh),a		;8a7a
	call leon_suma		;8a7d   ; un LEON mas
L_8A80:
	call puntos_cifras		;8a80
	call record_mira		;8a83
	jp puntos_pon		;8a86
puntos_cifras:		; Los tres bytes BCD de los puntos (0xE00C) en cifras (0xE006)
	ld hl,0e006h		;8a89
	ld de,0e00ch		;8a8c   ; los bytes BCD
	ld b,003h		;8a8f   ; tres
cifras_bcd:		; B bytes BCD de DE a cifras en HL (dos por byte)
	ld a,(de)			;8a91   ; un byte
	ld c,a			;8a92   ; guardado
	and 0f0h		;8a93   ; la cifra alta
	rrca			;8a95
	rrca			;8a96
	rrca			;8a97
	rrca			;8a98
	ld (hl),a			;8a99   ; apuntada
	inc hl			;8a9a   ; la siguiente
	ld a,c			;8a9b   ; la baja
	and 00fh		;8a9c   ; la baja
	ld (hl),a			;8a9e   ; la baja
	inc hl			;8a9f   ; la siguiente
	inc de			;8aa0   ; el siguiente
	djnz cifras_bcd		;8aa1   ; tres bytes
	ret			;8aa3
record_mira:		; Si los puntos (0xE00C) pasan del record (0xE034), son el record nuevo y sus cifras (0xE02E)
	ld de,0e034h		;8aa4   ; el record
	ld hl,0e00ch		;8aa7   ; los puntos
	ld a,(de)			;8aaa   ; el byte alto...
	ld b,a			;8aab
	ld a,(hl)			;8aac   ; ...contra el de los puntos
	cp b			;8aad   ; menos: nada
	ret c			;8aae   ; menor: nada
	jr nz,record_nuevo_3		;8aaf   ; mayor: record nuevo
	inc de			;8ab1   ; iguales: el siguiente
	inc hl			;8ab2
	ld a,(de)			;8ab3   ; el siguiente
	ld b,a			;8ab4
	ld a,(hl)			;8ab5
	cp b			;8ab6   ; menos?
	ret c			;8ab7   ; menor: nada
	jr nz,record_nuevo_2		;8ab8   ; mas: record
	inc de			;8aba   ; el bajo
	inc hl			;8abb
	ld a,(de)			;8abc   ; el siguiente
	ld b,a			;8abd
	ld a,(hl)			;8abe
	cp b			;8abf   ; menos?
	ret c			;8ac0   ; menor: nada
	jr record_nuevo		;8ac1   ; igual o mas: record
record_nuevo_3:
	inc de			;8ac3
	inc hl			;8ac4
record_nuevo_2:
	inc de			;8ac5
	inc hl			;8ac6
record_nuevo:		; Los tres bytes, hacia atras
	ld bc,00003h		;8ac7   ; tres bytes...
	lddr		;8aca   ; ...hacia atras
	ld hl,0e02eh		;8acc   ; sus cifras
	ld de,0e034h		;8acf   ; el record
	ld b,003h		;8ad2   ; tres bytes
	jr cifras_bcd		;8ad4   ; sus cifras
espera_musica:		; Espera 8 cuadros, despues hasta que la musica acabe (0xE2BD y 0xE2BE a 0; en el titulo, el boton la corta) y despues 16 cuadros mas
	xor a			;8ad6   ; la cuenta a 0
	ld (0e010h),a		;8ad7
espera_ocho:
	ld a,(0e010h)		;8ada   ; 8 cuadros
	cp 008h		;8add
	jr c,espera_ocho		;8adf
espera_musica_va:
	call prota_vram		;8ae1   ; los sprites del protagonista
	ld a,(0e000h)		;8ae4   ; jugando?
	and a			;8ae7
	jr nz,espera_musica_mira		;8ae8
	ld a,(0e026h)		;8aea   ; el boton?
	and a			;8aed
	ret nz			;8aee
espera_musica_mira:
	ld a,(0e2bdh)		;8aef   ; sonando?
	and a			;8af2
	jr nz,espera_musica_va		;8af3
	ld a,(0e2beh)		;8af5   ; pedida?
	and a			;8af8
	jr nz,espera_musica_va		;8af9
	ld (0e010h),a		;8afb   ; la cuenta a 0
	call sonido_reinicia		;8afe   ; el sonido, a cero
L_8B01:
	ld a,(0e010h)		;8b01
	cp 010h		;8b04
	jr c,L_8B01		;8b06
	ret			;8b08
interrupcion:		; La interrupcion (H.TIMI): el sonido a cero si se pidio (0xE002); el motor; 8 cuentas (0xE010-0xE017); jugando, F1 (0xE1B0), STOP (0xE1B2), los botones y la palanca; fuera, la demostracion o el titulo
	ld a,(0e002h)		;8b09   ; se pidio el sonido a cero?
	cp 0ffh		;8b0c   ; 0xFF?
	jr nz,L_8B17		;8b0e
	call sonido_cero		;8b10   ; a cero
	xor a			;8b13   ; atendido
	ld (0e002h),a		;8b14
L_8B17:
	call sonido		;8b17   ; el motor de sonido
	ld hl,0e010h		;8b1a   ; las 8 cuentas de cuadros (0xE010-0xE017)...
	ld b,008h		;8b1d
L_8B1F:
	inc (hl)			;8b1f   ; ...una mas
	inc hl			;8b20   ; la siguiente
	djnz L_8B1F		;8b21
	ld a,(0e000h)		;8b23   ; jugando?
	and a			;8b26
	jr z,interrupcion_quieto		;8b27   ; no: fuera de partida
	ld a,006h		;8b29   ; la fila 6: F1 (bit 5)?
	call 00141h		;8b2b   ; SNSMAT
	bit 5,a		;8b2e   ; F1?
	jr z,L_8B38		;8b30
	xor a			;8b32   ; F1 suelta
	ld (0e1b1h),a		;8b33   ; suelta
	jr L_8B45		;8b36
L_8B38:
	ld a,(0e1b1h)		;8b38   ; ya atendida?
	and a			;8b3b
	jr nz,L_8B45		;8b3c
	inc a			;8b3e   ; recien pulsada: la muerte (0xE1B0)
	ld (0e1b0h),a		;8b3f
	ld (0e1b1h),a		;8b42
L_8B45:
	ld a,007h		;8b45   ; la fila 7: STOP (bit 4)?
	call 00141h		;8b47   ; SNSMAT
	bit 4,a		;8b4a   ; STOP?
	jr z,L_8B54		;8b4c
	xor a			;8b4e   ; suelta
	ld (0e1b3h),a		;8b4f
	jr L_8B61		;8b52
L_8B54:
	ld a,(0e1b3h)		;8b54   ; ya atendida?
	and a			;8b57
	jr nz,L_8B61		;8b58
	inc a			;8b5a   ; recien pulsada: la pausa (0xE1B2)
	ld (0e1b2h),a		;8b5b
	ld (0e1b3h),a		;8b5e
L_8B61:
	ld de,0e020h		;8b61   ; el boton 2 del mando (GTTRIG 3)...
	ld hl,0e021h		;8b64   ; ...sostenido en 0xE021
	ld a,003h		;8b67
	call boton_mando		;8b69
	ld de,0e022h		;8b6c   ; el boton 1 del mando (GTTRIG 1)...
	ld hl,0e023h		;8b6f   ; ...sostenido en 0xE023
	ld a,001h		;8b72
	call boton_mando		;8b74
	ld a,001h		;8b77   ; y sostenido...
	call 000d8h		;8b79
	ld (0e03bh),a		;8b7c   ; ...en 0xE03B
	ld de,0e020h		;8b7f   ; GRAPH y la barra
	ld hl,0e02bh		;8b82
	call botones_teclado		;8b85
palanca:		; La palanca: los cursores o el mando 1 (GTSTCK 0 y 1), en 0xE180
	xor a			;8b88
	call 000d5h		;8b89   ; GTSTCK 0: los cursores
	ld (0e181h),a		;8b8c
	ld a,001h		;8b8f
	call 000d5h		;8b91   ; GTSTCK 1: el mando 1
	ld c,a			;8b94
	ld a,(0e181h)		;8b95
	or c			;8b98   ; uno u otro
	ld (0e180h),a		;8b99
	ret			;8b9c
interrupcion_quieto:		; Fuera de partida: en la demostracion (0xE027), cada 16 cuadros una entrada de la lista de 0xE037 (desde 0x5200): la mitad baja la palanca, la alta los botones (0x10 el 1, 0x20 el 2, otra los dos); en el titulo, el boton de empezar (0xE026) y la palanca
	ld a,(0e027h)		;8b9d   ; la demostracion?
	and a			;8ba0
	jr z,interrupcion_titulo		;8ba1
	ld a,(0e014h)		;8ba3   ; cada 16 cuadros
	cp 010h		;8ba6
	jr c,empezar_lee		;8ba8
	xor a			;8baa
	ld (0e014h),a		;8bab
	ld hl,(0e037h)		;8bae   ; la lista
	ld a,(hl)			;8bb1   ; un byte
	inc hl			;8bb2   ; el siguiente
	ld (0e037h),hl		;8bb3
	ld b,a			;8bb6   ; guardado
	and 00fh		;8bb7   ; la palanca
	ld (0e180h),a		;8bb9
	ld a,b			;8bbc
	and 0f0h		;8bbd   ; los botones
	and a			;8bbf
	jr z,empezar_lee		;8bc0
	cp 010h		;8bc2   ; 0x10: el boton 2 (0xE020)
	jr nz,demo_boton1		;8bc4
	ld (0e020h),a		;8bc6
	jr empezar_lee		;8bc9
demo_boton1:		; 0x20: el boton 1 (0xE022)
	cp 020h		;8bcb   ; 0x20: el boton 1
	jr nz,demo_los_dos		;8bcd
	ld (0e022h),a		;8bcf
	jr empezar_lee		;8bd2
demo_los_dos:		; Los dos botones
	ld (0e020h),a		;8bd4   ; otro: los dos
	ld (0e022h),a		;8bd7
	jr empezar_lee		;8bda
interrupcion_titulo:
	call empezar_lee		;8bdc
	jr palanca		;8bdf
empezar_lee:		; El boton de empezar (0xE026): la barra o el boton 1 del mando, recien pulsados
	ld de,0e026h		;8be1   ; la barra...
	ld hl,0e025h		;8be4   ; ...sostenida en 0xE025
	call barra_lee		;8be7
	ld a,(de)			;8bea   ; guardada
	ld (0e181h),a		;8beb
	ld hl,0e021h		;8bee   ; el boton 1 del mando...
	ld a,001h		;8bf1   ; GTTRIG 1
	call boton_mando		;8bf3
	ld a,(de)			;8bf6   ; ...o lo del mando
	ld b,a			;8bf7
	ld a,(0e181h)		;8bf8   ; una...
	or b			;8bfb   ; ...u otro
	ld (de),a			;8bfc
	ret			;8bfd
boton_mando:		; GTTRIG A: lo recien pulsado en (DE) y lo sostenido en (HL)
	call 000d8h		;8bfe   ; GTTRIG
	and a			;8c01
boton_mira:
	jr nz,boton_pulsado		;8c02   ; pulsado?
boton_suelto:
	ld (hl),000h		;8c04   ; suelto
	ret			;8c06
boton_pulsado:
	ld a,(hl)			;8c07   ; ya sostenido?
	and a			;8c08
	ret nz			;8c09
	inc a			;8c0a   ; recien pulsado
	ld (hl),a			;8c0b   ; sostenido
	ld (de),a			;8c0c   ; recien pulsado
	ret			;8c0d
barra_lee:		; La barra (fila 8, bit 0): lo mismo
	ld a,008h		;8c0e   ; la fila 8...
	call 00141h		;8c10   ; SNSMAT
	rrca			;8c13   ; el bit 0: pulsada = 0
	jr nc,boton_pulsado		;8c14
	jr boton_suelto		;8c16
botones_teclado:		; La barra como boton 1 y GRAPH (fila 6, bit 2) como boton 2
	ld a,006h		;8c18   ; la fila 6
	call 00141h		;8c1a   ; SNSMAT
	cpl			;8c1d   ; pulsada = 1
	bit 2,a		;8c1e   ; GRAPH (bit 2)
	call boton_mira		;8c20
	inc hl			;8c23   ; los siguientes
	inc de			;8c24
	inc de			;8c25
	ld a,008h		;8c26   ; la fila 8
	call 00141h		;8c28   ; SNSMAT
	cpl			;8c2b
	push af			;8c2c
	rrca			;8c2d   ; la barra: el bit 0
	jr nc,barra_suelta		;8c2e
	ld a,0ffh		;8c30   ; sostenida: 0xFF
	jr barra_sostenida		;8c32
barra_suelta:
	xor a			;8c34   ; suelta: 0
barra_sostenida:
	ld b,a			;8c35
	ld a,(0e03bh)		;8c36   ; con el boton 1 del mando, sostenido
	or b			;8c39
	ld (0e03bh),a		;8c3a
	pop af			;8c3d   ; la fila 8
	bit 0,a		;8c3e   ; la barra
	jr boton_mira		;8c40   ; recien pulsada?
presentacion:		; La presentacion de CASIO: cada 3 cuadros, dos CASIO entran por los lados (filas 11 y 12) y, desde el paso 9, otros dos bajan y suben hacia el centro; con el paso 21, la musica 4 y SOFTWARE (0x8B14) debajo; 128 cuadros o el boton y la pantalla en blanco
	ld a,001h		;8c42   ; el paso 1
	ld (0e187h),a		;8c44
	ld hl,0180ch		;8c47   ; el que baja: la fila 0, columna 12
	ld (0e189h),hl		;8c4a
	ld hl,01aech		;8c4d   ; el que sube: la fila 23
	ld (0e18bh),hl		;8c50
presentacion_cuadro:
	ld a,(0e010h)		;8c53   ; 3 cuadros
	cp 003h		;8c56
	jr c,presentacion_cuadro		;8c58
	xor a			;8c5a
	ld (0e010h),a		;8c5b
	call presentacion_vert		;8c5e   ; los de arriba y abajo
	call presentacion_lados		;8c61
	ld hl,0e187h		;8c64   ; un paso mas
	inc (hl)			;8c67
	ld a,(hl)			;8c68
	cp 015h		;8c69   ; 21?
	jr nc,presentacion_junta		;8c6b
	cp 009h		;8c6d   ; desde el 9...
	jr c,presentacion_sigue		;8c6f
	ld hl,(0e189h)		;8c71   ; ...el de arriba baja una fila...
	ld bc,00020h		;8c74
	add hl,bc			;8c77
	ld (0e189h),hl		;8c78
	ld hl,(0e18bh)		;8c7b   ; ...y el de abajo sube
	sbc hl,bc		;8c7e
	ld (0e18bh),hl		;8c80
presentacion_sigue:
	jr presentacion_cuadro		;8c83
presentacion_junta:
	ld a,004h		;8c85   ; la musica 4
	call musica_pide		;8c87   ; pide la musica
	ld hl,08d87h		;8c8a
	ld de,019cch		;8c8d   ; ...en la fila 14, columna 12
	ld bc,00007h		;8c90
	call 0005ch		;8c93   ; LDIRVM
presentacion_espera:
	ld a,(0e026h)		;8c96   ; el boton?
	and a			;8c99
	jr nz,presentacion_fin		;8c9a
	ld a,(0e010h)		;8c9c   ; 128 cuadros?
	cp 080h		;8c9f
	jr c,presentacion_espera		;8ca1
presentacion_fin:
	xor a			;8ca3
	ld (0e026h),a		;8ca4
	call sonido_reinicia		;8ca7   ; el sonido a cero
	call nombres_borra		;8caa
	ret			;8cad
presentacion_vert:		; Desde el paso 9: el CASIO que baja (0xE189) y el que sube (0xE18B), con la fila en blanco detras
	ld a,(0e187h)		;8cae   ; el paso
	cp 009h		;8cb1   ; antes del 9: nada
	ret c			;8cb3
	ld bc,00008h		;8cb4   ; 8 casillas
	ld hl,08d7eh		;8cb7   ; la fila de abajo de CASIO...
	ld de,(0e189h)		;8cba   ; ...donde va el que baja
	call 0005ch		;8cbe   ; LDIRVM
	ld de,00020h		;8cc1   ; una fila arriba
	and a			;8cc4
	sbc hl,de		;8cc5
	ex de,hl			;8cc7
	ld hl,08d75h		;8cc8   ; la de arriba
	ld bc,00008h		;8ccb   ; 8 casillas
	call 0005ch		;8cce   ; LDIRVM
	ld de,00020h		;8cd1   ; otra fila arriba
	and a			;8cd4
	sbc hl,de		;8cd5
	ex de,hl			;8cd7
	ld hl,08f7ch		;8cd8
	ld bc,00008h		;8cdb
	call 0005ch		;8cde
	ld bc,00008h		;8ce1
	ld hl,08d75h		;8ce4
	ld de,(0e18bh)		;8ce7
	call 0005ch		;8ceb
	ld de,00020h		;8cee
	add hl,de			;8cf1
	ex de,hl			;8cf2
	ld hl,08d7eh		;8cf3
	ld bc,00008h		;8cf6
	call 0005ch		;8cf9
	ld de,00020h		;8cfc
	add hl,de			;8cff
	ex de,hl			;8d00
	ld hl,08f7ch		;8d01
	ld bc,00008h		;8d04
	call 0005ch		;8d07   ; LDIRVM
	ret			;8d0a
presentacion_lados:		; Los dos CASIO de los lados en las filas 11 y 12: uno entra por la derecha casilla a casilla y el otro por la izquierda, leido desde el final
	ld a,(0e187h)		;8d0b   ; el paso
	ld c,a			;8d0e
	cp 009h		;8d0f   ; ...no mas de 9
	jr c,presentacion_arriba		;8d11
	ld c,009h		;8d13   ; 9 como mucho
presentacion_arriba:
	ld hl,01980h		;8d15   ; en la fila 12, columna 0, menos el paso
	ld b,a			;8d18   ; la columna, hacia la izquierda
	ld a,l			;8d19
	sub b			;8d1a
	ld l,a			;8d1b
	ex de,hl			;8d1c
	ld hl,08d75h		;8d1d   ; la fila de arriba de CASIO...
	ld b,000h		;8d20
	call 0005ch		;8d22
	ld de,00020h		;8d25
	add hl,de			;8d28
	ex de,hl			;8d29
	ld hl,08d7eh		;8d2a
	ld a,(0e187h)		;8d2d
	cp 009h		;8d30
	jr c,presentacion_arriba_pon		;8d32
	ld a,009h		;8d34
presentacion_arriba_pon:
	ld c,a			;8d36   ; C casillas
	call 0005ch		;8d37   ; LDIRVM
	ld hl,01960h		;8d3a   ; el otro: la fila 11
	ld a,(0e187h)		;8d3d
	ld c,a			;8d40
	cp 009h		;8d41   ; 9 o mas?
	jr c,presentacion_izq		;8d43
	sub 009h		;8d45   ; pasado el 9, se mueve
	add a,l			;8d47
	ld l,a			;8d48
	ld c,009h		;8d49   ; 9
presentacion_izq:
	ex de,hl			;8d4b   ; DE: la VRAM
	ld hl,08d7dh		;8d4c   ; la fila de arriba, desde el final
	ld a,l			;8d4f
	sub c			;8d50   ; - C
	jr nc,presentacion_izq_pon		;8d51
	dec h			;8d53
presentacion_izq_pon:
	ld l,a			;8d54
	call 0005ch		;8d55   ; LDIRVM
	ld de,00020h		;8d58   ; una fila abajo
	add hl,de			;8d5b
	ex de,hl			;8d5c
	ld a,(0e187h)		;8d5d   ; el paso
	ld c,a			;8d60
	cp 009h		;8d61
	jr c,presentacion_izq_abajo		;8d63
	ld c,009h		;8d65
presentacion_izq_abajo:
	ld hl,08d86h		;8d67
	ld a,l			;8d6a
	sub c			;8d6b
	jr nc,L_8D6F		;8d6c
	dec h			;8d6e
L_8D6F:
	ld l,a			;8d6f
	call 0005ch		;8d70
	ret			;8d73

; ----------------------------------------------------------------------
; DATOS casio_filas: Las filas de CASIO de la presentacion
;   0x8d74..0x8d8e  (26 bytes)
DATA_casio_filas:
	defb 010h,070h,072h,074h,076h,078h,07ah,07ch,07eh,010h,071h,073h,075h,077h,079h,07bh	; 8d74  .prtvxz|~.qsuwy{
	defb 07dh,07fh,010h,080h,081h,082h,083h,084h,085h,086h	; 8d84  }.........

; ----------------------------------------------------------------------
; DATOS nombre_titulo: El nombre del titulo: 闇の竜王 (8 + 8 casillas) y ハデスの紋章
;   (16 + 16 + 16)
;   0x8d8e..0x8dce  (64 bytes)
DATA_nombre_titulo:
	defb 050h,051h,052h,053h,030h,031h,032h,033h,054h,055h,056h,057h,034h,035h,036h,037h	; 8d8e  PQRS0123TUVW4567
	defb 058h,059h,05ah,05bh,038h,039h,03ah,03bh,064h,065h,066h,067h,044h,045h,046h,047h	; 8d9e  XYZ[89:;defgDEFG
	defb 05ch,05dh,05eh,05fh,03ch,03dh,03eh,03fh,068h,069h,06ah,06bh,048h,049h,04ah,04bh	; 8dae  \]^_<=>?hijkHIJK
	defb 060h,061h,062h,063h,040h,041h,042h,043h,06ch,06dh,06eh,06fh,04ch,04dh,04eh,04fh	; 8dbe  `abc@ABClmnoLMNO

; ----------------------------------------------------------------------
; DATOS sobra_energy: ENERGY: nadie lo apunta
;   0x8dce..0x8dd4  (6 bytes)
DATA_sobra_energy:
	defb 015h,01eh,015h,022h,017h,029h	; 8dce

; ----------------------------------------------------------------------
; DATOS marcador_textos: POWER y AIR
;   0x8dd4..0x8ddc  (8 bytes)
DATA_marcador_textos:
	defb 020h,01fh,027h,015h,022h,011h,019h,022h	; 8dd4   .'.".."

; ----------------------------------------------------------------------
; DATOS sobra_over: " OVER": nadie lo apunta
;   0x8ddc..0x8de1  (5 bytes)
DATA_sobra_over:
	defb 010h,01fh,026h,015h,022h	; 8ddc

; ----------------------------------------------------------------------
; DATOS titulo_txt: GAME START y CASIO (las casillas 0x8A-0x8F)
;   0x8de1..0x8df1  (16 bytes)
DATA_titulo_txt:
	defb 017h,011h,01dh,015h,010h,023h,024h,011h,022h,024h,08ah,08bh,08ch,08dh,08eh,08fh	; 8de1  .....#$."$......

; ----------------------------------------------------------------------
; DATOS sobra_stone: THE STONE OF WISDOM: el texto del juego anterior, que
;   nadie apunta (INIT busca el de Stone of Wisdom en otro cartucho, no este)
;   0x8df1..0x8e04  (19 bytes)
DATA_sobra_stone:
	defb 024h,018h,015h,010h,023h,024h,01fh,01eh,015h,010h,01fh,016h,010h,027h,019h,023h	; 8df1  $...#$.......'.#
	defb 014h,01fh,01dh	; 8e01

; ----------------------------------------------------------------------
; DATOS titulo_textos2: PUSH TRIG:1 OR SPACE y COPYRIGHT 1986 (c) CASIO
;   0x8e04..0x8e2e  (42 bytes)
DATA_titulo_textos2:
	defb 020h,025h,023h,018h,010h,024h,022h,019h,017h,00ah,001h,010h,01fh,022h,010h,023h	; 8e04   %#..$"......".#
	defb 020h,011h,013h,015h,013h,01fh,020h,029h,022h,019h,017h,018h,024h,010h,001h,009h	; 8e14   ..... )"...$...
	defb 008h,006h,010h,089h,010h,013h,011h,023h,019h,01fh	; 8e24  .......#..

; ----------------------------------------------------------------------
; DATOS hiscore: HISCORE: (se copian 7; SCORE, 0x8E30, es su final)
;   0x8e2e..0x8e36  (8 bytes)
DATA_hiscore:
	defb 018h,019h,023h,013h,01fh,022h,015h,00ah	; 8e2e  ..#.."..

; ----------------------------------------------------------------------
; DATOS game_over_txt: GAME OVER
;   0x8e36..0x8e3f  (9 bytes)
DATA_game_over_txt:
	defb 017h,011h,01dh,015h,010h,01fh,026h,015h,022h	; 8e36  ......&."

; ----------------------------------------------------------------------
; DATOS sobra_power: "T;POWER": nadie lo apunta
;   0x8e3f..0x8e46  (7 bytes)
DATA_sobra_power:
	defb 024h,00bh,020h,01fh,027h,015h,022h	; 8e3f

; ----------------------------------------------------------------------
; DATOS leon_scene: LEON y SCENE
;   0x8e46..0x8e50  (10 bytes)
DATA_leon_scene:
	defb 01ch,015h,01fh,01eh,010h,023h,013h,015h,01eh,015h	; 8e46  .....#....

; ----------------------------------------------------------------------
; DATOS final_texto: El texto del final (16, 16, 14, 18, 5, 18 y 20 casillas;
;   las letras de la BIOS con su numero: hiragana 0x86-0x9F y 0xE0-0xFD,
;   katakana 0xA1-0xDF): "わたしは ほしのめがみ エーメ / やみのりゅうおうは さりました / あなたの ゆうきを たたえて /
;   ひかりのしょうごうを さずけます / イルシオン / いつのひにか あなたは もういちど / そのゆうきを ためされるでしょう..."
;   0x8e50..0x8ebb  (107 bytes)
DATA_final_texto:
	defb 0fch,0e0h,09ch,0eah,010h,0eeh,09ch,0e9h,0f2h,096h,0deh,0f0h,010h,0b4h,0b0h,0d2h	; 8e50  ................
	defb 0f4h,0f0h,0e9h,0f8h,08dh,093h,095h,093h,0eah,010h,09bh,0f8h,0efh,09ch,0e0h,010h	; 8e60  ................
	defb 091h,0e5h,0e0h,0e9h,010h,0f5h,093h,097h,086h,010h,0e0h,0e0h,094h,0e3h,0ebh,096h	; 8e70  ................
	defb 0f8h,0e9h,09ch,08eh,093h,09ah,0deh,093h,086h,010h,09bh,09dh,0deh,099h,0efh,09dh	; 8e80  ................
	defb 0b2h,0d9h,0bch,0b5h,0ddh,092h,0e2h,0e9h,0ebh,0e6h,096h,010h,091h,0e5h,0e0h,0eah	; 8e90  ................
	defb 010h,0f3h,093h,092h,0e1h,0e4h,0deh,09fh,0e9h,0f5h,093h,097h,086h,010h,0e0h,0f2h	; 8ea0  ................
	defb 09bh,0fah,0f9h,0e3h,0deh,09ch,08eh,093h,0a5h,0a5h,0a5h	; 8eb0  ...........

; ======================================================================
; CODIGO 0x8ebb..0x8f41  (134 bytes)
; ======================================================================


sprites_rota:		; Los sprites de 0xE110 en adelante fuera (0x58 bytes) y los que hay en pantalla de 0xE340-0xE47F copiados empezando cada vez por otro (0xE185): asi, con mas de cuatro en una linea, parpadean en vez de desaparecer
	ld hl,0e110h		;8ebb   ; fuera...
	ld (hl),0ech		;8ebe
	ld de,0e111h		;8ec0
	ld bc,00057h		;8ec3   ; ...0x58 bytes
	ldir		;8ec6
	ld hl,0e344h		;8ec8   ; los de 0xE340 (+4: hay?)...
	ld bc,01400h		;8ecb   ; ...20 de ellos; C, la cuenta
	ld de,00010h		;8ece
sprites_cuenta:
	ld a,(hl)			;8ed1   ; en pantalla?
	and a			;8ed2
	jr z,sprites_cuenta_sig		;8ed3
	inc c			;8ed5   ; uno mas
sprites_cuenta_sig:
	add hl,de			;8ed6
	djnz sprites_cuenta		;8ed7
	ld a,c			;8ed9   ; ninguno?
	and a			;8eda
	ret z			;8edb
	ld a,(0e185h)		;8edc   ; el primero de esta vez...
	inc a			;8edf
	ld (0e185h),a		;8ee0
	cp c			;8ee3   ; pasa de los que hay?
	jr c,L_8EEA		;8ee4
	xor a			;8ee6   ; si: desde el primero
	ld (0e185h),a		;8ee7
L_8EEA:
	ld hl,0e344h		;8eea   ; desde 0xE344
	ld a,(0e185h)		;8eed   ; el primero de esta vez
	and a			;8ef0
	jr z,sprites_rota_copia		;8ef1   ; el 0: desde aqui
	ld b,a			;8ef3   ; saltar tantos
	ld de,00010h		;8ef4
sprites_rota_salta:
	ld a,(hl)			;8ef7   ; en pantalla?
	and a			;8ef8
	jr z,sprites_rota_vacio		;8ef9
	add hl,de			;8efb   ; el siguiente
	djnz sprites_rota_salta		;8efc   ; uno menos que saltar
	jr sprites_rota_copia		;8efe
sprites_rota_vacio:
	add hl,de			;8f00   ; el siguiente, sin contar
	jr sprites_rota_salta		;8f01
sprites_rota_copia:
	ld de,0e110h		;8f03   ; a 0xE108
	ld b,c			;8f06
sprites_rota_uno:
	ld a,(hl)			;8f07   ; en pantalla?
	and a			;8f08
	jr z,sprites_rota_libre		;8f09
	push bc			;8f0b
	dec hl			;8f0c   ; sus atributos (-4)
	dec hl			;8f0d
	dec hl			;8f0e
	dec hl			;8f0f
	ld bc,00004h		;8f10   ; cuatro bytes
	ldir		;8f13
	ld bc,00010h		;8f15   ; el siguiente
	add hl,bc			;8f18
	ld a,h			;8f19   ; el final (0xE464)?
	cp 0e4h		;8f1a
	jr nz,sprites_rota_sig		;8f1c
	ld a,l			;8f1e
	cp 084h		;8f1f
	jr z,L_8F3C		;8f21
sprites_rota_sig:
	pop bc			;8f23
	djnz sprites_rota_uno		;8f24
	ret			;8f26
sprites_rota_libre:
	push bc			;8f27   ; no esta: el siguiente
	ld bc,00010h		;8f28
	add hl,bc			;8f2b
	pop bc			;8f2c
	ld a,h			;8f2d
	cp 0e4h		;8f2e   ; el final (0xE464)?
	jr nz,sprites_rota_uno		;8f30
	ld a,l			;8f32
	cp 084h		;8f33
	jr nz,sprites_rota_uno		;8f35
	ld hl,0e344h		;8f37
	jr sprites_rota_uno		;8f3a
L_8F3C:
	ld hl,0e344h		;8f3c
	jr sprites_rota_sig		;8f3f

; ----------------------------------------------------------------------
; DATOS sobra_8f41: 6 bytes que nadie ejecuta (ld hl,0xE600...)
;   0x8f41..0x8f47  (6 bytes)
DATA_sobra_8f41:
	defb 021h,000h,0e6h,001h,060h,009h	; 8f41

; ======================================================================
; CODIGO 0x8f47..0x8f7c  (53 bytes)
; ======================================================================


nombre_pon:		; El nombre del titulo (0x8D8E): 8 + 8 casillas en las filas 7 y 8 (闇の竜王) y 16 + 16 + 16 en las 10-12 (ハデスの紋章)
	ld hl,08d8eh		;8f47   ; el nombre (0x8D8E)
	ld de,018ech		;8f4a   ; en la fila 7, columna 12
	ld bc,00008h		;8f4d
	call 0005ch		;8f50
	ex de,hl			;8f53
	ld de,0190ch		;8f54   ; la fila 8
	ld bc,00008h		;8f57
	call 0005ch		;8f5a   ; LDIRVM
	ex de,hl			;8f5d
	ld de,01948h		;8f5e   ; la fila 10
	ld bc,00010h		;8f61
	call 0005ch		;8f64   ; LDIRVM
	ex de,hl			;8f67
	ld de,01968h		;8f68   ; la fila 11
	ld bc,00010h		;8f6b
	call 0005ch		;8f6e   ; LDIRVM
	ex de,hl			;8f71
	ld de,01988h		;8f72
	ld bc,00010h		;8f75
	call 0005ch		;8f78
	ret			;8f7b

; ----------------------------------------------------------------------
; DATOS espacios: 20 espacios: la fila en blanco de la presentacion
;   0x8f7c..0x8f90  (20 bytes)
DATA_espacios:
	defb 010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	; 8f7c  ................
	defb 010h,010h,010h,010h	; 8f8c

; ======================================================================
; CODIGO 0x8f90..0x8fbd  (45 bytes)
; ======================================================================


final_letras:		; El final: las casillas 0x80-0xFF en blanco sobre negro y los kana de la BIOS (desde 0x1FBF, la letra 0x80) en ellas
	ld hl,02400h		;8f90   ; los colores de las casillas 0x80-0xFF...
	ld bc,00400h		;8f93
	ld a,0f0h		;8f96   ; ...blanco sobre negro
	call 00056h		;8f98
	ld hl,02c00h		;8f9b   ; el segundo tercio
	ld bc,00400h		;8f9e
	ld a,0f0h		;8fa1
	call 00056h		;8fa3
	ld hl,03400h		;8fa6   ; el tercero
	ld bc,00400h		;8fa9
	ld a,0f0h		;8fac
	call 00056h		;8fae
	ld hl,01fbfh		;8fb1   ; la BIOS: la letra 0x80 (0x1BBF + 0x400)...
	ld de,00400h		;8fb4   ; ...a la casilla 0x80
	ld bc,00400h		;8fb7   ; 0x400 bytes
	jp tercios_va		;8fba

; ----------------------------------------------------------------------
; DATOS sobra_8fbd: 67 bytes que nadie lee: un jp, "ER    T;MORIYAMA" (un
;   resto de unos creditos) y espacios
;   0x8fbd..0x9000  (67 bytes)
DATA_sobra_8fbd:
	defb 0c3h,09ch,089h,015h,022h,010h,010h,010h,010h,024h,00bh,01dh,01fh,022h,019h,029h	; 8fbd  ...."....$...".)
	defb 011h,01dh,011h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	; 8fcd  ................
	defb 010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	; 8fdd  ................
	defb 010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h,010h	; 8fed  ................
	defb 010h,010h,010h	; 8ffd

; ----------------------------------------------------------------------
; DATOS sprites: Los dibujos de los 64 sprites de 16 x 16 (0x800 bytes, a
;   0x3800)
;   0x9000..0x9800  (2048 bytes)
DATA_sprites:
	defb 007h,00dh,01bh,01bh,01fh,01fh,00dh,005h,018h,018h,008h,01fh,00eh,000h,000h,000h	; 9000  ................
	defb 0f0h,0f8h,0fch,0fch,0fch,0f0h,0c8h,0d0h,088h,08ch,08ch,0f8h,038h,038h,000h,000h	; 9010  ............88..
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,002h,004h,004h,000h,000h	; 9020  ................
	defb 000h,000h,000h,000h,000h,000h,000h,01ch,062h,001h,001h,001h,001h,001h,002h,00ch	; 9030  ........b.......
	defb 002h,012h,027h,027h,007h,020h,070h,03ch,018h,000h,000h,000h,000h,000h,000h,000h	; 9040  ..''. p<........
	defb 030h,026h,076h,072h,070h,000h,000h,000h,038h,038h,000h,000h,000h,000h,000h,000h	; 9050  0&vrp...88......
	defb 000h,003h,007h,00fh,007h,003h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9060  ................
	defb 000h,0f0h,0f8h,0fch,0f8h,0f0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 9070  ................
	defb 00fh,01bh,037h,037h,03fh,03fh,01bh,00bh,011h,031h,031h,01fh,01ch,01ch,000h,000h	; 9080  ..77??...11.....
	defb 0e0h,0f0h,0f8h,0f8h,0f8h,0e0h,090h,0a0h,018h,018h,010h,0f8h,070h,000h,000h,000h	; 9090  ............p...
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,004h,008h,008h,000h,000h	; 90a0  ................
	defb 000h,000h,000h,000h,000h,000h,000h,038h,0c4h,002h,002h,002h,002h,002h,004h,018h	; 90b0  .......8........
	defb 004h,064h,06eh,04eh,00eh,000h,000h,000h,01ch,01ch,000h,000h,000h,000h,000h,000h	; 90c0  .dnN............
	defb 060h,048h,0e4h,0e4h,0e0h,004h,00eh,03ch,018h,000h,000h,000h,000h,000h,000h,000h	; 90d0  `H.....<........
	defb 000h,00fh,01fh,03fh,01fh,00fh,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 90e0  ...?............
	defb 000h,0c0h,0e0h,0f0h,0e0h,0c0h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h	; 90f0  ................
	defb 000h,000h,000h,000h,000h,003h,007h,006h,006h,007h,003h,000h,000h,000h,000h,000h	; 9100  ................
	defb 000h,000h,000h,000h,000h,0c0h,0e0h,060h,060h,0e0h,0c0h,000h,000h,000h,000h,000h	; 9110  .......``.......
	defb 000h,000h,000h,000h,000h,078h,0fch,0cch,0cch,0fch,078h,000h,000h,000h,000h,000h	; 9120  .....x....x.....
	defb 000h,000h,000h,000h,000h,01eh,03fh,033h,033h,03fh,01eh,000h,000h,000h,000h,000h	; 9130  ......?33?......
	defb 000h,000h,001h,001h,000h,001h,001h,001h,000h,001h,001h,003h,001h,001h,001h,000h	; 9140  ................
	defb 000h,080h,000h,080h,080h,080h,000h,080h,080h,080h,000h,0c0h,080h,080h,080h,000h	; 9150  ................
	defb 000h,020h,040h,060h,020h,060h,040h,060h,020h,060h,040h,0f0h,060h,060h,060h,000h	; 9160  . @` `@` `@.```.
	defb 000h,004h,002h,006h,004h,006h,002h,006h,004h,006h,002h,00fh,006h,006h,006h,000h	; 9170  ................
	defb 01fh,012h,000h,007h,000h,060h,0e0h,020h,03fh,030h,018h,01fh,01fh,000h,00eh,01fh	; 9180  .....`. ?0......
	defb 0f8h,0a8h,000h,0e0h,000h,006h,007h,007h,0ffh,00fh,01bh,0f8h,0f8h,000h,030h,000h	; 9190  ..............0.
	defb 000h,00dh,01fh,018h,01dh,01dh,01fh,0dfh,0c0h,00fh,007h,000h,000h,00eh,000h,000h	; 91a0  ................
	defb 000h,050h,0f8h,018h,0b8h,0b8h,0f8h,0f8h,000h,0f0h,0e0h,003h,000h,070h,000h,000h	; 91b0  .P...........p..
	defb 000h,01fh,015h,000h,007h,060h,0e0h,0e0h,0e0h,0ffh,010h,018h,01fh,000h,00ch,000h	; 91c0  .....`..........
	defb 000h,0f8h,048h,000h,0e0h,006h,007h,004h,004h,0fch,008h,018h,0f8h,000h,070h,0f8h	; 91d0  ..H...........p.
	defb 000h,000h,00ah,01fh,018h,01dh,01dh,01fh,01fh,000h,0cfh,007h,000h,00eh,000h,000h	; 91e0  ................
	defb 000h,000h,0b0h,0f8h,018h,0b8h,0b8h,0fbh,0fbh,000h,0f0h,0e0h,000h,070h,000h,000h	; 91f0  .............p..
	defb 000h,03ch,00eh,00fh,01fh,03fh,03dh,03eh,01ch,00ch,01ch,01fh,01fh,00eh,000h,000h	; 9200  .<...?=>........
	defb 000h,03ch,070h,0f0h,0f8h,0fch,0dch,0bch,018h,010h,018h,0f8h,0f8h,070h,000h,000h	; 9210  .<p..........p..
	defb 000h,000h,000h,000h,000h,000h,002h,0c0h,0e3h,0f2h,0e3h,0e0h,080h,080h,00eh,01fh	; 9220  ................
	defb 000h,000h,000h,000h,000h,000h,020h,003h,0e7h,0afh,0e7h,007h,001h,001h,030h,000h	; 9230  ...... .......0.
	defb 03ch,00eh,00fh,01fh,03fh,03bh,03dh,018h,008h,018h,01fh,01fh,01fh,00eh,000h,000h	; 9240  <...?;=.........
	defb 03eh,070h,0f0h,0f8h,0fch,0bch,07ch,038h,030h,038h,0f8h,0f8h,0f8h,070h,000h,000h	; 9250  >p....|808...p..
	defb 000h,000h,000h,000h,000h,004h,020h,067h,075h,067h,060h,060h,060h,000h,00ch,000h	; 9260  ...... gug```...
	defb 000h,000h,000h,000h,000h,040h,004h,0c6h,04eh,0c6h,006h,006h,006h,000h,070h,0f8h	; 9270  .....@..N.....p.
	defb 000h,003h,00fh,00fh,01fh,033h,060h,040h,040h,060h,030h,030h,018h,00fh,003h,000h	; 9280  .....3`@@`00....
	defb 078h,0f0h,0f8h,0f8h,0fch,0e6h,002h,002h,002h,002h,006h,006h,00ch,0f8h,0e0h,000h	; 9290  x...............
	defb 000h,000h,000h,000h,000h,00ch,093h,0a1h,0a1h,093h,0cfh,048h,007h,000h,00ch,01eh	; 92a0  ...........H....
	defb 000h,000h,000h,000h,000h,018h,0e4h,0c0h,0c0h,064h,0f9h,009h,0f3h,003h,01ch,000h	; 92b0  .........d......
	defb 000h,03eh,00fh,01fh,01fh,03fh,067h,040h,040h,040h,060h,060h,030h,01fh,007h,000h	; 92c0  .>...?g@@@``0...
	defb 000h,000h,0c0h,0f0h,0f0h,0f8h,0cch,006h,002h,006h,00ch,00ch,018h,0f0h,0c0h,000h	; 92d0  ................
	defb 000h,000h,000h,000h,000h,000h,018h,027h,003h,003h,026h,09fh,08fh,0c0h,0f8h,000h	; 92e0  .......'..&.....
	defb 000h,000h,000h,000h,000h,000h,030h,0c9h,085h,085h,0c9h,0f3h,0e2h,000h,030h,078h	; 92f0  ......0.......0x
	defb 000h,000h,000h,003h,007h,00fh,01fh,01bh,011h,019h,00fh,005h,005h,000h,000h,000h	; 9300  ................
	defb 000h,000h,000h,0c0h,0e0h,0f0h,0f8h,0b8h,018h,038h,0f0h,040h,040h,000h,000h,000h	; 9310  .........8.@@...
	defb 00fh,03fh,070h,060h,0e0h,0c0h,0c0h,0c0h,0c0h,0c0h,0c0h,0e0h,060h,070h,03fh,00fh	; 9320  .?p`........`p?.
	defb 0f0h,0fch,00eh,006h,007h,003h,003h,003h,003h,003h,003h,007h,006h,00eh,0fch,0f0h	; 9330  ................
	defb 000h,000h,000h,002h,006h,00eh,01eh,01ah,010h,018h,00eh,004h,004h,000h,000h,000h	; 9340  ................
	defb 000h,000h,000h,040h,060h,070h,078h,038h,018h,038h,070h,060h,040h,000h,000h,000h	; 9350  ...@`px8.8p`@...
	defb 000h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,001h,000h	; 9360  ................
	defb 000h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,080h,000h	; 9370  ................
	defb 000h,003h,004h,00ch,008h,000h,000h,010h,010h,030h,030h,030h,020h,004h,00eh,01fh	; 9380  .........000 ...
	defb 000h,080h,040h,060h,030h,038h,034h,034h,032h,032h,012h,019h,015h,033h,078h,000h	; 9390  ..@`084422...3x.
	defb 000h,000h,003h,003h,007h,00bh,00fh,008h,00ch,00fh,00fh,00fh,007h,003h,000h,000h	; 93a0  ................
	defb 000h,000h,080h,080h,0c0h,040h,0c8h,048h,0ech,0ech,0ech,0e6h,0e2h,0c0h,000h,000h	; 93b0  .....@.H........
	defb 001h,003h,006h,00ch,01ch,02ch,02ch,04ch,04ch,048h,098h,0a8h,0cch,01eh,000h,000h	; 93c0  .....,,LLH......
	defb 0c0h,0e0h,030h,010h,000h,000h,008h,008h,00ch,00ch,00ch,004h,020h,070h,0f8h,000h	; 93d0  ..0......... p..
	defb 000h,001h,001h,003h,002h,013h,012h,037h,037h,037h,067h,047h,003h,000h,000h,000h	; 93e0  .......777gG....
	defb 000h,0c0h,0e0h,0e0h,0d0h,0f0h,010h,030h,0f0h,0f0h,0f0h,0e0h,0c0h,000h,000h,000h	; 93f0  .......0........
	defb 007h,01fh,03ch,070h,060h,0e0h,0e0h,0e0h,060h,03fh,007h,00fh,01eh,01fh,000h,000h	; 9400  ..<p`...`?......
	defb 0e0h,0f8h,03ch,00eh,006h,007h,007h,007h,006h,0fch,0e0h,0f0h,078h,0f8h,000h,000h	; 9410  ..<.........x...
	defb 000h,000h,003h,005h,00bh,015h,00bh,015h,00bh,000h,060h,070h,021h,000h,00eh,000h	; 9420  ..........`p!...
	defb 000h,000h,0c0h,0a0h,0d0h,0a8h,0d0h,0a8h,0d1h,003h,007h,00eh,080h,006h,00eh,01ch	; 9430  ................
	defb 000h,00fh,01fh,03ch,070h,060h,0e0h,0e0h,0e0h,060h,03fh,00fh,01ch,01fh,000h,000h	; 9440  ...<p`...`?.....
	defb 000h,0f0h,0f8h,03ch,00eh,006h,007h,007h,007h,006h,0fch,0f0h,038h,0f8h,000h,000h	; 9450  ...<........8...
	defb 000h,000h,000h,003h,004h,00ah,014h,00ah,014h,0cbh,0e0h,070h,003h,060h,070h,03ch	; 9460  ...........p.`p<
	defb 000h,000h,000h,0c0h,020h,050h,028h,050h,028h,0d0h,006h,00eh,0c0h,000h,038h,000h	; 9470  .... P(P(.....8.
	defb 000h,000h,010h,018h,018h,010h,019h,019h,019h,019h,019h,01ch,00ch,00ch,00eh,006h	; 9480  ................
	defb 000h,000h,004h,00ch,00ch,004h,04ch,04ch,04ch,04ch,0cch,01ch,018h,018h,038h,030h	; 9490  ......LLLL....80
	defb 007h,00fh,00fh,007h,000h,000h,006h,006h,006h,006h,006h,003h,000h,003h,003h,003h	; 94a0  ................
	defb 0f0h,0f8h,0f8h,0f0h,000h,080h,0b0h,0b0h,0b0h,0b0h,030h,0e0h,000h,0e0h,0e0h,0e0h	; 94b0  ..........0.....
	defb 00fh,000h,03eh,000h,07eh,006h,0ffh,010h,0f8h,01eh,0feh,03eh,0ffh,00ch,00fh,007h	; 94c0  ..>.~......>....
	defb 0f0h,000h,07ch,000h,07eh,060h,0ffh,0f8h,09fh,0f8h,0ffh,0fch,0ffh,030h,0f0h,0e0h	; 94d0  ..|.~`.......0..
	defb 000h,01fh,001h,03fh,001h,079h,000h,0efh,001h,0e1h,001h,0c1h,000h,070h,000h,000h	; 94e0  ...?.y.......p..
	defb 000h,0f8h,080h,0fch,080h,09eh,000h,007h,000h,007h,000h,003h,000h,00eh,000h,000h	; 94f0  ................
	defb 000h,000h,000h,028h,041h,06ch,07eh,07ah,05fh,07eh,03bh,02fh,017h,00eh,003h,000h	; 9500  ...(Al~z_~;/....
	defb 000h,000h,000h,000h,000h,000h,000h,0c8h,0a0h,0f0h,0e4h,0f0h,0f8h,0bch,0f0h,000h	; 9510  ................
	defb 000h,01fh,03fh,017h,03eh,013h,001h,001h,000h,000h,000h,000h,000h,000h,000h,000h	; 9520  ..?.>...........
	defb 000h,0c0h,0f0h,0f8h,0fch,0feh,0feh,036h,01eh,00eh,01ah,00eh,006h,000h,000h,000h	; 9530  .......6........
	defb 007h,00fh,01fh,01fh,01bh,019h,00dh,077h,055h,0e0h,0a7h,001h,007h,004h,004h,01ch	; 9540  .......wU.......
	defb 0c0h,0e5h,0f7h,0f2h,0b2h,03eh,068h,0c0h,040h,000h,0e4h,004h,0fch,000h,000h,000h	; 9550  .....>h.@.......
	defb 003h,0a7h,0efh,04fh,04dh,07ch,016h,003h,002h,000h,027h,020h,03fh,000h,000h,000h	; 9560  ...OM|....' ?...
	defb 0e0h,0f0h,0f8h,0f8h,0d8h,098h,0b0h,0eeh,0aah,007h,0e5h,080h,0e0h,020h,020h,038h	; 9570  .............  8
	defb 000h,000h,000h,000h,000h,001h,003h,006h,006h,003h,001h,000h,000h,000h,000h,000h	; 9580  ................
	defb 000h,000h,000h,000h,000h,080h,0c0h,060h,060h,0c0h,080h,000h,000h,000h,000h,000h	; 9590  .......``.......
	defb 000h,000h,000h,000h,003h,007h,00fh,01fh,01fh,00fh,007h,003h,000h,000h,000h,000h	; 95a0  ................
	defb 000h,000h,000h,000h,0c0h,0e0h,0f0h,0f8h,0f8h,0f0h,0e0h,0c0h,000h,000h,000h,000h	; 95b0  ................
	defb 003h,000h,000h,001h,003h,005h,003h,001h,001h,003h,001h,004h,007h,001h,001h,001h	; 95c0  ................
	defb 000h,080h,080h,080h,0c0h,0a0h,0c0h,080h,080h,0c0h,080h,020h,0e0h,080h,080h,080h	; 95d0  ........... ....
	defb 000h,000h,000h,000h,0a0h,0eah,07ch,07eh,03eh,01ch,018h,001h,000h,002h,002h,000h	; 95e0  ......|~>.......
	defb 000h,000h,000h,000h,005h,057h,03eh,07eh,07ch,038h,018h,080h,000h,040h,040h,000h	; 95f0  .....W>~|8...@@.
	defb 000h,001h,001h,000h,003h,003h,003h,001h,001h,003h,008h,007h,001h,001h,002h,001h	; 9600  ................
	defb 0c0h,000h,000h,080h,0c0h,0c0h,0c0h,080h,080h,0c0h,010h,0e0h,080h,080h,040h,080h	; 9610  ..............@.
	defb 000h,000h,002h,004h,004h,004h,00ch,00eh,00eh,004h,001h,000h,002h,002h,000h,000h	; 9620  ................
	defb 000h,000h,040h,020h,020h,020h,030h,070h,070h,020h,080h,000h,040h,040h,000h,000h	; 9630  ..@   0pp ..@@..
	defb 040h,0a3h,064h,0a3h,014h,083h,080h,020h,023h,054h,000h,011h,010h,041h,040h,000h	; 9640  @.d.... #T...A@.
	defb 080h,084h,0cah,0cch,0eah,0f0h,0a2h,0e2h,0a8h,0e8h,074h,060h,0f0h,0d0h,084h,004h	; 9650  ..........t`....
	defb 003h,040h,083h,014h,08bh,01ch,00bh,00fh,058h,08ah,08ch,00ch,02eh,026h,003h,000h	; 9660  .@......X....&..
	defb 000h,000h,004h,002h,010h,002h,010h,000h,000h,014h,002h,002h,000h,008h,008h,000h	; 9670  ................
	defb 000h,021h,052h,031h,052h,009h,040h,040h,011h,012h,028h,000h,008h,008h,020h,020h	; 9680  .!R1R.@@..(...  
	defb 042h,0c5h,066h,0e5h,078h,0f1h,051h,074h,0d4h,07ah,030h,0b8h,078h,0e2h,042h,000h	; 9690  B.f.x.Qt.z0.x.B.
	defb 001h,000h,021h,042h,00dh,046h,00dh,007h,004h,02dh,046h,046h,007h,013h,011h,000h	; 96a0  ..!B.F...-FF....
	defb 080h,002h,081h,008h,081h,008h,080h,080h,00ah,001h,001h,000h,004h,004h,080h,000h	; 96b0  ................
	defb 00fh,01fh,030h,025h,06eh,049h,052h,055h,06eh,01fh,000h,000h,000h,000h,000h,000h	; 96c0  ..0%nIRUn.......
	defb 0e0h,0f0h,038h,088h,06ch,0a4h,054h,024h,0dch,0f0h,000h,000h,000h,000h,000h,000h	; 96d0  ..8.l.T$........
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00ah,004h,009h,004h,00ah,001h	; 96e0  ................
	defb 000h,000h,0c0h,050h,000h,018h,008h,000h,000h,000h,0a0h,040h,020h,040h,0a0h,000h	; 96f0  ...P.......@ @..
	defb 000h,000h,00fh,018h,032h,025h,06ah,04ch,051h,058h,04dh,076h,01fh,000h,000h,000h	; 9700  ....2%jLQXMv....
	defb 000h,000h,0e0h,030h,098h,048h,02ch,084h,054h,0b4h,044h,0dch,0f0h,000h,000h,000h	; 9710  ...0.H,.T.D.....
	defb 000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,000h,00ah,091h,06bh	; 9720  ...............k
	defb 000h,000h,000h,080h,040h,010h,010h,008h,000h,000h,000h,000h,000h,0a0h,012h,0ach	; 9730  ....@...........
	defb 000h,000h,000h,002h,006h,00fh,01eh,01bh,011h,019h,00fh,006h,005h,000h,000h,000h	; 9740  ................
	defb 000h,000h,000h,040h,0e0h,070h,0f8h,0d8h,088h,098h,0f0h,060h,0a0h,000h,000h,000h	; 9750  ...@.p.....`....
	defb 000h,000h,000h,010h,009h,000h,00bh,005h,005h,00bh,000h,009h,010h,000h,000h,000h	; 9760  ................
	defb 000h,000h,000h,008h,090h,000h,0d0h,0a0h,0a0h,0d0h,000h,090h,008h,000h,000h,000h	; 9770  ................
	defb 007h,00fh,01fh,03fh,03eh,036h,030h,030h,030h,030h,010h,014h,013h,011h,000h,000h	; 9780  ...?>60000......
	defb 0c0h,0e0h,0d0h,0e8h,038h,018h,018h,018h,018h,018h,010h,050h,090h,010h,000h,000h	; 9790  ....8......P....
	defb 000h,000h,000h,000h,001h,009h,00fh,00dh,00dh,00fh,006h,063h,0c0h,0a0h,0c0h,070h	; 97a0  ...........c...p
	defb 000h,000h,000h,000h,0c0h,0e0h,0e0h,060h,060h,0e0h,0c0h,08ch,006h,00ah,006h,01ch	; 97b0  .......``.......
	defb 000h,000h,000h,000h,000h,000h,000h,040h,040h,040h,028h,008h,00ch,00eh,01fh,00fh	; 97c0  .......@@@(.....
	defb 000h,000h,020h,010h,000h,000h,000h,004h,004h,004h,028h,020h,060h,0e0h,0f0h,0e0h	; 97d0  .. .......( `...
	defb 01fh,017h,015h,015h,035h,025h,02dh,029h,02bh,06bh,0cbh,09bh,0b3h,0e7h,06fh,03fh	; 97e0  ....5%-)+k....o?
	defb 0f0h,0d0h,050h,050h,058h,048h,068h,028h,0a8h,0ach,0a6h,0b2h,09ah,0ceh,0ech,0f8h	; 97f0  ..PPXHh(........

; ----------------------------------------------------------------------
; DATOS sobra_9800: Un "ret" que nadie ejecuta
;   0x9800..0x9801  (1 bytes)
DATA_sobra_9800:
	defb 0c9h	; 9800

; ======================================================================
; CODIGO 0x9801..0x9e9d  (1692 bytes)
; ======================================================================


prota_sprites:		; Los sprites del protagonista: el de abajo (+0x10) 9 por encima, y los de 0xE300 y 0xE310 (la sombra y la marca) por debajo y en su X
	ld a,(ix+000h)		;9801   ; la Y - 9...
	sub 009h		;9804
	ld (ix+010h),a		;9806   ; ...en el segundo sprite
	add a,017h		;9809   ; + 0x17...
	ld (ix-010h),a		;980b   ; ...en el de 0xE310
	sub 007h		;980e   ; - 7...
	ld (ix-020h),a		;9810   ; ...en el de 0xE300
	ld a,(ix+001h)		;9813   ; la X, en los tres
	ld (ix+011h),a		;9816
	ld (ix-01fh),a		;9819
	ld (ix-00fh),a		;981c
	ret			;981f
prota_quieto:		; Quieto: los dibujos 0 o 0x10 cada 16 cuadros
	ld a,(0e012h)		;9820   ; cada 16 cuadros...
	and 010h		;9823
	jr prota_dibujos		;9825
prota_anda:		; Andando: los dibujos 0 o 0x10 cada 8 cuadros
	ld a,(0e012h)		;9827   ; cada 8...
	and 008h		;982a
	rlca			;982c
prota_dibujos:		; Los dibujos de los cuatro sprites: A, A+4, A+8 y A+12
	ld (ix+002h),a		;982d   ; el primero
	add a,004h		;9830   ; + 4: el segundo
	ld (ix+012h),a		;9832
	add a,004h		;9835   ; + 8: 0xE300 (IX - 0x1E)
	ld (ix-01eh),a		;9837
	add a,004h		;983a   ; + 12: 0xE310 (IX - 0x0E)
	ld (ix-00eh),a		;983c
	ret			;983f
prota_coge:		; Lo cogido (+0x19): 1, POWER + 2; 3, AIR + 2; 6, el arma + 1 (0xE059); 5, POWER + 8; 2 y 4, un poder (color 11 o 6) que dura 3 x 256 cuadros (+0x1A-0x1C)
	ld a,(ix+019h)		;9840   ; algo cogido?
	and a			;9843
	jr z,poder_cuenta		;9844
	ld (ix+019h),000h		;9846   ; atendido
	cp 001h		;984a   ; 1?
	jr nz,L_9853		;984c
	call power_suma2		;984e   ; POWER + 2
	jr poder_cuenta		;9851
L_9853:
	cp 003h		;9853   ; 3?
	jr nz,L_985C		;9855
	call air_suma		;9857   ; AIR + 2
	jr poder_cuenta		;985a
L_985C:
	cp 006h		;985c   ; 6?
	jr nz,L_9869		;985e
	ld a,(0e059h)		;9860   ; el arma...
	inc a			;9863   ; ...una mas
	ld (0e059h),a		;9864
	jr poder_cuenta		;9867
L_9869:
	cp 005h		;9869   ; 5?
	jr nz,L_9872		;986b
	call power_suma8		;986d   ; POWER + 8
	jr poder_cuenta		;9870
L_9872:
	cp 002h		;9872   ; 2: el color 11
	jr nz,L_987C		;9874
	ld (ix+01dh),00bh		;9876
	jr L_9886		;987a
L_987C:
	cp 004h		;987c   ; 4: el color 6
	jr nz,L_9886		;987e
	ld (ix+01dh),006h		;9880
	jr L_9886		;9884
L_9886:
	ld (ix+01ah),a		;9886   ; el poder (2 o 4)...
	ld (ix+01bh),000h		;9889   ; ...y su cuenta a 0
	ld (ix+01ch),000h		;988d
poder_cuenta:		; El poder: 3 x 256 cuadros; los dos primeros, el color del poder cada 8 cuadros; el ultimo, cada 2; luego el color 5
	ld a,(ix+01ah)		;9891   ; un poder?
	and a			;9894
	jr z,L_98D7		;9895
	inc (ix+01bh)		;9897   ; un cuadro mas
	jr nz,L_989F		;989a
	inc (ix+01ch)		;989c   ; 256: otro
L_989F:
	ld a,(ix+01ch)		;989f   ; 3 veces 256?
	cp 003h		;98a2
	jr c,L_98B8		;98a4
	ld (ix+01ah),000h		;98a6   ; se acabo
	ld (ix+01bh),000h		;98aa
	ld (ix+01ch),000h		;98ae
	ld (ix+003h),005h		;98b2   ; el color 5
	jr L_98D7		;98b6
L_98B8:
	cp 002h		;98b8   ; la ultima vez: cada 2 cuadros
	jr c,poder_parpadea_lento		;98ba
	ld a,(0e012h)		;98bc
	and 002h		;98bf
	jr poder_color		;98c1
poder_parpadea_lento:
	ld a,(0e012h)		;98c3   ; ...si no, cada 8
	and 008h		;98c6
poder_color:
	and a			;98c8
	jr nz,L_98D1		;98c9
	ld (ix+003h),001h		;98cb   ; el color 1
	jr L_98D7		;98cf
L_98D1:
	ld a,(ix+01dh)		;98d1   ; el color del poder
	ld (ix+003h),a		;98d4
L_98D7:
	ret			;98d7
disparo:		; El boton 1 (0xE022): un disparo en el primer hueco libre de 0xE340 (hasta 4, segun POWER: 1, con 0x10 2, con 0x18 3 y con 0x20 4), con el dibujo del arma (0x20/0x24/0x28/0x2C); con el arma 4 o mas, en abanico (5 direcciones, 0xE1BF)
	ld a,(0e022h)		;98d8   ; el boton 1?
	and a			;98db
	jp z,disparos_vuelan		;98dc   ; no: los disparos vuelan
	xor a			;98df   ; atendido
	ld (0e022h),a		;98e0
	ld c,000h		;98e3   ; C = 0: hacia arriba
	ld a,(ix+00eh)		;98e5   ; el arma...
	ld b,020h		;98e8   ; 0: el dibujo 0x20
	and a			;98ea
	jr z,L_9902		;98eb
	ld b,024h		;98ed   ; 1: 0x24
	cp 001h		;98ef
	jr z,L_9902		;98f1
	ld b,028h		;98f3   ; 2: 0x28
	cp 002h		;98f5
	jr z,L_9902		;98f7
	ld b,02ch		;98f9   ; 3: 0x2C
	cp 003h		;98fb
	jr z,L_9902		;98fd
	ld bc,02001h		;98ff   ; 4 o mas: 0x20 en abanico (C = 1)
L_9902:
	ld iy,0e340h		;9902   ; el primer disparo
	call disparo_pon		;9906   ; libre?
	ret z			;9909
	ld a,(0e058h)		;990a   ; POWER...
	cp 010h		;990d   ; ...menos de 0x10: solo uno
	ret c			;990f
	ld de,00010h		;9910   ; el segundo
	add iy,de		;9913
	call disparo_pon		;9915
	ret z			;9918
	ld a,(0e058h)		;9919   ; POWER...
	cp 018h		;991c   ; ...0x18 para el tercero
	ret c			;991e
	add iy,de		;991f
	call disparo_pon		;9921
	ret z			;9924
	ld a,(0e058h)		;9925   ; POWER...
	cp 020h		;9928   ; ...0x20 para el cuarto
	ret c			;992a
	add iy,de		;992b
	call disparo_pon		;992d
	ret			;9930
disparo_pon:		; Si el hueco IY esta libre: el disparo (+4 = arma + 1, +6 el arma, su dibujo, donde el protagonista, color 1), el sonido 5 y su direccion: 2 arriba, o la siguiente del abanico (0-4)
	ld a,(iy+004h)		;9931   ; libre?
	and a			;9934
	ret nz			;9935
	ld a,(ix+00eh)		;9936   ; el arma + 1...
	inc a			;9939
	ld (iy+004h),a		;993a   ; ...en +4
	ld a,(ix+00eh)		;993d   ; el arma, en +6
	ld (iy+006h),a		;9940
	ld (iy+002h),b		;9943   ; el dibujo
	ld a,(ix+000h)		;9946   ; donde el protagonista
	ld (iy+000h),a		;9949
	ld a,(ix+001h)		;994c
	ld (iy+001h),a		;994f
	ld (iy+003h),001h		;9952   ; color 1
	ld a,005h		;9956   ; el sonido 5
	call sonido_a_pide		;9958
	ld a,c			;995b   ; en abanico?
	and a			;995c
	jr nz,L_9965		;995d
	ld (iy+005h),002h		;995f   ; no: arriba (2)
	jr L_9974		;9963
L_9965:
	ld a,(0e1bfh)		;9965   ; la siguiente direccion del abanico...
	inc a			;9968
	cp 005h		;9969   ; ...de 0 a 4
	jr nz,L_996E		;996b
	xor a			;996d
L_996E:
	ld (0e1bfh),a		;996e
	ld (iy+005h),a		;9971
L_9974:
	xor a			;9974   ; Z: puesto
	ret			;9975
disparos_vuelan:		; Los cuatro disparos (0xE340), uno a uno
	ld iy,0e340h		;9976   ; el primero
	call disparo_vuela		;997a   ; vuela
	ld de,00010h		;997d   ; el siguiente
	add iy,de		;9980
	call disparo_vuela		;9982   ; el segundo
	add iy,de		;9985
	call disparo_vuela		;9987   ; el tercero
	add iy,de		;998a
	call disparo_vuela		;998c   ; el cuarto
	ret			;998f
disparo_vuela:		; Un disparo: sube 4 por cuadro; en abanico, ademas, -2, -1, 0, +1 o +2 en X; fuera de la pantalla, se acaba
	ld a,(iy+004h)		;9990   ; hay?
	and a			;9993   ; hay?
	ret z			;9994
	ld a,(iy+005h)		;9995   ; su direccion
	cp 002h		;9998   ; 2: solo arriba
	jr nz,L_99B4		;999a   ; no: en abanico
L_999C:
	ld a,(iy+000h)		;999c   ; 4 arriba
	sub 004h		;999f   ; 4 arriba
	ld (iy+000h),a		;99a1
	cp 0f0h		;99a4   ; fuera por arriba?
	ret c			;99a6
L_99A7:
	ld (iy+000h),0ech		;99a7   ; se acaba
	ld (iy+004h),000h		;99ab
	ld (iy+005h),000h		;99af
	ret			;99b3
L_99B4:
	cp 000h		;99b4   ; 0: 2 a la izquierda
	jr nz,L_99C6		;99b6
	ld a,(iy+001h)		;99b8
	sub 002h		;99bb
L_99BD:
	ld (iy+001h),a		;99bd
	cp 0f0h		;99c0
	jr c,L_999C		;99c2
	jr L_99A7		;99c4
L_99C6:
	cp 001h		;99c6   ; 1: 1 a la izquierda
	jr nz,L_99D1		;99c8
	ld a,(iy+001h)		;99ca
	sub 001h		;99cd
	jr L_99BD		;99cf
L_99D1:
	cp 003h		;99d1   ; 3: 1 a la derecha
	jr nz,L_99E3		;99d3
	ld a,(iy+001h)		;99d5
	add a,001h		;99d8
L_99DA:
	ld (iy+001h),a		;99da
	cp 0b4h		;99dd
	jr c,L_999C		;99df
	jr L_99A7		;99e1
L_99E3:
	cp 004h		;99e3   ; 4: 2 a la derecha
	jr nz,L_99EE		;99e5
	ld a,(iy+001h)		;99e7
	add a,002h		;99ea
	jr L_99DA		;99ec
L_99EE:
	ret			;99ee
prota_mueve:		; El protagonista: en la pantalla 9 (0xE053), empujado abajo; la palanca: 1 arriba (y, por encima de la Y 0x78, la pantalla avanza), 3 derecha, 5 abajo, 7 izquierda y las diagonales; 1 pixel por cuadro (2 con 0xE05A)
	ld a,(0e053h)		;99ef   ; la pantalla 9?
	cp 009h		;99f2
	call z,empujado		;99f4   ; si: empujado
	ld a,(0e180h)		;99f7   ; la palanca
	and a			;99fa
	jp z,prota_quieto		;99fb   ; quieto
	call prota_anda		;99fe   ; andando
	ld a,(0e180h)		;9a01
	cp 001h		;9a04   ; 1: arriba
	jr z,prota_arriba		;9a06
	cp 002h		;9a08   ; 2: arriba-derecha
	jp z,prota_arriba_der		;9a0a
	cp 008h		;9a0d   ; 8: arriba-izquierda
	jp z,prota_arriba_izq		;9a0f
	cp 004h		;9a12   ; 4: abajo-derecha
	jp z,prota_abajo_der		;9a14
	cp 005h		;9a17   ; 5: abajo
	jp z,prota_abajo		;9a19
	cp 006h		;9a1c   ; 6: abajo-izquierda
	jp z,prota_abajo_izq		;9a1e
	cp 007h		;9a21   ; 7: izquierda
	jp z,prota_izq		;9a23
	cp 003h		;9a26   ; 3: derecha
	jp z,prota_der		;9a28
	ret			;9a2b
prota_arriba:		; Arriba: si se pasa; por encima de 0x78, la pantalla avanza; si no, 1 (2 con la velocidad, +0x1E)
	call pasa_arriba		;9a2c   ; se pasa?
	ret nc			;9a2f
	ld a,(ix+000h)		;9a30   ; la Y...
	cp 078h		;9a33   ; ...por encima de 0x78: avanza la pantalla
	jp c,avanza		;9a35
	ld b,001h		;9a38   ; 1 pixel...
	ld a,(ix+01eh)		;9a3a   ; ...2 con la velocidad
	and a			;9a3d
	jr z,L_9A42		;9a3e
	ld b,002h		;9a40
L_9A42:
	ld a,(ix+000h)		;9a42   ; arriba
	sub b			;9a45
	ld (ix+000h),a		;9a46
	ret			;9a49
prota_der:		; Derecha: hasta la X 0xAA
	call pasa_der		;9a4a   ; se pasa?
	ret nc			;9a4d
	ld a,(ix+001h)		;9a4e   ; la X...
	cp 0aah		;9a51   ; ...0xAA: el borde
	ret nc			;9a53
	ld b,001h		;9a54
	ld a,(ix+01eh)		;9a56
	and a			;9a59
	jr z,L_9A5E		;9a5a
	ld b,002h		;9a5c
L_9A5E:
	ld a,(ix+001h)		;9a5e
	add a,b			;9a61
	ld (ix+001h),a		;9a62
	ret			;9a65
prota_abajo:		; Abajo: hasta la Y 0xA8
	call pasa_abajo		;9a66   ; se pasa?
	ret nc			;9a69
	ld a,(ix+000h)		;9a6a
	cp 0a8h		;9a6d   ; 0xA8: el borde
	ret nc			;9a6f
	ld b,001h		;9a70
	ld a,(ix+01eh)		;9a72
	and a			;9a75
	jr z,L_9A7A		;9a76
	ld b,002h		;9a78
L_9A7A:
	ld a,(ix+000h)		;9a7a
	add a,b			;9a7d
	ld (ix+000h),a		;9a7e
	ret			;9a81
prota_izq:		; Izquierda: desde la X 9
	call pasa_izq		;9a82   ; se pasa?
	ret nc			;9a85
	ld a,(ix+001h)		;9a86
	cp 009h		;9a89   ; 9: el borde
	ret c			;9a8b
	ld b,001h		;9a8c
	ld a,(ix+01eh)		;9a8e
	and a			;9a91
	jr z,L_9A96		;9a92
	ld b,002h		;9a94
L_9A96:
	ld a,(ix+001h)		;9a96
	sub b			;9a99
	ld (ix+001h),a		;9a9a
	ret			;9a9d
prota_arriba_der:		; Arriba y a la derecha
	call prota_arriba		;9a9e
	jp prota_der		;9aa1
prota_abajo_der:		; Abajo y a la derecha
	call prota_abajo		;9aa4
	jp prota_der		;9aa7
prota_abajo_izq:		; Abajo y a la izquierda
	call prota_izq		;9aaa
	jp prota_abajo		;9aad
prota_arriba_izq:		; Arriba y a la izquierda
	call prota_izq		;9ab0
	jp prota_arriba		;9ab3
pasa_abajo:		; C si se pasa abajo: las casillas de la fila Y + 16 (X + 4 y X + 12) por debajo de 0xC0
	ld a,(ix+000h)		;9ab6   ; la Y + 16
	add a,010h		;9ab9
	jr pasa_fila		;9abb
pasa_arriba:		; C si se pasa arriba: la fila Y + 7
	ld a,(ix+000h)		;9abd   ; la Y + 7
	add a,007h		;9ac0
pasa_fila:		; Las dos casillas (X + 4 y X + 12) de la fila A / 8 en el mapa (0xEA50 + 24 x 0xE192, hacia atras): C si las dos son de menos de 0xC0
	srl a		;9ac2   ; entre 8: la fila
	srl a		;9ac4
	srl a		;9ac6
	ld b,a			;9ac8
	push bc			;9ac9
	ld hl,0ea50h		;9aca   ; el mapa (0xEA50)...
	ld a,(0e192h)		;9acd   ; ...mas las filas avanzadas (0xE192)
	and a			;9ad0
	jr z,L_9ADA		;9ad1
	ld b,a			;9ad3
	ld de,00018h		;9ad4
L_9AD7:
	add hl,de			;9ad7
	djnz L_9AD7		;9ad8
L_9ADA:
	pop bc			;9ada
	ld de,0ffe8h		;9adb   ; hacia atras, 24 por fila
casillas_pies_suma:
	add hl,de			;9ade   ; una fila
	djnz casillas_pies_suma		;9adf
casillas_pies_col:
	push hl			;9ae1
	ld a,(ix+001h)		;9ae2   ; la X + 4...
	add a,004h		;9ae5
	srl a		;9ae7   ; ...entre 8
	srl a		;9ae9
	srl a		;9aeb
	add a,l			;9aed
	jr nc,casillas_pies_1		;9aee
	inc h			;9af0
casillas_pies_1:
	ld l,a			;9af1
	ld a,(hl)			;9af2   ; la casilla
	ld (ix+015h),a		;9af3   ; en +0x14
	pop hl			;9af6
casillas_der_col:
	ld a,(ix+001h)		;9af7   ; la X + 12...
	add a,00ch		;9afa
	srl a		;9afc   ; ...entre 8
	srl a		;9afe
	srl a		;9b00
	add a,l			;9b02
	jr nc,casillas_der_lee		;9b03
	inc h			;9b05
casillas_der_lee:
	ld l,a			;9b06
	ld a,(hl)			;9b07   ; la casilla
	ld (ix+016h),a		;9b08   ; en +0x14
	cp 0c0h		;9b0b   ; 0xC0 o mas: no se pasa
	ret nc			;9b0d
	ld a,(ix+015h)		;9b0e   ; la otra...
	cp 0c0h		;9b11   ; ...0xC0 o mas?
	ret nc			;9b13
	scf			;9b14   ; se pasa: C
	ret			;9b15
pasa_der:		; C si se pasa a la derecha: la columna X + 13, en las filas Y + 9 e Y + 15
	ld c,00dh		;9b16   ; X + 13
pasa_lado:		; Las casillas de la columna X + C en las filas Y + 9 e Y + 15: C si las dos son de menos de 0xC0
	ld a,(ix+000h)		;9b18   ; la Y + 9...
	add a,009h		;9b1b
	srl a		;9b1d   ; ...entre 8
	srl a		;9b1f
	srl a		;9b21
	ld b,a			;9b23
	push bc			;9b24
	ld hl,0ea50h		;9b25   ; el mapa
	ld a,(0e192h)		;9b28
	and a			;9b2b
	jr z,L_9B35		;9b2c
	ld b,a			;9b2e
	ld de,00018h		;9b2f
L_9B32:
	add hl,de			;9b32
	djnz L_9B32		;9b33
L_9B35:
	ld (0e1a0h),hl		;9b35   ; apuntado
	pop bc			;9b38
	ld de,0ffe8h		;9b39
L_9B3C:
	add hl,de			;9b3c
	djnz L_9B3C		;9b3d
	ld a,(ix+001h)		;9b3f   ; la X + C...
	add a,c			;9b42
	srl a		;9b43   ; ...entre 8
	srl a		;9b45
	srl a		;9b47
	add a,l			;9b49
	jr nc,casillas_pies_2		;9b4a
	inc h			;9b4c
casillas_pies_2:
	ld l,a			;9b4d
	ld a,(hl)			;9b4e   ; la casilla
	ld (ix+015h),a		;9b4f   ; en +0x15
	ld a,(ix+000h)		;9b52   ; la Y + 15
	add a,00fh		;9b55
	srl a		;9b57
	srl a		;9b59
	srl a		;9b5b
	ld b,a			;9b5d
	ld hl,(0e1a0h)		;9b5e
	ld de,0ffe8h		;9b61
L_9B64:
	add hl,de			;9b64   ; una fila atras
	djnz L_9B64		;9b65
	ld a,(ix+001h)		;9b67   ; la X + C...
	add a,c			;9b6a
	srl a		;9b6b   ; ...entre 8
	srl a		;9b6d
	srl a		;9b6f
	add a,l			;9b71
	jr nc,L_9B75		;9b72
	inc h			;9b74
L_9B75:
	ld l,a			;9b75   ; la casilla
	ld a,(hl)			;9b76   ; la otra casilla
	ld (ix+016h),a		;9b77   ; en +0x16
	cp 0c0h		;9b7a   ; 0xC0 o mas?
	ret nc			;9b7c   ; 0xC0 o mas: no
	ld a,(ix+015h)		;9b7d   ; la primera...
	cp 0c0h		;9b80   ; ...0xC0 o mas?
	ret nc			;9b82   ; tampoco
	scf			;9b83   ; se pasa
	ret			;9b84   ; C: se pasa
pasa_izq:		; C si se pasa a la izquierda: la columna X + 3
	ld c,003h		;9b85   ; X + 3
	jr pasa_lado		;9b87   ; a mirar
pantalla_monta:		; La pantalla siguiente: la de ahora (0xEA80) pasa a 0xE840 y la nueva se monta en 0xEA80 desde la tabla de la escena (0x4068 + 2 x escena: una por pantalla, 0xE053): el juego de casillas (0xE1BE), rectangulos, rellenos de cuatro, el borde (0x49B6 o 0x49DB), los dibujos y los objetos
	ld hl,0ea80h		;9b89   ; la de ahora...
	ld de,0e840h		;9b8c   ; ...a 0xE840
	ld (0e190h),de		;9b8f   ; la ventana, en la vieja
	ld bc,00240h		;9b93   ; 0x240 bytes
	ldir		;9b96
	ld hl,0ea80h		;9b98   ; la nueva...
	ld bc,00240h		;9b9b   ; ...en blanco
L_9B9E:
	ld (hl),010h		;9b9e
	inc hl			;9ba0
	dec bc			;9ba1
	ld a,c			;9ba2
	or b			;9ba3
	jr nz,L_9B9E		;9ba4
	ld a,(0e050h)		;9ba6   ; la escena
	ld hl,04068h		;9ba9   ; la tabla (0x4068)
	add a,a			;9bac
	add a,l			;9bad
	jr nc,L_9BB1		;9bae
	inc h			;9bb0
L_9BB1:
	ld l,a			;9bb1
	ld e,(hl)			;9bb2   ; la tabla de sus pantallas
	inc hl			;9bb3
	ld d,(hl)			;9bb4
	ex de,hl			;9bb5
	ld a,(0e053h)		;9bb6   ; la pantalla (0xE053)
	add a,a			;9bb9
	add a,l			;9bba
	jr nc,L_9BBE		;9bbb
	inc h			;9bbd
L_9BBE:
	ld l,a			;9bbe
	ld e,(hl)			;9bbf   ; su descripcion
	inc hl			;9bc0
	ld d,(hl)			;9bc1
	ld a,(de)			;9bc2   ; el juego de casillas
	ld (0e1beh),a		;9bc3   ; en 0xE1BE
	inc de			;9bc6
	call rellenos_1		;9bc7   ; rectangulos
	inc de			;9bca
	call rellenos_4		;9bcb   ; rellenos de cuatro
	inc de			;9bce
	ld a,(de)			;9bcf   ; el borde?
	inc de			;9bd0
	cp 0ffh		;9bd1   ; 0xFF: sin borde
	jr z,dibujos_pon		;9bd3
	push de			;9bd5
	cp 002h		;9bd6   ; 2: el de 0x49DB
	jr z,L_9BDF		;9bd8
	ld de,049b6h		;9bda   ; si no, 0x49B6
	jr borde_pon		;9bdd
L_9BDF:
	ld de,049dbh		;9bdf
borde_pon:		; Los dibujos del borde hasta 0xFF
	ld a,(de)			;9be2   ; 0xFF?
	cp 0ffh		;9be3
	jr z,L_9BEF		;9be5
	call mapa_sitio		;9be7   ; el sitio
	call dibujo_va		;9bea   ; el dibujo
	jr borde_pon		;9bed
L_9BEF:
	pop de			;9bef
dibujos_pon:		; Los dibujos de la pantalla (sitio y puntero) hasta 0xFF; luego los objetos
	ld a,(de)			;9bf0   ; 0xFF?
	cp 0ffh		;9bf1
	jp z,objetos_pon		;9bf3   ; si: los objetos
	call mapa_sitio		;9bf6   ; el sitio
	call dibujo_va		;9bf9   ; el dibujo
	jr dibujos_pon		;9bfc
dibujo_va:		; El dibujo del puntero DE en HL
	ld a,(de)			;9bfe   ; el puntero
	ld c,a			;9bff
	inc de			;9c00
	ld a,(de)			;9c01
	ld b,a			;9c02
	inc de			;9c03
	push de			;9c04
	ld e,c			;9c05
	ld d,b			;9c06
	call dibujo_pon		;9c07   ; el dibujo
	pop de			;9c0a
	ret			;9c0b
dibujo_pon:		; Un dibujo de casillas (ancho, alto y las casillas) en HL (filas de 32)
	ld a,(de)			;9c0c   ; el ancho
	ld (0e1a0h),a		;9c0d
	inc de			;9c10
	ld a,(de)			;9c11   ; el alto
	ld b,a			;9c12
	inc de			;9c13
dibujo_fila:
	ld a,(0e1a0h)		;9c14
	ld c,a			;9c17
	push hl			;9c18
dibujo_casilla:
	ld a,(de)			;9c19   ; una casilla
	and a			;9c1a   ; 0: se deja lo que habia
	jr z,L_9C1E		;9c1b
	ld (hl),a			;9c1d
L_9C1E:
	inc de			;9c1e   ; la siguiente
	inc hl			;9c1f
	dec c			;9c20   ; una menos
	jr nz,dibujo_casilla		;9c21   ; la fila entera
	pop hl			;9c23   ; su principio
	push de			;9c24
	ld de,00018h		;9c25   ; una fila abajo: +24
	add hl,de			;9c28
	pop de			;9c29
	djnz dibujo_fila		;9c2a   ; el alto
	ret			;9c2c
rellenos_4:		; Rectangulos de cuatro casillas que se alternan hasta 0xFF
	ld a,(de)			;9c2d   ; 0xFF?
	cp 0ffh		;9c2e   ; 0xFF?
	ret z			;9c30   ; se acabo
	call mapa_sitio		;9c31   ; el sitio
	ld a,(de)			;9c34   ; el ancho
	ld (0e1a0h),a		;9c35   ; apuntado
	inc de			;9c38   ; el alto
	ld a,(de)			;9c39   ; el alto
	inc de			;9c3a   ; detras
	ld b,a			;9c3b   ; las filas
	ld (0e1a1h),hl		;9c3c   ; su sitio
	ld a,(de)			;9c3f   ; la casilla N
	ld (0e1a4h),a		;9c40   ; apuntada
	inc de			;9c43   ; detras
	xor a			;9c44   ; la primera fila, par
	ld (0e1a3h),a		;9c45   ; la primera fila, par
trozo_rect2_fila:		; Una fila: las pares N, N+1, N, N+1...; las impares N+2, N+3...
	ld hl,(0e1a1h)		;9c48   ; su sitio
	ld a,(0e1a0h)		;9c4b   ; el ancho
	ld c,a			;9c4e
	ld a,(0e1a3h)		;9c4f   ; fila par o impar?
	and a			;9c52
	jr nz,trozo_rect2_impar		;9c53
	cpl			;9c55   ; la siguiente, impar
	ld (0e1a3h),a		;9c56
trozo_rect2_par:
	ld a,(0e1a4h)		;9c59   ; N y N+1
	ld (hl),a			;9c5c   ; N
	inc hl			;9c5d   ; la siguiente
	dec c			;9c5e
	jr z,trozo_rect2_sigue		;9c5f
	ld a,(0e1a4h)		;9c61   ; N + 1
	inc a			;9c64
	ld (hl),a			;9c65
	inc hl			;9c66   ; la siguiente
	dec c			;9c67
	jr nz,trozo_rect2_par		;9c68   ; la fila entera
	jr trozo_rect2_sigue		;9c6a
trozo_rect2_impar:
	cpl			;9c6c   ; la siguiente, par
	ld (0e1a3h),a		;9c6d
trozo_rect2_impar_par:
	ld a,(0e1a4h)		;9c70   ; N+2 y N+3
	add a,002h		;9c73   ; N + 2
	ld (hl),a			;9c75
	inc hl			;9c76   ; la siguiente
	dec c			;9c77
	jr z,trozo_rect2_sigue		;9c78
	ld a,(0e1a4h)		;9c7a   ; N + 3
	add a,003h		;9c7d
	ld (hl),a			;9c7f
	inc hl			;9c80   ; la siguiente
	dec c			;9c81
	jr nz,trozo_rect2_impar_par		;9c82   ; la fila entera
	jr trozo_rect2_sigue		;9c84
trozo_rect2_sigue:
	ld hl,(0e1a1h)		;9c86   ; la fila siguiente
	push de			;9c89
	ld de,00018h		;9c8a   ; una fila abajo
	add hl,de			;9c8d
	pop de			;9c8e
	ld (0e1a1h),hl		;9c8f
	djnz trozo_rect2_fila		;9c92
	jr rellenos_4		;9c94
rellenos_1:		; Rectangulos hasta 0xFF: el sitio (fila y columna), el ancho, el alto y una casilla
	ld a,(de)			;9c96   ; 0xFF?
	cp 0ffh		;9c97
	ret z			;9c99
	call mapa_sitio		;9c9a   ; el sitio
	ld (0e1a2h),hl		;9c9d   ; apuntado
	ld a,(de)			;9ca0   ; el ancho
	ld (0e1a0h),a		;9ca1
	inc de			;9ca4
	ld a,(de)			;9ca5   ; el alto
	ld b,a			;9ca6   ; las filas
	inc de			;9ca7
	ld a,(de)			;9ca8   ; la casilla
	ld (0e1a1h),a		;9ca9   ; apuntada
	inc de			;9cac
trozo_rect1_fila:
	ld a,(0e1a0h)		;9cad   ; el ancho
	ld c,a			;9cb0
trozo_rect1_casilla:
	ld a,(0e1a1h)		;9cb1   ; la casilla
	ld (hl),a			;9cb4   ; puesta
	inc hl			;9cb5   ; la siguiente
	dec c			;9cb6
	jr nz,trozo_rect1_casilla		;9cb7   ; la fila entera
	push de			;9cb9
	ld de,00018h		;9cba   ; una fila abajo
	ld hl,(0e1a2h)		;9cbd
	add hl,de			;9cc0
	ld (0e1a2h),hl		;9cc1
	pop de			;9cc4
	djnz trozo_rect1_fila		;9cc5   ; una fila menos
	jr rellenos_1		;9cc7   ; el siguiente
mapa_sitio:		; La fila (A) y la columna (el byte siguiente) en la pantalla nueva: HL = 0xEA80 + 24 x fila + columna
	ld hl,0ea80h		;9cc9
	and a			;9ccc   ; la fila 0?
	jr z,L_9CD8		;9ccd
	ld b,a			;9ccf
	push de			;9cd0
	ld de,00018h		;9cd1   ; 24 por fila
L_9CD4:
	add hl,de			;9cd4
	djnz L_9CD4		;9cd5
	pop de			;9cd7
L_9CD8:
	inc de			;9cd8
	ld a,(de)			;9cd9   ; la columna
	add a,l			;9cda
	jr nc,L_9CDE		;9cdb
	inc h			;9cdd
L_9CDE:
	ld l,a			;9cde
	inc de			;9cdf   ; detras
	ret			;9ce0
objetos_pon:		; Los objetos de la pantalla (hasta 0xFF: tipo, fila, columna y el dibujo) en el primer hueco libre de 0xE500: Y por encima de la pantalla (-(fila + 2) x 8), X = columna x 8, su sitio en el mapa (+5)
	inc de			;9ce1
	ld iy,0e500h		;9ce2   ; los objetos
L_9CE6:
	ld a,(de)			;9ce6   ; 0xFF?
	cp 0ffh		;9ce7
	ret z			;9ce9
	push de			;9cea
	ld de,00010h		;9ceb   ; 16 huecos
	ld b,010h		;9cee
trozo_objeto_libre:
	ld a,(iy+004h)		;9cf0   ; libre?
	and a			;9cf3
	jr z,trozo_objeto_pon		;9cf4
	add iy,de		;9cf6
	djnz trozo_objeto_libre		;9cf8
	pop de			;9cfa   ; ninguno
	ret			;9cfb
trozo_objeto_pon:
	pop de			;9cfc
	ld a,(de)			;9cfd   ; su tipo
	ld (iy+004h),a		;9cfe
	inc de			;9d01
	push de			;9d02
	ld a,(de)			;9d03   ; la fila + 5...
	add a,002h		;9d04
	ld b,a			;9d06
	xor a			;9d07
trozo_objeto_y:
	add a,008h		;9d08   ; ...x 8
	djnz trozo_objeto_y		;9d0a
	ld b,a			;9d0c   ; en negativo: por encima
	xor a			;9d0d
	sub b			;9d0e
	ld (iy+000h),a		;9d0f
	inc de			;9d12
	ld a,(de)			;9d13   ; la columna...
	ld b,a			;9d14
	xor a			;9d15
trozo_objeto_x:
	add a,008h		;9d16   ; ...x 8
	djnz trozo_objeto_x		;9d18
	ld (iy+001h),a		;9d1a
	pop de			;9d1d
	ld a,(de)			;9d1e   ; su sitio en la pantalla de la RAM
	call mapa_sitio		;9d1f
	ld (iy+005h),l		;9d22
	ld (iy+006h),h		;9d25
	call dibujo_va		;9d28
	jr L_9CE6		;9d2b
pantalla_borde:		; El borde de la escena: 0x49DB en las 1, 2 y 5; 0x49B6 en las 0, 3 y 4; y la pantalla a la vista
	ld a,(0e003h)		;9d2d   ; la escena
	cp 000h		;9d30   ; la 0?
	jr z,L_9D49		;9d32
	cp 001h		;9d34   ; la 1?
	jr z,L_9D44		;9d36
	cp 002h		;9d38   ; la 2?
	jr z,L_9D44		;9d3a
	cp 003h		;9d3c   ; la 3?
	jr z,L_9D49		;9d3e
	cp 004h		;9d40   ; la 4?
	jr z,L_9D49		;9d42
L_9D44:
	ld de,049dbh		;9d44   ; la 5 (y la 1 y la 2): 0x49DB
	jr borde_dibuja		;9d47
L_9D49:
	ld de,049b6h		;9d49   ; 0x49B6
borde_dibuja:		; Los dibujos del borde hasta 0xFF
	ld a,(de)			;9d4c   ; 0xFF?
	cp 0ffh		;9d4d
	jr z,pantalla_vista		;9d4f
	call mapa_sitio		;9d51   ; el sitio
	call dibujo_va		;9d54   ; el dibujo
	jr borde_dibuja		;9d57
pantalla_vista:		; A la vista
	call avance_objetos		;9d59
	ret			;9d5c
nada:		; Nada
	ret			;9d5d
empujado:		; En la pantalla 9: cada 12 cuadros, el protagonista 8 abajo (hasta 0xA8) y la pantalla avanza una linea
	ld a,(0e053h)		;9d5e   ; pasada?
	cp 00ah		;9d61
	ret nc			;9d63
	ld a,(0e195h)		;9d64   ; cada 12 cuadros
	inc a			;9d67
	ld (0e195h),a		;9d68
	cp 00ch		;9d6b
	ret c			;9d6d
	xor a			;9d6e
	ld (0e195h),a		;9d6f
	ld a,(ix+000h)		;9d72   ; 8 abajo...
	add a,008h		;9d75
	cp 0a8h		;9d77   ; ...hasta 0xA8
	jr c,L_9D7D		;9d79
	ld a,0a8h		;9d7b
L_9D7D:
	ld (ix+000h),a		;9d7d
	jr L_9DA8		;9d80
avanza:		; La pantalla avanza (hasta la pantalla 9): una fila cada 16 cuadros (13 con la velocidad); los objetos y los enemigos bajan 8; a las 24 filas, la pantalla siguiente
	ld a,(0e053h)		;9d82   ; la pantalla 9?
	cp 009h		;9d85   ; si: no avanza
	ret nc			;9d87
	ld a,(ix+01eh)		;9d88   ; la velocidad?
	and a			;9d8b
	jr z,L_9D9A		;9d8c
	ld a,(0e195h)		;9d8e
	inc a			;9d91
	ld (0e195h),a		;9d92
	cp 00dh		;9d95   ; 13 cuadros
	ret c			;9d97
	jr avanza_fila		;9d98
L_9D9A:
	ld a,(0e195h)		;9d9a
	inc a			;9d9d
	ld (0e195h),a		;9d9e
	cp 010h		;9da1   ; 16 cuadros
	ret c			;9da3
avanza_fila:		; Una fila mas: los objetos (0xE500) y los enemigos (0xE380) 8 abajo
	xor a			;9da4
	ld (0e195h),a		;9da5
L_9DA8:
	ld hl,(0e193h)		;9da8   ; la cuenta de filas (0xE193)
	inc hl			;9dab
	ld (0e193h),hl		;9dac
	ld iy,0e500h		;9daf   ; los objetos
	ld de,00010h		;9db3
	ld b,010h		;9db6
L_9DB8:
	ld a,(iy+004h)		;9db8
	and a			;9dbb
	jr nz,L_9DC4		;9dbc
L_9DBE:
	add iy,de		;9dbe
	djnz L_9DB8		;9dc0
	jr L_9DD4		;9dc2
L_9DC4:
	ld a,(iy+000h)		;9dc4   ; 8 abajo
	add a,008h		;9dc7
	ld (iy+000h),a		;9dc9
	and a			;9dcc
	jr nz,L_9DBE		;9dcd
	inc (iy+003h)		;9dcf   ; pasa de 0: +3
	jr L_9DBE		;9dd2
L_9DD4:
	ld iy,0e380h		;9dd4   ; los enemigos
	ld de,00010h		;9dd8
	ld b,00eh		;9ddb
L_9DDD:
	ld a,(iy+004h)		;9ddd
	and a			;9de0
	jr nz,L_9DE9		;9de1
L_9DE3:
	add iy,de		;9de3
	djnz L_9DDD		;9de5
	jr L_9DF3		;9de7
L_9DE9:
	ld a,(iy+000h)		;9de9   ; 8 abajo
	add a,008h		;9dec
	ld (iy+000h),a		;9dee
	jr L_9DE3		;9df1
L_9DF3:
	ld hl,(0e190h)		;9df3   ; la ventana, una fila
	ld de,00018h		;9df6
	add hl,de			;9df9
	ld (0e190h),hl		;9dfa
	ld a,(0e192h)		;9dfd   ; la fila de la pantalla (0xE192)
	inc a			;9e00
	ld (0e192h),a		;9e01
	cp 018h		;9e04   ; 24?
	jr c,ventana_pon		;9e06
	xor a			;9e08   ; si: la pantalla siguiente
	ld (0e192h),a		;9e09
	ld a,(0e053h)		;9e0c
	inc a			;9e0f
	ld (0e053h),a		;9e10
avance_objetos:		; Los objetos en pantalla: su sitio en el mapa, 0x240 atras (la pantalla nueva desplaza a la vieja)
	ld iy,0e500h		;9e13
	ld de,00010h		;9e17
	ld b,010h		;9e1a
avance_objetos_uno:
	ld a,(iy+000h)		;9e1c
	and a			;9e1f
	jr nz,avance_objetos_mueve		;9e20
avance_objetos_sig:
	add iy,de		;9e22
	djnz avance_objetos_uno		;9e24
	jr avance_monta		;9e26
avance_objetos_mueve:
	ld l,(iy+005h)		;9e28   ; su sitio en la pantalla de la RAM...
	ld h,(iy+006h)		;9e2b
	ld de,0fdc0h		;9e2e   ; ...24 filas atras (- 0x300)
	add hl,de			;9e31
	ld (iy+005h),l		;9e32
	ld (iy+006h),h		;9e35
	ld de,00010h		;9e38
	jr avance_objetos_sig		;9e3b
avance_monta:		; La pantalla nueva
	call pantalla_monta		;9e3d
ventana_pon:		; La ventana (0xE190): 24 filas de 24 casillas a la VRAM, desde la fila 23 hacia arriba
	ld hl,(0e190h)		;9e40   ; la ventana
	ld (0e1a0h),hl		;9e43
	ld hl,01ae0h		;9e46   ; la fila 23
	ld (0e1a2h),hl		;9e49
	ld b,018h		;9e4c   ; 24 filas
L_9E4E:
	push bc			;9e4e
	ld hl,(0e1a0h)		;9e4f
	ld de,(0e1a2h)		;9e52
	ld bc,00018h		;9e56   ; 24 casillas
	call 0005ch		;9e59   ; LDIRVM
	ld hl,(0e1a0h)		;9e5c
	ld de,00018h		;9e5f   ; la siguiente, en la RAM
	add hl,de			;9e62
	ld (0e1a0h),hl		;9e63
	ld hl,(0e1a2h)		;9e66
	ld de,0ffe0h		;9e69   ; una fila arriba, en la VRAM
	add hl,de			;9e6c
	ld (0e1a2h),hl		;9e6d
	pop bc			;9e70
	djnz L_9E4E		;9e71
	ret			;9e73
objetos:		; Los 16 objetos de 0xE500 (16 bytes; +4 el tipo): los que tienen tipo van a su rutina por la tabla de 0x9E9D
	ld iy,0e500h		;9e74   ; 16
	ld b,010h		;9e78
otros_uno:
	push bc			;9e7a   ; la cuenta
	ld a,(iy+004h)		;9e7b   ; esta?
	and a			;9e7e
	jr nz,otros_mueve		;9e7f
otros_sig:
	ld de,00010h		;9e81   ; el siguiente: + 16
	add iy,de		;9e84
	pop bc			;9e86
	djnz otros_uno		;9e87
	ret			;9e89
otros_mueve:
	call objeto_salta		;9e8a   ; se mueve
	jr otros_sig		;9e8d
objeto_salta:		; A la rutina del tipo A (tabla 0x9E9D)
	ld hl,09e9dh		;9e8f
	add a,a			;9e92
	add a,l			;9e93
	jr nc,L_9E97		;9e94
	inc h			;9e96
L_9E97:
	ld l,a			;9e97   ; la tabla
	ld e,(hl)			;9e98   ; la rutina
	inc hl			;9e99
	ld d,(hl)			;9e9a
	ex de,hl			;9e9b
	jp (hl)			;9e9c   ; a ella

; ----------------------------------------------------------------------
; DATOS objetos_tabla: Las rutinas de los 16 tipos de objeto de 0xE500
;   0x9e9d..0x9ebd  (32 bytes)
DATA_objetos_tabla:
	defb 07fh,0a6h,07fh,0a6h,07fh,0a6h,07fh,0a6h,0d6h,0a7h,07fh,0a6h,07eh,0aah,03dh,0abh	; 9e9d  ............~.=.
	defb 084h,0abh,03dh,0abh,01ah,0ach,042h,0ach,042h,0ach,042h,0ach,042h,0ach,042h,0ach	; 9ead  ..=...B.B.B.B.B.

; ======================================================================
; CODIGO 0x9ebd..0x9ef3  (54 bytes)
; ======================================================================


otro_borra_corto:		; Los 16 bytes del objeto IY a cero (sin sacarlo de la pantalla)
	push iy		;9ebd
	pop hl			;9ebf
	ld b,010h		;9ec0
L_9EC2:
	ld (hl),000h		;9ec2
	inc hl			;9ec4
	djnz L_9EC2		;9ec5
	ret			;9ec7
enemigos:		; Los 16 enemigos de 0xE380 (+4 el tipo): cada uno a su rutina por la tabla de 0x9EF3; y luego los objetos
	ld iy,0e380h		;9ec8   ; 16
	ld b,010h		;9ecc   ; 16
enemigo_uno:
	push bc			;9ece
	ld a,(iy+004h)		;9ecf   ; esta?
	and a			;9ed2
	jr nz,L_9EE0		;9ed3
enemigo_sig:
	ld de,00010h		;9ed5   ; el siguiente (+16)
	add iy,de		;9ed8
	pop bc			;9eda
	djnz enemigo_uno		;9edb
	jp objetos		;9edd   ; y los objetos de tierra
L_9EE0:
	call enemigo_salta		;9ee0
	jr enemigo_sig		;9ee3
enemigo_salta:		; A la rutina del tipo A (tabla 0x9EF3)
	ld hl,09ef3h		;9ee5
	add a,a			;9ee8
	add a,l			;9ee9
	jr nc,L_9EED		;9eea
	inc h			;9eec
L_9EED:
	ld l,a			;9eed   ; la tabla
	ld e,(hl)			;9eee   ; la rutina
	inc hl			;9eef
	ld d,(hl)			;9ef0
	ex de,hl			;9ef1
	jp (hl)			;9ef2   ; a ella

; ----------------------------------------------------------------------
; DATOS enemigos_tabla: Las rutinas de los 16 tipos de enemigo de 0xE380
;   0x9ef3..0x9f13  (32 bytes)
DATA_enemigos_tabla:
	defb 07ah,09fh,07ah,09fh,07ah,09fh,0a8h,0a0h,0a8h,0a0h,0a8h,0a0h,07ah,09fh,099h,0a1h	; 9ef3  z.z.z.......z...
	defb 07ah,09fh,017h,0a2h,095h,0a2h,0b6h,0a3h,0d1h,0a3h,0ech,0a3h,020h,0a4h,029h,0a3h	; 9f03  z........... .).

; ======================================================================
; CODIGO 0x9f13..0xa49b  (1416 bytes)
; ======================================================================


vencido:		; Un enemigo vencido (+5 = 0x0A): 0x20 cuadros de explosion; luego fuera (y, antes de la pantalla 9, 0xE199 = 0x10)
	inc (iy+006h)		;9f13   ; la cuenta
	ld a,(iy+006h)		;9f16
	cp 020h		;9f19   ; 0x20?
	jr c,L_9F2D		;9f1b
	ld a,(0e053h)		;9f1d   ; la pantalla 9 (el jefe)?
	cp 009h		;9f20
	jp nc,L_A59C		;9f22
	ld a,010h		;9f25   ; si no: 0xE199 = 0x10
	ld (0e199h),a		;9f27
	jp L_A59C		;9f2a
L_9F2D:
	ld a,(iy+004h)		;9f2d   ; el tipo...
	cp 001h		;9f30   ; 1, 3 o 6: la explosion grande
	jr z,L_9F3E		;9f32
	cp 003h		;9f34
	jr z,L_9F3E		;9f36
	cp 006h		;9f38
	jr z,L_9F3E		;9f3a
	jr vencido_chico		;9f3c
L_9F3E:
	ld a,(iy+006h)		;9f3e   ; los 10 primeros cuadros...
	cp 00ah		;9f41
	jr nc,L_9F4E		;9f43
	ld (iy+002h),0a8h		;9f45   ; ...el dibujo 0xA8, color 1
	ld (iy+003h),001h		;9f49
	ret			;9f4d
L_9F4E:
	ld a,(0e012h)		;9f4e   ; luego, color 1 o 3 cada 2 cuadros...
	and 002h		;9f51
	add a,001h		;9f53
	ld (iy+003h),a		;9f55
	ld a,(0e012h)		;9f58   ; ...y 0xA8 o 0xAC cada 8
	and 008h		;9f5b
	rrca			;9f5d
	add a,0a8h		;9f5e
	ld (iy+002h),a		;9f60
	ret			;9f63
vencido_chico:		; Los demas: color 9 u 11 cada 2 cuadros y los dibujos 0xB0/0xB4 cada 8
	ld a,(0e012h)		;9f64   ; cada 2 cuadros...
	and 002h		;9f67   ; ...color 9 u 11
	add a,009h		;9f69
	ld (iy+003h),a		;9f6b
	ld a,(0e012h)		;9f6e   ; cada 8...
	and 008h		;9f71
	rrca			;9f73
	add a,0b0h		;9f74   ; ...0xB0 o 0xB4
	ld (iy+002h),a		;9f76
	ret			;9f79
enemigo_a:		; Los enemigos 0, 1, 2, 6 y 8: al salir, arriba de la pantalla, cerca de la X del protagonista (-0x20 + 0-0x3F); dos sprites (dibujos 0x30/0x34; el 2, 0xC8; el 6, 0x70; el 0 y el 8, 0xB8); andan en diagonal cambiando de lado cada 0x20-0x5F cuadros; el 2 dispara (0xEC) y el 6 tambien (0xB0) cada tanto
	ld a,(iy+005h)		;9f7a   ; recien salido?
	and a			;9f7d   ; recien salido?
	jp nz,enemigo_a_anda		;9f7e
	inc (iy+005h)		;9f81   ; ya no
	ld (iy+000h),000h		;9f84   ; arriba del todo
	ld (iy+010h),000h		;9f88   ; el segundo, arriba
	ld a,(ix+001h)		;9f8c   ; la X del protagonista - 0x20...
	sub 020h		;9f8f   ; menos 0x20
	ld b,a			;9f91
	ld a,r		;9f92   ; ...+ 0-0x3F al azar
	and 03fh		;9f94
	add a,b			;9f96
	ld (iy+001h),a		;9f97
	ld (iy+011h),a		;9f9a
	ld (iy+002h),030h		;9f9d   ; los dibujos 0x30 y 0x34, colores 1 y 5
	ld (iy+003h),001h		;9fa1
	ld (iy+012h),034h		;9fa5
	ld (iy+013h),005h		;9fa9
	ld (iy+014h),00fh		;9fad   ; +0x14 = 0x0F: hay segundo sprite
	ld (iy+00ah),030h		;9fb1   ; sus dibujos: 0x30 (+0x0A)
	ld (iy+00eh),005h		;9fb5   ; 5 (50 puntos)
	ld a,r		;9fb9   ; al azar, 0x20-0x3F cuadros...
	and 01fh		;9fbb
	add a,020h		;9fbd
	ld (iy+007h),a		;9fbf
	and 002h		;9fc2   ; ...y el lado (bit 1)
	ld (iy+008h),a		;9fc4
	ld a,(iy+004h)		;9fc7   ; el tipo
	cp 001h		;9fca   ; 1: asi
	ret z			;9fcc
	cp 002h		;9fcd   ; 2: colores 1 y 10, dibujos 0xC8, 0x10 (100 puntos)
	jr nz,L_9FE2		;9fcf
	ld (iy+003h),001h		;9fd1
	ld (iy+013h),00ah		;9fd5
	ld (iy+00ah),0c8h		;9fd9
	ld (iy+00eh),010h		;9fdd
	ret			;9fe1
L_9FE2:
	cp 006h		;9fe2   ; 6: colores 1 y 15, dibujos 0x70, 7 (70)
	jr nz,L_9FF7		;9fe4
	ld (iy+003h),001h		;9fe6
	ld (iy+013h),00fh		;9fea
	ld (iy+00ah),070h		;9fee
	ld (iy+00eh),007h		;9ff2
	ret			;9ff6
L_9FF7:
	ld (iy+003h),00ch		;9ff7   ; los demas: colores 12 y 5, dibujos 0xB8, 6 (60)
	ld (iy+013h),005h		;9ffb
	ld (iy+00ah),0b8h		;9fff
	ld (iy+00eh),006h		;a003
	ret			;a007
enemigo_a_anda:		; Andando: los dibujos cada 8 cuadros; al acabar la cuenta, otro lado y otra pausa al azar; el 2 dispara; el 6, cada 2 cuadros, y los demas cada 3, un paso en diagonal (1 abajo y 1 al lado)
	cp 00ah		;a008   ; vencido?
	jp z,vencido		;a00a
	ld b,(iy+00ah)		;a00d   ; sus dibujos...
	ld a,(0e012h)		;a010   ; ...+8 cada 8 cuadros
	and 008h		;a013
	add a,b			;a015
	ld (iy+002h),a		;a016
	add a,004h		;a019   ; +4, el segundo
	ld (iy+012h),a		;a01b
	dec (iy+007h)		;a01e   ; la cuenta
	jr nz,L_A03A		;a021
	ld a,r		;a023   ; al azar: 0x30-0x6F
	and 03fh		;a025
	add a,030h		;a027
	ld (iy+007h),a		;a029
	and 002h		;a02c   ; el lado
	ld (iy+008h),a		;a02e
	ld a,r		;a031   ; la pausa: 0x10-0x2F
	and 01fh		;a033
	add a,010h		;a035
	ld (iy+009h),a		;a037
L_A03A:
	ld a,(iy+004h)		;a03a   ; el 2?
	cp 002h		;a03d
	jr nz,L_A048		;a03f
	ld c,0ech		;a041   ; dispara (0xEC)
	call enemigo_dispara		;a043
	jr enemigo_a_pausa		;a046
L_A048:
	cp 006h		;a048   ; el 6?
	jr nz,L_A05D		;a04a
	inc (iy+006h)		;a04c   ; cada 2 cuadros
	ld a,(iy+006h)		;a04f
	cp 002h		;a052
	jp c,enemigo_comun		;a054
	ld (iy+006h),000h		;a057
	jr enemigo_a_pausa		;a05b
L_A05D:
	inc (iy+006h)		;a05d   ; los demas, cada 3
	ld a,(iy+006h)		;a060
	cp 003h		;a063
	jp c,enemigo_comun		;a065
	ld (iy+006h),000h		;a068
enemigo_a_pausa:		; El 2 y el 6 se paran mientras dura la pausa (el 6, disparando 0xB0)
	ld a,(iy+004h)		;a06c   ; el 2?
	cp 002h		;a06f
	jr nz,L_A07F		;a071
	ld a,(iy+009h)		;a073   ; la pausa?
	and a			;a076
	jr z,L_A07F		;a077
	dec (iy+009h)		;a079   ; un cuadro menos
	jp enemigo_comun		;a07c
L_A07F:
	cp 006h		;a07f   ; el 6?
	jr nz,enemigo_a_paso		;a081
	ld a,(iy+009h)		;a083
	and a			;a086
	jr z,enemigo_a_paso		;a087
	dec (iy+009h)		;a089
	ld c,0b0h		;a08c   ; dispara (0xB0)
	call enemigo_dispara		;a08e
	jp enemigo_comun		;a091
enemigo_a_paso:		; Un paso: 1 al lado (+8: derecha o izquierda) y 1 abajo
	ld a,(iy+008h)		;a094   ; el lado
	and a			;a097
	jr nz,L_A09F		;a098
	inc (iy+001h)		;a09a   ; a la derecha
	jr L_A0A2		;a09d
L_A09F:
	dec (iy+001h)		;a09f   ; a la izquierda
L_A0A2:
	inc (iy+000h)		;a0a2   ; 1 abajo
	jp enemigo_comun		;a0a5
enemigo_b:		; Los enemigos 3, 4 y 5: salen arriba en una X al azar (0x20-0x9F); el 3 (dibujos 0x40, colores 1 y 11, 70 puntos) baja cada 2 cuadros y dispara (0xB0) escena x 2 + 3 veces; el 4 y el 5 (0xD8, colores 9 y 1, 60 o 200 puntos) andan en cuatro direcciones al azar
	ld a,(iy+005h)		;a0a8   ; recien salido?
	and a			;a0ab
	jr nz,enemigo_b_anda		;a0ac
	inc (iy+005h)		;a0ae
	ld (iy+000h),000h		;a0b1   ; arriba
	ld a,r		;a0b5   ; X al azar: 0x20-0x9F
	and 07fh		;a0b7
	add a,020h		;a0b9
	ld (iy+001h),a		;a0bb
	ld (iy+014h),00fh		;a0be
	ld (iy+00ah),040h		;a0c2   ; los dibujos 0x40
	ld (iy+003h),001h		;a0c6   ; colores 1 y 11
	ld (iy+013h),00bh		;a0ca
	ld (iy+00eh),007h		;a0ce   ; 7 (70 puntos)
	ld a,(0e003h)		;a0d2   ; los disparos: escena x 2 + 3
	add a,a			;a0d5
	add a,003h		;a0d6
	ld (iy+00bh),a		;a0d8
	ld a,(iy+004h)		;a0db   ; el 3?
	cp 003h		;a0de
	jr z,enemigo_b_anda		;a0e0
	ld (iy+003h),009h		;a0e2   ; los demas: colores 9 y 1...
	ld (iy+013h),001h		;a0e6
	ld (iy+00ah),0d8h		;a0ea   ; ...dibujos 0xD8...
	ld (iy+008h),000h		;a0ee
	ld (iy+00eh),006h		;a0f2   ; ...6 (60 puntos; el 5, 0x20: 200)...
	ld a,r		;a0f6   ; ...y una pausa al azar
	and 01fh		;a0f8
	add a,010h		;a0fa
	ld (iy+009h),a		;a0fc
	ld a,(iy+004h)		;a0ff   ; el 4?
	cp 004h		;a102
	jr z,enemigo_b_anda		;a104
	ld (iy+00eh),020h		;a106
	ld (iy+00ah),0b8h		;a10a
enemigo_b_anda:		; Andando: los dibujos cada 8 cuadros; el 3 baja cada 2 cuadros y dispara; el 4 y el 5, en la direccion al azar (+8: 0-1 abajo, 2 derecha, 3 izquierda) mientras dura la cuenta
	ld a,(iy+005h)		;a10e   ; vencido?
	cp 00ah		;a111
	jp z,vencido		;a113   ; los dibujos, +8 cada 8 cuadros
	ld a,(0e012h)		;a116
	and 008h		;a119
	ld b,(iy+00ah)		;a11b
	add a,b			;a11e   ; el 3?
	ld (iy+002h),a		;a11f
	add a,004h		;a122   ; cada 2 cuadros...
	ld (iy+012h),a		;a124
	ld a,(iy+004h)		;a127
	cp 003h		;a12a   ; ...1 abajo
	jr nz,enemigo_b_dir		;a12c
	inc (iy+006h)		;a12e
	ld a,(iy+006h)		;a131
	cp 002h		;a134
	jr c,enemigo_b_dispara		;a136
	ld (iy+006h),a		;a138
	inc (iy+000h)		;a13b
	jr enemigo_b_dispara		;a13e
enemigo_b_dir:		; El 4 y el 5: mientras dura la cuenta, un paso en su direccion; acabada, otra al azar
	ld a,(iy+009h)		;a140   ; la cuenta?
	and a			;a143
	jr z,enemigo_b_gira		;a144
	dec (iy+009h)		;a146   ; un cuadro menos
	ld a,(iy+008h)		;a149   ; la direccion
	cp 002h		;a14c
	jr nc,enemigo_b_lado		;a14e   ; 0-1: abajo
	inc (iy+000h)		;a150
	jr enemigo_b_baja		;a153
enemigo_b_lado:		; 2: derecha; 3: izquierda
	cp 002h		;a155
	jr nz,L_A15E		;a157
	inc (iy+001h)		;a159
	jr enemigo_b_baja		;a15c
L_A15E:
	dec (iy+001h)		;a15e
	jr enemigo_b_baja		;a161
enemigo_b_gira:		; Otra cuenta (0x10-0x2F) y otra direccion (0-3) al azar
	ld a,r		;a163   ; al azar...
	and 01fh		;a165   ; ...0x10-0x2F cuadros
	add a,010h		;a167
	ld (iy+009h),a		;a169
	and 003h		;a16c   ; la direccion: 0-3
	ld (iy+008h),a		;a16e
enemigo_b_baja:		; El 5 baja 1 mas y dispara (0xB0); el 4, no
	ld a,(iy+004h)		;a171   ; el 4?
	cp 004h		;a174   ; el 4?
	jp z,enemigo_comun		;a176
	inc (iy+000h)		;a179
	ld c,0b0h		;a17c
	call enemigo_dispara		;a17e
	jr enemigo_b_fin		;a181
enemigo_b_dispara:		; El 3: mientras le queden disparos (+0x0B), uno cada vez que pueda (0xB0)
	ld a,(iy+00bh)		;a183   ; le quedan?
	and a			;a186
	jp z,enemigo_comun		;a187
	ld c,0b0h		;a18a   ; dispara
	call enemigo_dispara		;a18c
	jr nc,enemigo_b_fin		;a18f   ; salio: uno menos
	dec (iy+00bh)		;a191
	ld c,0b0h		;a194
enemigo_b_fin:		; A lo comun
	jp enemigo_comun		;a196
enemigo_c:		; El enemigo 7: sale arriba en una X al azar (0x20-0x9F), dibujos 0x60, colores 15 y 1, 100 puntos; baja de 2 en 2 hasta la Y 0x68 y vuelve a subir disparando (0xE8), zigzagueando de lado cada 8 cuadros
	ld a,(iy+005h)		;a199   ; recien salido?
	and a			;a19c
	jr nz,enemigo_c_anda		;a19d
	inc (iy+005h)		;a19f
	ld (iy+003h),00fh		;a1a2
	ld (iy+013h),001h		;a1a6
	ld (iy+014h),00fh		;a1aa   ; los dibujos 0x60
	ld (iy+00ah),060h		;a1ae
	ld (iy+00eh),010h		;a1b2   ; X al azar: 0x20-0x9F
	ld a,r		;a1b6
	and 07fh		;a1b8
	add a,020h		;a1ba
	ld (iy+001h),a		;a1bc
	ld (iy+000h),000h		;a1bf   ; 0x10 (100 puntos)
	ld (iy+00eh),010h		;a1c3
	ld a,(iy+005h)		;a1c7
enemigo_c_anda:		; Bajando (+8 = 0) de 2 en 2 hasta 0x68; luego subiendo de 1 en 1 y disparando
	cp 00ah		;a1ca   ; vencido?
	jp z,vencido		;a1cc
	ld a,(iy+008h)		;a1cf   ; bajando?
	and a			;a1d2
	jr nz,enemigo_c_sube		;a1d3
	inc (iy+000h)		;a1d5
	inc (iy+000h)		;a1d8
	ld a,(iy+000h)		;a1db
	cp 068h		;a1de
	jr c,enemigo_c_lado		;a1e0
	inc (iy+008h)		;a1e2
	jr enemigo_c_lado		;a1e5
enemigo_c_sube:		; 1 arriba y dispara (0xE8)
	dec (iy+000h)		;a1e7
	ld c,0e8h		;a1ea
	call enemigo_dispara		;a1ec
enemigo_c_lado:		; El zigzag: 8 cuadros a la derecha y 8 a la izquierda
	inc (iy+009h)		;a1ef   ; la cuenta del zigzag
	ld a,(iy+009h)		;a1f2
	and 00fh		;a1f5   ; de 16 en 16...
	cp 008h		;a1f7   ; ...los 8 primeros, a la izquierda
	jr c,enemigo_c_izq		;a1f9
	inc (iy+001h)		;a1fb   ; a la derecha
	jr enemigo_c_dibujo		;a1fe
enemigo_c_izq:		; A la izquierda
	dec (iy+001h)		;a200
enemigo_c_dibujo:		; Los dibujos, +8 cada 8 cuadros, y a lo comun
	ld a,(0e012h)		;a203   ; cada 8 cuadros...
	and 008h		;a206
	ld b,(iy+00ah)		;a208   ; ...+8 a los dibujos
	add a,b			;a20b
	ld (iy+002h),a		;a20c   ; el primero
	add a,004h		;a20f   ; +4, el segundo
	ld (iy+012h),a		;a211
	jp enemigo_comun		;a214   ; a lo comun
enemigo_d:		; El enemigo 9: sale arriba en una X al azar (0x40-0x7F), dibujos 0x50, colores 9 y 1, 100 puntos; baja hasta la Y 0x28 y luego, cada 4 cuadros, 1 abajo, y se mece de lado (32 cuadros a cada lado)
	ld a,(iy+005h)		;a217   ; recien salido?
	and a			;a21a   ; recien salido?
	jr nz,enemigo_d_anda		;a21b   ; no: andando
	inc (iy+005h)		;a21d   ; ya no
	ld (iy+000h),000h		;a220   ; arriba del todo
	ld a,r		;a224   ; al azar...
	and 03fh		;a226   ; ...0x40-0x7F...
	add a,040h		;a228
	ld (iy+001h),a		;a22a   ; ...la X
	ld (iy+003h),009h		;a22d   ; colores 9...
	ld (iy+013h),001h		;a231   ; ...y 1
	ld (iy+014h),00fh		;a235   ; con segundo sprite
	ld (iy+00ah),050h		;a239   ; los dibujos 0x50
	ld (iy+00eh),010h		;a23d   ; 0x10 (100 puntos)
	ld a,(iy+005h)		;a241
enemigo_d_anda:		; Bajando hasta 0x28; luego despacio y meciendose
	cp 00ah		;a244   ; vencido?
	jp z,vencido		;a246
	ld a,(iy+009h)		;a249   ; bajando?
	and a			;a24c
	jr nz,enemigo_d_despacio		;a24d
	inc (iy+000h)		;a24f   ; 1 abajo
	ld a,(iy+000h)		;a252
	cp 028h		;a255   ; 0x28?
	jr c,enemigo_d_dibujo		;a257
	inc (iy+009h)		;a259   ; ya
enemigo_d_despacio:		; Cada 4 cuadros, 1 abajo
	inc (iy+006h)		;a25c   ; la cuenta
	ld a,(iy+006h)		;a25f
	cp 004h		;a262   ; cada 4 cuadros
	jr c,enemigo_d_mece		;a264
	ld (iy+006h),000h		;a266   ; a cero
	inc (iy+000h)		;a26a   ; 1 abajo
enemigo_d_mece:		; 32 cuadros a la derecha y 32 a la izquierda (+8)
	ld a,(iy+008h)		;a26d   ; la cuenta del meneo...
	and 03fh		;a270   ; ...de 64 en 64...
	cp 01fh		;a272   ; ...los 32 primeros, a la izquierda
	jr c,enemigo_d_izq		;a274
	inc (iy+001h)		;a276   ; a la derecha
	jr enemigo_d_dibujo		;a279
enemigo_d_izq:		; Izquierda
	dec (iy+001h)		;a27b
enemigo_d_dibujo:		; Los dibujos, +8 cada 8 cuadros, y a lo comun
	inc (iy+008h)		;a27e   ; la cuenta del meneo
	ld a,(0e012h)		;a281   ; cada 8 cuadros...
	and 008h		;a284
	ld b,(iy+00ah)		;a286   ; los dibujos
	add a,b			;a289   ; ...+8 al dibujo
	ld (iy+002h),a		;a28a
	add a,004h		;a28d   ; +4, el segundo
	ld (iy+012h),a		;a28f
	jp enemigo_comun		;a292   ; a lo comun
enemigo_e:		; El enemigo 0x0A, una cosa que baja: sale arriba (X al azar 0x30-0x6F), baja 1 cada 2 cuadros con los dibujos 0x80/0x88; al tocar al protagonista, el arma de velocidad (+0x1E; con dos, el arma + 1 si es menor que 3), el sonido 1, 100 puntos, 0xE199 = 0x80 y todo fuera
	ld a,(iy+005h)		;a295   ; recien salido?
	and a			;a298   ; recien salido?
	jr nz,enemigo_e_baja		;a299   ; no: baja
	inc (iy+005h)		;a29b   ; ya no
	ld (iy+000h),000h		;a29e   ; arriba del todo
	ld (iy+003h),005h		;a2a2   ; color 5...
	ld (iy+013h),001h		;a2a6   ; ...y 1
	ld (iy+014h),00fh		;a2aa   ; con segundo sprite
	ld a,r		;a2ae   ; al azar 0x30-0x6F...
	and 03fh		;a2b0
	add a,030h		;a2b2
	ld (iy+001h),a		;a2b4   ; ...la X
enemigo_e_baja:		; Cada 2 cuadros, 1 abajo
	inc (iy+006h)		;a2b7   ; la cuenta...
	ld a,(iy+006h)		;a2ba
	cp 002h		;a2bd   ; ...cada 2 cuadros
	jr c,enemigo_e_toca		;a2bf
	ld (iy+006h),000h		;a2c1   ; a cero
	inc (iy+000h)		;a2c5
enemigo_e_toca:		; Los dos sprites en su sitio y los dibujos 0x80/0x88 cada 16 cuadros; si toca al protagonista, lo coge
	ld a,(iy+000h)		;a2c8   ; el segundo sprite...
	ld (iy+010h),a		;a2cb
	ld a,(iy+001h)		;a2ce   ; ...en su sitio
	ld (iy+011h),a		;a2d1
	ld a,(0e012h)		;a2d4   ; cada 16 cuadros...
	and 010h		;a2d7
	rrca			;a2d9
	add a,080h		;a2da   ; ...0x80 o 0x88
	ld (iy+002h),a		;a2dc
	add a,004h		;a2df
	ld (iy+012h),a		;a2e1
	ld bc,008f8h		;a2e4   ; toca en Y (8 arriba, 8 abajo)?
	call cerca_y		;a2e7
	jr nc,enemigo_e_fuera		;a2ea
	ld bc,00af6h		;a2ec   ; toca en X (10 a cada lado)?
	call cerca_x		;a2ef
	jr nc,enemigo_e_fuera		;a2f2
	ld (iy+010h),0ech		;a2f4   ; cogido: fuera
	ld (iy+014h),000h		;a2f8
	ld (iy+015h),000h		;a2fc
	inc (ix+01eh)		;a300
	ld a,(ix+01eh)		;a303
	cp 002h		;a306
	jr c,enemigo_e_cogido		;a308
	ld a,(ix+00eh)		;a30a
	cp 003h		;a30d
	jr nc,enemigo_e_cogido		;a30f
	inc (ix+00eh)		;a311
enemigo_e_cogido:		; El sonido 1, 100 puntos, 0xE199 = 0x80 y todo fuera
	ld a,001h		;a314   ; el sonido 1
	call sonido_a_pide		;a316
	ld a,010h		;a319   ; 100 puntos
	call puntos_suma		;a31b
	ld a,080h		;a31e   ; 0xE199 = 0x80: mas tiempo hasta el siguiente enemigo
	ld (0e199h),a		;a320
	jp todo_fuera		;a323   ; todo fuera
enemigo_e_fuera:		; Si sale de la pantalla, fuera
	jp enemigo_fuera_mira		;a326   ; si sale, fuera
enemigo_nada:		; El tipo 0x0F: nada
	ret			;a329
enemigo_comun:		; Lo comun de los enemigos: el segundo sprite junto al primero; si toca al protagonista, sin el poder 2 la muerte (0xE183) y con el 4, vencido; si le da un disparo: los tipos 4, 7 y 9, con armas 0 y 1, aguantan 4; los demas, vencidos (sus puntos, el sonido 4 y la explosion); fuera de la pantalla, fuera
	ld a,(iy+000h)		;a32a   ; el segundo sprite, junto al primero
	ld (iy+010h),a		;a32d   ; su Y (el segundo sprite)
	ld a,(iy+001h)		;a330
	ld (iy+011h),a		;a333   ; su X (el segundo sprite)
	ld bc,008f8h		;a336   ; la caja en Y...
	call cerca_y		;a339
	jr nc,enemigo_disparo		;a33c
	ld bc,00af6h		;a33e
	call cerca_x		;a341
	jr nc,enemigo_disparo		;a344
	ld a,(ix+01ah)		;a346
	cp 002h		;a349
	jr z,enemigo_disparo		;a34b   ; 2: no le pasa nada
	cp 004h		;a34d
	jr z,enemigo_vencido		;a34f   ; 4: lo vence
	ld a,001h		;a351
	ld (0e183h),a		;a353   ; si no: la muerte
	jr enemigo_disparo		;a356
enemigo_disparo:		; Un disparo del protagonista le da?
	ld b,(iy+000h)		;a358   ; su Y...
	ld c,(iy+001h)		;a35b   ; ...y su X
	call disparo_da		;a35e   ; algun disparo?
	jr nc,enemigo_fuera_mira		;a361
	ld a,(iy+004h)		;a363   ; el tipo...
	cp 004h		;a366   ; ...4, 9 o 7: aguantan
	jr z,enemigo_aguanta		;a368
	cp 009h		;a36a
	jr z,enemigo_aguanta		;a36c
	cp 007h		;a36e
	jr z,enemigo_aguanta		;a370
	jr enemigo_vencido		;a372
enemigo_aguanta:		; Con el arma 0 o 1, cuatro disparos (+0x0C)
	ld a,(ix+00eh)		;a374   ; el arma...
	cp 002h		;a377   ; ...2 o mas: vencido
	jr nc,enemigo_vencido		;a379
	inc (iy+00ch)		;a37b
	ld a,(iy+00ch)		;a37e
	cp 004h		;a381
	jr c,enemigo_fuera_mira		;a383
enemigo_vencido:		; Vencido: sus puntos (+0x0E), el sonido 4, +5 = 0x0A (la explosion) y el segundo sprite fuera
	ld a,(iy+00eh)		;a385   ; sus puntos
	call puntos_suma		;a388
	ld a,004h		;a38b
	call sonido_a_pide		;a38d
	ld (iy+005h),00ah		;a390
	ld (iy+010h),0ech		;a394
	ld (iy+014h),000h		;a398
	ld (iy+015h),000h		;a39c
	ld (iy+006h),000h		;a3a0
enemigo_fuera_mira:		; Por debajo de 0xB4 y a la izquierda de 0xB0: sigue; si no, fuera
	ld a,(iy+000h)		;a3a4
	cp 0b4h		;a3a7
	jr c,enemigo_fuera_x		;a3a9
	jr enemigo_fuera		;a3ab
enemigo_fuera_x:		; La X
	ld a,(iy+001h)		;a3ad
	cp 0b0h		;a3b0
	ret c			;a3b2
enemigo_fuera:		; Fuera
	jp L_A59C		;a3b3
torreta_a:		; El enemigo 0x0B: fijo en el suelo (dibujos 0xA0/0xA4, colores 14 y 15); dispara hacia el protagonista
	ld a,(iy+005h)		;a3b6   ; recien salido?
	and a			;a3b9
	jr nz,torreta_anda		;a3ba
	inc (iy+005h)		;a3bc
	ld (iy+002h),0a0h		;a3bf
	ld (iy+003h),00eh		;a3c3
	ld (iy+012h),0a4h		;a3c7
	ld (iy+013h),00fh		;a3cb
	jr torreta_dos		;a3cf
torreta_b:		; El 0x0C: dibujos 0x98/0x9C, colores 14 y 1
	ld a,(iy+005h)		;a3d1   ; recien salido?
	and a			;a3d4
	jr nz,torreta_anda		;a3d5
	inc (iy+005h)		;a3d7
	ld (iy+002h),098h		;a3da
	ld (iy+003h),00eh		;a3de
	ld (iy+012h),09ch		;a3e2
	ld (iy+013h),001h		;a3e6
	jr torreta_dos		;a3ea
torreta_c:		; El 0x0D: dibujos 0x90/0x94, colores 6 y 9
	ld a,(iy+005h)		;a3ec   ; recien salido?
	and a			;a3ef
	jr nz,torreta_anda		;a3f0
	inc (iy+005h)		;a3f2
	ld (iy+002h),090h		;a3f5
	ld (iy+003h),006h		;a3f9
	ld (iy+012h),094h		;a3fd
	ld (iy+013h),009h		;a401
torreta_dos:		; Con segundo sprite
	ld (iy+014h),00fh		;a405
torreta_anda:		; Vencida, la explosion; si no, el segundo sprite en su sitio y a disparar
	ld a,(iy+005h)		;a409   ; vencida?
	cp 00ah		;a40c
	jp z,vencido		;a40e
	ld a,(iy+000h)		;a411
	ld (iy+010h),a		;a414
	ld a,(iy+001h)		;a417
	ld (iy+011h),a		;a41a
	jp bala_dir		;a41d
bala:		; El enemigo 0x0E, una bala: al salir, su dibujo guardado (+0x0C) y color 9 (1 en las escenas impares); se va con el poder 3 (+0x3F); vuela hacia donde estaba el protagonista al salir
	ld a,(iy+005h)		;a420   ; recien salida?
	and a			;a423
	jp nz,bala_mira		;a424
	inc (iy+005h)		;a427   ; el dibujo, guardado
	ld a,(iy+002h)		;a42a
	ld (iy+00ch),a		;a42d   ; color 9
	ld (iy+003h),009h		;a430   ; la escena impar?
	ld a,(0e003h)		;a434
	bit 0,a		;a437
	jr z,bala_mira		;a439
	ld (iy+003h),001h		;a43b
bala_mira:		; Con +0x3F (otra cosa del protagonista), fuera
	ld a,(ix+03fh)		;a43f
	and a			;a442
	jr z,bala_dibujo		;a443
	jp otro_borra_va		;a445
bala_dibujo:		; Su dibujo
	ld a,(iy+00ch)		;a448
	ld (iy+002h),a		;a44b
bala_dir:		; La primera vez, la direccion hacia el protagonista (+8); luego, cada tantos cuadros (3 - escena / 2; en la pantalla 9, ademas, las que no son 0xB0), un paso en esa direccion
	ld a,(iy+006h)		;a44e   ; la primera vez?
	and a			;a451
	jp nz,bala_espera		;a452
	inc (iy+006h)		;a455
	call direccion_prota		;a458
	ld (iy+008h),a		;a45b
	ret			;a45e
bala_espera:		; La pantalla 9?
	ld a,(0e053h)		;a45f
	cp 009h		;a462
	jr nc,bala_jefe		;a464
bala_ritmo:		; Cada 3 - (escena / 2) cuadros
	ld a,(0e003h)		;a466   ; la escena...
	rrca			;a469   ; ...entre 2...
	and 003h		;a46a
	ld b,a			;a46c
	ld a,003h		;a46d   ; ...3 menos eso
	sub b			;a46f
	ld b,a			;a470
	jr bala_cuenta		;a471   ; a contar
bala_jefe:		; En la pantalla 9: las 0xB0, al ritmo; las demas, cada cuadro
	ld a,(iy+002h)		;a473   ; la bala 0xB0?
	cp 0b0h		;a476   ; si: al ritmo
	jr z,bala_ritmo		;a478
	jr bala_paso		;a47a
bala_cuenta:		; Un cuadro mas
	inc (iy+007h)		;a47c
	ld a,(iy+007h)		;a47f
	cp b			;a482
	jp c,bala_toca		;a483
bala_paso:		; Un paso, por la direccion (tabla 0xA49B)
	ld (iy+007h),000h		;a486   ; la cuenta a 0
	ld a,(iy+008h)		;a48a   ; la direccion...
	ld hl,0a49bh		;a48d   ; ...en la tabla
	add a,a			;a490   ; x 2
	add a,l			;a491
	jr nc,L_A495		;a492
	inc h			;a494
L_A495:
	ld l,a			;a495   ; su paso
	ld e,(hl)			;a496
	inc hl			;a497
	ld d,(hl)			;a498
	ex de,hl			;a499
	jp (hl)			;a49a   ; a el

; ----------------------------------------------------------------------
; DATOS balas_tabla: Los pasos de las balas en sus 16 direcciones (0 arriba, 4
;   derecha, 8 abajo, 12 izquierda)
;   0xa49b..0xa4bb  (32 bytes)
DATA_balas_tabla:
	defb 0c1h,0a4h,0beh,0a4h,0bbh,0a4h,0c9h,0a4h,0cch,0a4h,0d7h,0a4h,0d4h,0a4h,0dch,0a4h	; a49b  ................
	defb 0dfh,0a4h,0eah,0a4h,0e7h,0a4h,0efh,0a4h,0f2h,0a4h,0fdh,0a4h,0fah,0a4h,002h,0a5h	; a4ab  ................

; ======================================================================
; CODIGO 0xa4bb..0xa7b6  (763 bytes)
; ======================================================================


bala_dir2:
	inc (iy+001h)		;a4bb
bala_dir1:
	inc (iy+001h)		;a4be
bala_dir0:		; Arriba (dos), con la X que toque
	dec (iy+000h)		;a4c1
	dec (iy+000h)		;a4c4
	jr bala_corrige		;a4c7
bala_dir3:
	dec (iy+000h)		;a4c9
bala_dir4:		; A la derecha (dos)
	inc (iy+001h)		;a4cc
	inc (iy+001h)		;a4cf
	jr bala_corrige		;a4d2
bala_dir5:
	inc (iy+000h)		;a4d4
bala_dir6:
	inc (iy+000h)		;a4d7
	jr bala_dir4		;a4da
bala_dir7:
	inc (iy+001h)		;a4dc
bala_dir8:		; Abajo (dos)
	inc (iy+000h)		;a4df
	inc (iy+000h)		;a4e2
	jr bala_corrige		;a4e5
bala_dir9:
	dec (iy+001h)		;a4e7
bala_dir10:
	dec (iy+001h)		;a4ea
	jr bala_dir8		;a4ed
bala_dir11:
	inc (iy+000h)		;a4ef
bala_dir12:		; A la izquierda (dos)
	dec (iy+001h)		;a4f2
	dec (iy+001h)		;a4f5
	jr bala_corrige		;a4f8
bala_dir13:
	dec (iy+000h)		;a4fa
bala_dir14:
	dec (iy+000h)		;a4fd
	jr bala_dir12		;a500
bala_dir15:
	dec (iy+001h)		;a502
	jr bala_dir0		;a505
bala_corrige:		; Desde la pantalla 9 (el final de la escena): cada 2 pasos, la X un punto hacia el protagonista
	ld a,(0e053h)		;a507   ; la pantalla 9 o mas?
	cp 009h		;a50a
	jr c,bala_toca		;a50c
cae_persigue_paso:
	inc (iy+00ah)		;a50e   ; cada 2 pasos
	ld a,(iy+00ah)		;a511
	cp 002h		;a514
	jr c,bala_toca		;a516
	ld (iy+00ah),000h		;a518
	ld a,(ix+001h)		;a51c   ; la X del protagonista
	ld b,(iy+001h)		;a51f
	cp b			;a522
	jr c,bala_corrige_izq		;a523
	inc (iy+001h)		;a525
	jr bala_toca		;a528
bala_corrige_izq:
	dec (iy+001h)		;a52a
bala_toca:
	ld bc,006fah		;a52d   ; la caja en Y
	call cerca_y		;a530   ; toca en Y (6 a cada lado)?
	jr nc,L_A554		;a533
	ld bc,006fah		;a535   ; en X
	call cerca_x		;a538
	jr nc,L_A554		;a53b
	ld a,(iy+002h)		;a53d   ; la bala 0xB0...
	cp 0b0h		;a540   ; ...es un corazon?
	jr nz,L_A54F		;a542
	ld a,(0e054h)		;a544   ; los corazones...
	and a			;a547
	jr z,L_A54F		;a548   ; ...ninguno: la muerte
	call corazon_resta		;a54a   ; uno menos
	jr L_A594		;a54d
L_A54F:
	ld a,001h		;a54f   ; la muerte
	ld (0e183h),a		;a551
L_A554:
	ld a,(iy+004h)		;a554   ; el tipo...
	cp 00eh		;a557   ; ...0x0E (una bala)?
	jr z,L_A585		;a559   ; si: no se vence
	ld b,(iy+000h)		;a55b   ; su Y...
	ld c,(iy+001h)		;a55e   ; ...y su X
	call disparo_da		;a561   ; un disparo le da?
	jr nc,L_A585		;a564   ; no
	ld a,005h		;a566   ; 50 puntos
	call puntos_suma		;a568
	ld a,004h		;a56b   ; el sonido 4
	call sonido_a_pide		;a56d
	ld (iy+005h),00ah		;a570   ; vencido (+5 = 0x0A)
	ld (iy+006h),000h		;a574   ; la cuenta a 0
	ld (iy+014h),00fh		;a578   ; segundo sprite...
	ld (iy+012h),0b0h		;a57c   ; ...la explosion (0xB0)...
	ld (iy+013h),001h		;a580   ; ...color 1
	ret			;a584
L_A585:
	ld a,(iy+000h)		;a585
	cp 0b4h		;a588
	jr c,L_A58E		;a58a
	jr L_A594		;a58c
L_A58E:
	ld a,(iy+001h)		;a58e
	cp 0b0h		;a591
	ret c			;a593
L_A594:
	ld a,(iy+004h)		;a594
	cp 00eh		;a597
	jp z,otro_borra_va		;a599
L_A59C:
	ld (iy+010h),0ech		;a59c
	ld (iy+014h),000h		;a5a0
	ld (iy+015h),000h		;a5a4
	jp otro_borra_va		;a5a8
direccion_prota:		; De las 16 direcciones (0 arriba, 4 derecha, 8 abajo, 12 izquierda), la que va desde IY hacia el protagonista IX, por la proporcion entre dy y dx
	ld a,(ix+000h)		;a5ab   ; dy
	ld b,(iy+000h)		;a5ae
	sub b			;a5b1
	ld c,a			;a5b2
	jr c,L_A5D1		;a5b3   ; el protagonista arriba?
	ld a,(ix+001h)		;a5b5   ; dx
	ld b,(iy+001h)		;a5b8
	sub b			;a5bb
	ld b,a			;a5bc
	jr c,L_A5C9		;a5bd   ; el protagonista a la izquierda?
	call octante		;a5bf   ; el octante
	ld b,a			;a5c2
	ld a,004h		;a5c3
	sub b			;a5c5
	add a,004h		;a5c6
	ret			;a5c8
L_A5C9:
	cpl			;a5c9
	ld b,a			;a5ca
	call octante		;a5cb
	add a,008h		;a5ce
	ret			;a5d0
L_A5D1:
	cpl			;a5d1   ; dy al reves
	ld c,a			;a5d2
	ld a,(ix+001h)		;a5d3   ; dx
	ld b,(iy+001h)		;a5d6
	sub b			;a5d9   ; la X del protagonista menos la suya
	ld b,a			;a5da
	jr c,direccion_arriba_izq		;a5db   ; a la izquierda?
octante:		; El octante (0-4) de la direccion: dx (B) contra dy (C): casi recto 0; luego 1, 2, 3 y 4 segun la proporcion
	add a,a			;a5dd   ; dx x 2...
	jr c,L_A5E8		;a5de   ; pasa de 255: no es la 0
	add a,a			;a5e0   ; x 4...
	jr c,L_A5E8		;a5e1
	cp c			;a5e3   ; ...menos que dy?
	jr nc,L_A5E8		;a5e4   ; no
	xor a			;a5e6   ; la 0 (casi recto)
	ret			;a5e7
L_A5E8:
	ld a,b			;a5e8   ; dx x 1,5...
	srl a		;a5e9
	add a,b			;a5eb
	jr c,L_A5F4		;a5ec
	cp c			;a5ee   ; ...menos que dy?
	jr nc,L_A5F4		;a5ef
	ld a,001h		;a5f1   ; la 1
	ret			;a5f3
L_A5F4:
	ld l,c			;a5f4   ; dy x 3...
	ld h,000h		;a5f5
	add hl,hl			;a5f7   ; x 2
	ld a,c			;a5f8
	add a,l			;a5f9
	jr c,L_A5FD		;a5fa
	inc hl			;a5fc
L_A5FD:
	ld l,a			;a5fd   ; dx x 2...
	ex de,hl			;a5fe   ; en DE
	ld l,b			;a5ff   ; dx x 2
	ld h,000h		;a600
	add hl,hl			;a602
	and a			;a603   ; ...menos dy x 3
	sbc hl,de		;a604   ; menos dy x 3
	jr nc,direccion_3		;a606   ; mas: la 3
	ld a,002h		;a608   ; la 2
	ret			;a60a
direccion_3:
	ld a,b			;a60b   ; dx / 4 < dy?
	srl a		;a60c   ; dx / 4
	srl a		;a60e
	cp c			;a610   ; contra dy
	jr nc,direccion_4		;a611   ; menos: la 4
	ld a,003h		;a613   ; la 3
	ret			;a615
direccion_4:
	ld a,004h		;a616   ; la 4
	ret			;a618
direccion_arriba_izq:
	cpl			;a619   ; dx al reves
	ld b,a			;a61a
	call octante		;a61b   ; el octante
	neg		;a61e   ; negado: hacia la izquierda
	and 00fh		;a620
	ret			;a622
enemigo_dispara:		; El enemigo IY dispara una bala (dibujo C): en las escenas 0-2, solo por encima de la Y 0x90; cada 0x20 - escena x 2 + 0-0x1F cuadros (0xE19C); en un hueco libre de 0xE420-0xE47F (seis)
	ld a,(0e003h)		;a623   ; la escena...
	cp 003h		;a626   ; ...3 o mas: siempre
	jr nc,L_A630		;a628
	ld a,(iy+000h)		;a62a
	cp 090h		;a62d   ; por debajo de 0x90: no
	ret nc			;a62f
L_A630:
	ld a,(0e19ch)		;a630   ; la espera?
	and a			;a633
	jr z,L_A63B		;a634
	dec a			;a636   ; un cuadro menos
	ld (0e19ch),a		;a637
	ret			;a63a
L_A63B:
	ld a,r		;a63b   ; al azar 0-0x1F...
	and 01fh		;a63d
	ld b,a			;a63f
	ld a,(0e003h)		;a640   ; ...+ 0x20 - escena x 2
	rlca			;a643
	ld d,a			;a644
	ld a,020h		;a645
	sub d			;a647
	add a,b			;a648
	ld (0e19ch),a		;a649
bala_hueco:		; Un hueco libre entre 0xE420 y 0xE47F (+4 = 0)
	ld hl,0e424h		;a64c
	ld de,00010h		;a64f
	ld b,006h		;a652
bala_hueco_uno:		; Libre?
	ld a,(hl)			;a654   ; libre?
	and a			;a655
	jr z,bala_pon		;a656   ; si: la bala
	add hl,de			;a658   ; el siguiente
	djnz bala_hueco_uno		;a659
	xor a			;a65b   ; ninguno: NC
	ret			;a65c
bala_hueco_otro:		; Otra busqueda de hueco (0xE384, de 32 en 32, ocho)
	ld hl,0e384h		;a65d   ; desde 0xE384...
	ld de,00020h		;a660   ; ...de 32 en 32...
	ld b,008h		;a663   ; ...ocho
	ld a,(hl)			;a665   ; libre?
	and a			;a666
	jr z,bala_pon		;a667   ; si: la bala
	add hl,de			;a669   ; el siguiente
	djnz bala_hueco_uno		;a66a
	xor a			;a66c   ; ninguno: NC
	ret			;a66d
bala_pon:		; La bala: tipo 0x0E, su dibujo (C), y la Y y X del enemigo; C: salio
	ld (hl),00eh		;a66e   ; tipo 0x0E
	dec hl			;a670
	dec hl			;a671
	ld (hl),c			;a672   ; el dibujo
	dec hl			;a673
	ld a,(iy+001h)		;a674   ; su X
	ld (hl),a			;a677
	dec hl			;a678
	ld a,(iy+000h)		;a679   ; su Y
	ld (hl),a			;a67c
	scf			;a67d   ; C: sale
	ret			;a67e
bloque:		; Los objetos 0-3 y 5, bloques del suelo: los disparos los rompen (6 golpes; 16 el 5, por encima de la Y 0x30; dobles con el arma 2 o mas); rotos, el sonido 3 y lo que guardan: el 2, un corazon (0xA7C6); el 3, POWER + 8 (0xA7CA); el 5, la salida (0xA7CE; en la escena 5, el final de escena directo con 1.000 puntos); los demas, al azar: nada (50 puntos) o una de cuatro cosas (0xA7B6-0xA7C2)
	ld a,(iy+003h)		;a67f   ; en pantalla?
	and a			;a682
	ret z			;a683
	ld a,(iy+008h)		;a684   ; ya roto?
	and a			;a687
	jp nz,bloque_coge		;a688   ; si: se coge
	ld b,(iy+000h)		;a68b   ; su Y...
	ld c,(iy+001h)		;a68e   ; ...y su X
	call disparo_da		;a691   ; un disparo le da?
	jp nc,bloque_fuera		;a694   ; no
	ld a,(iy+004h)		;a697   ; el 5?
	cp 005h		;a69a
	jr nz,bloque_golpe		;a69c
	ld a,(iy+000h)		;a69e   ; por encima de 0x30: no
	cp 030h		;a6a1
	jp c,bloque_fuera		;a6a3
	ld a,(ix+00eh)		;a6a6   ; el arma 2 o mas...
	cp 002h		;a6a9
	jr c,L_A6B0		;a6ab
	inc (iy+007h)		;a6ad   ; ...un golpe mas
L_A6B0:
	inc (iy+007h)		;a6b0   ; un golpe
	ld a,(iy+007h)		;a6b3
	cp 010h		;a6b6   ; 16?
	jp c,bloque_fuera		;a6b8
	jr bloque_roto		;a6bb
bloque_golpe:		; Los demas: 6 golpes
	ld a,(ix+00eh)		;a6bd   ; el arma 2 o mas...
	cp 002h		;a6c0
	jr c,L_A6C7		;a6c2
	inc (iy+007h)		;a6c4   ; ...un golpe mas
L_A6C7:
	inc (iy+007h)		;a6c7   ; un golpe
	ld a,(iy+007h)		;a6ca
	cp 006h		;a6cd   ; 6?
	jp c,bloque_fuera		;a6cf
bloque_roto:		; Roto: el sonido 3 y lo que guarda
	ld a,003h		;a6d2   ; el sonido 3
	call sonido_a_pide		;a6d4
	ld l,(iy+005h)		;a6d7   ; su sitio en el mapa
	ld h,(iy+006h)		;a6da
	ld a,(iy+004h)		;a6dd   ; el tipo
	cp 002h		;a6e0   ; 2: un corazon
	jr z,bloque_corazon		;a6e2
	cp 003h		;a6e4   ; 3: POWER
	jr z,bloque_power		;a6e6
	cp 005h		;a6e8   ; 5: la salida
	jr nz,bloque_azar		;a6ea
	ld a,(0e003h)		;a6ec   ; la escena 5?
	cp 005h		;a6ef
	jr nz,bloque_salida		;a6f1
	ld a,001h		;a6f3   ; si: la escena acabada...
	ld (0e184h),a		;a6f5
	ld a,010h		;a6f8   ; ...con el parpadeo...
	ld (0e1c0h),a		;a6fa
	ld a,010h		;a6fd   ; ...y 1.000 puntos (0x10 en las centenas)
	call puntos_suma_cien		;a6ff
	ret			;a702
bloque_salida:		; La salida (0xA7CE): al tocarla, la escena acabada
	ld de,0a7ceh		;a703
	ld (iy+008h),007h		;a706
	jr bloque_dibujo		;a70a
bloque_power:		; POWER + 8 (0xA7CA)
	ld de,0a7cah		;a70c
	ld (iy+008h),005h		;a70f
	jr bloque_dibujo		;a713
bloque_corazon:		; Un corazon (0xA7C6)
	ld de,0a7c6h		;a715
	ld (iy+008h),006h		;a718
	jr bloque_dibujo		;a71c
bloque_azar:		; Al azar: la mitad, nada (el suelo, 0xA7D2, y 50 puntos); la otra, una de cuatro cosas (1-4)
	ld a,r		;a71e   ; al azar...
	and 007h		;a720
	cp 004h		;a722   ; ...4-7: algo
	jr nc,bloque_cosa		;a724
	ld de,0a7d2h		;a726   ; 0-3: nada, el suelo
	call dibujo_2x2		;a729
	ld a,005h		;a72c   ; 50 puntos
	call puntos_suma		;a72e
	jp otro_borra_corto		;a731
bloque_cosa:		; La cosa (1-4): su dibujo
	and 003h		;a734   ; 0-3...
	ld (iy+008h),a		;a736   ; ...+1: la cosa
	inc (iy+008h)		;a739
	cp 000h		;a73c
	jr z,bloque_cosa1		;a73e
	cp 001h		;a740
	jr z,bloque_cosa2		;a742
	cp 002h		;a744
	jr z,bloque_cosa3		;a746
	cp 003h		;a748
	jr z,bloque_cosa4		;a74a
	xor a			;a74c
	ld de,0a7d2h		;a74d
	jr bloque_dibujo		;a750
bloque_cosa4:		; 4 (0xA7C2)
	ld de,0a7c2h		;a752
	jr bloque_dibujo		;a755
bloque_cosa3:		; 3 (0xA7BE)
	ld de,0a7beh		;a757
	jr bloque_dibujo		;a75a
bloque_cosa2:		; 2 (0xA7BA)
	ld de,0a7bah		;a75c
	jr bloque_dibujo		;a75f
bloque_cosa1:		; 1 (0xA7B6)
	ld de,0a7b6h		;a761
bloque_dibujo:		; El dibujo en el mapa
	call dibujo_2x2		;a764
bloque_coge:		; Al tocarla: la salida, el final de escena (500 puntos); si no, la cosa (al protagonista, +0x19), un corazon con el 6, el suelo, el sonido 2 y 100 puntos
	ld bc,00af8h		;a767   ; toca en Y?
	call cerca_y		;a76a
	jr nc,bloque_fuera		;a76d
	ld bc,008f8h		;a76f   ; toca en X?
	call cerca_x		;a772
	jr nc,bloque_fuera		;a775
	ld a,(iy+008h)		;a777   ; la salida (7)?
	cp 007h		;a77a
	jr nz,bloque_coge_cosa		;a77c
	ld a,001h		;a77e   ; si: la escena acabada...
	ld (0e184h),a		;a780
	ld a,005h		;a783   ; ...y 500 puntos
	call puntos_suma_cien		;a785
	ret			;a788
bloque_coge_cosa:		; La cosa
	cp 006h		;a789   ; 6: un corazon mas
	call z,corazon_suma		;a78b
	ld l,(iy+005h)		;a78e   ; su sitio
	ld h,(iy+006h)		;a791
	ld de,0a7d2h		;a794   ; el suelo
	call dibujo_2x2		;a797
	ld a,002h		;a79a   ; el sonido 2
	call sonido_a_pide		;a79c
	ld a,010h		;a79f   ; 100 puntos
	call puntos_suma		;a7a1
	ld a,(iy+008h)		;a7a4   ; la cosa...
	ld (ix+019h),a		;a7a7   ; ...al protagonista
	jp otro_borra_corto		;a7aa
bloque_fuera:		; Por debajo de 0xB8, fuera
	ld a,(iy+000h)		;a7ad
	cp 0b8h		;a7b0
	ret c			;a7b2
	jp otro_borra_corto		;a7b3

; ----------------------------------------------------------------------
; DATOS bloque_dibujos: Los dibujos (2 x 2 casillas, 4 bytes) de lo que
;   guardan los bloques: las cosas 1-4 (0xA7B6), el corazon (0xA7C6), POWER
;   (0xA7CA), la salida (0xA7CE) y el suelo (0xA7D2)
;   0xa7b6..0xa7d6  (32 bytes)
DATA_bloque_dibujos:
	defb 092h,093h,090h,091h,096h,097h,094h,095h,09ah,09bh,098h,099h,09eh,09fh,09ch,09dh	; a7b6  ................
	defb 08ah,08bh,088h,089h,08eh,08fh,08ch,08dh,03eh,03fh,03ch,03dh,086h,087h,084h,085h	; a7c6  ........>?<=....

; ======================================================================
; CODIGO 0xa7d6..0xacb6  (1248 bytes)
; ======================================================================


agujero:		; El objeto 4, un agujero: si el protagonista cae dentro (de 4 a 0x19 por debajo y de -4 a 0x13 a la derecha), 0xE183 = 2 (la muerte)
	ld a,(iy+003h)		;a7d6   ; en pantalla?
	and a			;a7d9
	ret z			;a7da
	ld b,(ix+000h)		;a7db   ; la Y del protagonista...
	ld a,(iy+000h)		;a7de   ; ...la del agujero menos ella
	sub b			;a7e1
	cp 004h		;a7e2   ; menos de 4: no
	jr c,agujero_fuera		;a7e4
	cp 01ah		;a7e6   ; 0x1A o mas: no
	jr nc,agujero_fuera		;a7e8
	ld a,(ix+001h)		;a7ea   ; la X
	ld b,(iy+001h)		;a7ed
	sub b			;a7f0
	cp 0fch		;a7f1   ; de -4 a -1: dentro
	jr nc,agujero_cae		;a7f3
	cp 014h		;a7f5   ; 0x14 o mas: no
	jr nc,agujero_fuera		;a7f7
agujero_cae:		; Dentro: la muerte (0xE183 = 2)
	ld a,002h		;a7f9
	ld (0e183h),a		;a7fb
	ret			;a7fe
agujero_fuera:		; Por debajo de 0xC0, fuera
	ld a,(iy+000h)		;a7ff
	cp 0c0h		;a802
	ret c			;a804
	jp otro_borra_corto		;a805
dibujo_2x2:		; Un dibujo de 2 x 2 casillas (DE) en el mapa (HL) y la ventana a la VRAM
	ld b,002h		;a808   ; dos filas
L_A80A:
	ld a,(de)			;a80a
	ld (hl),a			;a80b
	inc hl			;a80c
	inc de			;a80d
	ld a,(de)			;a80e
	ld (hl),a			;a80f
	inc de			;a810
	push de			;a811
	ld de,00017h		;a812   ; la fila siguiente (24 - 1)
	add hl,de			;a815
	pop de			;a816
	djnz L_A80A		;a817
	call ventana_pon		;a819   ; a la pantalla
	ret			;a81c
dibujo_mapa:		; Un dibujo (ancho, alto y casillas, DE) en el mapa (HL) y la ventana a la VRAM
	ld a,(de)			;a81d   ; el ancho
	ld (0e1a0h),a		;a81e
	inc de			;a821
	ld a,(de)			;a822   ; el alto
	ld b,a			;a823
	inc de			;a824
	ld (0e1a2h),hl		;a825   ; su sitio
L_A828:
	ld hl,(0e1a2h)		;a828
	ld a,(0e1a0h)		;a82b
	ld c,a			;a82e
L_A82F:
	ld a,(de)			;a82f
	ld (hl),a			;a830
	inc hl			;a831
	inc de			;a832
	dec c			;a833
	jr nz,L_A82F		;a834
	push de			;a836
	ld de,00018h		;a837   ; la fila siguiente (24)
	ld hl,(0e1a2h)		;a83a
	add hl,de			;a83d
	ld (0e1a2h),hl		;a83e
	pop de			;a841
	djnz L_A828		;a842
	call ventana_pon		;a844   ; a la pantalla
	ret			;a847
disparo_da:		; C si algun disparo del protagonista (0xE340-0xE370) da en (B, C): +0x3F, siempre; la caja, 7 (14 los de arma 2-3); los de arma 1 y 3 se acaban; los de arma 2 y 4 bajan uno (el dibujo - 4) y siguen, 7 a un lado
	ld a,(ix+03fh)		;a848   ; +0x3F?
	and a			;a84b   ; hay?
	jr z,disparo_1		;a84c
	scf			;a84e   ; todo da
	ret			;a84f
disparo_1:		; El primer disparo (0xE340): su nivel (+4)
	ld a,(ix+024h)		;a850   ; el nivel
	and a			;a853   ; hay?
	jp z,disparo_2		;a854   ; no hay: el segundo
	cp 001h		;a857   ; nivel 1?
	jr z,disparo_1_y7		;a859   ; 1 o 2: la caja de 7
	cp 002h		;a85b   ; nivel 2?
	jr z,disparo_1_y7		;a85d
	ld a,(ix+020h)		;a85f   ; 3 o 4: la de 14
	sub b			;a862   ; menos la Y del blanco
	cp 00eh		;a863   ; de 0 a 13?
	jr c,disparo_1_x		;a865
	cp 0f2h		;a867   ; de -14 a -1?
	jr c,disparo_2		;a869
	jr disparo_1_x		;a86b
disparo_1_y7:		; En Y, de -7 a +6
	ld a,(ix+020h)		;a86d   ; la Y del disparo 1
	sub b			;a870   ; menos la Y del blanco
	cp 007h		;a871   ; de 0 a 6?
	jr c,disparo_1_x		;a873
	cp 0f9h		;a875   ; de -7 a -1?
	jr c,disparo_2		;a877
disparo_1_x:		; En X
	ld a,(ix+024h)		;a879   ; el nivel del disparo 1
	cp 001h		;a87c   ; nivel 1?
	jr z,disparo_1_x7		;a87e
	cp 003h		;a880   ; nivel 3?
	jr z,disparo_1_x7		;a882
	ld a,(ix+021h)		;a884   ; la X del disparo 1
	sub c			;a887   ; menos la X del blanco
	cp 00eh		;a888   ; de 0 a 13?
	jr c,disparo_1_da		;a88a
	cp 0f2h		;a88c   ; de -14 a -1?
	jr c,disparo_2		;a88e
	jr disparo_1_da		;a890
disparo_1_x7:		; De -7 a +6
	ld a,(ix+021h)		;a892   ; la X del disparo 1
	sub c			;a895   ; menos la X del blanco
	cp 007h		;a896   ; de 0 a 6?
	jr c,disparo_1_da		;a898
	cp 0f9h		;a89a   ; de -7 a -1?
	jr c,disparo_2		;a89c
disparo_1_da:		; Da: 1 y 3 se acaban; 2 y 4 bajan un nivel y se apartan 7
	ld a,(ix+024h)		;a89e   ; el nivel del disparo 1
	cp 001h		;a8a1   ; nivel 1?
	jr z,disparo_1_fin		;a8a3
	cp 003h		;a8a5   ; nivel 3?
	jr z,disparo_1_fin		;a8a7
	dec (ix+024h)		;a8a9   ; un nivel menos
	ld a,(ix+022h)		;a8ac   ; el dibujo anterior
	sub 004h		;a8af   ; el dibujo anterior
	ld (ix+022h),a		;a8b1   ; apuntado
	ld a,(iy+001h)		;a8b4   ; la X del blanco
	ld b,(ix+021h)		;a8b7   ; ...contra la del disparo
	cp b			;a8ba   ; a que lado?
	jr c,disparo_1_der		;a8bb
	ld a,(ix+021h)		;a8bd   ; 7 a la izquierda
	sub 007h		;a8c0   ; 7 a la izquierda
	ld (ix+021h),a		;a8c2   ; apuntada
	jr disparo_si		;a8c5
disparo_1_der:		; 7 a la derecha
	ld a,(ix+021h)		;a8c7   ; su X - C
	add a,007h		;a8ca   ; 7 a la derecha
	ld (ix+021h),a		;a8cc   ; apuntada
	jr disparo_si		;a8cf
disparo_1_fin:		; Se acaba
	ld (ix+024h),000h		;a8d1   ; el fino se acaba
	ld (ix+020h),0ech		;a8d5   ; fuera
disparo_si:		; C: da
	scf			;a8d9   ; C: da
	ret			;a8da
disparo_2:		; El segundo (0xE350), igual
	ld a,(ix+034h)		;a8db   ; el nivel del disparo 2
	and a			;a8de   ; hay?
	jp z,disparo_3		;a8df   ; no: el siguiente
	cp 001h		;a8e2   ; nivel 1?
	jr z,disparo_2_y7		;a8e4
	cp 002h		;a8e6   ; nivel 2?
	jr z,disparo_2_y7		;a8e8
	ld a,(ix+030h)		;a8ea   ; la Y del disparo 2
	sub b			;a8ed   ; menos la Y del blanco
	cp 00eh		;a8ee   ; de 0 a 13?
	jr c,disparo_2_x		;a8f0
	cp 0f2h		;a8f2   ; de -14 a -1?
	jr c,disparo_3		;a8f4
	jr disparo_2_x		;a8f6
disparo_2_y7:		; En Y
	ld a,(ix+030h)		;a8f8   ; la Y del disparo 2
	sub b			;a8fb   ; menos la Y del blanco
	cp 007h		;a8fc   ; de 0 a 6?
	jr c,disparo_2_x		;a8fe
	cp 0f9h		;a900   ; de -7 a -1?
	jr c,disparo_3		;a902
disparo_2_x:		; En X
	ld a,(ix+034h)		;a904   ; el nivel del disparo 2
	cp 001h		;a907   ; nivel 1?
	jr z,disparo_2_x7		;a909
	cp 003h		;a90b   ; nivel 3?
	jr z,disparo_2_x7		;a90d
	ld a,(ix+031h)		;a90f   ; la X del disparo 2
	sub c			;a912   ; menos la X del blanco
	cp 00eh		;a913   ; de 0 a 13?
	jr c,disparo_2_da		;a915
	cp 0f2h		;a917   ; de -14 a -1?
	jr c,disparo_3		;a919
	jr disparo_2_da		;a91b
disparo_2_x7:		; En X, de 7
	ld a,(ix+031h)		;a91d   ; la X del disparo 2
	sub c			;a920   ; menos la X del blanco
	cp 007h		;a921   ; de 0 a 6?
	jr c,disparo_2_da		;a923
	cp 0f9h		;a925   ; de -7 a -1?
	jr c,disparo_3		;a927
disparo_2_da:		; Da
	ld a,(ix+034h)		;a929   ; el nivel del disparo 2
	cp 001h		;a92c   ; nivel 1?
	jr z,disparo_2_fin		;a92e
	cp 003h		;a930   ; nivel 3?
	jr z,disparo_2_fin		;a932
	dec (ix+034h)		;a934   ; un nivel menos
	ld a,(ix+032h)		;a937   ; su dibujo
	sub 004h		;a93a   ; el dibujo anterior
	ld (ix+032h),a		;a93c   ; apuntado
	ld a,(iy+001h)		;a93f   ; la X del blanco
	ld b,(ix+031h)		;a942   ; ...contra la del disparo
	cp b			;a945   ; a que lado?
	jr c,disparo_2_der		;a946
	ld a,(ix+031h)		;a948   ; su X - C
	sub 007h		;a94b   ; 7 a la izquierda
	ld (ix+031h),a		;a94d   ; apuntada
	jr disparo_2_si		;a950
disparo_2_der:		; A la derecha
	ld a,(ix+031h)		;a952   ; su X - C
	add a,007h		;a955   ; 7 a la derecha
	ld (ix+031h),a		;a957   ; apuntada
	jr disparo_2_si		;a95a
disparo_2_fin:		; Se acaba
	ld (ix+034h),000h		;a95c   ; el fino se acaba
	ld (ix+030h),0ech		;a960   ; fuera
disparo_2_si:		; C
	scf			;a964   ; C: da
	ret			;a965
disparo_3:		; El tercero (0xE360)
	ld a,(ix+044h)		;a966   ; el nivel del disparo 3
	and a			;a969   ; hay?
	jp z,disparo_4		;a96a   ; no: el siguiente
	cp 001h		;a96d   ; nivel 1?
	jr z,disparo_3_y7		;a96f
	cp 002h		;a971   ; nivel 2?
	jr z,disparo_3_y7		;a973
	ld a,(ix+040h)		;a975   ; la Y del disparo 3
	sub b			;a978   ; menos la Y del blanco
	cp 00eh		;a979   ; de 0 a 13?
	jr c,disparo_3_x		;a97b
	cp 0f2h		;a97d   ; de -14 a -1?
	jr c,disparo_4		;a97f
	jr disparo_3_x		;a981
disparo_3_y7:		; En Y
	ld a,(ix+040h)		;a983   ; la Y del disparo 3
	sub b			;a986   ; menos la Y del blanco
	cp 007h		;a987   ; de 0 a 6?
	jr c,disparo_3_x		;a989
	cp 0f9h		;a98b   ; de -7 a -1?
	jr c,disparo_4		;a98d
disparo_3_x:		; En X
	ld a,(ix+044h)		;a98f   ; el nivel del disparo 3
	cp 001h		;a992   ; nivel 1?
	jr z,L_A9A8		;a994
	cp 003h		;a996   ; nivel 3?
	jr z,L_A9A8		;a998
	ld a,(ix+041h)		;a99a   ; la X del disparo 3
	sub c			;a99d   ; menos la X del blanco
	cp 00eh		;a99e   ; de 0 a 13?
	jr c,L_A9B4		;a9a0
	cp 0f2h		;a9a2   ; de -14 a -1?
	jr c,disparo_4		;a9a4
	jr L_A9B4		;a9a6
L_A9A8:
	ld a,(ix+041h)		;a9a8   ; la X del disparo 3
	sub c			;a9ab   ; menos la X del blanco
	cp 007h		;a9ac   ; de 0 a 6?
	jr c,L_A9B4		;a9ae
	cp 0f9h		;a9b0   ; de -7 a -1?
	jr c,disparo_4		;a9b2
L_A9B4:
	ld a,(ix+044h)		;a9b4   ; el nivel del disparo 3
	cp 001h		;a9b7   ; nivel 1?
	jr z,L_A9E7		;a9b9
	cp 003h		;a9bb   ; nivel 3?
	jr z,L_A9E7		;a9bd
	dec (ix+044h)		;a9bf   ; un nivel menos
	ld a,(ix+042h)		;a9c2   ; su dibujo
	sub 004h		;a9c5   ; el dibujo anterior
	ld (ix+042h),a		;a9c7   ; apuntado
	ld a,(iy+001h)		;a9ca   ; la X del blanco
	ld b,(ix+041h)		;a9cd   ; ...contra la del disparo
	cp b			;a9d0   ; a que lado?
	jr c,L_A9DD		;a9d1
	ld a,(ix+041h)		;a9d3   ; su X - C
	sub 007h		;a9d6   ; 7 a la izquierda
	ld (ix+041h),a		;a9d8   ; apuntada
	jr L_A9EF		;a9db
L_A9DD:
	ld a,(ix+041h)		;a9dd   ; su X - C
	add a,007h		;a9e0   ; 7 a la derecha
	ld (ix+041h),a		;a9e2   ; apuntada
	jr L_A9EF		;a9e5
L_A9E7:
	ld (ix+044h),000h		;a9e7   ; el fino se acaba
	ld (ix+040h),0ech		;a9eb   ; fuera
L_A9EF:
	scf			;a9ef   ; C: da
	ret			;a9f0
disparo_4:		; El cuarto (0xE370)
	ld a,(ix+054h)		;a9f1   ; el nivel del disparo 4
	and a			;a9f4   ; hay?
	jp z,disparo_no		;a9f5   ; no: el siguiente
	cp 001h		;a9f8   ; nivel 1?
	jr z,disparo_4_y7		;a9fa
	cp 003h		;a9fc   ; nivel 3?
	jr z,disparo_4_y7		;a9fe
	ld a,(ix+050h)		;aa00   ; la Y del disparo 4
	sub b			;aa03   ; menos la Y del blanco
	cp 00eh		;aa04   ; de 0 a 13?
	jr c,disparo_4_x		;aa06
	cp 0f2h		;aa08   ; de -14 a -1?
	jr c,disparo_no		;aa0a
	jr disparo_4_x		;aa0c
disparo_4_y7:		; En Y
	ld a,(ix+050h)		;aa0e   ; la Y del disparo 4
	sub b			;aa11   ; menos la Y del blanco
	cp 007h		;aa12   ; de 0 a 6?
	jr c,disparo_4_x		;aa14
	cp 0f9h		;aa16   ; de -7 a -1?
	jr c,disparo_no		;aa18
disparo_4_x:		; En X
	ld a,(ix+054h)		;aa1a   ; el nivel del disparo 4
	cp 001h		;aa1d   ; nivel 1?
	jr z,disparo_4_x7		;aa1f
	cp 003h		;aa21   ; nivel 3?
	jr z,disparo_4_x7		;aa23
	ld a,(ix+051h)		;aa25   ; la X del disparo 4
	sub c			;aa28   ; menos la X del blanco
	cp 00eh		;aa29   ; de 0 a 13?
	jr c,disparo_4_da		;aa2b
	cp 0f2h		;aa2d   ; de -14 a -1?
	jr c,disparo_no		;aa2f
	jr disparo_4_da		;aa31
disparo_4_x7:		; En X, de 7
	ld a,(ix+051h)		;aa33   ; la X del disparo 4
	sub c			;aa36   ; menos la X del blanco
	cp 007h		;aa37   ; de 0 a 6?
	jr c,disparo_4_da		;aa39
	cp 0f9h		;aa3b   ; de -7 a -1?
	jr c,disparo_no		;aa3d
disparo_4_da:		; Da
	ld a,(ix+054h)		;aa3f   ; el nivel del disparo 4
	cp 001h		;aa42   ; nivel 1?
	jr z,disparo_4_fin		;aa44
	cp 003h		;aa46   ; nivel 3?
	jr z,disparo_4_fin		;aa48
	dec (ix+054h)		;aa4a   ; un nivel menos
	ld a,(ix+052h)		;aa4d   ; su dibujo
	sub 004h		;aa50   ; el dibujo anterior
	ld (ix+052h),a		;aa52   ; apuntado
	ld a,(iy+001h)		;aa55   ; la X del blanco
	ld b,(ix+051h)		;aa58   ; ...contra la del disparo
	cp b			;aa5b   ; a que lado?
	jr c,disparo_4_der		;aa5c
	ld a,(ix+051h)		;aa5e   ; su X - C
	sub 007h		;aa61   ; 7 a la izquierda
	ld (ix+051h),a		;aa63   ; apuntada
	jr disparo_4_si		;aa66
disparo_4_der:		; A la derecha
	ld a,(ix+051h)		;aa68   ; su X - C
	add a,007h		;aa6b   ; 7 a la derecha
	ld (ix+051h),a		;aa6d   ; apuntada
	jr disparo_4_si		;aa70
disparo_4_fin:		; Se acaba
	ld (ix+054h),000h		;aa72   ; el fino se acaba
	ld (ix+050h),0ech		;aa76   ; fuera
disparo_4_si:		; C
	scf			;aa7a   ; C: da
	ret			;aa7b
disparo_no:		; NC: ninguno
	xor a			;aa7c   ; NC
	ret			;aa7d
guardian:		; El objeto 6, una pieza del guardian del final de escena: cuando la pantalla esta casi entera (fila 0x12 o la 0), se coloca (X + 0x18) y cuenta en 0xE198; dispara (0xB4) cada 0x18-0x37 cuadros; cada 0x40 cuadros cambia de dibujo (0x4A90 / 0x4DE8) con el sonido 2; aguanta 20 disparos (dobles con el arma 2 o mas): rota, 2.000 puntos, su dibujo roto (0x4E4A), el parpadeo; la ultima, la escena acabada
	ld a,(iy+003h)		;aa7e   ; en pantalla?
	and a			;aa81
	ret z			;aa82
	ld a,(0e192h)		;aa83   ; la fila de la pantalla...
	and a			;aa86
	jr z,L_AA8C		;aa87
	cp 012h		;aa89   ; ...hasta la 0x12, nada
	ret c			;aa8b
L_AA8C:
	ld a,(iy+008h)		;aa8c   ; colocado?
	and a			;aa8f
	jr nz,guardian_dispara		;aa90
	inc (iy+008h)		;aa92   ; ya si
	ld a,(iy+001h)		;aa95   ; 0x18 a la derecha
	add a,018h		;aa98
	ld (iy+001h),a		;aa9a
	ld a,(0e198h)		;aa9d   ; una pieza mas
	inc a			;aaa0
	ld (0e198h),a		;aaa1
guardian_dispara:		; La espera del disparo
	ld a,(iy+00dh)		;aaa4   ; esperando?
	and a			;aaa7
	jr nz,guardian_espera		;aaa8
	ld a,r		;aaaa   ; otra espera: 0x18-0x37
	and 01fh		;aaac
	add a,018h		;aaae
	ld (iy+00dh),a		;aab0
	ld c,0b4h		;aab3   ; la bala 0xB4
	call bala_hueco		;aab5
	jr guardian_dibujo		;aab8
guardian_espera:		; Un cuadro menos
	dec (iy+00dh)		;aaba
guardian_dibujo:		; Cada 0x40 cuadros, el otro dibujo
	inc (iy+009h)		;aabd   ; la cuenta del dibujo
	ld a,(iy+009h)		;aac0
	cp 040h		;aac3   ; 0x40?
	jr c,guardian_golpe		;aac5
	ld (iy+009h),000h		;aac7   ; a cero
	inc (iy+00ah)		;aacb   ; la vez...
	ld a,(iy+00ah)		;aace
	bit 0,a		;aad1   ; ...par o impar
	jr nz,guardian_dibujo2		;aad3
	ld de,04a90h		;aad5   ; 0x4A90
	jr guardian_dibujo_pon		;aad8
guardian_dibujo2:		; 0x4DE8
	ld de,04de8h		;aada
guardian_dibujo_pon:		; En el mapa, con el efecto 2
	ld l,(iy+005h)		;aadd   ; su sitio en el mapa
	ld h,(iy+006h)		;aae0
	call dibujo_mapa		;aae3   ; el dibujo
	ld a,002h		;aae6   ; el efecto 2
	call efecto_pide		;aae8
guardian_golpe:		; Un disparo le da?
	ld b,(iy+000h)		;aaeb
	ld c,(iy+001h)		;aaee
	call disparo_da		;aaf1
	ret nc			;aaf4
	ld a,004h		;aaf5   ; el sonido 4
	call sonido_a_pide		;aaf7
	ld a,(ix+00eh)		;aafa   ; el arma...
	cp 002h		;aafd   ; ...2 o mas: tres golpes
	jr c,L_AB07		;aaff
	inc (iy+00bh)		;ab01
	inc (iy+00bh)		;ab04
L_AB07:
	inc (iy+00bh)		;ab07   ; un golpe
	ld a,(iy+00bh)		;ab0a
	cp 014h		;ab0d   ; 20?
	ret c			;ab0f
	ld a,002h		;ab10   ; 2.000 puntos
	call puntos_suma_cien		;ab12
	ld l,(iy+005h)		;ab15   ; su dibujo roto (0x4E4A)
	ld h,(iy+006h)		;ab18
	ld de,04e4ah		;ab1b
	call dibujo_mapa		;ab1e
	ld a,020h		;ab21   ; el parpadeo
	ld (0e1c0h),a		;ab23
	ld a,(0e198h)		;ab26   ; una pieza menos
	dec a			;ab29
	ld (0e198h),a		;ab2a
	and a			;ab2d
	jr nz,guardian_fuera		;ab2e
	ld a,001h		;ab30   ; ninguna: la escena acabada
	ld (0e184h),a		;ab32
	ld a,040h		;ab35   ; y un parpadeo mas largo
	ld (0e1c0h),a		;ab37
guardian_fuera:		; Fuera
	jp otro_borra_corto		;ab3a
canon:		; Los objetos 7 y 9, canones: cada 0x30-0x6F cuadros sacan un enemigo (0x0C; el 9, 0x0B) en un hueco libre; el 9, solo en la pantalla 10 o desde la fila 0x11
	ld a,(iy+003h)		;ab3d   ; en pantalla?
	and a			;ab40
	ret z			;ab41
	ld a,(iy+004h)		;ab42   ; el 9?
	cp 009h		;ab45
	jr nz,canon_7		;ab47
	ld a,(0e053h)		;ab49   ; la pantalla 10?
	cp 00ah		;ab4c
	jr z,canon_espera		;ab4e
	ld a,(0e192h)		;ab50   ; la fila...
	cp 011h		;ab53   ; ...0x11
	ret c			;ab55
	jr canon_espera		;ab56
canon_7:		; El 7, por debajo de la Y 0x10
	ld a,(iy+000h)		;ab58
	cp 010h		;ab5b
	ret c			;ab5d
canon_espera:		; Esperando?
	ld a,(iy+007h)		;ab5e
	and a			;ab61
	jr z,canon_saca		;ab62
	dec (iy+007h)		;ab64
	ret			;ab67
canon_saca:		; Otra espera y un enemigo: el 0x0C (el 9, 0x0B)
	ld a,r		;ab68   ; la espera: 0x30-0x6F
	and 03fh		;ab6a
	add a,030h		;ab6c
	ld (iy+007h),a		;ab6e
	call bala_hueco_otro		;ab71   ; un hueco?
	ret nc			;ab74
	inc hl			;ab75
	inc hl			;ab76
	inc hl			;ab77
	inc hl			;ab78
	ld (hl),00ch		;ab79   ; el tipo 0x0C
	ld a,(iy+004h)		;ab7b   ; el 9?
	cp 009h		;ab7e
	ret nz			;ab80
	ld (hl),00bh		;ab81   ; el 0x0B
	ret			;ab83
boca:		; El objeto 8, una boca que se abre y se cierra (0x4D2B / 0x4D19) cada 0x18-0x37 cuadros y saca un enemigo 0x0D al abrirse; abierta, aguanta 20 disparos: 3.000 puntos y el parpadeo; la segunda, la escena acabada (0xE19A)
	ld a,(iy+003h)		;ab84   ; en pantalla?
	and a			;ab87
	ret z			;ab88
	ld a,(iy+000h)		;ab89   ; por debajo de 0x50?
	cp 050h		;ab8c
	ret c			;ab8e
	ld a,(iy+007h)		;ab8f   ; la espera
	and a			;ab92
	jr z,boca_cambia		;ab93
	dec (iy+007h)		;ab95   ; un cuadro menos
	ld a,(iy+008h)		;ab98   ; cerrada?
	bit 0,a		;ab9b
	ret nz			;ab9d
	ld b,(iy+000h)		;ab9e   ; su Y...
	ld a,(iy+001h)		;aba1   ; ...y su X + 12
	add a,00ch		;aba4
	ld c,a			;aba6
	call disparo_da		;aba7   ; un disparo le da?
	ret nc			;abaa
	ld a,004h		;abab   ; el sonido 4
	call sonido_a_pide		;abad
	ld a,(ix+00eh)		;abb0   ; el arma 2 o mas: doble
	cp 002h		;abb3
	jr c,boca_golpe		;abb5
	inc (iy+00dh)		;abb7
boca_golpe:		; Un golpe; a los 20, rota
	inc (iy+00dh)		;abba
	ld a,(iy+00dh)		;abbd
	cp 014h		;abc0   ; 20?
	ret c			;abc2
	ld a,018h		;abc3   ; el parpadeo
	ld (0e1c0h),a		;abc5
	ld a,003h		;abc8   ; 3.000 puntos
	call puntos_suma_cien		;abca
	ld de,04d19h		;abcd   ; cerrada para siempre
	ld l,(iy+005h)		;abd0
	ld h,(iy+006h)		;abd3
	call dibujo_mapa		;abd6
	ld a,(0e19ah)		;abd9   ; una boca rota mas
	inc a			;abdc
	ld (0e19ah),a		;abdd
	cp 001h		;abe0   ; la primera: sigue
	jp z,otro_borra_corto		;abe2
	ld (0e184h),a		;abe5   ; la segunda: la escena acabada
	jp otro_borra_corto		;abe8
boca_cambia:		; Otra espera (0x18-0x37) y se abre o se cierra; al cambiar, un enemigo 0x0D
	ld a,r		;abeb   ; otra espera...
	and 01fh		;abed   ; ...0x18-0x37
	add a,018h		;abef
	ld (iy+007h),a		;abf1
	inc (iy+008h)		;abf4   ; abre o cierra
	ld a,(iy+008h)		;abf7
	bit 0,a		;abfa   ; abierta?
	jr nz,boca_cerrada		;abfc
	ld de,04d2bh		;abfe   ; 0x4D2B: abierta
	jr boca_dibujo		;ac01
boca_cerrada:		; Cerrada (0x4D19)
	ld de,04d19h		;ac03
boca_dibujo:		; En el mapa, y el enemigo
	ld l,(iy+005h)		;ac06   ; su sitio en el mapa
	ld h,(iy+006h)		;ac09
	call dibujo_mapa		;ac0c   ; el dibujo
	call bala_hueco_otro		;ac0f   ; un hueco?
	ret nc			;ac12   ; no
	inc hl			;ac13   ; al tipo (+4)
	inc hl			;ac14
	inc hl			;ac15
	inc hl			;ac16
	ld (hl),00dh		;ac17   ; el tipo 0x0D
	ret			;ac19   ; puesto
corazon_sale:		; El objeto 0x0A: por debajo de la Y 0x10, saca el enemigo 0x0A (el corazon que baja) y se va
	ld a,(iy+003h)		;ac1a   ; en pantalla?
	and a			;ac1d
	ret z			;ac1e
	ld a,(iy+000h)		;ac1f   ; la Y...
	cp 010h		;ac22   ; ...por encima de 0x10: nada
	ret c			;ac24
	ld c,00ah		;ac25   ; el tipo 0x0A
	call enemigo_hueco		;ac27   ; un hueco?
	ret nc			;ac2a
	jp otro_borra_corto		;ac2b   ; y se va
enemigo_hueco:		; El tipo C en el primer hueco libre de los enemigos (0xE384, ocho, de 32 en 32); C: puesto
	ld hl,0e384h		;ac2e
	ld b,008h		;ac31
	ld de,00020h		;ac33
enemigo_hueco_uno:		; Libre?
	ld a,(hl)			;ac36   ; libre?
	and a			;ac37
	jr z,enemigo_hueco_pon		;ac38   ; si: puesto
	add hl,de			;ac3a   ; el siguiente
	djnz enemigo_hueco_uno		;ac3b
	xor a			;ac3d   ; ninguno: NC
	ret			;ac3e
enemigo_hueco_pon:		; Puesto
	ld (hl),c			;ac3f   ; el tipo
	scf			;ac40   ; C: puesto
	ret			;ac41
nada_baja:		; Los objetos 0x0B-0x0F: nada; por debajo de 0x80, fuera
	ld a,(iy+003h)		;ac42   ; en pantalla?
	and a			;ac45
	ret z			;ac46
	ld a,(iy+000h)		;ac47   ; la Y...
	cp 080h		;ac4a   ; ...por encima de 0x80: nada
	ret c			;ac4c
	jp otro_borra_corto		;ac4d   ; fuera
enemigos_salen:		; Los enemigos que salen solos: cada 0x20 - escena x 4 + 0-0x1F cuadros (0xE199), uno en un hueco libre: el de la tabla de 0xACB6 por escena y pantalla; desde la pantalla 8, el 8 (el 5 en las escenas 3 y 5)
	ld a,(0e199h)		;ac50   ; esperando?
	and a			;ac53
	jr z,L_AC5B		;ac54
	dec a			;ac56   ; un cuadro menos
	ld (0e199h),a		;ac57
	ret			;ac5a
L_AC5B:
	ld a,(0e053h)		;ac5b
	cp 009h		;ac5e
	jr c,L_AC62		;ac60
L_AC62:
	ld a,(0e003h)		;ac62   ; la escena x 4...
	rlca			;ac65
	rlca			;ac66
	ld b,a			;ac67
	ld a,020h		;ac68
	sub b			;ac6a
	ld b,a			;ac6b
	ld a,r		;ac6c   ; ...0x20 menos eso, + 0-0x1F
	and 01fh		;ac6e
	add a,b			;ac70
	ld (0e199h),a		;ac71
	ld hl,0e384h		;ac74   ; un hueco
	ld b,008h		;ac77
	ld de,00020h		;ac79
L_AC7C:
	ld a,(hl)			;ac7c   ; libre?
	and a			;ac7d
	jr z,enemigos_salen_pon		;ac7e   ; si: ese
	add hl,de			;ac80   ; el siguiente
	djnz L_AC7C		;ac81
	ret			;ac83   ; ninguno: nada
enemigos_salen_pon:		; Desde la pantalla 8, el 8 (y en las escenas impares desde la 3, el 5)
	ld a,(0e053h)		;ac84   ; la pantalla...
	cp 008h		;ac87   ; ...8 o mas?
	jr c,enemigos_salen_tabla		;ac89
	ld (hl),008h		;ac8b   ; el 8
	ld a,(0e003h)		;ac8d   ; la escena impar?
	bit 0,a		;ac90
	ret z			;ac92
	cp 002h		;ac93   ; 3 o mas?
	ret c			;ac95
	ld (hl),005h		;ac96   ; el 5
	ret			;ac98
enemigos_salen_tabla:		; El tipo de la tabla de la escena (0xACB6), por la pantalla (0xE053)
	push hl			;ac99
	ld hl,0acb6h		;ac9a   ; la tabla
	ld a,(0e003h)		;ac9d   ; la escena
	add a,a			;aca0   ; x 2
	add a,l			;aca1
	jr nc,L_ACA5		;aca2
	inc h			;aca4
L_ACA5:
	ld l,a			;aca5
	ld e,(hl)			;aca6   ; su lista
	inc hl			;aca7
	ld d,(hl)			;aca8
	ex de,hl			;aca9
	ld a,(0e053h)		;acaa   ; la pantalla
	add a,l			;acad
	jr nc,L_ACB1		;acae
	inc h			;acb0
L_ACB1:
	ld l,a			;acb1
	ld a,(hl)			;acb2   ; el tipo
	pop hl			;acb3
	ld (hl),a			;acb4   ; en el hueco
	ret			;acb5

; ----------------------------------------------------------------------
; DATOS enemigos_salen_tabla_d: Las tablas de los enemigos que salen solos:
;   seis punteros (uno por escena) y diez tipos por escena (uno por pantalla)
;   0xacb6..0xad00  (74 bytes)
DATA_enemigos_salen_tabla_d:
	defb 0c2h,0ach,0cch,0ach,0d6h,0ach,0e0h,0ach,0eah,0ach,0f4h,0ach,001h,001h,001h,003h	; acb6  ................
	defb 001h,004h,003h,001h,002h,001h,001h,001h,002h,001h,003h,001h,006h,002h,001h,001h	; acc6  ................
	defb 001h,004h,002h,004h,003h,001h,002h,001h,003h,001h,001h,002h,006h,001h,009h,003h	; acd6  ................
	defb 007h,002h,004h,001h,001h,001h,002h,004h,005h,002h,003h,009h,002h,002h,001h,001h	; ace6  ................
	defb 007h,002h,005h,002h,005h,009h,007h,001h,009h,007h	; acf6  ..........

; ----------------------------------------------------------------------
; DATOS musicas: Las 9 musicas: las piezas de los canales A, B y C (6 bytes
;   cada una; la 0, nada)
;   0xad00..0xad36  (54 bytes)
DATA_musicas:
	defb 040h,0b1h,040h,0b1h,040h,0b1h,071h,0b7h,091h,0b7h,0c1h,0b7h,0e6h,0b5h,008h,0b6h	; ad00  @.@.@.q.........
	defb 039h,0b6h,091h,0b6h,0aah,0b6h,0c9h,0b6h,044h,0b1h,048h,0b1h,04ch,0b1h,0e9h,0b6h	; ad10  9.......D.H.L...
	defb 023h,0b7h,04ah,0b7h,0f3h,0b7h,031h,0b8h,07fh,0b8h,0cfh,0b8h,008h,0b9h,04ah,0b9h	; ad20  #.J...1.......J.
	defb 07ah,0b2h,047h,0b3h,052h,0b4h	; ad30

; ----------------------------------------------------------------------
; DATOS efectos_a: Los 6 efectos del canal A: su pieza (2 bytes)
;   0xad36..0xad42  (12 bytes)
DATA_efectos_a:
	defb 03ch,0b1h,064h,0b2h,048h,0b2h,01fh,0b2h,0f6h,0b1h,0e5h,0b1h	; ad36  <.d.H.......

; ----------------------------------------------------------------------
; DATOS efectos_bc: Los 7 efectos de los canales B y C: sus dos piezas (4
;   bytes); del 3 al 6, el fondo de las escenas
;   0xad42..0xad5e  (28 bytes)
DATA_efectos_bc:
	defb 040h,0b1h,040h,0b1h,052h,0b1h,073h,0b1h,09eh,0b1h,0ddh,0b1h,03dh,0beh,0cbh,0beh	; ad42  @.@.R.s.....=...
	defb 0b4h,0bch,07bh,0bdh,002h,0bch,053h,0bch,0b7h,0b9h,099h,0bah	; ad52  ..{...S.....

; ======================================================================
; CODIGO 0xad5e..0xb033  (725 bytes)
; ======================================================================


sonido_a_pide:		; Pide el efecto A del canal A (0xE2C0); gana el de numero menor. Donde otros Casio llevan "ret z" (sin partida, nada), aqui hay un "nop": suena tambien en la demostracion
	ld b,a			;ad5e
	ld a,(0e000h)		;ad5f   ; jugando...
	and a			;ad62   ; ninguno?
	nop			;ad63   ; ..."nop" (no "ret z")
sonido_a_pon:
	ld a,b			;ad64   ; el efecto
	ld hl,0e2c0h		;ad65   ; el efecto del canal A pedido
	jr pide_va		;ad68
efecto_pide:		; Pide el efecto A (0xE2C2), solo en partida: si ya hay uno, se queda el de numero mas bajo
	ld b,a			;ad6a   ; el numero
	ld a,(0e000h)		;ad6b   ; en partida?
	and a			;ad6e
	nop			;ad6f   ; ..."nop"
	ld a,b			;ad70   ; el efecto
	ld hl,0e2c2h		;ad71   ; el efecto pedido
pide_va:
	ld b,a			;ad74
	ld a,(hl)			;ad75   ; ya hay uno?
	and a			;ad76
	jr z,pide_pon		;ad77
	cp b			;ad79   ; el de antes es menor: se queda
	ret c			;ad7a
pide_pon:
	ld (hl),b			;ad7b   ; el nuevo
	ret			;ad7c
musica_pide:		; Pide la musica A (0xE2BE), con la misma regla
	ld hl,0e2beh		;ad7d   ; la musica pedida
	jr pide_va		;ad80
sonido:		; El sonido de cada cuadro (desde la interrupcion): una musica nueva o un efecto nuevo empiezan; los tres canales (0xE280, 0xE292, 0xE2A4, 18 bytes) siguen
	ld hl,0e2bdh		;ad82   ; una musica sonando?
	xor a			;ad85
	cp (hl)			;ad86   ; sonando?
	jr nz,L_ADA1		;ad87
	inc hl			;ad89   ; una pedida?
	cp (hl)			;ad8a
	jp nz,musica_empieza		;ad8b   ; empieza
	inc hl			;ad8e
	cp (hl)			;ad8f
	jr nz,L_ADA9		;ad90
	inc hl			;ad92
	cp (hl)			;ad93
	jp nz,efecto_a_empieza		;ad94
L_AD97:
	xor a			;ad97   ; nada en el canal A...
	inc hl			;ad98   ; el efecto de B y C?
	cp (hl)			;ad99
	jr nz,L_ADB1		;ad9a   ; sonando
	inc hl			;ad9c   ; pedido?
	cp (hl)			;ad9d
	jp nz,efecto_bc_empieza		;ad9e   ; empieza
L_ADA1:
	call pedido_mira		;ada1
	jp c,musica_empieza		;ada4
	jr sonido_canal_a		;ada7
L_ADA9:
	call pedido_mira		;ada9
	jp c,efecto_a_empieza		;adac
	jr L_AD97		;adaf
L_ADB1:
	call pedido_mira		;adb1
	jp c,efecto_bc_empieza		;adb4
sonido_canal_a:		; El canal A: su bloque a 0xE2C3, un paso y de vuelta
	ld a,(0e2bdh)		;adb7   ; la musica?
	and a			;adba
	jr nz,sonido_canal_a_va		;adbb
	ld a,(0e2bfh)		;adbd   ; o un efecto que use el canal A?
	and a			;adc0
	jr z,sonido_canal_b		;adc1
sonido_canal_a_va:
	ld hl,0e280h		;adc3   ; el canal A
	call canal_a_trabajo		;adc6   ; al canal de trabajo
	ld bc,00008h		;adc9
	xor a			;adcc
	call canal_un_paso		;adcd
	push af			;add0
	ld de,0e280h		;add1
	call canal_de_trabajo		;add4
	pop af			;add7
	and a			;add8
	jr z,sonido_canal_b		;add9
	cp 001h		;addb
	jp z,musica_acaba		;addd
	cp 002h		;ade0
	jp z,sonido_a_acaba		;ade2
sonido_canal_b:		; Los canales B y C: con la musica o el efecto de B y C, un paso de cada uno (los registros 2-3 y 9, 4-5 y 10); al acabar, sonido_bc_acaba
	ld a,(0e2bdh)		;ade5   ; la musica?
	and a			;ade8
	jr nz,sonido_canal_b_va		;ade9
	ld a,(0e2c1h)		;adeb   ; o el efecto de B y C?
	and a			;adee
	ret z			;adef
sonido_canal_b_va:
	ld hl,0e292h		;adf0   ; el canal B
	call canal_a_trabajo		;adf3
	ld bc,00209h		;adf6
	ld a,(0e03ch)		;adf9
	rrca			;adfc
	ld (0e03ch),a		;adfd
	ld a,001h		;ae00
	call canal_un_paso		;ae02
	push af			;ae05
	ld de,0e292h		;ae06
	call canal_de_trabajo		;ae09
	pop af			;ae0c
	cp 003h		;ae0d   ; 3: sigue
	jr z,L_AE1E		;ae0f
	ld b,a			;ae11
	ld a,(0e03ch)		;ae12   ; los bits de vuelta
	rlca			;ae15
	ld (0e03ch),a		;ae16
	ld a,b			;ae19
	and a			;ae1a
	jp nz,sonido_bc_acaba		;ae1b   ; acabado
L_AE1E:
	ld hl,0e2a4h		;ae1e   ; el canal C
	call canal_a_trabajo		;ae21
	ld bc,0040ah		;ae24   ; los registros 4 y 10
	ld a,(0e03ch)		;ae27   ; los bits del mezclador...
	rrca			;ae2a
	rrca			;ae2b
	ld (0e03ch),a		;ae2c
	ld a,002h		;ae2f   ; el canal 2
	call canal_un_paso		;ae31   ; un paso
	push af			;ae34
	ld de,0e2a4h		;ae35   ; de vuelta
	call canal_de_trabajo		;ae38
	pop af			;ae3b
	cp 003h		;ae3c   ; 3: sigue
	jp z,ruido_barrido		;ae3e
	ld b,a			;ae41
	ld a,(0e03ch)		;ae42
	rlca			;ae45
	rlca			;ae46
	ld (0e03ch),a		;ae47
	ld a,b			;ae4a
	and a			;ae4b
	jp nz,sonido_bc_acaba		;ae4c
	jp ruido_barrido		;ae4f
canal_a_trabajo:		; Copia el bloque del canal (HL, 18 bytes) a 0xE2C3
	ld de,0e2c3h		;ae52   ; al canal de trabajo
copia18:
	ld bc,00012h		;ae55   ; 18 bytes
	ldir		;ae58   ; copiados
	ret			;ae5a
canal_de_trabajo:		; Y de vuelta a DE
	ld hl,0e2c3h		;ae5b
	jr copia18		;ae5e
canal_paso:		; Un paso del canal de trabajo: si la nota sigue, nada; si no, el byte siguiente de la pieza: una nota (menos de 0xF0) o una orden
	ld hl,0e2cdh		;ae60   ; la nota sigue?
	ld a,(hl)			;ae63
	and a			;ae64
	jr z,canal_byte		;ae65
	call canal_cuenta		;ae67   ; su cuenta
	and a			;ae6a
	ret z			;ae6b
canal_byte:		; El byte siguiente de la pieza (0xE2C3): menos de 0xF0, una nota (duracion y volumen, el tono) y 3; si no, una orden
	ld iy,0e2cdh		;ae6c
	ld hl,(0e2c3h)		;ae70
	ld a,(hl)			;ae73   ; el byte
	cp 0f0h		;ae74   ; 0xF0 o mas: una orden
	jr nc,L_AE9D		;ae76
	call nota_pon		;ae78   ; la duracion y el volumen
	call nota_tono		;ae7b
	ld (0e2c3h),hl		;ae7e   ; apuntado
	ld a,(0e03ch)		;ae81   ; el canal con tono, sin ruido
	res 0,a		;ae84
	set 3,a		;ae86
canal_mezcla:
	ld c,a			;ae88   ; guardado
	ld a,(0e2d5h)		;ae89   ; corrido al canal
	and a			;ae8c
	ld b,a			;ae8d
	ld a,c			;ae8e
	jr z,canal_mezcla_pon		;ae8f
canal_mezcla_corre:
	rlca			;ae91
	djnz canal_mezcla_corre		;ae92   ; B veces
canal_mezcla_pon:
	ld (0e03ch),a		;ae94   ; el registro 7
	call psg_mezcla		;ae97   ; al PSG
	ld a,003h		;ae9a
	ret			;ae9c
L_AE9D:
	jp z,canal_ruido		;ae9d
	cp 0ffh		;aea0   ; 0xFF: el final
	jr nz,canal_orden_f7		;aea2
	ld a,001h		;aea4   ; 1
	ret			;aea6
canal_orden_f7:
	cp 0f7h		;aea7   ; 0xF7: callar
	jr nz,canal_orden_fe		;aea9
	ld a,002h		;aeab   ; 2
	ret			;aead
canal_orden_fe:
	cp 0feh		;aeae   ; 0xFE: al principio
	jr nz,canal_orden_fd		;aeb0
	ld hl,(0e2c5h)		;aeb2   ; la pieza otra vez desde su principio
	jr canal_orden_sigue		;aeb5
canal_orden_fd:		; 0xFD n: la marca 1 y cuantas veces
	cp 0fdh		;aeb7   ; 0xFD n: el primer bucle, n veces
	jr nz,canal_orden_fc		;aeb9
	inc hl			;aebb   ; cuantas veces...
	ld a,(hl)			;aebc
	ld (iy+005h),a		;aebd   ; ...en +5
	inc hl			;aec0
	ld (0e2c7h),hl		;aec1   ; la marca 1
	jr canal_orden_sigue		;aec4
canal_orden_fc:		; 0xFC: vuelve a la marca 1 si quedan
	cp 0fch		;aec6   ; 0xFC: el final del primer bucle
	jr nz,canal_orden_fb		;aec8
	dec (iy+005h)		;aeca   ; una vez menos
	jr nz,canal_orden_fc_vuelve		;aecd
	inc hl			;aecf   ; ya: sigue
	jr canal_orden_sigue		;aed0
canal_orden_fc_vuelve:
	ld hl,(0e2c7h)		;aed2   ; a la marca 1
	jr canal_orden_sigue		;aed5
canal_orden_fb:		; 0xFB n: la marca 2
	cp 0fbh		;aed7   ; 0xFB n: el segundo bucle
	jr nz,canal_orden_fa		;aed9
	inc hl			;aedb   ; cuantas veces...
	ld a,(hl)			;aedc
	ld (iy+006h),a		;aedd   ; ...en +6
	inc hl			;aee0
	ld (0e2c9h),hl		;aee1   ; la marca 2
canal_orden_sigue:		; Sigue leyendo
	ld (0e2c3h),hl		;aee4   ; por donde va
	jr canal_byte		;aee7
canal_orden_fa:		; 0xFA: vuelve a la marca 2
	cp 0fah		;aee9   ; 0xFA: su final
	jr nz,canal_orden_f9		;aeeb
	dec (iy+006h)		;aeed   ; una vez menos
	jr nz,canal_orden_fa_vuelve		;aef0
	inc hl			;aef2   ; ya: sigue
	jr canal_orden_sigue		;aef3
canal_orden_fa_vuelve:
	ld hl,(0e2c9h)		;aef5   ; a la marca 2
	jr canal_orden_sigue		;aef8
canal_orden_f9:		; 0xF9 n: la marca 3
	cp 0f9h		;aefa   ; 0xF9 n: el tercer bucle
	jr nz,canal_orden_f8		;aefc
	inc hl			;aefe   ; cuantas veces...
	ld a,(hl)			;aeff
	ld (iy+007h),a		;af00   ; ...en +7
	inc hl			;af03
	ld (0e2cbh),hl		;af04   ; la marca 3
	jr canal_orden_sigue		;af07
canal_orden_f8:		; 0xF8 (o mas): vuelve a la marca 3
	dec (iy+007h)		;af09   ; una vez menos
	jr nz,canal_orden_f8_vuelve		;af0c
	inc hl			;af0e   ; ya: sigue
	jr canal_orden_sigue		;af0f
canal_orden_f8_vuelve:
	ld hl,(0e2cbh)		;af11   ; a la marca 3
	jr canal_orden_sigue		;af14
canal_ruido:		; 0xF0: una nota de ruido (el periodo y su barrido) y su duracion; el canal, a ruido en el registro 7
	call ruido_pon		;af16   ; el ruido
	inc hl			;af19
	call nota_pon		;af1a
	inc hl			;af1d
	ld (0e2c3h),hl		;af1e
	ld a,(0e03ch)		;af21
	res 3,a		;af24
	set 0,a		;af26
	jp canal_mezcla		;af28
ruido_barrido:		; El barrido del ruido: cada tantos cuadros, el periodo + el paso, unas cuantas veces
	ld a,(0e2b6h)		;af2b   ; hay ruido?
	and a			;af2e
	ret z			;af2f
	ld a,(0e2b7h)		;af30   ; con barrido?
	and a			;af33
	ret z			;af34
	ld a,(0e2b9h)		;af35   ; quedan pasos?
	and a			;af38
	ret z			;af39
	ld a,(0e2bbh)		;af3a   ; la espera...
	dec a			;af3d   ; ...un cuadro menos
	ld (0e2bbh),a		;af3e
	ret nz			;af41
	ld a,(0e2b9h)		;af42   ; un paso menos
	dec a			;af45
	ld (0e2b9h),a		;af46
	ld a,(0e2bah)		;af49   ; otra vez la espera
	ld (0e2bbh),a		;af4c
	ld a,(0e2b8h)		;af4f   ; el periodo...
	ld b,a			;af52
	ld a,(0e2bch)		;af53   ; ...mas el paso
	add a,b			;af56
	ld (0e2b8h),a		;af57
	jp psg_ruido		;af5a   ; al registro 6
canal_un_paso:		; Un paso del canal de trabajo, que es el A (0xE2D5)
	ld (0e2d5h),a		;af5d   ; el canal
	call canal_paso		;af60   ; un paso
	ret			;af63
pedido_mira:		; C si lo pedido (HL + 1) va antes (numero menor) que lo que suena (HL)
	ld b,(hl)			;af64   ; lo que suena
	inc hl			;af65
	ld a,(hl)			;af66   ; lo pedido
	and a			;af67   ; nada pedido: NC
	ret z			;af68
	cp b			;af69   ; menor: C
	ret			;af6a
canal_cuenta:		; La cuenta de la nota: un cuadro menos; acabada, A = 1; con volumen 15 la envolvente corta, si no la que baja el volumen
	inc hl			;af6b   ; la duracion...
	dec (hl)			;af6c   ; ...un cuadro menos
	jp z,canal_cuenta_fin		;af6d
	inc hl			;af70   ; la envolvente
	ld a,(hl)			;af71
	and a			;af72   ; sin envolvente
	jp z,canal_cuenta_sigue		;af73
	cp 00fh		;af76   ; 15: la envolvente corta
	jr z,canal_cuenta_15		;af78
	inc hl			;af7a
	dec (hl)			;af7b   ; la cuenta de la envolvente
	jr nz,canal_cuenta_sigue		;af7c
	dec hl			;af7e
	ld a,(hl)			;af7f   ; la espera...
	inc hl			;af80
	ld (hl),a			;af81   ; ...otra vez
	inc hl			;af82
	dec (hl)			;af83   ; el volumen, uno menos
	ld a,(hl)			;af84
	call psg_c		;af85   ; al PSG
	and a			;af88
	jr nz,canal_cuenta_sigue		;af89
	dec hl			;af8b   ; volumen 0: sin envolvente
	dec hl			;af8c
	ld (hl),a			;af8d
canal_cuenta_sigue:
	xor a			;af8e
	ret			;af8f
canal_cuenta_15:
	inc hl			;af90
	dec (hl)			;af91   ; la cuenta
	jr nz,canal_cuenta_sigue		;af92
	xor a			;af94
	dec hl			;af95
	ld (hl),a			;af96   ; el volumen a 0
	call psg_c		;af97
	ret			;af9a
canal_cuenta_fin:
	dec hl			;af9b   ; acabada
	xor a			;af9c
	ld (hl),a			;af9d   ; acabada: A = 1
	ld a,001h		;af9e   ; 1
	ret			;afa0
ruido_pon:		; El ruido: su periodo fijo o con barrido (periodo, cuantas veces, cada cuanto, el paso)
	ld (iy+000h),a		;afa1   ; la nota
	inc hl			;afa4
	ld a,(hl)			;afa5   ; con barrido?
	ld (0e2b7h),a		;afa6   ; con barrido (cuantas veces)?
	and a			;afa9
	jr nz,ruido_barre		;afaa
	inc hl			;afac   ; sin barrido
	ld a,(hl)			;afad   ; el periodo...
	ld (0e2b8h),a		;afae
	call psg_ruido		;afb1   ; ...registro 6
	xor a			;afb4   ; sin barrido
	ld (0e2b9h),a		;afb5
	ld (0e2bah),a		;afb8
	ld (0e2bbh),a		;afbb
	ld (0e2bch),a		;afbe
	inc a			;afc1   ; hay ruido
	ld (0e2b6h),a		;afc2
	ret			;afc5
ruido_barre:
	ld (0e2b6h),a		;afc6   ; hay ruido con barrido
	ld (0e2bch),a		;afc9
	inc hl			;afcc
	ld a,(hl)			;afcd   ; el periodo...
	ld (0e2b8h),a		;afce
	call psg_ruido		;afd1   ; ...registro 6
	inc hl			;afd4
	ld a,(hl)			;afd5   ; cuantas veces...
	ld (0e2b9h),a		;afd6
	inc hl			;afd9
	ld a,(hl)			;afda   ; ...cada cuanto
	ld (0e2bah),a		;afdb
	ld (0e2bbh),a		;afde
	ret			;afe1
nota_pon:		; Una nota: la mitad alta del byte es la duracion (la tabla 0xB033, o el byte siguiente con 0xE), la baja el volumen (15: la mitad)
	ld a,(hl)			;afe2   ; la nota...
	ld (iy+000h),a		;afe3
	and 00fh		;afe6   ; ...el volumen (la mitad baja)
	ld (iy+002h),a		;afe8
	ld a,(hl)			;afeb   ; la duracion (la mitad alta)...
	and 0f0h		;afec
	rrca			;afee
	rrca			;afef
	rrca			;aff0
	rrca			;aff1
	cp 00eh		;aff2   ; ...0xE: en el byte siguiente
	jr z,nota_duracion_byte		;aff4
	ld de,0b033h		;aff6   ; la tabla de duraciones
	add a,e			;aff9   ; + la mitad alta
	jr nc,nota_duracion		;affa
	inc d			;affc   ; acarreo
nota_duracion:
	ld e,a			;affd
	ld a,(de)			;affe   ; la duracion
	jr nota_volumen		;afff
nota_duracion_byte:
	inc hl			;b001
	ld a,(hl)			;b002
nota_volumen:
	ld (iy+001h),a		;b003   ; la duracion
	ld a,(iy+002h)		;b006   ; volumen 15?
	cp 00fh		;b009
	jr nz,nota_cuenta		;b00b
	ld a,(iy+001h)		;b00d   ; la duracion...
	push bc			;b010   ; (guardado)
	ld c,a			;b011
	srl a		;b012   ; ...menos la mitad: la espera
	ld b,a			;b014
	ld a,c			;b015
	sub b			;b016
	pop bc			;b017   ; (recuperado)
nota_cuenta:
	ld (iy+003h),a		;b018   ; la cuenta de la envolvente
	ld a,00fh		;b01b   ; el volumen 15
	ld (iy+004h),a		;b01d
	jp psg_c		;b020   ; al PSG
nota_tono:		; El tono de la nota: dos bytes (el alto, por debajo de 0x10, al registro B + 1) o uno (al registro B)
	inc hl			;b023   ; el byte siguiente
	ld a,(hl)			;b024
	cp 010h		;b025   ; por debajo de 0x10: el byte alto
	jr nc,L_B02E		;b027
	call psg_b1		;b029   ; al registro B + 1
	inc hl			;b02c   ; el bajo
	ld a,(hl)			;b02d
L_B02E:
	call psg_b		;b02e   ; al registro B
	inc hl			;b031   ; el siguiente
	ret			;b032

; ----------------------------------------------------------------------
; DATOS duraciones: Las duraciones de las notas (la mitad alta del byte, 0-13)
;   0xb033..0xb041  (14 bytes)
DATA_duraciones:
	defb 080h,060h,040h,030h,020h,018h,010h,00ch,008h,006h,004h,003h,002h,001h	; b033  .`@0 .........

; ======================================================================
; CODIGO 0xb041..0xb13c  (251 bytes)
; ======================================================================


psg_c:		; WRTPSG: el registro C
	ld e,a			;b041   ; el valor...
	ld a,c			;b042   ; ...el registro C
psg:
	jp 00093h		;b043   ; WRTPSG
psg_b:		; El registro B
	ld e,a			;b046   ; el registro B
	ld a,b			;b047
	jr psg		;b048
psg_b1:		; El registro B + 1
	ld e,a			;b04a   ; el registro B + 1
	ld a,b			;b04b
	inc a			;b04c
	jr psg		;b04d
psg_mezcla:		; El registro 7
	ld e,a			;b04f   ; el registro 7
	ld a,007h		;b050
	jr psg		;b052
psg_ruido:		; El registro 6
	ld e,a			;b054   ; el registro 6
	ld a,006h		;b055
	jr psg		;b057
musica_empieza:		; Una musica: los tres canales de la tabla 0xAD00 (6 bytes por musica: la musica N en 0xAD00 + 6N)
	ld hl,0ad00h		;b059   ; la tabla de musicas
	ld a,(0e2beh)		;b05c   ; la pedida...
	ld (0e2bdh),a		;b05f   ; ...suena
	ld b,a			;b062   ; x 6
	add a,b			;b063
	add a,b			;b064
	add a,b			;b065
	add a,b			;b066
	add a,b			;b067
	call canal_a_tabla		;b068
	inc hl			;b06b
	call canales_bc		;b06c
	ld (0e28ah),a		;b06f   ; sin nota en marcha
	ld (0e2beh),a		;b072   ; el pedido, gastado
	ld a,0f8h		;b075   ; el mezclador: los tres canales con tono
mezcla_y_canal_a:		; El mezclador y al canal A
	ld (0e03ch),a		;b077
	call psg_mezcla		;b07a
	jp sonido_canal_a		;b07d
musica_acaba:		; La musica acabada: otra pedida, o el sonido a cero
	ld a,(0e2beh)		;b080   ; otra pedida?
	and a			;b083
	jr nz,musica_empieza		;b084
	ld (0e2bdh),a		;b086   ; ninguna suena
	dec a			;b089   ; 0xFF: los tres callados
sonido_cero:		; El mezclador A y los bloques de los canales (0xE280, 0x43 bytes) a cero
	ld (0e03ch),a		;b08a   ; el mezclador
	call psg_mezcla		;b08d
	ld hl,0e280h		;b090   ; los canales...
	ld b,043h		;b093   ; ...0x43 bytes...
cero_b:		; B bytes de HL a cero
	ld (hl),000h		;b095   ; a cero
	inc hl			;b097
	djnz cero_b		;b098
	ret			;b09a
efecto_a_empieza:		; Un efecto del canal A (0xE2C0): su pieza de la tabla 0xAD36
	ld hl,0ad36h		;b09b   ; la tabla
	ld a,(0e2c0h)		;b09e   ; el pedido...
	ld (0e2bfh),a		;b0a1   ; ...suena
	add a,a			;b0a4   ; x 2
	call canal_a_tabla		;b0a5   ; el canal A
	xor a			;b0a8   ; sin nota en marcha
	ld (0e28ah),a		;b0a9
	ld (0e2c0h),a		;b0ac   ; el pedido, gastado
	ld a,(0e03ch)		;b0af   ; el canal A con tono
	res 0,a		;b0b2
	ld (0e03ch),a		;b0b4
	call psg_mezcla		;b0b7   ; al PSG
	ld hl,0e2c0h		;b0ba
	jp L_AD97		;b0bd
sonido_a_acaba:		; El efecto del canal A acabado (0xF7): otro pedido, o el canal A callado
	ld a,(0e2c0h)		;b0c0   ; otro pedido?
	and a			;b0c3
	jr nz,efecto_a_empieza		;b0c4
	ld (0e2bfh),a		;b0c6   ; ninguno suena
	ld hl,0e280h		;b0c9   ; el canal A a cero
	ld b,012h		;b0cc
	call cero_b		;b0ce
	ld a,(0e03ch)		;b0d1
	or 009h		;b0d4
L_B0D6:
	ld (0e03ch),a		;b0d6
	jp psg_mezcla		;b0d9
efecto_bc_empieza:		; Un efecto de los canales B y C (0xE2C2): sus dos piezas de la tabla 0xAD42
	ld hl,0ad42h		;b0dc   ; la tabla
	ld a,(0e2c2h)		;b0df   ; el pedido...
	ld (0e2c1h),a		;b0e2   ; ...suena
	add a,a			;b0e5   ; x 4
	add a,a			;b0e6
	add a,l			;b0e7
	ld l,a			;b0e8
	call canales_bc		;b0e9   ; los canales B y C
	ld (0e2c2h),a		;b0ec   ; el pedido, gastado
	ld a,(0e03ch)		;b0ef   ; B y C con tono
	and 0f9h		;b0f2
	jp mezcla_y_canal_a		;b0f4
sonido_bc_acaba:		; El efecto de B y C acabado: otro pedido, o B y C callados
	ld a,(0e2c2h)		;b0f7   ; otro pedido?
	and a			;b0fa
	jr nz,efecto_bc_empieza		;b0fb
	ld (0e2c1h),a		;b0fd
	ld hl,0e292h		;b100   ; los canales B y C...
	ld b,024h		;b103   ; ...a cero
	call cero_b		;b105
	ld a,(0e03ch)		;b108   ; el mezclador: B y C callados
	or 036h		;b10b
	jr L_B0D6		;b10d
canales_bc:		; Los canales B y C desde la tabla HL
	ld e,(hl)			;b10f   ; la pieza del canal B
	inc hl			;b110
	ld d,(hl)			;b111
	ld (0e292h),de		;b112   ; ...y su principio
	ld (0e294h),de		;b116
	inc hl			;b11a
	ld e,(hl)			;b11b   ; la del canal C
	inc hl			;b11c
	ld d,(hl)			;b11d
	ld (0e2a4h),de		;b11e
	ld (0e2a6h),de		;b122
	xor a			;b126   ; sin nota en marcha
	ld (0e29ch),a		;b127
	ld (0e2aeh),a		;b12a
	ret			;b12d
canal_a_tabla:		; El canal A desde la tabla
	add a,l			;b12e   ; + la musica x 6
	ld l,a			;b12f
	ld e,(hl)			;b130   ; el canal A: su pieza...
	inc hl			;b131
	ld d,(hl)			;b132
	ld (0e280h),de		;b133   ; ...y su principio
	ld (0e282h),de		;b137
	ret			;b13b

; ----------------------------------------------------------------------
; DATOS piezas: Las piezas de las musicas y los efectos (los punteros de
;   0xAD00-0xAD5D): notas, ruidos y ordenes 0xF0-0xFF; al final, el relleno FB
;   00 de la EPROM, que nadie lee
;   0xb13c..0xc000  (3780 bytes)
DATA_piezas:
	defb 01ch,000h,000h,0f7h,01ch,000h,000h,0ffh,026h,000h,050h,0ffh,026h,000h,040h,0ffh	; b13c  ........&.P.&.@.
	defb 081h,000h,000h,026h,020h,0ffh,082h,001h,01dh,082h,002h,03bh,082h,03bh,082h,001h	; b14c  ...& ......;.;..
	defb 01dh,082h,002h,03bh,082h,03bh,081h,001h,01dh,081h,07dh,081h,094h,081h,002h,03bh	; b15c  ...;.;....}....;
	defb 081h,003h,027h,081h,004h,075h,0ffh,082h,000h,0d6h,082h,001h,094h,082h,094h,082h	; b16c  ..'..u..........
	defb 000h,0d6h,082h,001h,094h,082h,094h,0a3h,000h,0cah,0a3h,0d6h,0a3h,0e2h,0a3h,0f0h	; b17c  ................
	defb 0a3h,0feh,0a3h,001h,00dh,0a3h,01dh,0a3h,02eh,0a3h,040h,0a3h,053h,0a3h,068h,0a3h	; b18c  ..........@.S.h.
	defb 07dh,0ffh,0d1h,002h,0cah,0d1h,0beh,0d1h,0b4h,0d1h,0aah,0d1h,0a0h,0d1h,097h,0d1h	; b19c  }...............
	defb 08fh,0d1h,087h,0d1h,07fh,0d1h,078h,0c2h,002h,020h,0c1h,040h,0c1h,060h,0c1h,030h	; b1ac  ......x.. .@.`.0
	defb 0c1h,050h,0c1h,070h,0c1h,060h,0c1h,080h,0c1h,0a0h,0c1h,0c0h,0c1h,0b0h,0c1h,0f0h	; b1bc  .P.p.`..........
	defb 0c1h,003h,020h,0c1h,050h,0c1h,030h,0c1h,070h,0c1h,090h,0c1h,0b0h,064h,000h,000h	; b1cc  .. .P.0.p....d..
	defb 0ffh,091h,000h,010h,0a1h,040h,0a1h,030h,0feh,0fdh,003h,0d1h,000h,020h,0d1h,040h	; b1dc  .....@.0..... .@
	defb 0d1h,001h,020h,0d1h,080h,0d1h,002h,030h,0fch,0f7h,0d1h,001h,053h,0d1h,040h,0d1h	; b1ec  .. ....0....S.@.
	defb 02eh,0d1h,01dh,0d1h,02eh,0d1h,040h,0d1h,0f0h,000h,002h,081h,0f0h,000h,010h,084h	; b1fc  ......@.........
	defb 0d1h,002h,01bh,0d1h,03bh,0d1h,05dh,0d1h,081h,0d1h,0a7h,0d1h,0cfh,0c1h,0fah,0c1h	; b20c  ....;.].........
	defb 003h,027h,0f7h,0d1h,002h,081h,0d1h,05dh,0d1h,03bh,0d1h,01bh,0d1h,001h,0fch,0d1h	; b21c  .'.....].;......
	defb 0e0h,0d1h,0c5h,0d1h,0ach,0d1h,094h,0d1h,07dh,0d1h,068h,0d1h,053h,0d1h,040h,0d1h	; b22c  ........}.h.S.@.
	defb 02eh,0d1h,01dh,0d1h,001h,00dh,0d1h,000h,0feh,065h,040h,0f7h,081h,000h,040h,0d1h	; b23c  .........e@...@.
	defb 07fh,0d1h,078h,0d1h,071h,0d1h,06bh,0d1h,065h,0d1h,05fh,0d1h,05ah,0d1h,055h,0d1h	; b24c  ..x.q.k.e._.Z.U.
	defb 050h,0d1h,04ch,0d1h,047h,0d1h,043h,0f7h,0f0h,000h,01fh,0a1h,0d1h,001h,0e0h,0d1h	; b25c  P.L.G.C.........
	defb 02eh,0d1h,0c5h,0d1h,040h,0d1h,0ach,0d1h,053h,0d1h,094h,0d1h,07dh,0f7h,0fdh,003h	; b26c  ....@...S...}...
	defb 053h,003h,0f9h,081h,0f9h,081h,0f9h,081h,0f9h,053h,0f9h,082h,0f9h,082h,0f9h,081h	; b27c  S........S......
	defb 0f9h,053h,002h,0fah,081h,0fah,081h,0fah,081h,0fah,053h,0fah,081h,0fah,081h,0fah	; b28c  .S........S.....
	defb 081h,0fah,0fch,053h,003h,0f9h,081h,0f9h,081h,0f9h,081h,0f9h,053h,0f9h,081h,0f9h	; b29c  ...S........S...
	defb 081h,0f9h,081h,0f9h,081h,003h,057h,081h,057h,081h,057h,081h,027h,081h,027h,081h	; b2ac  ......W.W.W.'.'.
	defb 027h,081h,002h,0fah,041h,000h,000h,081h,000h,000h,0fdh,002h,0fbh,010h,081h,001h	; b2bc  '...A...........
	defb 0fch,081h,000h,000h,0fah,0fbh,010h,081h,002h,081h,081h,000h,000h,0fah,0fch,0fdh	; b2cc  ................
	defb 002h,0fbh,002h,081h,001h,07dh,081h,000h,000h,081h,002h,03bh,081h,000h,000h,081h	; b2dc  .....}.....;....
	defb 002h,03bh,081h,000h,000h,0fah,081h,001h,07dh,081h,000h,000h,081h,002h,03bh,081h	; b2ec  .;......}.....;.
	defb 000h,000h,0fbh,002h,081h,001h,0ach,081h,000h,000h,081h,002h,081h,081h,000h,000h	; b2fc  ................
	defb 081h,002h,081h,081h,000h,000h,0fah,081h,001h,0ach,081h,000h,000h,081h,002h,081h	; b30c  ................
	defb 081h,000h,000h,0fch,00dh,000h,000h,001h,000h,000h,001h,000h,000h,001h,000h,000h	; b31c  ................
	defb 001h,000h,000h,0fdh,004h,053h,005h,04dh,081h,04dh,081h,04dh,081h,04dh,081h,04dh	; b32c  .....S.M.M.M.M.M
	defb 061h,000h,000h,081h,005h,04dh,061h,000h,000h,0fch,0ffh,056h,001h,0ach,083h,0ach	; b33c  a....Ma....V....
	defb 083h,0ach,083h,0ach,056h,0ach,056h,053h,039h,07dh,083h,07dh,083h,002h,05dh,083h	; b34c  ....V.VS9}.}..].
	defb 001h,0fch,083h,000h,0feh,083h,001h,02eh,083h,07dh,056h,001h,0ach,083h,0ach,083h	; b35c  .........}V.....
	defb 0ach,083h,0ach,056h,0ach,056h,053h,056h,07dh,083h,002h,05dh,083h,001h,0fch,083h	; b36c  ...V.VSV}..]....
	defb 07dh,083h,0fch,083h,07dh,083h,02eh,083h,07dh,083h,02eh,083h,000h,0feh,056h,001h	; b37c  }...}...}.....V.
	defb 0ach,083h,0ach,083h,0ach,083h,0ach,056h,0ach,056h,053h,039h,07dh,083h,07dh,083h	; b38c  .......V.VS9}.}.
	defb 002h,05dh,083h,001h,0fch,083h,000h,0feh,083h,001h,02eh,083h,07dh,056h,001h,0ach	; b39c  .]..........}V..
	defb 083h,0ach,083h,0ach,083h,0ach,056h,0ach,056h,053h,083h,07dh,083h,02eh,083h,000h	; b3ac  ......V.VS.}....
	defb 0feh,083h,001h,068h,083h,040h,083h,000h,0feh,083h,001h,00dh,041h,000h,000h,081h	; b3bc  ...h.@......A...
	defb 000h,000h,0fdh,002h,0fbh,004h,081h,001h,053h,081h,000h,000h,081h,001h,0ach,081h	; b3cc  ........S.......
	defb 000h,000h,041h,000h,000h,0fah,0fbh,004h,081h,001h,040h,081h,000h,000h,081h,001h	; b3dc  ..A.......@.....
	defb 0ach,081h,000h,000h,041h,000h,000h,0fah,0fch,0fdh,002h,039h,000h,08fh,083h,0beh	; b3ec  ....A......9....
	defb 083h,0beh,083h,0beh,083h,0e2h,083h,001h,01dh,083h,000h,0feh,065h,0e2h,083h,0beh	; b3fc  ............e...
	defb 083h,071h,039h,07fh,083h,08fh,056h,0a0h,083h,0feh,083h,0feh,083h,0feh,083h,001h	; b40c  .q9...V.........
	defb 01dh,083h,040h,083h,0ach,0fch,0fdh,007h,083h,001h,0c5h,083h,07dh,083h,001h,00dh	; b41c  ..@.........}...
	defb 083h,000h,0e2h,0fch,083h,000h,0aah,083h,0a0h,083h,0aah,083h,0beh,0fdh,004h,0fbh	; b42c  ................
	defb 004h,082h,000h,0feh,082h,0e2h,082h,0aah,0fah,0fbh,004h,082h,001h,00dh,082h,000h	; b43c  ................
	defb 0e2h,082h,0aah,0fah,0fch,0feh,0fdh,003h,0fbh,002h,082h,000h,055h,082h,06bh,082h	; b44c  ............U.k.
	defb 07fh,082h,0aah,082h,0d6h,082h,0feh,0fah,0fbh,002h,082h,000h,05fh,082h,07fh,082h	; b45c  ............_...
	defb 097h,082h,0beh,082h,0feh,082h,001h,02eh,0fah,0fch,0fdh,002h,082h,000h,055h,082h	; b46c  ..............U.
	defb 06bh,082h,07fh,082h,0aah,082h,0d6h,082h,0feh,0fch,083h,001h,02eh,083h,000h,0feh	; b47c  k...............
	defb 083h,0beh,083h,001h,040h,083h,000h,0feh,083h,0b4h,083h,0aah,051h,000h,000h,083h	; b48c  ....@.......Q...
	defb 000h,0d6h,083h,0beh,039h,0aah,083h,0d6h,083h,0beh,039h,0aah,083h,0d6h,083h,0beh	; b49c  ....9.....9.....
	defb 083h,0aah,083h,0d6h,083h,0beh,083h,0aah,083h,0beh,083h,0d6h,083h,0e2h,083h,0d6h	; b4ac  ................
	defb 083h,0beh,083h,0d6h,083h,0e2h,083h,0feh,083h,0e2h,083h,0d6h,083h,0beh,083h,0aah	; b4bc  ................
	defb 039h,0a0h,083h,0beh,083h,0aah,039h,0a0h,083h,0beh,083h,0aah,083h,0a0h,083h,0beh	; b4cc  9.....9.........
	defb 083h,0aah,083h,0a0h,083h,0aah,083h,0beh,083h,0cah,083h,0beh,083h,0aah,083h,0a0h	; b4dc  ................
	defb 083h,08fh,083h,07fh,083h,08fh,083h,0a0h,083h,0aah,083h,0beh,039h,0aah,083h,0d6h	; b4ec  ............9...
	defb 083h,0beh,039h,0aah,083h,0d6h,083h,0beh,083h,0aah,083h,0d6h,083h,0beh,083h,0aah	; b4fc  ..9.............
	defb 083h,0beh,083h,0d6h,083h,0e2h,083h,0d6h,083h,0beh,083h,0d6h,083h,0e2h,083h,0feh	; b50c  ................
	defb 083h,0e2h,083h,0d6h,083h,0beh,083h,0aah,039h,0a0h,083h,0beh,083h,0aah,039h,0a0h	; b51c  ........9.....9.
	defb 083h,0beh,083h,0aah,083h,0a0h,083h,0beh,083h,0aah,083h,0a0h,083h,0aah,083h,0beh	; b52c  ................
	defb 083h,0cah,083h,0beh,083h,0a0h,083h,0beh,083h,0aah,083h,0a0h,083h,08fh,083h,0a0h	; b53c  ................
	defb 083h,08fh,083h,07fh,0fdh,002h,039h,000h,071h,083h,08fh,083h,08fh,083h,08fh,083h	; b54c  ......9.q.......
	defb 0beh,083h,0e2h,083h,0d6h,065h,0beh,083h,08fh,083h,05fh,039h,06bh,083h,071h,056h	; b55c  .....e...._9k.qV
	defb 07fh,083h,0d6h,083h,0d6h,083h,0a0h,083h,08fh,083h,07fh,083h,0d6h,0fch,0fdh,003h	; b56c  ................
	defb 083h,000h,071h,083h,07fh,083h,087h,083h,0aah,083h,087h,083h,0a0h,083h,0aah,083h	; b57c  ..q.............
	defb 0beh,0fch,083h,000h,071h,083h,07fh,083h,087h,083h,0aah,083h,087h,083h,07fh,083h	; b58c  ....q...........
	defb 071h,083h,055h,0a1h,000h,000h,0fdh,003h,0fbh,004h,082h,000h,0feh,082h,0e2h,082h	; b59c  q.U.............
	defb 0aah,0fah,0fbh,004h,082h,001h,00dh,082h,000h,0e2h,082h,0aah,0fah,0fch,0fdh,003h	; b5ac  ................
	defb 082h,000h,0feh,082h,0e2h,082h,0aah,0fch,082h,000h,0feh,082h,0e2h,0a2h,0aah,082h	; b5bc  ................
	defb 001h,00dh,082h,000h,0e2h,082h,0aah,082h,0e2h,082h,0aah,082h,087h,082h,0aah,082h	; b5cc  ................
	defb 087h,082h,071h,082h,087h,082h,071h,082h,05fh,0feh,0fdh,004h,083h,003h,08ah,081h	; b5dc  ..q...q._.......
	defb 000h,000h,083h,003h,08ah,058h,002h,05dh,0fch,0fdh,004h,082h,003h,08ah,081h,000h	; b5ec  .....X.]........
	defb 000h,082h,003h,08ah,082h,08ah,082h,08ah,082h,08ah,0fch,0ffh,058h,000h,0e2h,083h	; b5fc  ............X...
	defb 0e2h,083h,0e2h,083h,0e2h,039h,000h,0b4h,058h,0e2h,083h,0e2h,083h,0e2h,083h,0e2h	; b60c  .....9..X.......
	defb 058h,0b4h,065h,0aah,083h,0b4h,0fdh,004h,083h,000h,0feh,083h,001h,02eh,083h,068h	; b61c  X.e............h
	defb 0fch,0fdh,004h,083h,000h,0e2h,083h,001h,02eh,083h,068h,0fch,0ffh,058h,000h,0aah	; b62c  ..........h..X..
	defb 083h,0aah,083h,0aah,083h,0aah,083h,0feh,083h,0e2h,083h,071h,083h,07fh,083h,0feh	; b63c  ...........q....
	defb 083h,0e2h,058h,0aah,083h,0aah,083h,0aah,083h,0aah,083h,0feh,083h,0e2h,083h,071h	; b64c  ..X............q
	defb 065h,07fh,083h,097h,083h,097h,083h,0b4h,083h,0b4h,083h,0b4h,083h,0aah,083h,097h	; b65c  e...............
	defb 083h,07fh,083h,097h,083h,097h,083h,097h,083h,087h,083h,07fh,083h,065h,083h,07fh	; b66c  .............e..
	defb 083h,07fh,083h,07fh,083h,071h,083h,065h,083h,05ah,083h,071h,083h,071h,083h,04ch	; b67c  .....q.e.Z.q.q.L
	defb 083h,05ah,083h,05ah,0ffh,0fdh,002h,083h,005h,04dh,083h,04dh,083h,04dh,056h,04dh	; b68c  .Z.Z.....M.M.MVM
	defb 0fch,0fdh,003h,083h,003h,08ah,083h,003h,08ah,0fch,039h,005h,04dh,0ffh,0fdh,002h	; b69c  ..........9.M...
	defb 083h,001h,00dh,083h,053h,083h,0c5h,056h,001h,00dh,0fch,083h,001h,02eh,083h,07dh	; b6ac  ....S..V.......}
	defb 083h,0fch,083h,02eh,083h,001h,00dh,083h,0feh,039h,001h,00dh,0ffh,056h,000h,087h	; b6bc  .........9...V..
	defb 083h,087h,083h,087h,083h,087h,083h,087h,083h,07fh,083h,071h,083h,087h,083h,07fh	; b6cc  ...........q....
	defb 083h,071h,056h,05fh,083h,06bh,083h,071h,083h,07fh,039h,071h,0ffh,0fdh,002h,083h	; b6dc  .qV_.k.q..9q....
	defb 005h,04dh,083h,003h,0f9h,083h,08ah,083h,002h,0a7h,083h,001h,0fch,083h,0c5h,083h	; b6ec  .M..............
	defb 053h,0fch,083h,002h,0a7h,083h,0a7h,083h,0a7h,02bh,0a7h,083h,005h,04dh,083h,004h	; b6fc  S........+...M..
	defb 075h,083h,035h,0fdh,004h,065h,003h,0f9h,083h,005h,04dh,083h,004h,075h,083h,035h	; b70c  u.5..e....M..u.5
	defb 083h,003h,0f9h,083h,0c0h,0fch,0ffh,04ah,000h,0e2h,081h,000h,000h,083h,000h,0e2h	; b71c  .......J........
	defb 083h,0e2h,083h,0e2h,083h,0feh,083h,0e2h,065h,0d6h,065h,0beh,083h,0e2h,083h,0e2h	; b72c  ........e.e.....
	defb 083h,0e2h,02bh,0e2h,051h,000h,000h,001h,000h,000h,011h,000h,000h,0ffh,04ah,000h	; b73c  ..+.Q.........J.
	defb 0aah,081h,000h,000h,083h,000h,0aah,083h,0aah,083h,0aah,083h,0beh,083h,0aah,065h	; b74c  ...............e
	defb 0a0h,065h,08fh,083h,0aah,083h,0aah,083h,0aah,02bh,0aah,051h,000h,000h,001h,000h	; b75c  .e.......+.Q....
	defb 000h,011h,000h,000h,0ffh,0fdh,002h,0fbh,004h,082h,003h,0f9h,082h,0f9h,0fah,082h	; b76c  ................
	defb 003h,0f9h,082h,057h,081h,000h,000h,065h,004h,075h,082h,075h,082h,075h,082h,035h	; b77c  ...W...e.u.u.u.5
	defb 0fch,084h,003h,0f9h,0ffh,0fdh,002h,083h,001h,094h,081h,000h,000h,083h,001h,053h	; b78c  ...............S
	defb 081h,000h,000h,083h,001h,094h,081h,000h,000h,083h,001h,053h,081h,000h,000h,083h	; b79c  ...........S....
	defb 001h,094h,083h,053h,081h,000h,000h,065h,001h,07dh,083h,0c5h,083h,0c5h,083h,0ach	; b7ac  ...S...e.}......
	defb 0fch,084h,001h,094h,0ffh,0fdh,002h,083h,000h,0feh,081h,000h,000h,083h,000h,0d6h	; b7bc  ................
	defb 081h,000h,000h,083h,000h,0feh,081h,000h,000h,083h,000h,0d6h,081h,000h,000h,083h	; b7cc  ................
	defb 000h,0feh,083h,000h,0d6h,081h,000h,000h,065h,001h,01dh,083h,01dh,083h,01dh,083h	; b7dc  ........e.......
	defb 001h,00dh,0fch,084h,000h,0feh,0ffh,0fdh,002h,083h,003h,0f9h,083h,0f9h,083h,0f9h	; b7ec  ................
	defb 056h,0f9h,0fch,0fdh,002h,083h,002h,03bh,083h,001h,0c5h,083h,0ach,083h,07dh,083h	; b7fc  V......;......}.
	defb 0ach,083h,0c5h,0fch,0fdh,002h,083h,003h,0f9h,083h,0f9h,083h,0f9h,056h,0f9h,0fch	; b80c  .............V..
	defb 0fdh,003h,083h,005h,001h,083h,005h,001h,0fch,0fdh,003h,083h,004h,075h,083h,075h	; b81c  .............u.u
	defb 0fch,083h,003h,0f9h,0ffh,0fdh,002h,083h,000h,0feh,083h,001h,053h,083h,07dh,056h	; b82c  ............S.}V
	defb 094h,0fch,051h,000h,000h,083h,001h,01dh,083h,000h,0feh,048h,0e2h,083h,001h,01dh	; b83c  ..Q........H....
	defb 083h,000h,0feh,083h,0e2h,0fdh,002h,083h,000h,0feh,083h,001h,053h,083h,07dh,056h	; b84c  ............S.}V
	defb 094h,0fch,083h,001h,0fch,083h,0ach,083h,040h,083h,0ach,083h,040h,083h,000h,0feh	; b85c  ........@...@...
	defb 083h,001h,07dh,083h,01dh,083h,000h,0e2h,083h,001h,01dh,083h,000h,0e2h,083h,0beh	; b86c  ..}.............
	defb 083h,0cah,0ffh,083h,000h,0aah,083h,07fh,083h,05fh,056h,065h,083h,0aah,083h,07fh	; b87c  ........._Ve....
	defb 083h,05fh,083h,065h,083h,071h,083h,07fh,083h,071h,083h,06bh,048h,05fh,083h,071h	; b88c  ._.e.q...q.kH_.q
	defb 083h,06bh,048h,05fh,083h,0aah,083h,07fh,083h,05fh,056h,065h,083h,0aah,083h,07fh	; b89c  .kH_....._Ve....
	defb 083h,05fh,083h,065h,083h,071h,083h,07fh,083h,06bh,083h,071h,083h,07fh,083h,06bh	; b8ac  ._.e.q...k.q...k
	defb 083h,071h,083h,07fh,083h,05fh,083h,06bh,083h,071h,083h,05fh,083h,06bh,083h,071h	; b8bc  .q..._.k.q._.k.q
	defb 083h,07fh,0ffh,02bh,002h,0fah,061h,000h,000h,065h,002h,05dh,065h,01bh,065h,001h	; b8cc  ...+..a..e.]e.e.
	defb 0fch,02bh,002h,01bh,065h,001h,0c5h,065h,002h,01bh,065h,0a7h,065h,003h,027h,039h	; b8dc  .+..e..e..e.e.'9
	defb 002h,0fah,065h,0a7h,065h,001h,02eh,065h,001h,00dh,065h,000h,0feh,065h,0e2h,065h	; b8ec  ..e.e..e..e..e.e
	defb 0feh,065h,002h,0a7h,065h,0fah,065h,0a7h,029h,003h,0f9h,0ffh,039h,001h,02eh,065h	; b8fc  .e..e.e.)...9..e
	defb 001h,00dh,065h,000h,0feh,065h,001h,02eh,065h,001h,00dh,065h,000h,0feh,02bh,0aah	; b90c  ..e..e..e..e..+.
	defb 039h,0e2h,083h,0beh,083h,0aah,065h,097h,065h,0beh,065h,0feh,048h,001h,00dh,065h	; b91c  9.....e.e.e.H..e
	defb 000h,0feh,065h,0e2h,065h,001h,053h,083h,000h,07fh,083h,0cah,083h,0aah,083h,0feh	; b92c  ..e.e.S.........
	defb 083h,0cah,083h,001h,053h,083h,000h,0feh,083h,001h,07dh,029h,094h,0ffh,0fdh,002h	; b93c  ....S.....})....
	defb 082h,000h,05fh,081h,000h,000h,082h,000h,097h,081h,000h,000h,082h,000h,07fh,081h	; b94c  .._.............
	defb 000h,000h,082h,000h,097h,081h,000h,000h,0fch,0fdh,002h,082h,000h,055h,081h,000h	; b95c  .............U..
	defb 000h,082h,000h,087h,081h,000h,000h,082h,000h,071h,081h,000h,000h,082h,000h,087h	; b96c  .........q......
	defb 081h,000h,000h,0fch,082h,000h,05fh,081h,000h,000h,082h,000h,097h,081h,000h,000h	; b97c  ......_.........
	defb 082h,000h,07fh,081h,000h,000h,082h,000h,097h,081h,000h,000h,082h,000h,0aah,081h	; b98c  ................
	defb 000h,000h,082h,000h,097h,081h,000h,000h,082h,000h,087h,081h,000h,000h,082h,000h	; b99c  ................
	defb 071h,081h,000h,000h,021h,000h,000h,029h,000h,07fh,0ffh,082h,003h,0f9h,082h,0f9h	; b9ac  q...!..)........
	defb 082h,0f9h,056h,0f9h,082h,0f9h,082h,0f9h,082h,0f9h,083h,000h,0aah,083h,0beh,083h	; b9bc  ..V.............
	defb 0d6h,082h,003h,08ah,082h,08ah,082h,08ah,056h,08ah,082h,004h,035h,081h,035h,081h	; b9cc  ........V...5.5.
	defb 035h,056h,035h,081h,003h,0f9h,081h,0f9h,081h,0f9h,056h,0f9h,081h,0f9h,081h,0f9h	; b9dc  5V5.......V.....
	defb 081h,0f9h,083h,000h,0aah,083h,0beh,083h,0d6h,081h,003h,08ah,081h,08ah,081h,08ah	; b9ec  ................
	defb 056h,08ah,081h,005h,04dh,081h,04dh,081h,04dh,056h,04dh,0fdh,004h,081h,003h,0f9h	; b9fc  V...M.M.MVM.....
	defb 081h,0f9h,081h,0f9h,056h,0f9h,081h,0f9h,081h,0f9h,081h,0f9h,056h,0f9h,081h,005h	; ba0c  ....V.......V...
	defb 001h,081h,005h,001h,081h,005h,001h,056h,005h,001h,081h,004h,075h,081h,075h,081h	; ba1c  .......V....u.u.
	defb 075h,056h,075h,0fch,0fdh,002h,0fbh,002h,065h,003h,057h,081h,057h,081h,057h,081h	; ba2c  uVu.....e.W.W.W.
	defb 057h,081h,057h,0fah,065h,004h,075h,081h,075h,081h,075h,081h,075h,081h,075h,056h	; ba3c  W.W.e.u.u.u.u.uV
	defb 075h,056h,002h,0fah,0fch,0fdh,002h,0fbh,002h,065h,003h,057h,081h,057h,081h,057h	; ba4c  uV.......e.W.W.W
	defb 081h,057h,081h,057h,0fah,065h,004h,075h,081h,075h,081h,075h,081h,075h,081h,075h	; ba5c  .W.W.e.u.u.u.u.u
	defb 081h,075h,081h,003h,08ah,081h,002h,0fah,081h,004h,075h,081h,003h,08ah,081h,002h	; ba6c  .u........u.....
	defb 0fah,0fch,0fdh,002h,0fbh,002h,065h,005h,04dh,081h,04dh,081h,04dh,081h,04dh,081h	; ba7c  ......e.M.M.M.M.
	defb 04dh,0fah,0fbh,006h,086h,001h,00dh,086h,000h,0feh,0fah,0fch,0feh,083h,000h,0d6h	; ba8c  M...............
	defb 083h,0beh,083h,0aah,056h,0d6h,083h,0d6h,083h,0beh,083h,0aah,083h,08fh,083h,0a0h	; ba9c  ....V...........
	defb 083h,0aah,083h,0beh,083h,0d6h,083h,0e2h,083h,001h,00dh,083h,040h,083h,053h,083h	; baac  ............@.S.
	defb 040h,083h,001h,00dh,083h,000h,0e2h,083h,001h,00dh,083h,000h,0e2h,083h,0beh,083h	; babc  @...............
	defb 000h,0d6h,083h,0beh,083h,0aah,056h,0d6h,083h,0d6h,083h,0beh,083h,0aah,083h,08fh	; bacc  ......V.........
	defb 083h,0a0h,083h,0aah,083h,0beh,083h,0d6h,083h,0e2h,083h,001h,00dh,083h,040h,083h	; badc  ..............@.
	defb 053h,083h,040h,083h,001h,00dh,083h,000h,0e2h,056h,0aah,0fdh,002h,065h,000h,0feh	; baec  S.@......V...e..
	defb 083h,0feh,083h,001h,053h,083h,01dh,083h,000h,0feh,083h,0d6h,083h,0beh,083h,0aah	; bafc  ....S...........
	defb 065h,0d6h,083h,001h,01dh,083h,000h,0feh,083h,0e2h,083h,0d6h,083h,001h,040h,083h	; bb0c  e.............@.
	defb 000h,0feh,083h,0d6h,065h,0beh,083h,0d6h,083h,0e2h,083h,0feh,083h,001h,01dh,0fch	; bb1c  ....e...........
	defb 065h,000h,0aah,083h,0aah,083h,0d6h,083h,0beh,083h,0aah,083h,07fh,083h,071h,083h	; bb2c  e.............q.
	defb 06bh,065h,0aah,083h,0d6h,083h,0beh,083h,0aah,083h,0a0h,083h,0d6h,083h,0a0h,083h	; bb3c  ke..............
	defb 07fh,065h,08fh,083h,0beh,083h,0e2h,083h,0feh,083h,001h,01dh,065h,000h,0aah,083h	; bb4c  .e..........e...
	defb 0aah,083h,0d6h,083h,0beh,083h,0aah,083h,07fh,083h,071h,083h,06bh,065h,0aah,083h	; bb5c  ..........q.ke..
	defb 0d6h,083h,0beh,083h,0aah,083h,0a0h,083h,0d6h,083h,0a0h,083h,07fh,065h,08fh,083h	; bb6c  .............e..
	defb 0beh,083h,0e2h,083h,0d6h,083h,0beh,0fdh,002h,065h,000h,0aah,083h,0aah,083h,0d6h	; bb7c  .........e......
	defb 083h,0beh,083h,0b4h,065h,0aah,083h,0aah,083h,08fh,083h,0a0h,083h,0aah,065h,0beh	; bb8c  ....e.........e.
	defb 083h,0beh,083h,0e2h,083h,0d6h,083h,0cah,056h,0beh,056h,08fh,0fch,0fdh,002h,083h	; bb9c  ........V.V.....
	defb 000h,06bh,083h,08fh,083h,0aah,083h,08fh,083h,0a0h,083h,0aah,083h,06bh,083h,071h	; bbac  .k...........k.q
	defb 083h,06bh,083h,055h,083h,05fh,083h,06bh,083h,071h,083h,08fh,083h,0a0h,083h,071h	; bbbc  .k.U._.k.q.....q
	defb 083h,08fh,083h,0a0h,083h,071h,083h,06bh,083h,05fh,083h,071h,083h,06bh,083h,05fh	; bbcc  .....q.k._.q.k._
	defb 0fch,0fdh,002h,083h,000h,055h,083h,071h,083h,07fh,083h,087h,083h,0a0h,083h,0aah	; bbdc  .....U.q........
	defb 083h,087h,083h,0a0h,083h,0aah,083h,0e2h,083h,0d6h,083h,0beh,05ch,0a0h,05ch,0aah	; bbec  ............\.\.
	defb 05ch,0a0h,05ch,0aah,0fch,0feh,0fdh,008h,082h,003h,0c0h,081h,000h,000h,082h,003h	; bbfc  \.\.............
	defb 0f9h,081h,000h,000h,082h,003h,08ah,081h,000h,000h,082h,003h,0f9h,081h,000h,000h	; bc0c  ................
	defb 0fch,0fdh,002h,0fbh,004h,0f9h,004h,083h,003h,0f9h,083h,004h,075h,083h,005h,04dh	; bc1c  ............u..M
	defb 0f8h,083h,003h,0f9h,081h,000h,000h,065h,003h,0c0h,0fah,0fbh,004h,0f9h,004h,083h	; bc2c  .......e........
	defb 002h,0a7h,083h,003h,08ah,083h,004h,035h,0f8h,083h,002h,0a7h,083h,003h,08ah,083h	; bc3c  .......5........
	defb 002h,0a7h,083h,081h,0fah,0fch,0feh,0fdh,002h,001h,000h,000h,083h,000h,0aah,083h	; bc4c  ................
	defb 0f0h,01ah,0feh,061h,000h,000h,0fch,0fdh,002h,0fbh,002h,0f9h,004h,083h,000h,0feh	; bc5c  ...a............
	defb 083h,0e2h,083h,0d6h,0f8h,065h,000h,0b4h,065h,0beh,0fah,0fbh,002h,0f9h,004h,083h	; bc6c  .....e..e.......
	defb 000h,0d6h,083h,0beh,083h,0aah,0f8h,065h,000h,08fh,065h,097h,0fah,0fbh,002h,0a3h	; bc7c  .......e..e.....
	defb 000h,0aah,0a3h,0a0h,0a3h,0aah,0a3h,0beh,02ah,0aah,061h,000h,000h,083h,000h,0beh	; bc8c  ........*.a.....
	defb 083h,0aah,083h,0a0h,083h,08fh,083h,07fh,083h,08fh,083h,0a0h,083h,0aah,083h,0beh	; bc9c  ................
	defb 02ah,0aah,051h,000h,000h,0fah,0fch,0feh,0fdh,002h,021h,000h,000h,082h,004h,075h	; bcac  *.Q.......!....u
	defb 082h,075h,081h,000h,000h,082h,004h,075h,081h,000h,000h,082h,004h,075h,081h,000h	; bcbc  .u.....u.....u..
	defb 000h,082h,004h,075h,0fch,0fdh,002h,082h,003h,0f9h,082h,0f9h,082h,0f9h,082h,0f9h	; bccc  ...u............
	defb 082h,0f9h,051h,000h,000h,083h,002h,0a7h,083h,003h,08ah,083h,08ah,083h,08ah,083h	; bcdc  ..Q.............
	defb 002h,081h,083h,003h,08ah,083h,08ah,083h,08ah,083h,08ah,083h,057h,083h,002h,0cfh	; bcec  ............W...
	defb 083h,003h,057h,081h,000h,000h,083h,003h,0f9h,083h,004h,035h,083h,005h,001h,0fbh	; bcfc  ..W........5....
	defb 004h,083h,005h,04dh,083h,04dh,0fah,0fch,084h,003h,0f9h,051h,000h,000h,084h,003h	; bd0c  ...M.M.....Q....
	defb 0f9h,051h,000h,000h,084h,003h,0f9h,051h,000h,000h,083h,003h,08ah,083h,08ah,083h	; bd1c  .Q.....Q........
	defb 08ah,083h,08ah,084h,003h,0f9h,051h,000h,000h,084h,003h,0f9h,051h,000h,000h,084h	; bd2c  ......Q.....Q...
	defb 003h,0f9h,051h,000h,000h,083h,005h,001h,083h,005h,001h,083h,004h,075h,083h,075h	; bd3c  ..Q..........u.u
	defb 0fdh,003h,084h,003h,0f9h,083h,000h,0feh,083h,0e2h,083h,0d6h,0fch,083h,003h,08ah	; bd4c  ................
	defb 083h,08ah,083h,08ah,083h,08ah,0fdh,003h,084h,003h,0f9h,083h,000h,0feh,083h,0e2h	; bd5c  ................
	defb 083h,0d6h,0fch,083h,005h,001h,083h,005h,001h,083h,004h,075h,083h,075h,0feh,0fdh	; bd6c  ...........u.u..
	defb 002h,0fbh,002h,085h,000h,07fh,085h,0aah,085h,0d6h,085h,0feh,0fah,082h,002h,03bh	; bd7c  ...............;
	defb 082h,03bh,081h,000h,000h,082h,002h,03bh,081h,000h,000h,082h,002h,03bh,081h,000h	; bd8c  .;.....;.....;..
	defb 000h,082h,002h,03bh,0fch,0fdh,002h,082h,000h,0feh,082h,0e2h,082h,0d6h,082h,0beh	; bd9c  ...;............
	defb 082h,0feh,051h,000h,000h,083h,000h,0aah,083h,0a0h,083h,087h,083h,0a0h,083h,0aah	; bdac  ..Q.............
	defb 083h,0beh,083h,0aah,083h,0a0h,085h,0b4h,085h,0aah,085h,0b4h,085h,0aah,081h,000h	; bdbc  ................
	defb 000h,083h,000h,0d6h,083h,0e2h,083h,0feh,083h,001h,00dh,083h,040h,083h,053h,083h	; bdcc  ............@.S.
	defb 07dh,065h,053h,065h,001h,00dh,0fch,0fdh,003h,081h,000h,000h,083h,000h,0feh,083h	; bddc  }eSe............
	defb 0e2h,083h,0d6h,0fch,081h,000h,000h,083h,000h,0e2h,083h,0d6h,083h,0beh,0fdh,003h	; bdec  ................
	defb 081h,000h,000h,083h,000h,0feh,083h,0e2h,083h,0d6h,0fch,083h,000h,0feh,083h,0d6h	; bdfc  ................
	defb 083h,0e2h,083h,0beh,0fdh,003h,081h,000h,000h,083h,000h,0d6h,083h,0beh,083h,0aah	; be0c  ................
	defb 0fch,083h,000h,08fh,083h,0a0h,083h,0aah,083h,0a0h,0fdh,003h,081h,000h,000h,083h	; be1c  ................
	defb 000h,0d6h,083h,0beh,083h,0aah,0fch,083h,000h,0beh,083h,0aah,083h,0a0h,083h,087h	; be2c  ................
	defb 0feh,083h,001h,00dh,083h,001h,00dh,061h,000h,000h,083h,001h,00dh,083h,001h,00dh	; be3c  .......a........
	defb 041h,000h,000h,083h,001h,00dh,083h,001h,00dh,083h,001h,00dh,083h,001h,00dh,083h	; be4c  A...............
	defb 000h,0e2h,083h,0d6h,083h,0beh,049h,0aah,083h,0e2h,083h,0feh,083h,001h,00dh,083h	; be5c  ......I.........
	defb 040h,083h,053h,083h,0c5h,083h,002h,01bh,0fdh,004h,083h,003h,0f9h,065h,057h,083h	; be6c  @.S..........eW.
	defb 0f9h,065h,002h,0fah,083h,003h,0f9h,065h,002h,0cfh,083h,003h,0f9h,065h,002h,0fah	; be7c  .e.....e.....e..
	defb 065h,003h,057h,0fch,0fdh,004h,083h,005h,04dh,065h,004h,075h,083h,005h,04dh,065h	; be8c  e.W.....Me.u..Me
	defb 003h,0f9h,083h,005h,04dh,065h,003h,0c0h,083h,005h,04dh,065h,003h,0f9h,065h,004h	; be9c  ....Me....Me..e.
	defb 075h,0fch,0fdh,004h,083h,003h,0f9h,065h,057h,083h,0f9h,065h,002h,0fah,083h,003h	; beac  u......eW..e....
	defb 0f9h,065h,002h,0cfh,083h,003h,0f9h,065h,002h,0fah,065h,003h,057h,0fch,0feh,083h	; bebc  .e.....e..e.W...
	defb 000h,0aah,083h,0aah,061h,000h,000h,083h,000h,0aah,083h,0aah,061h,000h,000h,0a1h	; becc  ....a.......a...
	defb 000h,000h,0a2h,001h,053h,0a2h,001h,00dh,0a2h,000h,0e2h,083h,000h,0aah,083h,0aah	; bedc  ....S...........
	defb 083h,0aah,083h,0aah,083h,001h,053h,083h,053h,083h,053h,0fdh,002h,0a3h,000h,055h	; beec  ......S.S.S....U
	defb 0a3h,050h,0a3h,039h,0a3h,040h,0fch,083h,000h,0beh,083h,0aah,083h,0a0h,083h,087h	; befc  .P.9.@..........
	defb 083h,071h,083h,05fh,083h,055h,01ch,000h,0feh,061h,000h,000h,083h,001h,01dh,065h	; bf0c  .q._.U...a.....e
	defb 001h,00dh,083h,000h,0feh,081h,000h,000h,065h,000h,0d6h,083h,0feh,083h,0b4h,083h	; bf1c  ........e.......
	defb 0aah,083h,0b4h,083h,0beh,083h,0d6h,081h,000h,000h,065h,000h,0feh,083h,001h,01dh	; bf2c  ..........e.....
	defb 00dh,053h,021h,000h,000h,081h,000h,000h,0fdh,004h,083h,000h,0f0h,083h,0e2h,083h	; bf3c  .S!.............
	defb 0aah,0fch,083h,000h,0beh,083h,0e2h,011h,000h,000h,061h,000h,000h,083h,000h,0f0h	; bf4c  ..........a.....
	defb 083h,0e2h,083h,0aah,083h,0b4h,083h,0aah,083h,08fh,083h,07fh,065h,078h,083h,07fh	; bf5c  ............ex..
	defb 083h,08fh,065h,07fh,083h,0aah,065h,08fh,083h,0beh,065h,0aah,083h,0f0h,083h,0feh	; bf6c  ..e...e...e.....
	defb 083h,001h,01dh,083h,053h,083h,07dh,083h,0c5h,083h,0fch,083h,002h,03bh,083h,0a7h	; bf7c  ....S.}......;..
	defb 01ch,001h,0fch,061h,000h,000h,083h,001h,0fch,065h,0ach,083h,0fch,065h,07dh,083h	; bf8c  ...a.....e...e}.
	defb 0fch,065h,068h,083h,0fch,065h,07dh,065h,0ach,083h,000h,0feh,065h,0d6h,083h,0feh	; bf9c  .eh..e}e....e...
	defb 065h,0beh,083h,0feh,065h,0b4h,083h,0feh,065h,0beh,065h,0d6h,083h,07fh,065h,06bh	; bfac  e...e...e.e...ek
	defb 083h,07fh,065h,05fh,083h,07fh,065h,05ah,083h,07fh,065h,05fh,065h,06bh,0feh,0fbh	; bfbc  ..e_..eZ..e_ek..
	defb 000h,0fbh,000h,0fbh,0fbh,000h,0fbh,000h,0ffh,000h,0fbh,000h,0ffh,000h,0fbh,000h	; bfcc  ................
	defb 0ffh,000h,0fbh,000h,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0fbh	; bfdc  ................
	defb 000h,0ffh,000h,0fbh,0fbh,000h,0fbh,000h,0fbh,000h,0fbh,000h,0ffh,000h,0f3h,000h	; bfec  ................
	defb 0fbh,000h,0fbh,000h	; bffc
