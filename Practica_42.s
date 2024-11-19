// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Convertir un numero hexadecimal a uno decimal 
// Asciinema: https://asciinema.org/a/fnML9Lvyo1zkGK5eie3kbtb0Z

.data
    msg_input: .asciz "Ingrese un número hexadecimal: "
    msg_output: .asciz "El número en decimal es: %ld\n"
    msg_error: .asciz "Error: Entrada inválida. Ingrese solo dígitos hexadecimales (0-9, A-F).\n"
    formato_in: .asciz "%s"
    buffer: .skip 17  // 16 dígitos + 1 para el carácter nulo

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Pedir número hexadecimal
    adrp x0, msg_input
    add x0, x0, :lo12:msg_input
    bl printf

    // Leer número hexadecimal
    adrp x0, formato_in
    add x0, x0, :lo12:formato_in
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Convertir a decimal
    adrp x0, buffer
    add x0, x0, :lo12:buffer
    bl hex_to_decimal

    // Verificar si hubo error (resultado negativo)
    cmp x0, #0
    b.lt error_input

    // Imprimir resultado
    mov x1, x0
    adrp x0, msg_output
    add x0, x0, :lo12:msg_output
    bl printf

    b exit_program

error_input:
    adrp x0, msg_error
    add x0, x0, :lo12:msg_error
    bl printf

exit_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret

// Función para convertir hexadecimal a decimal
// Entrada: x0 = dirección de la cadena hexadecimal
// Salida: x0 = número decimal (o -1 si hay error)
hex_to_decimal:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    mov x1, #0   // x1 = resultado decimal
    mov x2, #0   // x2 = índice actual en la cadena

convert_loop:
    ldrb w3, [x0, x2]  // Cargar siguiente carácter
    cbz w3, end_convert  // Si es nulo, terminar

    // Convertir carácter a valor
    cmp w3, #'0'
    b.lt invalid_char
    cmp w3, #'9'
    b.le digit_char
    cmp w3, #'A'
    b.lt invalid_char
    cmp w3, #'F'
    b.le upper_char
    cmp w3, #'a'
    b.lt invalid_char
    cmp w3, #'f'
    b.le lower_char
    b invalid_char

digit_char:
    sub w3, w3, #'0'
    b add_digit

upper_char:
    sub w3, w3, #'A'
    add w3, w3, #10
    b add_digit

lower_char:
    sub w3, w3, #'a'
    add w3, w3, #10

add_digit:
    // Multiplicar resultado actual por 16 y sumar nuevo dígito
    lsl x1, x1, #4
    add x1, x1, x3

    add x2, x2, #1
    b convert_loop

end_convert:
    mov x0, x1
    ldp x29, x30, [sp], #16
    ret

invalid_char:
    mov x0, #-1
    ldp x29, x30, [sp], #16
    ret
