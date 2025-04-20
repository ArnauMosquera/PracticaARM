    .section .data
    .align 4

@ Constants codificades en E9M22 (convertides des de float en C)
c_9_over_5:
    .word 0x40e66666   @ float(1.8) ˜ E9M22

c_32:
    .word 0x42000000   @ float(32.0) ˜ E9M22

c_5_over_9:
    .word 0x3f124925   @ float(5/9) ˜ 0.555... en E9M22


    .section .text
    .global Celsius2Fahrenheit
    .type Celsius2Fahrenheit, %function

Celsius2Fahrenheit:
    push {lr}                      @ Guardem l’adreça de retorn

    ldr r1, =c_9_over_5            @ Carreguem l’adreça de la constant 9/5
    ldr r1, [r1]                   @ r1 = E9M22(9/5)

    bl E9M22_mul                   @ r0 = input * 9/5

    mov r2, r0                     @ guardem el resultat parcial a r2

    ldr r1, =c_32                  @ carreguem l’adreça de la constant 32
    ldr r1, [r1]                   @ r1 = E9M22(32)

    mov r0, r2                     @ r0 = resultat anterior

    bl E9M22_add                   @ r0 = (input * 9/5) + 32

    pop {lr}                       @ Recuperem l’adreça de retorn
    bx lr                          @ Retornem (resultat en r0)


    .global Fahrenheit2Celsius
    .type Fahrenheit2Celsius, %function

Fahrenheit2Celsius:
    push {lr}                      @ Guardem l’adreça de retorn

    ldr r1, =c_32                  @ Carreguem l’adreça de la constant 32
    ldr r1, [r1]                   @ r1 = E9M22(32)

    bl E9M22_sub                   @ r0 = input - 32

    mov r2, r0                     @ guardem el resultat parcial a r2

    ldr r1, =c_5_over_9            @ carreguem l’adreça de la constant 5/9
    ldr r1, [r1]                   @ r1 = E9M22(5/9)

    mov r0, r2                     @ r0 = resultat anterior

    bl E9M22_mul                   @ r0 = (input - 32) * 5/9

    pop {lr}                       @ Recuperem l’adreça de retorn
    bx lr                          @ Retornem (resultat en r0)
