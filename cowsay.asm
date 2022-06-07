; Game Boy Cowsay 1.0
; June 6, 2022
; Leonardo Z. Nunes

INCLUDE "hardware.inc"

SECTION "Header", rom0[$100]
	DEF TEXT EQUS "\"Hello!\""

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
	; Shut down audio circuitry
	ld a, 0
	ld [rNR52], a
    
WaitVBlank:
	ld a, [rLY]
	cp 144
	jp c, WaitVBlank

   ; Turn the LCD off
	ld a, 0
	ld [rLCDC], a

	ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles

    ld de, SayStr
    ld hl, $9801
    ld bc, OverChar

    inc de
    inc de
    inc de

printOverLine:
    ld a, [bc]
    ld [hli], a
    ld a, [de]
    inc de
    and a
    jr nz, printOverLine

    ld de, SayStr
    ld hl, $9841
    ld bc, UnderChar

    inc de
    inc de
    inc de

printUnderLine:
    ld a, [bc]
    ld [hli], a
    ld a, [de]
    inc de
    and a
    jr nz, printUnderLine

    ld hl, $9820
    ld de, SayStr

CopySayString:
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, CopySayString

    jp Cow

SECTION "Cow", rom0
Cow:
	ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles

CowCopyFont:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, CowCopyFont

    ld hl, $9863
    ld de, CowStr

CowCopyString:
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, CowCopyString

   ; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

    ; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

Done:
	jp Done

SECTION "Font", rom0

FontTiles:
    INCBIN "font.chr"
FontTilesEnd:

SECTION "Cowsay strings", rom0

OverChar:
    db "_", 0

UnderChar:
    db "-", 0

SayStr:
    db "<", TEXT, ">", 0

CowStr:
	db "\\                              ",
    db "  \\ ^__^                        ",
	db "    (oo)\\_______                ",
	db "    (__)\\       )\\/\\            ",
	db "        ||----w |               ",
	db "        ||     ||", 0