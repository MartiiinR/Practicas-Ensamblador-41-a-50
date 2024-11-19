// Autor: Ruiz Barcenas Martin Adolfo
// Fecha: 09-11-2024
// Descripción: Calculadora Simple que elabore las operaciones basicas (suma, resta, multiplicacion y division)
// Asciinema: https://asciinema.org/a/LyXIxJUF9wy1X5sFsIjqtfSeP

.data
    msg_welcome: .asciz "Calculadora Simple\n"
    msg_num1: .asciz "Ingrese el primer número: "
    msg_num2: .asciz "Ingrese el segundo número: "
    msg_operation: .asciz "Ingrese la operación (+, -, *, /): "
    msg_result: .asciz "El resultado es: %ld\n"
    msg_div_zero: .asciz "Error: División por cero\n"
    msg_invalid_op: .asciz "Error: Operación inválida\n"
    formato_in_num: .asciz "%ld"
    formato_in_op: .asciz " %c"
    buffer: .skip 2

.text
.global main
.align 2

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Mostrar mensaje de bienvenida
    adrp x0, msg_welcome
    add x0, x0, :lo12:msg_welcome
    bl printf

    // Pedir primer número
    adrp x0, msg_num1
    add x0, x0, :lo12:msg_num1
    bl printf

    // Leer primer número
    sub sp, sp, #16
    mov x1, sp
    adrp x0, formato_in_num
    add x0, x0, :lo12:formato_in_num
    bl scanf
    ldr x19, [sp]  // x19 = primer número
    add sp, sp, #16

    // Pedir segundo número
    adrp x0, msg_num2
    add x0, x0, :lo12:msg_num2
    bl printf

    // Leer segundo número
    sub sp, sp, #16
    mov x1, sp
    adrp x0, formato_in_num
    add x0, x0, :lo12:formato_in_num
    bl scanf
    ldr x20, [sp]  // x20 = segundo número
    add sp, sp, #16

    // Pedir operación
    adrp x0, msg_operation
    add x0, x0, :lo12:msg_operation
    bl printf

    // Leer operación
    adrp x0, formato_in_op
    add x0, x0, :lo12:formato_in_op
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf

    // Cargar operación
    adrp x0, buffer
    add x0, x0, :lo12:buffer
    ldrb w21, [x0]  // w21 = operación

    // Realizar operación
    cmp w21, #'+'
    b.eq suma
    cmp w21, #'-'
    b.eq resta
    cmp w21, #'*'
    b.eq multiplicacion
    cmp w21, #'/'
    b.eq division

    // Operación inválida
    adrp x0, msg_invalid_op
    add x0, x0, :lo12:msg_invalid_op
    bl printf
    b end_program

suma:
    add x22, x19, x20
    b print_result

resta:
    sub x22, x19, x20
    b print_result

multiplicacion:
    mul x22, x19, x20
    b print_result

division:
    // Verificar división por cero
    cmp x20, #0
    b.eq div_zero
    sdiv x22, x19, x20
    b print_result

div_zero:
    adrp x0, msg_div_zero
    add x0, x0, :lo12:msg_div_zero
    bl printf
    b end_program

print_result:
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    mov x1, x22
    bl printf

end_program:
    // Salir del programa
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
