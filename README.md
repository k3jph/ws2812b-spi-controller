# WS2818B SPI Controller for ATtiny85

This code for a WS2818B SPI controller using the
[ATtiny85](https://www.microchip.com/wwwproducts/en/ATtiny85).  It
is loosely based on the [ATtiny10 Neopixel controller by Wayne
Holder](https://sites.google.com/site/wayneholder/besting-ben-heck).

The controller requires three pins on the ATtiny85.  The pin
assignments can be changed in the defines, but the following shows
the default layout.  PB5 (Pin 1) should probably be connected to +5V
through a resistor in the 10k- to 30k-ohm range.

In this configuration, the device assumes it is the only peripheral
on the SPI bus.  Accordingly, there is no provision for chip select.
This may be changed in future revisions.

## Expected Connection Diagram

                +====+
     +5V -> PB5 |*   | +5V
      NC -- PB3 |    | PB2 <- SCLK
    DOUT <- PB4 |    | PB1 -- NC
            GND |    | PB0 <- COPI
                +====+

## Direct Dependencies

* [GCC for AVR](https://www.microchip.com/en-us/tools-resources/develop/microchip-studio/gcc-compilers) for compiling
* [CMake](https://cmake.org/) is used to manage the build environment.

## Contribution guidelines

* Use [GitFlow](http://nvie.com/posts/a-successful-git-branching-model/)

## For more information

* James P. Howard, II <<james.howard@jhu.edu>>
