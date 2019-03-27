#-------------------------------------------------------------------------------
# Example Makefile to assembly, link and debug ARM source code
# programador1: bernat.bosca@estudiants.urv.cat
# programador2: albert.canellas@estudiants.urv.cat
# Date: May 2016
# Licence: Public Domain
#-------------------------------------------------------------------------------

#-------------------------------------------------------------------------------
# options for code generation
#-------------------------------------------------------------------------------
ASFLAGS	:= -march=armv5te -mlittle-endian -g
LDFLAGS := -z max-page-size=0x8000


#-------------------------------------------------------------------------------
# make commands
#-------------------------------------------------------------------------------

practicaFC.elf : startup.o barcos_j.o barcos_p.o 
	arm-none-eabi-ld $(LDFLAGS) startup.o barcos_j.o barcos_p.o libBarcos.a -o practicaFC.elf

barcos_j.o : barcos_j.s
	arm-none-eabi-as $(ASFLAGS) barcos_j.s -o barcos_j.o

barcos_p.o : barcos_p.s
	arm-none-eabi-as $(ASFLAGS) barcos_p.s -o barcos_p.o

startup.o : startup.s
	arm-none-eabi-as $(ASFLAGS) startup.s -o startup.o


#-------------------------------------------------------------------------------
# clean commands
#-------------------------------------------------------------------------------
clean : 
	@rm -fv *.o
	@rm -fv *.elf


#-------------------------------------------------------------------------------
# debug commands
#-------------------------------------------------------------------------------
debug : PracticaFC.elf
	arm-eabi-insight practicaFC.elf &

