# WS2818B SPI Controller for ATtiny85

This code for a WS2818B SPI controller using the
[ATtiny85](https://www.microchip.com/wwwproducts/en/ATtiny85).  It
is loosely based on the [ATtiny10 Neopixel controller by Wayne
Holder](https://sites.google.com/site/wayneholder/besting-ben-heck).

The controller requires three pins on the ATtiny85.  The pin
assignments can be changed in the defines, but the following shows
the default layout.  PB5 (Pin 1) shold probably be connected to Vcc
through a resistor in the 10k- to 30k-ohm range.

## Connection Diagram

                +====+
     Vcc -> PB5 |*   | Vcc
      NC <- PB3 |    | PB2 <- CLK
    LEDs -- PB4 |    | PB1 -- NC
            GND |    | PB0 <- MOSI
                +====+