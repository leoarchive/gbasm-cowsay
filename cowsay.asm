; Game Boy cowsay 
;


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

	xor a; ld a, 0
    ld [rLCDC], a

	ld hl, $9000
    ld de, FontTiles
    ld bc, FontTilesEnd - FontTiles

CopyFont:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jr nz, CopyFont

    ld de, SayStr
    ld hl, $9801
    ld bc, textOverLine

    inc de
    inc de
    inc de
printOverLine:
    ld a, [bc]
    ld [hli], a

    ld [rLCDC], a

    ld a, [de]
    inc de
    and a
    jr nz, printOverLine

    ld de, SayStr
    ld hl, $9841
    ld bc, textUnderLine

    inc de
    inc de
    inc de
printUnderLine:
    ld a, [bc]
    ld [hli], a

    ld [rLCDC], a

    ld a, [de]
    inc de
    and a
    jr nz, printUnderLine

    ld hl, $9820
    ld de, SayStr

CopyString:
    ld a, [de]
    ld [hli], a
    inc de
    and a
    jr nz, CopyString

    ld a, %11100100
    ld [rBGP], a

    xor a; ld a, 0
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a
    ld a, %10000001
    ld [rLCDC], a
    jp Cow

SECTION "Cow", rom0
Cow:
	xor a; ld a, 0
    ld [rLCDC], a

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

    xor a; ld a, 0
    ld [rSCY], a
    ld [rSCX], a
    ld [rNR52], a
    ld a, %10000001
    ld [rLCDC], a

Done:
	jp Done

SECTION "Font", rom0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Cowsay strings", rom0

spaceChar:
    db " ", 0

textOverLine:
    db "_", 0

textUnderLine:
    db "-", 0

SayStr:
    db "<", TEXT, ">", 0

CowStr:
	db "\\  ", "                            ",
    db "  \\ ^__^", "                        ",
	db "    (oo)\\_______", "                ",
	db "    (__)\\       )\\/\\", "            ",
	db "        ||----w |", "               ",
	db "        ||     ||", 0