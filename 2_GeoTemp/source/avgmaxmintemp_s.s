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


@; avgmaxmin_city(): calcula la temperatura mitjana, màxima i mínima 
@;				d'una ciutat d'una taula de temperatures, 
@;				amb una fila per ciutat i una columna per mes, 
@;				expressades en graus Celsius en format E9M22.
@;	Entrada:
@;		ttemp[][12]	→	R0: taula de temperatures, amb 12 columnes i nrows files
@;		nrows		→	R1: número de files de la taula
@;		id_city		→	R2: índex de la fila (ciutat) a processar
@;		*mmres		→	R3: adreça de l'estructura maxmin_t que retornarà els
@;						resultats de temperatures màximes i mínimes
@;	Sortida:
@;		R0			→	temperatura mitjana, expressada en graus Celsius, en format E9M22.		
        .global avgmaxmin_city
avgmaxmin_city:
    push {r4-r10, lr}

    mov r4, #1              @ i = 1
    mov r9, #0              @ idmax = 0
    mov r10, #0             @ idmin = 0

    mov r5, r2              @ r5 = id_city
    mov r6, #0              @ offset = 0
    mov r7, #0              @ columna = 0

    @ accedir a ttemp[id_city][0] → base = R0 + id_city * 48 (12×4)
    mov r8, #48
    mul r9, r5, r8            @; Usar r9 para la multiplicación
    add r8, r0, r9            @; Agregar el resultado a la base
    ldr r5, [r8]              @; r5 = avg
    mov r6, r5                @; max = avg
    mov r7, r5                @; min = avg

loop_city:
    cmp r4, #12
    beq end_loop_city

    @ calcular ttemp[id_city][i] = base + i×4
    mov r8, r4
    lsl r8, r8, #2
    add r8, r8, r0
    add r8, r8, r5
    ldr r8, [r8]              @; tvar = ttemp[id_city][i]

    mov r0, r5                @; avg
    mov r1, r8                @; tvar
    bl E9M22_add
    mov r5, r0                @; avg = avg + tvar

    mov r0, r8                @; tvar
    mov r1, r6                @; max
    bl E9M22_is_gt
    cmp r0, #0
    beq check_min_city
    mov r6, r8                @; max = tvar
    mov r9, r4                @; idmax = i

check_min_city:
    mov r0, r8                @; tvar
    mov r1, r7                @; min
    bl E9M22_is_lt
    cmp r0, #0
    beq next_city
    mov r7, r8                @; min = tvar
    mov r10, r4               @; idmin = i

next_city:
    add r4, r4, #1
    b loop_city

end_loop_city:
    ldr r1, =0x40A00000       @; 12.0 en E9M22
    mov r0, r5                @; avg
    bl E9M22_div
    mov r5, r0                @; avg = avg / 12

    @ mmres->tmin_C = min
    str r7, [r3, #MM_TMINC]
    @ mmres->tmax_C = max
    str r6, [r3, #MM_TMAXC]

    @ mmres->tmin_F = Celsius2Fahrenheit(min)
    mov r0, r7
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMINF]

    @ mmres->tmax_F = Celsius2Fahrenheit(max)
    mov r0, r6
    bl Celsius2Fahrenheit
    str r0, [r3, #MM_TMAXF]

    @ mmres->id_min = idmin
    strh r10, [r3, #MM_IDMIN]
    @ mmres->id_max = idmax
    strh r9, [r3, #MM_IDMAX]

    mov r0, r5                @; return avg
    pop {r4-r10, pc}
    
@; avgmaxmin_month(): calcula la temperatura mitjana, màxima i mínima 
@;				d'un mes d'una taula de temperatures, 
@;				amb una fila per ciutat i una columna per mes, 
@;				expressades en graus Celsius en format E9M22.
@;	Entrada:
@;		ttemp[][12]	→	R0: taula de temperatures, amb 12 columnes i nrows files
@;		nrows		→	R1: número de files de la taula
@;		id_month	→	R2: índex de la columna (mes) a processar
@;		*mmres		→	R3: adreça de l'estructura maxmin_t que retornarà els
@;						resultats de temperatures màximes i mínimes
@;	Sortida:
@;		R0			→	temperatura mitjana, expressada en graus Celsius, en format E9M22.		
.global avgmaxmin_month
avgmaxmin_month:
    push {r4-r10, lr}

    mov r4, #1              @ i = 1
    mov r9, #0              @ idmax = 0
    mov r10, #0             @ idmin = 0

    mov r5, #48             @ files de 12×4 = 48 bytes
    mov r6, r0              @ base = ttemp
    lsl r7, r2, #2          @ offset = id_month × 4
    add r6, r6, r7
    ldr r5, [r6]            @ avg = ttemp[0][id_month]
    mov r6, r5              @ max = avg
    mov r7, r5              @ min = avg

loop_month:
    cmp r4, r1              @ i < nrows
    bge end_loop_month

    mov r8, r4
    mov r9, #48          @ Cargar el valor 48 en r9
    mul r8, r8, r9       @ Multiplicar r8 por 48 y almacenar el resultado en r8
    add r8, r0, r8
    add r8, r8, r7          @ offset columna
    ldr r8, [r8]            @ tvar = ttemp[i][id_month]

    mov r0, r5              @ avg
    mov r1, r8              @ tvar
    bl E9M22_add
    mov r5, r0              @ avg += tvar

    mov r0, r8              @ tvar
    mov r1, r6              @ max
    bl E9M22_is_gt
    cmp r0, #0
    beq check_min_month
    mov r6, r8              @ max = tvar
    mov r9, r4              @ idmax = i

check_min_month:
    mov r0, r8              @ tvar
    mov r1, r7              @ min
    bl E9M22_is_lt
    cmp r0, #0
    beq next_month
    mov r7, r8              @ min = tvar
    mov r10, r4             @ idmin = i

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
