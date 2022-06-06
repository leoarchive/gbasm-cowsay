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

    ; ld hl, $9850; print sentence on top screen
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

    ld hl, $9860
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

SECTION "Font", ROM0

FontTiles:
INCBIN "font.chr"
FontTilesEnd:

SECTION "Cowsay strings", ROM0

SayStr:
    db TEXT, 0

CowStr:
	db "\\  ", "                            ",
    db "  \\ ^__^", "                        ",
	db "    (oo)\\_______", "                ",
	db "    (__)\\       )\\/\\", "            ",
	db "        ||----w |", "               ",
	db "        ||     ||", 0