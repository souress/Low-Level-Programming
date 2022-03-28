section .text

global exit
global read_sentence
global string_length
global print_error
global print_string
global print_char
global print_newline
global print_uint
global print_int
global string_equals
global read_char
global read_word
global parse_uint
global parse_int
global string_copy

 
; Принимает код возврата и завершает текущий процесс 
exit: 
    mov rax, 60
    syscall


; Принимает указатель на нуль-терминированную строку, возвращает её длину
string_length:
    xor rax, rax
	.loop:
		cmp byte [rdi+rax], 0
		je .end
		inc rax
		jmp .loop
	.end:
		ret


; Принимает указатель на нуль-терминированную строку, выводит её в stdout 
print_string:
	push rax
	push rsi
	push rdi
	push rdx

    mov rsi, rdi
    call string_length
	mov rdx, rax
	mov rax, 1
	mov rdi, 1
	syscall

	pop rdx
	pop rdi
	pop rsi
	pop rax
    ret

; Принимает указатель на нуль-терминированную строку, выводит её в stderr 
print_error:
	push rax
	push rsi
	push rdi
	push rdx

    mov rsi, rdi
    call string_length
	mov rdx, rax
	mov rax, 1
	mov rdi, 2
	syscall

	pop rdx
	pop rdi
	pop rsi
	pop rax
    ret

; Принимает код символа и выводит его в stdout
print_char:
	push rax
	push rsi
	push rdx
    push rdi

    mov rax, 1
    mov rdi, 1
    mov rsi, rsp
    mov rdx, 1
    syscall

    pop rdi
	pop rdx
	pop rsi
	pop rax
    ret


; Переводит строку (выводит символ с кодом 0xA)
print_newline:
	push rdi
    mov rdi, 0xA
    call print_char
	pop rdi
    ret
    


; Выводит беззнаковое 8-байтовое число в десятичном формате 
; Совет: выделите место в стеке и храните там результаты деления
; Не забудьте перевести цифры в их ASCII коды.
print_uint:
    push rbx
    mov rax, rdi
    mov rbx, 10
    push r9
    mov r9, rsp
    push 0
    .loop:
        xor rdx, rdx
        div rbx
        add rdx, '0'
        dec rsp
        mov byte [rsp], dl
        test rax, rax
        jnz .loop
    mov rdi, rsp
    call print_string
    mov rsp, r9
    pop r9
    pop rbx
    ret

; Выводит знаковое 8-байтовое число в десятичном формате 
print_int:
    push rdi
    cmp rdi, 0
    jge .out
    mov rdi, '-'
    call print_char
    pop rdi
    neg rdi
	call print_uint
	ret
    .out:
        call print_uint
		pop rdi
    	ret


; Принимает два указателя на нуль-терминированные строки, возвращает 1 если они равны, 0 иначе
string_equals:
	xor rax, rax
    .loop:
        mov al, byte [rdi]
        cmp al, byte [rsi]
        jne .nequals
        inc rdi
        inc rsi
        cmp al, 0
        jne .loop
    .equals:
        mov rax, 1
        ret
    .nequals:
        xor rax, rax
        ret


; Читает один символ из stdin и возвращает его. Возвращает 0 если достигнут конец потока
read_char:
    mov rdi, 0
    mov rdx, 1
    mov rax, 0
    push rax
    mov rsi, rsp
    syscall
    pop rax
    ret


; Принимает: адрес начала буфера, размер буфера
; Читает в буфер слово из stdin, пропуская пробельные символы в начале, .
; Пробельные символы это пробел 0x20, табуляция 0x9 и перевод строки 0xA.
; Останавливается и возвращает 0 если слово слишком большое для буфера
; При успехе возвращает адрес буфера в rax, длину слова в rdx.
; При неудаче возвращает 0 в rax
; Эта функция должна дописывать к слову нуль-терминатор

read_word:
	push r12
	push r13
	push r14
	mov r14, rdi
	mov r12, rsi
	dec r12
	xor r13, r13

	.spaces:
		call read_char
        	cmp rax, 0x20
        	je .spaces
	        cmp rax, 0x9
	        je .spaces
	        cmp rax, 0xA
	        je .spaces
	        cmp rax, 0
	        je .end

	.loop:
		cmp r12, r13
		je .err
		mov byte [r14+r13], al
		inc r13
		call read_char
		cmp rax, 0
		je .end
		cmp rax, 0x20
		je .end
		cmp rax, 0x9
		je .end
		cmp rax, 0xA
		je .end
		jmp .loop

	.err:
		xor rax, rax
		pop r14
		pop r13
		pop r12
		ret

	.end:
		mov rax, r14
		mov rdx, r13
		mov byte[r14+r13], 0
		pop r14
		pop r13
		pop r12
		ret

; reads sentence
read_sentence:
	push r12
	push r13
	push r14
	mov r14, rdi
	mov r12, rsi
	dec r12
	xor r13, r13

	.spaces:
		call read_char
        	cmp rax, 0x20
        	je .spaces
	        cmp rax, 0x9
	        je .spaces
	        cmp rax, 0xA
	        je .spaces
	        cmp rax, 0
	        je .end

	.loop:
		cmp r12, r13
		je .err
		mov byte [r14+r13], al
		inc r13
		call read_char
		cmp rax, 0
		je .end
		cmp rax, 0xA
		je .end
		cmp rax, 0x9
		je .end
		jmp .loop

	.err:
		xor rax, rax
		pop r14
		pop r13
		pop r12
		ret

	.end:
		mov rax, r14
		mov rdx, r13
		mov byte[r14+r13], 0
		pop r14
		pop r13
		pop r12
		ret

; Принимает указатель на строку, пытается
; прочитать из её начала беззнаковое число.
; Возвращает в rax: число, rdx : его длину в символах
; rdx = 0 если число прочитать не удалось
parse_uint:
	push r12
	push r13
	push r14
    xor rax, rax
	xor r12, r12
	xor r13, r13
	mov r14, 10
	
	.loop:
		mov r12b, byte[rdi]
		cmp r12b, '0'
		jb .end
		cmp r12b, '9'
		ja .end
		mul r14
		sub r12b, '0'
		add rax, r12
		inc rdi
		inc r13
		jmp .loop

	.end:
		mov rdx, r13
		pop r14
		pop r13
		pop r12
		ret




; Принимает указатель на строку, пытается
; прочитать из её начала знаковое число.
; Если есть знак, пробелы между ним и числом не разрешены.
; Возвращает в rax: число, rdx : его длину в символах (включая знак, если он был) 
; rdx = 0 если число прочитать не удалось
parse_int:
    cmp byte[rdi], '-'
	jne .positive
	
	inc rdi
	call parse_uint
	cmp rdx, 0
	je .err
	neg rax
	inc rdx
	ret
	.positive:
		call parse_uint
		cmp rdx, 0
		je .err
		ret
	.err:
		xor rdx, rdx
		ret

; Принимает указатель на строку, указатель на буфер и длину буфера
; Копирует строку в буфер
; Возвращает длину строки если она умещается в буфер, иначе 0
string_copy:
	push rdi
	push rsi
	push rdx
	call string_length
	mov r9, rax
	cmp rax, rdx
	ja .nequals
	pop rdx
	pop rsi
	pop rdi
	
	.loop:
		mov al, byte [rdi]
	        mov byte [rsi], al
        	inc rdi
        	inc rsi
        	cmp al, 0
        	je .end
        	jmp .loop
	.end:
		mov rax, r9
		ret
	.nequals:
		mov rax, 0
		pop rdx
		pop rsi
		pop rdi
		ret
