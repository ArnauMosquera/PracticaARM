#-------------------------------------------------------------------------------
# Example Makefile to build a library and to test the functions of each module
# Authors: Santiago Romaní, Pere Millán
# Date: April 2021, March 2022-2024, March 2025
#-------------------------------------------------------------------------------
#	Programador/a 1: xxx.xxx@estudiants.urv.cat
#	Programador/a 2: yyy.yyy@estudiants.urv.cat
#-------------------------------------------------------------------------------

ARCH	:= -march=armv5te -mlittle-endian
INCL    := -I./include
ASFLAGS := $(ARCH) $(INCL) -g
CCFLAGS := -Wall -gdwarf-3 -O0 $(ARCH) $(INCL)
CFLAGS += -I/path/a/arm-none-eabi-newlib/include
LDFLAGS := -z max-page-size=0x8000

# Crear build si no existeix
$(shell mkdir -p build)

#-------------------------------------------------------------------------------
# Target principal
#-------------------------------------------------------------------------------
tota_2a_part_practica_FC : test_geotemp_c.elf test_geotemp_s.elf geotemp_c.elf geotemp_s.elf

#-------------------------------------------------------------------------------
# Compilació fitxers objecte
#-------------------------------------------------------------------------------
build/avgmaxmintemp_c.o : source/avgmaxmintemp_c.c include/avgmaxmintemp.h
	arm-none-eabi-gcc $(CCFLAGS) -c $< -o $@

build/avgmaxmintemp_s.o : source/avgmaxmintemp_s.s include/avgmaxmintemp.i
	arm-none-eabi-as $(ASFLAGS) -o $@ $<

build/data.o : source/data.c include/data.h
	arm-none-eabi-gcc $(CCFLAGS) -c $< -o $@

build/geotemp.o : source/geotemp.c include/E9M22.h include/CelsiusFahrenheit.h include/avgmaxmintemp.h include/geotemp.h
	arm-none-eabi-gcc $(CCFLAGS) -c $< -o $@

build/CelsiusFahrenheit_c.o : source/CelsiusFahrenheit_c.c include/CelsiusFahrenheit.h
	arm-none-eabi-gcc $(CCFLAGS) -c $< -o $@

#-------------------------------------------------------------------------------
# Enllaç executables
#-------------------------------------------------------------------------------
geotemp_c.elf : build/geotemp.o build/data.o build/avgmaxmintemp_c.o build/CelsiusFahrenheit_c.o
	arm-none-eabi-ld $(LDFLAGS) $^ p_lib/startup.o p_lib/libE9M22.a p_lib/libfoncompus.a -o $@

geotemp_s.elf : build/geotemp.o build/data.o build/avgmaxmintemp_s.o build/CelsiusFahrenheit_c.o
	arm-none-eabi-ld $(LDFLAGS) $^ p_lib/startup.o p_lib/libE9M22.a p_lib/libfoncompus.a -o $@

#-------------------------------------------------------------------------------
# Tests
#-------------------------------------------------------------------------------
build/test_geotemp.o : tests/test_geotemp.c include/E9M22.h include/avgmaxmintemp.h
	arm-none-eabi-gcc $(CCFLAGS) -c $< -o $@

test_geotemp_c.elf : build/test_geotemp.o build/avgmaxmintemp_c.o build/CelsiusFahrenheit_c.o
	arm-none-eabi-ld $(LDFLAGS) $^ p_lib/startup.o p_lib/libE9M22.a p_lib/libfoncompus.a -o $@

test_geotemp_s.elf : build/test_geotemp.o build/avgmaxmintemp_s.o build/CelsiusFahrenheit_c.o
	arm-none-eabi-ld $(LDFLAGS) $^ p_lib/startup.o p_lib/libE9M22.a p_lib/libfoncompus.a -o $@

#-------------------------------------------------------------------------------
# Neteja
#-------------------------------------------------------------------------------
clean :
	@rm -fv build/*
	@rm -fv *.elf

#-------------------------------------------------------------------------------
# Execució
#-------------------------------------------------------------------------------
run : geotemp_c.elf geotemp_s.elf
	arm-eabi-insight geotemp_c.elf &
	#arm-eabi-insight geotemp_s.elf &

#-------------------------------------------------------------------------------
# Debug
#-------------------------------------------------------------------------------
debug : test_geotemp_c.elf test_geotemp_s.elf
	arm-eabi-insight test_geotemp_c.elf &
	#arm-eabi-insight test_geotemp_s.elf &