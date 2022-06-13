; Game Boy Cowsay 1.0
; June 6, 2022
; Leonardo Z. Nunes

INCLUDE "hardware.inc"

SECTION "Header", rom0[$100]
	DEF TEXT EQUS "\"Hello!\""

	jp EntryPoint

	ds $150 - @, 0 ; Make room for the header

EntryPoint:
    ld d, 1 ; 0 for ASCII 1 for GRAPHICAL

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

    dec d
    jp z, GraphicalCow

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

    jp ASCIICow

SECTION "ASCII Cow", rom0
ASCIICow:
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

    jp Done

SECTION "Graphical Cow", rom0
GraphicalCow:
    ; Copy the tile data
    ld de, CowTiles
    ld hl, $9000
    ld bc, CowTilesEnd - CowTiles

CopyTiles:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTiles

    ; Copy the tilemap
    ld de, CowTilemap
    ld hl, $9800
    ld bc, CowTilemapEnd - CowTilemap
CopyTilemap:
    ld a, [de]
    ld [hli], a
    inc de
    dec bc
    ld a, b
    or a, c
    jp nz, CopyTilemap


Done:
    ; Turn the LCD on
	ld a, LCDCF_ON | LCDCF_BGON
	ld [rLCDC], a

    ; During the first (blank) frame, initialize display registers
	ld a, %11100100
	ld [rBGP], a

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

SECTION "Cow Tile data", rom0

CowTiles:
    db $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
    db $00,$00, $00,$00, $0f,$0f, $0f,$0f, $30,$30, $30,$30, $0f,$0f, $0f,$0f
    db $00,$00, $00,$00, $3f,$3f, $3f,$3f, $c0,$f0, $c0,$f0, $00,$3c, $00,$3c
    db $33,$3f, $33,$3f, $33,$33, $33,$33, $ff,$00, $ff,$00, $ff,$cc, $ff,$cc
    db $ff,$00, $ff,$00, $ff,$ff, $ff,$ff, $0c,$0f, $0c,$0f, $0c,$0f, $0c,$0f
    db $03,$03, $03,$03, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00
    db $03,$03, $03,$03, $03,$03, $03,$03, $0f,$0c, $0f,$0c, $0f,$0c, $0f,$0c
    db $3f,$3f,$3f,$3f,$30,$3f,$30,$3f,$30,$3f,$30,$3f,$30,$3f,$30,$3f;
    db $00,$00, $00,$00, $3f,$3f, $3f,$3f, $c3,$ff, $c3,$ff, $3f,$3f, $3f,$3f
    db $ff,$ff, $ff,$ff, $00,$f0, $00,$f0, $00,$f0, $00,$f0, $00,$00, $00,$00
    db $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $00,$00, $ff,$ff, $ff,$ff
    db $c0,$c0, $c0,$c0, $00,$00, $00,$00, $fc,$fc, $fc,$fc, $cc,$cc, $cc,$cc
    db $0f,$0f,$0f,$0f,$0f,$0f,$0f,$0f,$00,$00,$00,$00,$00,$00,$00,$00
    db $cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf,$00,$00,$00,$00,$00,$00,$00,$00
    db $cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$c0,$c0,$c0,$c0,$ff,$f0,$ff,$f0,$cc,$cc,$cc,$cc
    db $cf,$cf,$cf,$cf,$cf,$cf,$cf,$cf,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$0f,$00,$0f,$00,$0f,$00,$0f,$fc,$3f,$fc,$3f,$fc,$0f,$fc,$0f
    db $cf,$cf,$cf,$cf,$c3,$c3,$c3,$c3,$c3,$c3,$c3,$c3,$c0,$c0,$c0,$c0
    db $c0,$c0,$c0,$c0,$c0,$c0,$c0,$c0,$00,$00,$00,$00,$00,$00,$00,$00
    db $00,$00,$00,$00,$c0,$c0,$c0,$c0,$f0,$f0,$f0,$f0,$fc,$fc,$fc,$fc
    db $ff,$ff,$ff,$ff,$03,$03,$03,$03,$00,$00,$00,$00,$00,$00,$00,$00
CowTilesEnd:

SECTION "Cow Tilemap", rom0

CowTilemap:
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $01, $02, $08, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $06, $03, $07, $09, $15, $14, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $05, $04, $0b, $0f, $11, $12, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $0c, $0d, $0e, $10, $13, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
    db $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00,  0,0,0,0,0,0,0,0,0,0,0,0
CowTilemapEnd: