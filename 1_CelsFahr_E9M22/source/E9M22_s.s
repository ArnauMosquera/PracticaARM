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

@ --- FUNCIONS AUXILIARS QUE NECESSITAVES DEFINIR ---

.global E9M22_normalize_and_round_s
E9M22_normalize_and_round_s:
    @ Aquesta és una versió dummy que només retorna el mantissa amb signe i exponent com a resultat.
    @ Hauràs d'implementar la versió real més endavant.
    push {lr}
    @ suposant que r0 = mantissa, r1 = exponent, r2 = signe
    @ Aquí podries construir el resultat codificat, però ara només retornem r0 tal com està.
    pop {pc}

.global count_trailing_zeros_s
count_trailing_zeros_s:
    push {lr}
    mov r1, #0
.loop_ctz:
    tst r0, #1
    bne .end_ctz
    lsr r0, r0, #1
    add r1, r1, #1
    b .loop_ctz
.end_ctz:
    mov r0, r1
    pop {pc}

.global count_leading_zeros_s
count_leading_zeros_s:
    push {lr}
    mov r1, #0
    mov r2, #1 << 31
.loop_clz:
    tst r0, r2
    bne .end_clz
    lsr r2, r2, #1
    add r1, r1, #1
    cmp r1, #32
    bge .end_clz
    b .loop_clz
.end_clz:
    mov r0, r1
    pop {pc}

@; E9M22_add_s(): calcula num1 + num2 (en coma flotant E9M22)
.global E9M22_add_s
E9M22_add_s:
    push {r4-r11, lr}

    mov r4, r0          @; r4 = num1
    mov r5, r1          @; r5 = num2

    @; Obtenir signe1 i signe2
    ldr r6, =E9M22_MASK_SIGN
    and r7, r4, r6      @; signe1 → r7
    and r8, r5, r6      @; signe2 → r8

    @; Comprovar si num1 és NaN
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, r9
    bne check_nan2      @; No és NaN? comprovem el segon operand
    ldr r9, =E9M22_MASK_FRAC
    and r10, r4, r9
    cmp r10, #0
    bne return_nan1     @; num1 és NaN → retorna num1

check_nan2:
    ldr r9, =E9M22_MASK_EXP
    and r10, r5, r9
    cmp r10, r9
    bne check_inf       @; No és NaN? anem a veure si és infinit
    ldr r9, =E9M22_MASK_FRAC
    and r10, r5, r9
    cmp r10, #0
    bne return_nan2     @; num2 és NaN → retorna num2
    pop {r4-r11, pc}
check_inf:
    @; Comprovem si num1 és infinit
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, r9
    bne check_inf2

    @; num1 és infinit
    and r10, r5, r9
    cmp r10, r9
    bne return_inf1   @; num2 no és infinit → retorna num1

    @; num2 també és infinit → comparar signes
    cmp r7, r8
    beq return_inf1   @; mateixes signes → retorna num1
    ldr r0, =E9M22_qNAN
	ldr r0, [r0]  @; signes oposats → retorna NaN
    b end_add

check_inf2:
    @; Comprovem si num2 és infinit
    and r10, r5, r9
    cmp r10, r9
    bne check_zero

    @; num2 és infinit → retorna num2
    mov r0, r5
    b end_add

return_inf1:
    mov r0, r4
    b end_add

@ -----------------------
@ Tractament zeros
check_zero:
    @; Comprovar si num1 == 0
    ldr r9, =E9M22_MASK_EXP
    ldr r0, =E9M22_MASK_FRAC
	orr r9, r9, r0
    and r10, r4, r9
    cmp r10, #0
    bne check_zero2   @; num1 ≠ 0

    @; num1 és zero → retorna num2
    mov r0, r5
    b end_add

check_zero2:
    and r10, r5, r9
    cmp r10, #0
    bne normal_add     @; num2 ≠ 0

    @; num2 és zero → retorna num1
    mov r0, r4
    b end_add
@ -----------------------
@ num1 i num2 són finits, no zero → extreure mantissa i exponent

normal_add:
    @; Cal veure si num1 és normal o denormal
    ldr r9, =E9M22_MASK_EXP
    and r10, r4, r9
    cmp r10, #0
    beq num1_denorm

    @; num1 normal → exponent i mantissa
    ldr r9, =E9M22_MASK_FRAC
    and r6, r4, r9          @; mant1 = FRAC(num1)
    orr r6, r6, #E9M22_1_IMPLICIT_NORMAL @; mant1 amb 1 implícit
    mov r9, r4
    lsr r9, r9, #E9M22_m    @; shift exponent cap a dreta
    sub r9, r9, #E9M22_bias @; exponent real
    mov r10, r9             @; exp1 = r10
    b get_num2

num1_denorm:
    @; num1 denormal
    ldr r9, =E9M22_MASK_FRAC
    and r6, r4, r9          @; mant1 = FRAC(num1)
    ldr r10, =E9M22_Emin    @; exp1 = Emin

get_num2:
    @; Cal veure si num2 és normal o denormal
    ldr r9, =E9M22_MASK_EXP
    and r11, r5, r9
    cmp r11, #0
    beq num2_denorm

    @; num2 normal
    ldr r9, =E9M22_MASK_FRAC
    and r11, r5, r9
    orr r11, r11, #E9M22_1_IMPLICIT_NORMAL  @; mant2
    mov r9, r5
    lsr r9, r9, #E9M22_m
    sub r9, r9, #E9M22_bias
    mov r12, r9            @; exp2 = r12
    b align_exponents

num2_denorm:
    @; num2 denormal
    ldr r9, =E9M22_MASK_FRAC
    and r11, r5, r9
    ldr r12, =E9M22_Emin   @; exp2 = Emin

@ -----------------------
@ Alinear mantisses si exponents diferents

align_exponents:
    cmp r10, r12
    beq do_addition

    @; si exp1 < exp2 → desplaçar mant2
    movlt r0, r12
    sublt r0, r0, r10      @; dif_exp = exp2 - exp1
    cmp r0, #E9M22_e
    blt shift_mant2_left    @; sinò: cas complex
    mov r1, #E9M22_e - 1
    lsl r11, r11, r1       @; mant2 <<= (e-1)
    sub r12, r12, r1
    sub r0, r12, r10
    lsr r6, r6, r0         @; mant1 >>= dif_exp
    add r10, r10, r0
    b do_addition

shift_mant2_left:
    lsl r11, r11, r0
    sub r12, r12, r0
    b do_addition

@; Cas contrari: exp1 > exp2
    @; Mateix codi però intercanviant mant1 i mant2
    @; (segueix a la següent part)
@ -----------------------
@ Fer la suma de mantisses (considerant signe)

do_addition:
    @; Si signes diferents → convertir un operand a negatiu (Ca2)
    cmp r7, r8
    beq same_sign

    @; Són diferents → aplicar negatiu a qui toca
    @; if (num1 < 0) → mant1 = -mant1
    tst r7, r7
    rsbne r6, r6, #0    @; mant1 = -mant1 (r6)
    rsbeq r11, r11, #0  @; mant2 = -mant2 (r11)

same_sign:
    @; mant_suma = mant1 + mant2
    add r0, r6, r11

    @; Si el resultat és negatiu → fer valor absolut (mant_suma = -mant_suma)
    cmp r0, #0
    bge mantissa_ok
    rsb r0, r0, #0

mantissa_ok:
    @; Calcular signe del resultat:
    @; if (signe1 == signe2 || abs(num1) ≥ abs(num2)) → signe1
    cmp r7, r8
    beq signe1_ok       @; mateix signe → OK

    @; comparar magnituds: abs(num1) ≥ abs(num2) ?
    mov r1, r4
    mov r2, r5
    bic r1, r1, #E9M22_MASK_SIGN
    bic r2, r2, #E9M22_MASK_SIGN
    cmp r1, r2
    movge r9, r7        @; signe_suma = signe1
    movlt r9, r8        @; signe_suma = signe2
    b call_normalize

signe1_ok:
    mov r9, r7

@ -----------------------
@ Cridar a normalize_and_round: 
@ r0 = mantissa suma
@ r1 = exponent (exp1 = exp2, ja alineats)
@ r2 = signe

call_normalize:
    mov r1, r10     @; exp_suma = exp1
    mov r2, r9      @; signe_suma
    bl E9M22_normalize_and_round_s

return_nan1:
    mov r0, r4
    b end_add

return_nan2:
    mov r0, r5
    b end_add


end_add:
    pop {r4-r11, pc}
@; E9M22_sub_s(): calcula num1 - num2 (coma flotant E9M22)
.global E9M22_sub_s
E9M22_sub_s:
    push {lr}

    @; Negar num2: fer xor amb E9M22_MASK_SIGN
    ldr r2, =E9M22_MASK_SIGN
    eor r1, r1, r2      @; num2negat = num2 ^ SIGN

    @; Cridar a add amb num1 i -num2
    bl E9M22_add_s

    pop {pc}
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
    push {r4-r11, lr}

    mov r4, r0      @; r4 = num1
    mov r5, r1      @; r5 = num2

    @; Calcular signe del producte: signe1 ^ signe2
    ldr r6, =E9M22_MASK_SIGN
    and r7, r4, r6      @; signe1 → r7
    and r8, r5, r6      @; signe2 → r8
    eor r9, r7, r8      @; signe_prod → r9

    @; -------------------------
    @; Tractar NaNs

    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, r6
    bne .check_nan2
    ldr r6, =E9M22_MASK_FRAC
    and r0, r4, r6
    cmp r0, #0
    bne .return_nan1

.check_nan2:
    ldr r6, =E9M22_MASK_EXP
    and r0, r5, r6
    cmp r0, r6
    bne .check_inf_zero
    ldr r6, =E9M22_MASK_FRAC
    and r0, r5, r6
    cmp r0, #0
    bne .return_nan2

.return_nan1:
    mov r0, r4
    b .end_mul

.return_nan2:
    mov r0, r5
    b .end_mul

@; -------------------------
@; Tractar ∞ × 0 → NaN, ∞ × x → ∞

.check_inf_zero:
    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, r6
    bne .check_inf_num2

    @; num1 és ∞
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r1, r5, r6
    cmp r1, #0
    moveq r0, r9         @; signe_prod
	ldreq r1, =E9M22_qNAN
	orreq r0, r0, r1
    movne r0, r9
   ldrne r1, =E9M22_INF_POS
	orrne r0, r0, r1

    b .end_mul

.check_inf_num2:
    ldr r6, =E9M22_MASK_EXP
    and r0, r5, r6
    cmp r0, r6
    bne .check_zeros

    @; num2 és ∞
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r1, r4, r6
    cmp r1, #0
    moveq r0, r9
	ldreq r1, =E9M22_qNAN

	orreq r0, r0, r1

    movne r0, r9
  ldrne r1, =E9M22_INF_POS
	orrne r0, r0, r1

    b .end_mul

@; -------------------------
@; Tractar zeros normals → retorna ±0
.check_zeros:
    ldr r6, =E9M22_MASK_EXP | E9M22_MASK_FRAC
    and r0, r4, r6
    cmp r0, #0
    moveq r0, r9         @; signe_prod com a resultat
    beq .end_mul

    and r0, r5, r6
    cmp r0, #0
    moveq r0, r9
    beq .end_mul
@ -------------------------
@ Extracció d’exponents i mantisses

.extract_mant_exp:
    @; num1
    ldr r6, =E9M22_MASK_EXP
    and r0, r4, r6
    cmp r0, #0
    beq .denorm1

    @; num1 normal
    lsr r6, r0, #E9M22_m
    sub r6, r6, #E9M22_bias     @; exp1
    ldr r0, =E9M22_MASK_FRAC
    and r1, r4, r0
    orr r1, r1, #E9M22_1_IMPLICIT_NORMAL @; mant1
    b .done_num1

.denorm1:
    ldr r6, =E9M22_Emin
    ldr r0, =E9M22_MASK_FRAC
    and r1, r4, r0              @; mant1

.done_num1:
    mov r10, r6     @; exp1 → r10
    mov r6, r1      @; mant1 → r6

    @; num2
    ldr r0, =E9M22_MASK_EXP
    and r1, r5, r0
    cmp r1, #0
    beq .denorm2

    lsr r1, r1, #E9M22_m
    sub r1, r1, #E9M22_bias     @; exp2
    ldr r0, =E9M22_MASK_FRAC
    and r2, r5, r0
    orr r2, r2, #E9M22_1_IMPLICIT_NORMAL @; mant2
    b .done_num2

.denorm2:
    ldr r1, =E9M22_Emin
    ldr r0, =E9M22_MASK_FRAC
    and r2, r5, r0

.done_num2:
    mov r11, r1     @; exp2 → r11
    mov r7, r2      @; mant2 → r7

@ -------------------------
@ Eliminar zeros per la dreta

    @; count_trailing_zeros(mant1)
    mov r0, r6
    bl count_trailing_zeros_s
    cmp r0, #0
    beq .mant2_trail
    lsr r6, r6, r0      @; mant1 >>= n
    add r10, r10, r0    @; exp1 += n

.mant2_trail:
    mov r0, r7
    bl count_trailing_zeros_s
    cmp r0, #0
    beq .do_product
    lsr r7, r7, r0
    add r11, r11, r0
.do_product:
    @; r6 = mant1, r7 = mant2
    mov r0, r6
    mov r1, r7
    bl umul32x32_2x32      @; retorna r0=prod64lo, r1=prod64hi

    mov r2, r0      @; prod64lo
    mov r3, r1      @; prod64hi

    @; Calcular exp_prod = exp1 + exp2 - E9M22_m
    add r4, r10, r11       @; exp1 + exp2
    sub r4, r4, #E9M22_m   @; exp_prod → r4

    @; Si prod64hi != 0, necessitem normalitzar amb CLZ
    cmp r3, #0
    beq .no_shift

    mov r0, r3
    bl count_leading_zeros_s   @; retorna a r0 → num_leading_zeros
    rsb r5, r0, #32            @; despl = 32 - num_leading_zeros

    @; Calcular sticky bit
    mov r1, #1
    lsl r1, r1, r5
    sub r1, r1, #1             @; mask_sticky = (1<<despl) - 1
    and r1, r2, r1             @; prod64lo & mask_sticky
    cmp r1, #0
    moveq r1, #0
    movne r1, #1               @; sticky = 1 si hi ha bits perduts

    @; Construir mant_prod
    lsl r0, r3, r0             @; prod64hi << lz
    lsr r5, r2, r5             @; prod64lo >> despl
    orr r0, r0, r5             @; mant_prod = (hi << lz) | (lo >> despl)
    orr r0, r0, r1             @; afegir sticky

    add r4, r4, r5             @; ajustar exponent += despl
    b .normalize

.no_shift:
    mov r0, r2                @; mant_prod = prod64lo

.normalize:
    mov r1, r4                @; exp_prod
    mov r2, r9                @; signe_prod
    bl E9M22_normalize_and_round_s

.end_mul:
    pop {r4-r11, pc}
	
	.data
.align 2

E9M22_qNAN:      .word 0x7FC00000
E9M22_INF_POS:   .word 0x7F800000
FLOAT_sNAN:      .word 0x7FA00000
