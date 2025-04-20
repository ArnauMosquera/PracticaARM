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
        push {r1-r2, lr}		@; Salvar registres modificats i adreça retorn

            @; codi "FAKE": CAL SUBSTITUIR-LO!!! per la traducció a assemblador de la rutina en C

        ldr r1, =E9M22_sNAN		@; Signaling NaN per indicar rutina pendent d'implementació
        str r1, [r3, #MM_TMINC]		@; mmres->tmin_C = NaN
        str r1, [r3, #MM_TMAXC]		@; mmres->tmax_C = NaN
        str r1, [r3, #MM_TMINF]		@; mmres->tmin_F = NaN
        str r1, [r3, #MM_TMAXF]		@; mmres->tmax_F = NaN
        mov r2, #-1				@; Valor id fictici per indicar pendent implementació
        strh r2, [r3, #MM_IDMIN]	@; mmres->id_min = -1
        strh r2, [r3, #MM_IDMAX]	@; mmres->id_max = -1

        mov r0, r1				@; return (NaN)	→ per indicar pendent implementació

        pop {r1-r2, pc}			@; restaurar registres modificats i retornar



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
        push {r1-r2, lr}		@; Salvar registres modificats i adreça retorn

            @; codi "FAKE": CAL SUBSTITUIR-LO!!! per la traducció a assemblador de la rutina en C

        ldr r1, =E9M22_sNAN		@; Signaling NaN per indicar rutina pendent d'implementació
        str r1, [r3, #MM_TMINC]		@; mmres->tmin_C = NaN
        str r1, [r3, #MM_TMAXC]		@; mmres->tmax_C = NaN
        str r1, [r3, #MM_TMINF]		@; mmres->tmin_F = NaN
        str r1, [r3, #MM_TMAXF]		@; mmres->tmax_F = NaN
        mov r2, #-1				@; Valor id fictici per indicar pendent implementació
        strh r2, [r3, #MM_IDMIN]	@; mmres->id_min = -1
        strh r2, [r3, #MM_IDMAX]	@; mmres->id_max = -1

        mov r0, r1				@; return (NaN)	→ per indicar pendent implementació

        pop {r1-r2, pc}			@; restaurar registres modificats i retornar



.end

