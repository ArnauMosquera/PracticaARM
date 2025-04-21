@;-----------------------------------------------------------------------
@;  Description: a program to check the temperature-scale conversion
@;				functions implemented in "CelsiusFahrenheit.c".
@;	IMPORTANT NOTE: there is a much confident testing set implemented in
@;				"tests/test_CelsiusFahrenheit.c"; the aim of "demo.s" is
@;				to show how would it be a usual main() code invoking the
@;				mentioned functions.
@;-----------------------------------------------------------------------
@;	Author: Santiago Romaní, Pere Millán (DEIM, URV)
@;	Date:   March/2022-2023, February/2024, March/2025 
@;-----------------------------------------------------------------------
@;	Programmer 1: xxx.xxx@estudiants.urv.cat
@;	Programmer 2: yyy.yyy@estudiants.urv.cat
@;-----------------------------------------------------------------------*/

.include "E9M22.i"			@; operacions en coma flotant E9M22

.include "avgmaxmintemp.i"	@; offsets per accedir a structs 'maxmin_t'


.text
        .align 2
        .arm

.global avgmaxmin_city
avgmaxmin_city:
    push {r4-r10, lr}

    mov r4, #1              @ i = 1
    mov r9, #0              @ idmax = 0
    mov r10, #0             @ idmin = 0

    mov r5, #48             @ 12 columnes × 4 bytes = 48
    mul r11, r2, r5         @ r11 = offset fila ciutat
    add r11, r0, r11        @ r11 = &ttemp[id_city][0]

    ldr r5, [r11]           @ avg = ttemp[id_city][0]
    mov r6, r5              @ max = avg
    mov r7, r5              @ min = avg

loop_city:
    cmp r4, #12
    beq end_loop_city

    mov r8, r4
    lsl r8, r8, #2          @ offset columna i * 4
    add r8, r11, r8         @ &ttemp[id_city][i]
    ldr r8, [r8]            @ tvar = ttemp[id_city][i]

    mov r0, r5              @ avg
    mov r1, r8              @ tvar
    bl E9M22_add
    mov r5, r0              @ avg += tvar

    mov r0, r8
    mov r1, r6
    bl E9M22_is_gt
    cmp r0, #0
    beq check_min_city
    mov r6, r8              @ max = tvar
    mov r9, r4              @ idmax = i

check_min_city:
    mov r0, r8
    mov r1, r7
    bl E9M22_is_lt
    cmp r0, #0
    beq next_city
    mov r7, r8              @ min = tvar
    mov r10, r4             @ idmin = i

next_city:
    add r4, r4, #1
    b loop_city

end_loop_city:
    ldr r1, =0x40A00000     @ 12.0 en E9M22
    mov r0, r5
    bl E9M22_div
    mov r5, r0              @ avg /= 12

    str r7, [r3, #MM_TMINC]
    str r6, [r3, #MM_TMAXC]

    mov r0, r7
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMINF]

    mov r0, r6
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMAXF]

    strh r10, [r3, #MM_IDMIN]
    strh r9, [r3, #MM_IDMAX]

    mov r0, r5
    pop {r4-r10, pc}


.global avgmaxmin_month
avgmaxmin_month:
    push {r4-r10, lr}

    mov r4, #1              @ i = 1
    mov r9, #0              @ idmax = 0
    mov r10, #0             @ idmin = 0

    lsl r11, r2, #2         @ offset columna = id_month * 4
    add r6, r0, r11         @ &ttemp[0][id_month]
    ldr r5, [r6]            @ avg = ttemp[0][id_month]
    mov r6, r5              @ max = avg
    mov r7, r5              @ min = avg

loop_month:
    cmp r4, r1              @ i < nrows
    bge end_loop_month

    mov r8, r4
    mov r12, #48
    mul r8, r8, r12         @ offset fila i * 48
    add r8, r0, r8
    add r8, r8, r11         @ &ttemp[i][id_month]
    ldr r8, [r8]            @ tvar = ttemp[i][id_month]

    mov r0, r5
    mov r1, r8
    bl E9M22_add
    mov r5, r0

    mov r0, r8
    mov r1, r6
    bl E9M22_is_gt
    cmp r0, #0
    beq check_min_month
    mov r6, r8
    mov r9, r4

check_min_month:
    mov r0, r8
    mov r1, r7
    bl E9M22_is_lt
    cmp r0, #0
    beq next_month
    mov r7, r8
    mov r10, r4

next_month:
    add r4, r4, #1
    b loop_month

end_loop_month:
    mov r0, r1              @ nrows
    bl int_to_E9M22
    mov r1, r0              @ divisor
    mov r0, r5              @ avg
    bl E9M22_div
    mov r5, r0              @ avg /= nrows

    str r7, [r3, #MM_TMINC]
    str r6, [r3, #MM_TMAXC]

    mov r0, r7
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMINF]

    mov r0, r6
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMAXF]

    strh r10, [r3, #MM_IDMIN]
    strh r9, [r3, #MM_IDMAX]

    mov r0, r5
    pop {r4-r10, pc}