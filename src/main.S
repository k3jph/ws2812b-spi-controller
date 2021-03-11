;  Copyright (c) 2021 James P. Howard, II <jh@jameshoward.us>
;
;  Permission is hereby granted, free of charge, to any person
;  obtaining a copy of this software and associated documentation files
;  (the "Software"), to deal in the Software without restriction,
;  including without limitation the rights to use, copy, modify, merge,
;  publish, distribute, sublicense, and/or sell copies of the Software,
;  and to permit persons to whom the Software is furnished to do so,
;  subject to the following conditions:
;
;  The above copyright notice and this permission notice shall be
;  included in all copies or substantial portions of the Software.
;
;  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
;  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
;  ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
;  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
;  SOFTWARE.

;  WS2818b SPI controller using the ATtiny85.  This is loosely based on
;  the ATtiny10 Neopixel controller by Wayne Holder and available at
;  https://sites.google.com/site/wayneholder/besting-ben-heck
;
;  The controller requires three pins on the ATtiny85.  The pin
;  assignments can be changed below, but the following shows the
;  default layout.  PB5 (Pin 1) shold probably be connected to Vcc
;  through a resistor in the 10k- to 30k-ohm range.
;
;               +====+
;    Vcc -> PB5 |*   | Vcc
;     NC <- PB3 |    | PB2 <- CLK
;   LEDs -- PB4 |    | PB1 -- NC
;           GND |    | PB0 <- MOSI
;               +====+

#define __SFR_OFFSET 0

#include <avr/io.h>

;  Give the ports we intend to use with functional names
#define MOSI    DDB0
#define SCLK    DDB2
#define DOUT    DDB3

.org        0x0000          ; Lay out the interrupt table
    rjmp    RESET           ; Let's get this party started

.org        0x0010          ; Real work starts here

RESET:                      ; Reset the Attiny85
    clr     r17             ; Set Clock Prescaler to 1:1 (CLKPR = 0)
    out     CLKPR, r17

    cbi     DDRB, MOSI      ; Set MOSI as input
    cbi     DDRB, SCLK      ; Set SCLK as input
    sbi     DDRB, DOUT      ; Set DOUT as output
    cbi     PORTB, DOUT     ; Set DOUT LOW to clear the port

; Assembly code auto-generated
; by utility from Bret Mulvey
; Delay 80 000 000 cycles
; 10s at 8 MHz

    ldi  r24, 2
    ldi  r25, 150
    ldi  r26, 216
    ldi  r27, 9
LX: dec  r27
    brne LX
    dec  r26
    brne LX
    dec  r25
    brne LX
    dec  r24
    brne LX
    rjmp 0


    ldi     r17, 0x7F       ; Set OSCCAL to 20MHz
    out     OSCCAL, r17

    ldi     r24, 2          ; Let's let the clock settle out
    ldi     r25, 75         ; Delay 1000 cycles
LR: dec     r25             ; 50us at 20MHz
    brne    LR
    dec     r24
    brne    LR
    rjmp    +2

WAIT_SCLK_HI:
    sbis    PINB, SCLK      ; Wait for CLK to go HIGH (rising edge)
    rjmp    WAIT_SCLK_HI
    cli                     ; Disable interrupts for RT performance
    sbis    PINB, MOSI      ; Skip if MOSI "1" bit
    rjmp    SEND_0          ; Send 0 to DOUT

SEND_1:                     ; Else send 1 to DOUT
    sbi     PORTB, DOUT     ; Set DOUT HIGH to start sequence
    ldi     r24, 5          ; Delay 16 cycles
L1: dec     r24             ; 800 ns at 20 MHz
    brne    L1
    nop
    cbi     PORTB, DOUT     ; Set DOUT LOW to end sequence
    lpm                     ; Delay 9 cycles
    lpm                     ; 450 ns at 20 MHz
    lpm
    rjmp    CLOSEOUT

SEND_0:
    sbi     PORTB, DOUT     ; Set DOUT HIGH to start sequence
    lpm                     ; Delay 8 cycles
    lpm                     ; 400 ns at 20 MHz
    rjmp    +2
    cbi     PORTB, DOUT     ; Set DOUT LOW to end sequence
    ldi     r24, 5          ; Delay 17 cycles
L0: dec     r24             ; 850 ns at 20 MHz
    brne    L0
    rjmp    +2

CLOSEOUT:                   ; Cleanup and go back to the start
    sei                     ; Re-enable interrupts
WAIT_SCLK_LO: 
    sbic    PINB, SCLK      ; Wait for CLK to go LOW (falling edge)
    rjmp    WAIT_SCLK_LO
    rjmp    WAIT_SCLK_HI
