; ========================================
; Shape Generation Program - NASM Assembly
; Integrated Computer Systems Assignment
; ========================================
; This program generates various ASCII shapes
; (Circle, Triangle, Heart, Square, Rectangle)
; with solid or hollow options

section .data
    ; Menu and prompts
    banner db "╔════════════════════════════════════════╗", 10
           db "║    SHAPE GENERATION PROGRAM v2.0       ║", 10
           db "║        Assembly Language (NASM)        ║", 10
           db "╚════════════════════════════════════════╝", 10, 0
    
    menu db 10, "=== SHAPE MENU ===", 10
         db "1. Circle", 10
         db "2. Triangle", 10
         db "3. Heart", 10
         db "4. Square", 10
         db "5. Rectangle", 10
         db "6. Exit Program", 10
         db "Enter your choice (1-6): ", 0
    
    type_prompt db 10, "Select shape type:", 10
                db "1. Solid", 10
                db "2. Hollow", 10
                db "Enter type (1-2): ", 0
    
    radius_prompt db "Enter radius (5-15): ", 0
    size_prompt db "Enter size (5-20): ", 0
    length_prompt db "Enter length (5-25): ", 0
    breadth_prompt db "Enter breadth (5-25): ", 0
    heart_size_prompt db "Enter heart size (5-15): ", 0
    
    ; Messages
    invalid_choice db 10, "ERROR: Invalid choice! Please enter 1-6.", 10, 0
    invalid_type db "ERROR: Invalid type! Please enter 1 or 2.", 10, 0
    invalid_radius db "ERROR: Radius must be between 5 and 15!", 10, 0
    invalid_size db "ERROR: Size must be between 5 and 20!", 10, 0
    invalid_length db "ERROR: Length must be between 5 and 25!", 10, 0
    invalid_breadth db "ERROR: Breadth must be between 5 and 25!", 10, 0
    invalid_heart db "ERROR: Heart size must be between 5 and 15!", 10, 0
    thank_you db 10, "Thank you for using Shape Generator!", 10
              db "Program terminated successfully.", 10, 0
    newline db 10, 0
    space db " ", 0
    star db "*", 0
    
    ; Buffer for input
    input_buffer db 10 dup(0)
    
section .bss
    choice resb 2       ; Store user choice
    shape_type resb 1   ; 1=solid, 2=hollow
    radius resb 1       ; For circle
    size resb 1         ; For triangle, square, heart
    length resb 1       ; For rectangle
    breadth resb 1      ; For rectangle
    row resb 1          ; Loop counter for rows
    col resb 1          ; Loop counter for columns
    temp resb 1         ; Temporary storage
    temp2 resb 1        ; Additional temp storage

section .text
    global _start

_start:
    call clear_screen
    call print_banner
    jmp main_loop

; ========================================
; Main Program Loop
; ========================================
main_loop:
    call print_menu
    call get_choice
    
    ; Validate choice (1-6)
    mov al, [choice]
    cmp al, '1'
    jl invalid_input
    cmp al, '6'
    jg invalid_input
    
    ; Check if exit
    cmp al, '6'
    je exit_program
    
    ; Get shape type (solid/hollow)
    call get_shape_type
    
    ; Process valid choice
    call process_choice
    jmp main_loop

invalid_input:
    mov eax, invalid_choice
    call print_string
    jmp main_loop

; ========================================
; Get Shape Type (Solid/Hollow)
; ========================================
get_shape_type:
    mov eax, type_prompt
    call print_string
    
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input_buffer
    mov edx, 10
    int 0x80
    
    mov al, [input_buffer]
    cmp al, '1'
    je .valid
    cmp al, '2'
    je .valid
    
    mov eax, invalid_type
    call print_string
    jmp get_shape_type
    
.valid:
    mov [shape_type], al
    ret

; ========================================
; Process User Choice
; ========================================
process_choice:
    mov al, [choice]
    
    cmp al, '1'
    je gen_circle
    cmp al, '2'
    je gen_triangle
    cmp al, '3'
    je gen_heart
    cmp al, '4'
    je gen_square
    cmp al, '5'
    je gen_rectangle
    
    ret

; ========================================
; Generate Circle
; ========================================
gen_circle:
    mov eax, radius_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [radius], al
    
    ; Validate radius (5-15)
    cmp al, 5
    jl .invalid
    cmp al, 15
    jg .invalid
    
    ; Draw circle
    mov byte [row], 0
    movzx eax, byte [radius]
    shl eax, 1
    inc eax
    mov [temp2], al     ; diameter
    
.row_loop:
    mov al, [row]
    cmp al, [temp2]
    jge .done
    
    mov byte [col], 0
.col_loop:
    mov al, [col]
    cmp al, [temp2]
    jge .next_row
    
    ; Calculate if point is on circle
    ; (x - radius)^2 + (y - radius)^2 <= radius^2
    movzx ebx, byte [col]
    movzx ecx, byte [radius]
    sub ebx, ecx        ; x - radius
    imul ebx, ebx       ; (x - radius)^2
    
    movzx edx, byte [row]
    sub edx, ecx        ; y - radius
    imul edx, edx       ; (y - radius)^2
    
    add ebx, edx        ; distance^2
    imul ecx, ecx       ; radius^2
    
    ; Check if hollow
    cmp byte [shape_type], '2'
    je .check_hollow
    
    ; Solid: fill if inside
    cmp ebx, ecx
    jle .draw_star
    jmp .draw_space
    
.check_hollow:
    ; Hollow: draw only on edge
    mov eax, ecx
    sub eax, ebx
    cmp eax, 0
    jl .draw_space
    mov eax, ecx
    shr eax, 3          ; tolerance
    add eax, ecx
    cmp ebx, eax
    jle .draw_star
    jmp .draw_space
    
.draw_star:
    mov eax, star
    call print_string
    jmp .continue
    
.draw_space:
    mov eax, space
    call print_string
    
.continue:
    inc byte [col]
    jmp .col_loop
    
.next_row:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .row_loop
    
.done:
    ret
    
.invalid:
    mov eax, invalid_radius
    call print_string
    jmp gen_circle

; ========================================
; Generate Triangle
; ========================================
gen_triangle:
    mov eax, size_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [size], al
    
    ; Validate size (5-20)
    cmp al, 5
    jl .invalid
    cmp al, 20
    jg .invalid
    
    mov byte [row], 1
    
.row_loop:
    mov al, [row]
    cmp al, [size]
    jg .done
    
    ; Print leading spaces
    mov bl, [size]
    sub bl, [row]
    mov byte [col], 0
.spaces:
    cmp byte [col], bl
    jge .stars
    mov eax, space
    call print_string
    inc byte [col]
    jmp .spaces
    
.stars:
    mov al, [row]
    shl al, 1
    dec al
    mov byte [col], 0
    
    cmp byte [shape_type], '1'
    je .solid_star_loop
    
    ; Hollow triangle
.hollow_star_loop:
    cmp byte [col], al
    jge .next_row
    
    ; Draw star only on edges or last row
    cmp byte [col], 0
    je .draw_star_h
    mov bl, al
    dec bl
    cmp byte [col], bl
    je .draw_star_h
    mov bl, [size]
    dec bl
    cmp byte [row], bl
    je .draw_star_h
    
    mov eax, space
    call print_string
    jmp .continue_h
    
.draw_star_h:
    mov eax, star
    call print_string
    
.continue_h:
    inc byte [col]
    jmp .hollow_star_loop
    
    ; Solid triangle
.solid_star_loop:
    cmp byte [col], al
    jge .next_row
    mov eax, star
    call print_string
    inc byte [col]
    jmp .solid_star_loop
    
.next_row:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .row_loop
    
.done:
    ret
    
.invalid:
    mov eax, invalid_size
    call print_string
    jmp gen_triangle

; ========================================
; Generate Heart
; ========================================
gen_heart:
    mov eax, heart_size_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [size], al
    
    ; Validate size (5-15)
    cmp al, 5
    jl .invalid
    cmp al, 15
    jg .invalid
    
    ; Upper part of heart
    mov byte [row], 0
    mov al, [size]
    shr al, 1
    mov [temp2], al     ; half_size
    
.upper_loop:
    mov al, [row]
    cmp al, [temp2]
    jge .lower_part
    
    mov byte [col], 0
    mov al, [size]
    shl al, 1
    
.upper_col_loop:
    cmp byte [col], al
    jge .upper_next
    
    ; Heart pattern logic for upper part
    movzx ebx, byte [col]
    movzx ecx, byte [size]
    shr ecx, 1
    
    ; Left lobe
    sub ebx, ecx
    imul ebx, ebx
    movzx edx, byte [row]
    sub edx, ecx
    imul edx, edx
    add ebx, edx
    
    movzx eax, byte [size]
    shr eax, 2
    imul eax, eax
    
    cmp ebx, eax
    jle .draw_heart_star
    
    ; Right lobe check
    movzx ebx, byte [col]
    movzx ecx, byte [size]
    mov eax, ecx
    add eax, ecx
    shr eax, 1
    sub ebx, eax
    imul ebx, ebx
    movzx edx, byte [row]
    movzx eax, byte [size]
    shr eax, 1
    sub edx, eax
    imul edx, edx
    add ebx, edx
    
    movzx eax, byte [size]
    shr eax, 2
    imul eax, eax
    
    cmp ebx, eax
    jle .draw_heart_star
    jmp .draw_heart_space
    
.draw_heart_star:
    mov eax, star
    call print_string
    jmp .heart_continue
    
.draw_heart_space:
    mov eax, space
    call print_string
    
.heart_continue:
    inc byte [col]
    jmp .upper_col_loop
    
.upper_next:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .upper_loop
    
.lower_part:
    ; Lower triangular part
    mov al, [size]
    mov [temp2], al
    
.lower_loop:
    mov al, [row]
    movzx ebx, byte [size]
    add ebx, ebx
    shr ebx, 1
    add bl, [size]
    cmp al, bl
    jge .done
    
    ; Spaces before triangle
    movzx ebx, byte [row]
    sub ebx, [size]
    shr ebx, 1
    mov byte [col], 0
    
.lower_spaces:
    cmp byte [col], bl
    jge .lower_stars
    mov eax, space
    call print_string
    inc byte [col]
    jmp .lower_spaces
    
.lower_stars:
    movzx eax, byte [size]
    shl eax, 1
    movzx ebx, byte [row]
    sub ebx, [size]
    shr ebx, 1
    sub eax, ebx
    sub eax, ebx
    mov byte [col], 0
    
    cmp byte [shape_type], '1'
    je .lower_solid
    
.lower_hollow:
    cmp byte [col], al
    jge .lower_next
    
    cmp byte [col], 0
    je .draw_lower_star
    mov bl, al
    dec bl
    cmp byte [col], bl
    je .draw_lower_star
    
    mov eax, space
    call print_string
    jmp .lower_cont
    
.draw_lower_star:
    mov eax, star
    call print_string
    jmp .lower_cont
    
.lower_solid:
    cmp byte [col], al
    jge .lower_next
    mov eax, star
    call print_string
    
.lower_cont:
    inc byte [col]
    cmp byte [shape_type], '1'
    je .lower_solid
    jmp .lower_hollow
    
.lower_next:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .lower_loop
    
.done:
    ret
    
.invalid:
    mov eax, invalid_heart
    call print_string
    jmp gen_heart

; ========================================
; Generate Square
; ========================================
gen_square:
    mov eax, length_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [size], al
    
    ; Validate (5-25)
    cmp al, 5
    jl .invalid
    cmp al, 25
    jg .invalid
    
    mov byte [row], 0
    
.row_loop:
    mov al, [row]
    cmp al, [size]
    jge .done
    
    mov byte [col], 0
.col_loop:
    mov al, [col]
    cmp al, [size]
    jge .next_row
    
    ; Check if hollow
    cmp byte [shape_type], '2'
    je .check_border
    
    ; Solid
    mov eax, star
    call print_string
    jmp .continue
    
.check_border:
    ; Hollow: draw only on border
    cmp byte [row], 0
    je .draw_star
    mov al, [size]
    dec al
    cmp byte [row], al
    je .draw_star
    cmp byte [col], 0
    je .draw_star
    mov al, [size]
    dec al
    cmp byte [col], al
    je .draw_star
    
    mov eax, space
    call print_string
    jmp .continue
    
.draw_star:
    mov eax, star
    call print_string
    
.continue:
    mov eax, space
    call print_string
    inc byte [col]
    jmp .col_loop
    
.next_row:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .row_loop
    
.done:
    ret
    
.invalid:
    mov eax, invalid_length
    call print_string
    jmp gen_square

; ========================================
; Generate Rectangle
; ========================================
gen_rectangle:
    mov eax, length_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [length], al
    
    ; Validate length (5-25)
    cmp al, 5
    jl .invalid_len
    cmp al, 25
    jg .invalid_len
    
    mov eax, breadth_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [breadth], al
    
    ; Validate breadth (5-25)
    cmp al, 5
    jl .invalid_br
    cmp al, 25
    jg .invalid_br
    
    mov byte [row], 0
    
.row_loop:
    mov al, [row]
    cmp al, [breadth]
    jge .done
    
    mov byte [col], 0
.col_loop:
    mov al, [col]
    cmp al, [length]
    jge .next_row
    
    ; Check if hollow
    cmp byte [shape_type], '2'
    je .check_border
    
    ; Solid
    mov eax, star
    call print_string
    jmp .continue
    
.check_border:
    ; Hollow: draw only on border
    cmp byte [row], 0
    je .draw_star
    mov al, [breadth]
    dec al
    cmp byte [row], al
    je .draw_star
    cmp byte [col], 0
    je .draw_star
    mov al, [length]
    dec al
    cmp byte [col], al
    je .draw_star
    
    mov eax, space
    call print_string
    jmp .continue
    
.draw_star:
    mov eax, star
    call print_string
    
.continue:
    mov eax, space
    call print_string
    inc byte [col]
    jmp .col_loop
    
.next_row:
    mov eax, newline
    call print_string
    inc byte [row]
    jmp .row_loop
    
.done:
    ret
    
.invalid_len:
    mov eax, invalid_length
    call print_string
    jmp gen_rectangle
    
.invalid_br:
    mov eax, invalid_breadth
    call print_string
    mov eax, breadth_prompt
    call print_string
    call get_input
    mov al, [temp]
    mov [breadth], al
    cmp al, 5
    jl .invalid_br
    cmp al, 25
    jg .invalid_br
    jmp .row_loop

; ========================================
; Helper Functions
; ========================================

; Get numeric input and convert to integer
get_input:
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input_buffer
    mov edx, 10
    int 0x80
    
    ; Convert ASCII to number
    xor eax, eax
    xor ebx, ebx
    mov bl, [input_buffer]
    cmp bl, '0'
    jl .done
    cmp bl, '9'
    jg .check_two_digit
    
    sub bl, '0'
    mov [temp], bl
    ret
    
.check_two_digit:
    mov bl, [input_buffer]
    cmp bl, '1'
    jl .done
    cmp bl, '9'
    jg .done
    sub bl, '0'
    imul bl, 10
    mov al, [input_buffer + 1]
    cmp al, '0'
    jl .done
    cmp al, '9'
    jg .done
    sub al, '0'
    add bl, al
    mov [temp], bl
    
.done:
    ret

; Print string (eax = address of null-terminated string)
print_string:
    push eax
    push ebx
    push ecx
    push edx
    
    mov ebx, eax        ; String address
    xor ecx, ecx        ; Length counter
    
.count:
    cmp byte [ebx + ecx], 0
    je .print
    inc ecx
    jmp .count
    
.print:
    mov eax, 4          ; sys_write
    mov ebx, 1          ; stdout
    mov edx, ecx        ; Length
    mov ecx, [esp + 12] ; String address
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

; Print banner
print_banner:
    mov eax, banner
    call print_string
    ret

; Print menu
print_menu:
    mov eax, menu
    call print_string
    ret

; Get user choice
get_choice:
    mov eax, 3          ; sys_read
    mov ebx, 0          ; stdin
    mov ecx, input_buffer
    mov edx, 10
    int 0x80
    
    mov al, [input_buffer]
    mov [choice], al
    ret

; Clear screen
clear_screen:
    push eax
    push ebx
    push ecx
    push edx
    
    mov eax, 4
    mov ebx, 1
    lea ecx, [clear_seq]
    mov edx, 4
    int 0x80
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret

clear_seq db 27, '[', '2', 'J', 27, '[', 'H'

; Exit program
exit_program:
    mov eax, thank_you
    call print_string
    
    mov eax, 1          ; sys_exit
    xor ebx, ebx        ; Exit code 0
    int 0x80
