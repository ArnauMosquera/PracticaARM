@;-----------------------------------------------------------------------
@;  E9M22_s.s: operacions amb números en format Coma Flotant E9M22.
@;-----------------------------------------------------------------------
@;	santiago.romani@urv.cat
@;	pere.millan@urv.cat
@;	(Març 2021-2023, Febrer 2024, Març 2025)
@;-----------------------------------------------------------------------
@;	Programador/a 1: albert.marti@estudiants.urv.cat
@;	Programador/a 2: arnau.mosquera@estudiants.urv.cat
@;-----------------------------------------------------------------------

.include "E9M22.i"

FLOAT_sNAN	=	0x7FA00000	@; Un possible NaN (signaling) en binary32 

.text
        .align 2
        .arm


@;******************************************************
@;* Rutines de CONVERSIÓ de valors E9M22 <-> float/int *
@;******************************************************

@; E9M22_to_float_s(): converteix un valor E9M22 a float.
@;	Entrada:
@;		input 	-> R0: valor E9M22 a convertir
@;	Sortida:
@;		R0 		-> valor E9M22 convertit a float.
	.global E9M22_to_float_s
E9M22_to_float_s:
		push {lr}

		ldr r0, =FLOAT_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; float_to_E9M22_s(): converteix un valor float a E9M22.
@;	Entrada:
@;		input 	-> R0: valor float a convertir
@;	Sortida:
@;		R0 		-> valor float convertit a E9M22.
	.global float_to_E9M22_s
float_to_E9M22_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; E9M22_to_int_s(): converteix un valor E9M22 a enter (arrodonit).
@;	Entrada:
@;		input 	-> R0: valor E9M22 a convertir
@;	Sortida:
@;		R0 		-> valor E9M22 convertit a enter.
	.global E9M22_to_int_s
E9M22_to_int_s:
		push {lr}

		mov r0, #-1		@; to-do: -1 per indicar rutina pendent
		
		pop {pc}



@; int_to_E9M22_s(): converteix un valor enter a E9M22.
@;	Entrada:
@;		input 	-> R0: valor enter a convertir
@;	Sortida:
@;		R0 		-> valor float convertit a E9M22.
	.global int_to_E9M22_s
int_to_E9M22_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@;*************************************************
@;* Operacions ARITMÈTIQUES en Coma Flotant E9M22 *
@;*************************************************

@; E9M22_add_s(): calcula i retorna la suma dels 2 operands,
@;                (num1 + num2) codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> valor E9M22 de (num1 + num2).
	.global E9M22_add_s
E9M22_add_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; E9M22_sub_s(): calcula i retorna la diferència dels 2 operands,
@;                (num1 - num2) codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> valor E9M22 de (num1 - num2).
	.global E9M22_sub_s
E9M22_sub_s:
    push {lr}

    push {r0}             @ guardar num1
    mov r0, r1            @ r0 = num2
    bl E9M22_neg          @ r0 = -num2
    mov r1, r0            @ r1 = -num2
    pop {r0}              @ r0 = num1
    bl E9M22_add          @ r0 = num1 + (-num2)

    pop {pc}



@; E9M22_mul_s(): calcula i retorna el producte dels 2 operands,
@;                (num1 × num2) codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> valor E9M22 de (num1 × num2).
	.global E9M22_mul_s
E9M22_mul_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; E9M22_div_s(): calcula i retorna la divisió dels 2 operands,
@;                (num1 ÷ num2) codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> valor E9M22 de (num1 ÷ num2).
	.global E9M22_div_s
E9M22_div_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; E9M22_neg_s(): canvia el signe (nega) de l'operand num
@;                codificat en coma flotant E9M22.
@;	Entrada:
@;		num 	-> R0: valor a negar
@;	Sortida:
@;		R0 		-> valor E9M22 negat de num.
	.global E9M22_neg_s
E9M22_neg_s:
    push {lr}
    
    ldr r1, =0x80000000     @ màscara del bit de signe (bit 31)
    eor r0, r0, r1          @ XOR per canviar el signe
    
    pop {pc}



@; E9M22_abs_s(): calcula i retorna el valor absolut
@;                de l'operand num codificat en coma flotant E9M22.
@;	Entrada:
@;		num 	-> R0: valor a calcular el valor absolut
@;	Sortida:
@;		R0 		-> valor absolut E9M22 de num.
	.global E9M22_abs_s
E9M22_abs_s:
    push {lr}

    ldr r1, =0x7FFFFFFF   @ màscara: tots els bits a 1 excepte el de signe
    and r0, r0, r1        @ netegem el bit de signe

    pop {pc}



@;*************************************************************
@;* Operacions de COMPARACIÓ de números en Coma Flotant E9M22 *
@;*************************************************************

@; E9M22_are_eq_s(): indica si num1 == num2, considerant valors 
@;                	 codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 == num2.
	.global E9M22_are_eq_s
E9M22_are_eq_s:
    push {lr}

    cmp r0, r1
    moveq r0, #1    @ iguals → 1
    movne r0, #0    @ diferents → 0

    pop {pc}



@; E9M22_are_ne_s(): indica si num1 ≠ num2, considerant valors 
@;                	 codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 ≠ num2.
	.global E9M22_are_ne_s
E9M22_are_ne_s:
		push {lr}

		mov r0, #0		@; to-do: sempre fals per indicar rutina pendent
		
		pop {pc}



@; E9M22_are_unordered_s(): indica si num1 i num2 no són "ordenables", 
@;         				    perquè num1 o num2 són NaN (en coma flotant E9M22).
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 i num2 no es poden ordenar.
	.global E9M22_are_unordered_s
E9M22_are_unordered_s:
		push {lr}

		mov r0, #0		@; to-do: sempre fals per indicar rutina pendent
		
		pop {pc}



@; E9M22_is_gt_s(): indica si num1 > num2, considerant valors 
@;                	codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 > num2.
	.global E9M22_is_gt_s
E9M22_is_gt_s:
    push {lr}

    cmp r0, r1
    movgt r0, #1
    movle r0, #0

    pop {pc}



@; E9M22_is_ge_s(): indica si num1 ≥ num2, considerant valors 
@;                	codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 ≥ num2.
	.global E9M22_is_ge_s
E9M22_is_ge_s:
		push {lr}

		mov r0, #0		@; to-do: sempre fals per indicar rutina pendent
		
		pop {pc}



@; E9M22_is_lt_s(): indica si num1 < num2, considerant valors 
@;                	codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 < num2.
	.global E9M22_is_lt_s
E9M22_is_lt_s:
    push {lr}

    cmp r0, r1
    movlt r0, #1
    movge r0, #0

    pop {pc}




@; E9M22_is_le_s(): indica si num1 ≤ num2, considerant valors 
@;                	codificats en coma flotant E9M22.
@;	Entrada:
@;		num1 	-> R0: primer operand
@;		num2 	-> R1: segon operand
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 ≤ num2.
	.global E9M22_is_le_s
E9M22_is_le_s:
		push {lr}

		mov r0, #0		@; to-do: sempre fals per indicar rutina pendent
		
		pop {pc}




@;**********************************************************
@;* Funcions auxiliars: NORMALITZACIÓ i ARRODONIMENT E9M22 *
@;**********************************************************


@; E9M22_normalize_and_round_s(): normalitza 
@;                	i arrodoneix al més proper.
@;	Entrada:
@;		signe 	 -> R0: signe del valor a normalitzar
@;		exponent -> R1: exponent del valor a normalitzar
@;		mantissa -> R2: mantissa del valor a normalitzar
@;	Sortida:
@;		R0 		-> retorna un valor no-zero si num1 ≤ num2.
	.global E9M22_normalize_and_round_s
E9M22_normalize_and_round_s:
		push {lr}

		ldr r0, =E9M22_sNAN		@; to-do: NaN per indicar rutina pendent
		
		pop {pc}



@; E9M22_round_s(): Arrodoniment al més proper. 
@;                	Si es troba al mig, al més proper parell.
@;	Entrada:
@;		mantissa  -> R0: mantissa del valor a arrodonir
@;		nbits_shr -> R1: quantitat de bits a desplaçar a la dreta
@;	Sortida:
@;		R0 		 -> Retorna la mantissa arrodonida (+1) 
@;					o l'original (trunc) sense desplaçar.
	.global E9M22_round_s
E9M22_round_s:
		push {lr}

		mov r0, #-1		@; to-do: -1 per indicar rutina pendent
		
		pop {pc}



@;****************************************************************
@;* Funcions AUXILIARS per treballar amb els bits de codificació *
@;****************************************************************


@; count_leading_zeros_s(): compta quants bits a 0 hi ha 
@;                			des del bit de més pes (esquerra).
@;	Entrada:
@;		num  -> R0: número de 32 bits a analitzar.
@;	Sortida:
@;		R0 		 -> número de bits a zero (0-32) des del MSB.
	.global count_leading_zeros_s
count_leading_zeros_s:
		push {lr}

		mov r0, #123		@; to-do: 123 per indicar rutina pendent
		
		pop {pc}



@; count_trailing_zeros_s(): compta quants bits a 0 hi ha 
@;                 			 des del bit de menys pes (dreta).
@;	Entrada:
@;		num  -> R0: número de 32 bits a analitzar.
@;	Sortida:
@;		R0 		 -> número de bits a zero (0-32) des del LSB.
	.global count_trailing_zeros_s
count_trailing_zeros_s:
		push {lr}

		mov r0, #123		@; to-do: 123 per indicar rutina pendent
		
		pop {pc}






.end

