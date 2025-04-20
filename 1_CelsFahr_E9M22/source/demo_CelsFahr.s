@-----------------------------------------------------------------------
@;  Description: a program to check the temperature-scale conversion
@;				functions implemented in "CelsiusFahrenheit_c/_s".
@;	IMPORTANT NOTE: there is a much confident testing set 
@;				implemented in "tests/test_CelsiusFahrenheit.c"; 
@;				the aim of "demo_CelsFahr.s" is to show how would it be 
@;				a usual main() code invoking the mentioned functions.
@-----------------------------------------------------------------------
@;	Author: Santiago Romaní, Pere Millán (DEIM, URV)
@;	Date:   March/2022, March/2023, February/2024, March/2025 
@-----------------------------------------------------------------------
@;	Programmer 1: 39961195-y@estudiants.urv.cat
@;	Programmer 2: yyy.yyy@estudiants.urv.cat
@-----------------------------------------------------------------------

.data
        .align 2
    temp1C:	.word 0x41066B85		@ temp1C =  35.21 °C
    temp2F:	.word 0xC0DF0000		@ temp2F = -23.75 °F

.bss
        .align 2
    temp1F:	.space 4				@ expected:  95.3780 °F → 0x415F60C4
    temp2C:	.space 4				@ expected: -30.9722 °C → 0xC0FBE38E

.text
        .align 2
        .arm
        .global main
main:
        push {lr}
        
        @ temp1F = Celsius2Fahrenheit(temp1C);
        ldr r0, =temp1C
        ldr r0, [r0]                   @ r0 = valor de temp1C
        bl Celsius2Fahrenheit         @ r0 = resultat
        ldr r1, =temp1F
        str r0, [r1]                   @ guardem resultat a temp1F

        @ temp2C = Fahrenheit2Celsius(temp2F);
        ldr r0, =temp2F
        ldr r0, [r0]                   @ r0 = valor de temp2F
        bl Fahrenheit2Celsius         @ r0 = resultat
        ldr r1, =temp2C
        str r0, [r1]                   @ guardem resultat a temp2C

        @ TESTING POINT
        mov r0, #0                    @ return(0)
        pop {pc}

.end
