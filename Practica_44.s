// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Generacion de numeros aleatorios
// Asciinema: https://asciinema.org/a/isdRkqfiQ8j0Xx4gdmruFz2rO

 .data
    msg_seed: .asciz "Ingrese la semilla: "
    msg_count: .asciz "¿Cuántos números aleatorios desea generar? "
    msg_output: .asciz "Número aleatorio %d: %u\n"
    formato_in: .asciz "%ld"
    newline: .asciz "\n"

// Constantes para el generador congruencial lineal
multiplier: .quad 1103515245
increment: .quad 12345
modulus: .quad 0x80000000  // 2^31

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -32]!
    mov x29, sp

    // Pedir semilla
    adrp x0, msg_seed
    add x0, x0, :lo12:msg_seed
    bl printf

    // Leer semilla
    add x1, sp, 16
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    bl scanf
    ldr x19, [sp, 16]  // x19 = semilla

    // Pedir cantidad de números a generar
    adrp x0, msg_count
    add x0, x0, :lo12:msg_count
    bl printf

    // Leer cantidad
    add x1, sp, 24
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    bl scanf
    ldr x20, [sp, 24]  // x20 = cantidad de números a generar

    // Inicializar contador
    mov x21, #1  // x21 = contador actual

generate_loop:
    // Generar número aleatorio
    mov x0, x19
    bl random_number
    mov x19, x0  // Actualizar semilla para la próxima iteración

    // Imprimir número aleatorio
    adrp x0, msg_output
    add x0, x0, :lo12:msg_output
    mov x1, x21
    mov x2, x19
    bl printf

    // Incrementar contador y comprobar si hemos terminado
    add x21, x21, #1
    cmp x21, x20
    b.le generate_loop

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], 32
    ret

// Función para generar un número aleatorio
// Entrada: x0 = semilla actual
// Salida: x0 = nuevo número aleatorio
random_number:
    // Implementación del generador congruencial lineal
    // next = (a * seed + c) % m
    adrp x1, multiplier
    add x1, x1, :lo12:multiplier
    ldr x1, [x1]
    mul x0, x0, x1
    
    adrp x1, increment
    add x1, x1, :lo12:increment
    ldr x1, [x1]
    add x0, x0, x1
    
    adrp x1, modulus
    add x1, x1, :lo12:modulus
    ldr x1, [x1]
    sub x1, x1, #1
    and x0, x0, x1  // Equivalente a % MODULUS porque MODULUS es una potencia de 2

    ret
