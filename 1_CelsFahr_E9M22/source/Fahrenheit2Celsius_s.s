    .section .data
    .align 4

c_32:
    .word 0x42000000       @ float(32.0) ? E9M22

c_5_over_9:
    .word 0x3f0e38e3       @ float(5.0/9.0) ? E9M22

    .section .text
    .global Fahrenheit2Celsius
    .type Fahrenheit2Celsius, %function

Fahrenheit2Celsius:
    push {lr}                      @ Guardem LR

    ldr r1, =c_32                  @ Carreguem la constant 32
    ldr r1, [r1]

    mov r0, r0                     @ r0 ja conté input

    bl E9M22_sub                   @ r0 = input - 32

    mov r2, r0                     @ guardem el resultat parcial

    ldr r1, =c_5_over_9            @ carreguem la constant 5/9
    ldr r1, [r1]

    mov r0, r2

    bl E9M22_mul                   @ r0 = (input - 32) * (5/9)

    pop {lr}                       @ Recuperem LR
    bx lr                          @ Retornem (resultat a r0)
