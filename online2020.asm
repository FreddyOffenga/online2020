; Outline Online 2k20
; F#READY may 2020

; Yes, 128 bytes! :-)

SDMCTL		= $022f
HPOSP0      	= $d000
SIZEP0      	= $d008
GRAFP0   	= $d00d
WSYNC		= $d40a
VCOUNT		= $d40b

		org $80

sinewave	= $0600		; to $06ff

main	
		ldx #0
		stx SDMCTL
		ldy #$7f
		sty SIZEP0
make_sine
value_lo
		lda #0
  		clc
delta_lo
  		adc #0
  		sta value_lo+1
value_hi
  		lda #0
delta_hi
  		adc #0

  		sta value_hi+1 
 		sta sinewave+$80,y
  		eor #$7f
 		sta sinewave+$00,y
 
  		lda delta_lo+1
  		adc #4
  		sta delta_lo+1
  		bcc nothi
   		inc delta_hi+1
nothi
  		inx
  		dey
 		bpl make_sine

wait_top
		lda VCOUNT
		bne wait_top
		tay
next_char
		lda font_offsets,y
		sta font_lo+1

font_lo
		lda $e100

		sta WSYNC
		sta GRAFP0

		lda VCOUNT
		adc 20
		sta WSYNC
		sta $d011,y	;COLPM0

		tax
		lda sinewave,x

		adc #48
		sta HPOSP0
		inc font_lo+1
		lda font_lo+1
		and #7
		bne font_lo

		iny
		cpy #16
		bne next_char
			
		beq wait_top

font_offsets
		dta $f6,$f6
		dta $78,$a8,$a0,$60
		dta $48,$70,$28,$f6
		dta $78,$70,$60,$48
		dta $70,$28

		run main