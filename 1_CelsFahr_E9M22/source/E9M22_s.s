@;-----------------------------------------------------------------------
@;  E9M22_s.s: operacions amb números en format Coma Flotant E9M22.
@;-----------------------------------------------------------------------
@;	santiago.romani@urv.cat
@;	pere.millan@urv.cat
@;	(Març 2021-2023, Febrer 2024, Març 2025)
@;-----------------------------------------------------------------------
@;	Programador/a 1: xxx.xxx@estudiants.urv.cat
@;	Programador/a 2: yyy.yyy@estudiants.urv.cat
@;-----------------------------------------------------------------------
.include "E9M22.i"

FLOAT_sNAN	=	0x7FA00000	@; Un possible NaN (signaling) en binary32 

.text
        .align 2
        .arm
.text
.align 2
.arm


.global E9M22_normalize_and_round_s
E9M22_normalize_and_round_s:
    @ Aquesta és una versió dummy que només retorna el mantissa amb signe i exponent com a resultat.
    @ Hauràs d'implementar la versió real més endavant.

    push {lr}                       @ Guardem el registre de retorn (lr) per tornar després

    @ Suposant que:
    @ - r0 conté la mantissa
    @ - r1 conté l'exponent
    @ - r2 conté el signe del nombre (1 per negatiu, 0 per positiu)
    @ Aquesta funció hauria de normalitzar i arrodonir la mantissa, ajustant l'exponent i el signe.

    @ Però, de moment, només retornarem el registre r0 tal com està,
    @ sense realitzar cap operació de normalització o arrodoniment real.

    pop {pc}                         @ Recuperem el registre de retorn (pc) i tornem a la funció cridant

.global count_trailing_zeros_s
count_trailing_zeros_s:
    push {lr}              @ Guardem l'adreça de retorn a la pila
    mov r1, #0             @ Inicialitzem el comptador de zeros a r1

.loop_ctz:
    tst r0, #1             @ Comprovem si el bit menys significatiu és 1
    bne .end_ctz           @ Si ho és, sortim del bucle
    lsr r0, r0, #1         @ Desplacem r0 un bit cap a la dreta (r0 = r0 >> 1)
    add r1, r1, #1         @ Incrementem el comptador de zeros finals
    b .loop_ctz            @ Tornem a comprovar el següent bit

.end_ctz:
    mov r0, r1             @ El resultat (comptador) el posem a r0
    pop {pc}               @ Recuperem l'adreça de retorn i retornem

.global count_leading_zeros_s
count_leading_zeros_s:
    push {lr}               @ Guarda l'adreça de retorn a la pila
    mov r1, #0              @ r1 comptador de zeros inicialitzat a 0
    mov r2, #1 << 31        @ r2 comença amb un 1 a la posició més significativa (bit 31)

.loop_clz:
    tst r0, r2              @ Comprova si el bit corresponent de r0 és 1
    bne .end_clz            @ Si és 1, sortim del bucle
    lsr r2, r2, #1          @ Desplacem el bit de r2 cap a la dreta (bit següent)
    add r1, r1, #1          @ Incrementem el comptador de zeros
    cmp r1, #32             @ Si hem comptat 32 bits, sortim (tots són zeros)
    bge .end_clz
    b .loop_clz             @ Tornem a comprovar el següent bit

.end_clz:
    mov r0, r1              @ Retornem el nombre de zeros al principi (leading zeros)
    pop {pc}                @ Recuperem l'adreça de retorn

.global E9M22_add_s
E9M22_add_s:
    push {r4-r11, lr}         @ Guardem els registres que utilitzarem

    mov r4, r0                @ r4 = num1
    mov r5, r1                @ r5 = num2

    @ Obtenim els signes de num1 i num2
    ldr r6, =E9M22_MASK_SIGN
    and r7, r4, r6            @ signe1 → r7
    and r8, r5, r6            @ signe2 → r8

    @ Comprovem si num1 és NaN
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, r9
    bne check_nan2           @ Si no és NaN, mirem num2
    ldr r9, =E9M22_MASK_FRAC
    and r10, r4, r9
    cmp r10, #0
    bne return_nan1          @ num1 és NaN → retorna num1

check_nan2:
    @ Comprovem si num2 és NaN
    ldr r9, =E9M22_MASK_EXP
    and r10, r5, r9
    cmp r10, r9
    bne check_inf
    ldr r9, =E9M22_MASK_FRAC
    and r10, r5, r9
    cmp r10, #0
    bne return_nan2          @ num2 és NaN → retorna num2
    pop {r4-r11, pc}

check_inf:
    @ Comprovem si num1 és infinit
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, r9
    bne check_inf2

    @ num1 és infinit
    and r10, r5, r9
    cmp r10, r9
    bne return_inf1          @ num2 no és infinit → retorna num1

    @ Tots dos infinits → comparar signes
    cmp r7, r8
    beq return_inf1          @ mateix signe → retorna num1
    ldr r0, =E9M22_qNAN
    ldr r0, [r0]             @ signes oposats → retorna NaN
    b end_add

check_inf2:
    @ Comprovem si num2 és infinit
    and r10, r5, r9
    cmp r10, r9
    bne check_zero

    @ num2 és infinit → retorna num2
    mov r0, r5
    b end_add

return_inf1:
    mov r0, r4
    b end_add

@ ----------- Tractament de zeros -----------

check_zero:
    @ Comprovem si num1 == 0
    ldr r9, =E9M22_MASK_EXP
    ldr r0, =E9M22_MASK_FRAC
    orr r9, r9, r0
    and r10, r4, r9
    cmp r10, #0
    bne check_zero2          @ num1 ≠ 0

    @ num1 és 0 → retorna num2
    mov r0, r5
    b end_add

check_zero2:
    and r10, r5, r9
    cmp r10, #0
    bne normal_add           @ num2 ≠ 0

    @ num2 és 0 → retorna num1
    mov r0, r4
    b end_add

@ ----------- Tractament de nombres normals/denormals -----------

normal_add:
    @ num1 → normal o denormal?
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, #0
    beq num1_denorm

    @ num1 normal → obtenir mantissa i exponent
    ldr r9, =E9M22_MASK_FRAC
    and r6, r4, r9
    orr r6, r6, #E9M22_1_IMPLICIT_NORMAL
    mov r9, r4
    lsr r9, r9, #E9M22_m
    sub r9, r9, #E9M22_bias
    mov r10, r9               @ exp1 → r10
    b get_num2

num1_denorm:
    @ num1 denormal
    ldr r9, =E9M22_MASK_FRAC
    and r6, r4, r9
    ldr r10, =E9M22_Emin      @ exp1 = Emin

get_num2:
    @ num2 → normal o denormal?
    ldr r9, =E9M22_MASK_EXP
    and r11, r5, r9
    cmp r11, #0
    beq num2_denorm

    @ num2 normal
    ldr r9, =E9M22_MASK_FRAC
    and r11, r5, r9
    orr r11, r11, #E9M22_1_IMPLICIT_NORMAL
    mov r9, r5
    lsr r9, r9, #E9M22_m
    sub r9, r9, #E9M22_bias
    mov r12, r9               @ exp2 → r12
    b align_exponents

num2_denorm:
    @ num2 denormal
    ldr r9, =E9M22_MASK_FRAC
    and r11, r5, r9
    ldr r12, =E9M22_Emin      @ exp2 = Emin

@ ----------- Alineació de mantisses -----------

align_exponents:
    cmp r10, r12
    beq do_addition           @ exponents iguals → passar a suma

    @ Si exp1 < exp2 → desplaçar mant2
    movlt r0, r12
    sublt r0, r0, r10         @ dif_exp = exp2 - exp1
    cmp r0, #E9M22_e
    blt shift_mant2_left
    mov r1, #E9M22_e - 1
    lsl r11, r11, r1
    sub r12, r12, r1
    sub r0, r12, r10
    lsr r6, r6, r0
    add r10, r10, r0
    b do_addition

shift_mant2_left:
    lsl r11, r11, r0
    sub r12, r12, r0
    b do_addition

@ Cas contrari: exp1 > exp2 → (tractament simètric, intercanviant mantisses)

@ ----------- Suma de mantisses -----------

do_addition:
    cmp r7, r8
    beq same_sign

    @ Si signes diferents → negam una mantissa
    tst r7, r7
    rsbne r6, r6, #0
    rsbeq r11, r11, #0

same_sign:
    add r0, r6, r11           @ mantissa suma

    @ Si resultat negatiu → convertir a valor absolut
    cmp r0, #0
    bge mantissa_ok
    rsb r0, r0, #0

mantissa_ok:
    @ Calcular signe del resultat
    cmp r7, r8
    beq signe1_ok

    @ comparar magnituds
    mov r1, r4
    mov r2, r5
    bic r1, r1, #E9M22_MASK_SIGN
    bic r2, r2, #E9M22_MASK_SIGN
    cmp r1, r2
    movge r9, r7
    movlt r9, r8
    b call_normalize

signe1_ok:
    mov r9, r7

@ ----------- Normalització i arrodoniment -----------

call_normalize:
    mov r1, r10
    mov r2, r9
    bl E9M22_normalize_and_round_s

return_nan1:
    mov r0, r4
    b end_add

return_nan2:
    mov r0, r5
    b end_add

end_add:
    pop {r4-r11, pc}         @ Retornem de la funció


@; E9M22_sub_s(): calcula num1 - num2 (coma flotant E9M22)


.global E9M22_sub_s
E9M22_sub_s:
    push {lr}                        @ Guardem l'enllaç de retorn

    @ Neguem num2: canviem el bit de signe
    ldr r2, =E9M22_MASK_SIGN         @ Carreguem la màscara del bit de signe
    eor r1, r1, r2                   @ num2 = num2 XOR SIGN → canviem signe

    @ Cridem a la funció de suma amb num1 i -num2
    bl E9M22_add_s

    pop {pc}                         @ Retornem
@; E9M22_neg_s(): canvia el signe (nega) de num
.global E9M22_neg_s
E9M22_neg_s:
    push {lr}

    ldr r1, =E9M22_MASK_SIGN
    eor r0, r0, r1      @; Toggle del bit de signe

    pop {pc}
@; E9M22_abs_s(): valor absolut de num


.global E9M22_abs_s
E9M22_abs_s:
    push {lr}

    ldr r1, =E9M22_MASK_SIGN
    bic r0, r0, r1      @; Esborrem el bit de signe

    pop {pc}
@; E9M22_are_eq_s(): retorna 1 si num1 == num2, incloent +0 == -0


.global E9M22_are_eq_s
E9M22_are_eq_s:
    push {r2, r3, lr}

    mov r2, r0      @; r2 = num1
    mov r3, r1      @; r3 = num2

    @; Comprovar si algun operand és NaN
    ldr r1, =E9M22_MASK_EXP
    and r0, r2, r1
    cmp r0, r1
    bne .check_nan2_mul
    ldr r1, =E9M22_MASK_FRAC
    and r0, r2, r1
    cmp r0, #0
    bne .return_false

.check_nan2_mul:
    ldr r1, =E9M22_MASK_EXP
    and r0, r3, r1
    cmp r0, r1
    bne .check_equal
    ldr r1, =E9M22_MASK_FRAC
    and r0, r3, r1
    cmp r0, #0
    bne .return_false

.check_equal:
    cmp r2, r3
    moveq r0, #1
    bne .check_zero_eq
    b .end_eq

.check_zero_eq:
    orr r0, r2, r3
    ldr r1, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r0, r0, r1
    cmp r0, #0
    moveq r0, #1
    movne r0, #0
    b .end_eq

.return_false:
    mov r0, #0

.end_eq:
    pop {r2, r3, pc}
@; E9M22_are_unordered_s(): retorna 1 si num1 o num2 són NaN


.global E9M22_are_unordered_s
E9M22_are_unordered_s:
    push {r2, r3, lr}

    mov r2, r0      @; num1
    mov r3, r1      @; num2

    ldr r1, =E9M22_MASK_EXP
    and r0, r2, r1
    cmp r0, r1
    bne .check_nan2_addu
    ldr r1, =E9M22_MASK_FRAC
    and r0, r2, r1
    cmp r0, #0
    bne .return_true

.check_nan2_addu:
    ldr r1, =E9M22_MASK_EXP
    and r0, r3, r1
    cmp r0, r1
    bne .check_nan2uf
    ldr r1, =E9M22_MASK_FRAC
    and r0, r3, r1
    cmp r0, #0
    bne .return_true

.check_nan2uf:
    mov r0, #0
    b .end_unordered

.return_true:
    mov r0, #1

.end_unordered:
    pop {r2, r3, pc}
@; E9M22_mul_s(): calcula num1 × num2 (coma flotant E9M22)


.global E9M22_mul_s
E9M22_mul_s:
    push {r4-r11, lr}              @ Guardem els registres de treball i el retorn

    mov r4, r0                     @ r4 = num1
    mov r5, r1                     @ r5 = num2

    @ Calcular el signe del producte: signe1 XOR signe2
    ldr r6, =E9M22_MASK_SIGN
    and r7, r4, r6                 @ signe1 → r7
    and r8, r5, r6                 @ signe2 → r8
    eor r9, r7, r8                 @ signe_prod → r9

    @ -------------------------
    @ Tractament de NaNs

    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, r6
    bne .check_nan2
    ldr r6, =E9M22_MASK_FRAC
    and r0, r4, r6
    cmp r0, #0
    bne .return_nan1              @ num1 és NaN

.check_nan2:
    ldr r6, =E9M22_MASK_EXP
    and r0, r5, r6
    cmp r0, r6
    bne .check_inf_zero
    ldr r6, =E9M22_MASK_FRAC
    and r0, r5, r6
    cmp r0, #0
    bne .return_nan2              @ num2 és NaN

.return_nan1:
    mov r0, r4
    b .end_mul

.return_nan2:
    mov r0, r5
    b .end_mul

    @ -------------------------
    @ Tractament ∞ × 0 → NaN, ∞ × x → ∞

.check_inf_zero:
    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, r6
    bne .check_inf_num2          @ num1 no és ∞

    @ num1 és ∞
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r1, r5, r6
    cmp r1, #0
    moveq r0, r9
    ldreq r1, =E9M22_qNAN
    orreq r0, r0, r1             @ ∞ × 0 → NaN
    movne r0, r9
    ldrne r1, =E9M22_INF_POS
    orrne r0, r0, r1             @ ∞ × x → ∞
    b .end_mul

.check_inf_num2:
    ldr r6, =E9M22_MASK_EXP
    and r0, r5, r6
    cmp r0, r6
    bne .check_zeros             @ num2 no és ∞

    @ num2 és ∞
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r1, r4, r6
    cmp r1, #0
    moveq r0, r9
    ldreq r1, =E9M22_qNAN
    orreq r0, r0, r1             @ 0 × ∞ → NaN
    movne r0, r9
    ldrne r1, =E9M22_INF_POS
    orrne r0, r0, r1             @ x × ∞ → ∞
    b .end_mul

    @ -------------------------
    @ Tractament de zeros normals → retorna ±0

.check_zeros:
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r0, r4, r6
    cmp r0, #0
    moveq r0, r9                 @ signe del resultat
    beq .end_mul

    and r0, r5, r6
    cmp r0, #0
    moveq r0, r9
    beq .end_mul

    @ -------------------------
    @ Extracció d’exponents i mantisses

.extract_mant_exp:
    @ num1
    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, #0
    beq .denorm1

    @ num1 normalitzat
    lsr r6, r0, #E9M22_m
    sub r6, r6, #E9M22_bias         @ exp1
    ldr r0, =E9M22_MASK_FRAC
    and r1, r4, r0
    orr r1, r1, #E9M22_1_IMPLICIT_NORMAL @ mant1
    b .done_num1

.denorm1:
    ldr r6, =E9M22_Emin
    ldr r0, =E9M22_MASK_FRAC
    and r1, r4, r0                  @ mant1 per denormalitzat

.done_num1:
    mov r10, r6                     @ exp1 → r10
    mov r6, r1                      @ mant1 → r6

    @ num2
    ldr r0, =E9M22_MASK_EXP
    and r1, r5, r0
    cmp r1, #0
    beq .denorm2

    lsr r1, r1, #E9M22_m
    sub r1, r1, #E9M22_bias         @ exp2
    ldr r0, =E9M22_MASK_FRAC
    and r2, r5, r0
    orr r2, r2, #E9M22_1_IMPLICIT_NORMAL @ mant2
    b .done_num2

.denorm2:
    ldr r1, =E9M22_Emin
    ldr r0, =E9M22_MASK_FRAC
    and r2, r5, r0                  @ mant2 per denormalitzat

.done_num2:
    mov r11, r1                     @ exp2 → r11
    mov r7, r2                      @ mant2 → r7

    @ -------------------------
    @ Eliminar zeros finals per optimitzar precisió

    mov r0, r6
    bl count_trailing_zeros_s
    cmp r0, #0
    beq .mant2_trail
    lsr r6, r6, r0
    add r10, r10, r0

.mant2_trail:
    mov r0, r7
    bl count_trailing_zeros_s
    cmp r0, #0
    beq .do_product
    lsr r7, r7, r0
    add r11, r11, r0

.do_product:
    mov r0, r6
    mov r1, r7
    bl umul32x32_2x32               @ r0=prod64lo, r1=prod64hi

    mov r2, r0
    mov r3, r1

    @ Calcular exponent del producte
    add r4, r10, r11
    sub r4, r4, #E9M22_m            @ exp_prod

    cmp r3, #0
    beq .no_shift

    mov r0, r3
    bl count_leading_zeros_s
    rsb r5, r0, #32                 @ despl = 32 - clz

    @ Calcular sticky bit
    mov r1, #1
    lsl r1, r1, r5
    sub r1, r1, #1
    and r1, r2, r1
    cmp r1, #0
    moveq r1, #0
    movne r1, #1

    @ Construir mant_prod
    lsl r0, r3, r0
    lsr r5, r2, r5
    orr r0, r0, r5
    orr r0, r0, r1

    add r4, r4, r5                  @ ajustem exponent

    b .normalize

.no_shift:
    mov r0, r2                      @ mant_prod

.normalize:
    mov r1, r4                      @ exponent del producte
    mov r2, r9                      @ signe del producte
    bl E9M22_normalize_and_round_s

.end_mul:
    pop {r4-r11, pc}               @ Restaurar i retornar

.data
.align 2

E9M22_qNAN:      .word 0x7FC00000
E9M22_INF_POS:   .word 0x7F800000
FLOAT_sNAN:      .word 0x7FA00000