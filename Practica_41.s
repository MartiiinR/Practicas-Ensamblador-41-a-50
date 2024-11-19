// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Convertir un numero decimal a uno hexadecimal
// Asciinema: https://asciinema.org/a/Ov5iJzftKQX9WJb8968UYAjX9

.data
    msg_input: .asciz "Ingrese un número decimal positivo: "
    msg_output: .asciz "El número en hexadecimal es: "
    formato_in: .asciz "%ld"
    formato_out: .asciz "%c"
    newline: .asciz "\n"
    hex_chars: .asciz "0123456789ABCDEF"

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir número decimal
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Leer número decimal
    sub sp, sp, #16
    mov x2, sp
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    mov x1, x2
    bl scanf
    ldr x19, [sp]  // x19 = número decimal ingresado
    add sp, sp, #16

    // Reservar espacio para el resultado hexadecimal (16 caracteres máximo para 64 bits)
    sub sp, sp, #16
    mov x20, sp  // x20 = dirección base del resultado hexadecimal

    // Convertir a hexadecimal
    mov x21, #15  // x21 = índice del carácter actual (empezamos desde el final)
    mov x22, #0   // x22 = contador de caracteres significativos

convert_loop:
    and x23, x19, #15  // x23 = 4 bits menos significativos
    adrp x24, hex_chars
    add x24, x24, :lo12:hex_chars
    ldrb w23, [x24, x23]  // Cargar carácter hexadecimal correspondiente
    strb w23, [x20, x21]  // Guardar el carácter en el resultado
    lsr x19, x19, #4  // Desplazar el número 4 bits a la derecha
    sub x21, x21, #1  // Mover al siguiente carácter (de derecha a izquierda)
    add x22, x22, #1  // Incrementar contador de caracteres
    cbnz x19, convert_loop  // Continuar si el número no es cero

    // Ajustar el puntero al inicio del resultado hexadecimal
    add x20, x20, x21
    add x20, x20, #1

    // Imprimir mensaje de salida
    adrp x0, msg_output
    add x0, x0, :lo12:msg_output
    bl printf

    // Imprimir resultado hexadecimal
print_loop:
    ldrb w1, [x20], #1  // Cargar siguiente carácter y avanzar puntero
    adrp x0, formato_out
    add x0, x0, :lo12:formato_out
    bl printf
    subs x22, x22, #1  // Decrementar contador de caracteres
    b.ne print_loop  // Continuar si quedan caracteres por imprimir

    // Imprimir nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf

    // Liberar espacio del resultado hexadecimal
    add sp, sp, #16

    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
