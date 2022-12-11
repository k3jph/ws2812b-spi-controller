##########################################################################
# "THE ANY BEVERAGE-WARE LICENSE" (Revision 42 - based on beer-ware
# license):
# <dev@layer128.net> wrote this file. As long as you retain this notice
# you can do whatever you want with this stuff. If we meet some day, and
# you think this stuff is worth it, you can buy me a be(ve)er(age) in
# return. (I don't like beer much.)
#
# Matthias Kleemann
##########################################################################

SET(CMAKE_ASM_LINK_LIBRARY_FLAG "-nostartfiles -nostdlib -nodefaultlibs")
SET(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} ${CMAKE_ASM_LINK_LIBRARY_FLAG}")

add_avr_executable(ws2818b-spi-controller-firmware main.S)
