;     SPI (Mode 0) to NeoPixel Adapter using ATtiny10
;
;                +====+
;     SCK -> PB0 |*   | PB3 (RESET)
;            GND |    | Vcc
;    MOSI -> PB1 |    | PB2 -> Output to NeoPixels
;                +====+

CLK = 0        ; PB0
DIN = 1        ; PB1
OUT = 2        ; PB2

PINB = 0x00
DDRB = 0x01
PORTB = 0x02
CCP  = 0x3C
CLKPSR = 0x36

.section .text

eor   r17,  r17      ; Set r17 = 0
ldi   r20, 0xD8      ; Unprotect CLKPSR reg (CCP = 0xD8)
out   CCP, r20  
out   CLKPSR, r17    ; Set Clock Prescaler to 1:1 (CLKPSR = 0)
sbi   DDRB, OUT      ; Set PB2 as Output
loop1:
sbis  PINB, CLK      ; Wait for CLK to go HIGH (rising edge)
rjmp  loop1
sbi   PORTB, OUT     ; Set Output HIGH to begin pulse to Neopixel
nop                  ; Delay for "0" bit
sbis  PINB, DIN      ; Skip if DIN "1" bit
cbi   PORTB, OUT     ; Set Output LOW to end "0" bit pulse to Neopixel
nop                  ; Delay for "1" bit
nop                  ; Delay for "1" bit
nop                  ; Delay for "1" bit
cbi   PORTB, OUT     ; Set Output LOW to end "1" bit pulse to Neopixel
loop2:
sbic  PINB, CLK      ; Wait for CLK to go LOW (falling edge)
rjmp  loop2
rjmp  loop1 