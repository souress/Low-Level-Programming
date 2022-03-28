%include "colon.inc"
%include "lib.inc"
extern find_word

global _start

section .rodata
	%include "words.inc"
	not_found_err: db "Совпадений не найдено", 0
	invalid_key_err: db "Некорректное значение ключа!", 0

section .bss
	str_buffer: resb 256

section .text
	_start:
		mov rdi, str_buffer
		mov rsi, 256		
		call read_sentence
		cmp rax, 0
		je .invalid_key

		mov rsi, dlink
		mov rdi, str_buffer
		call find_word
		cmp rax, 0
		je .not_found

		mov rdi, rax
		call print_newline
		call print_string
		call print_newline
		call exit
	
	.invalid_key:
		call print_newline
		mov rdi, invalid_key_err
		jmp .write_error
	
	.not_found:
		call print_newline
		mov rdi, not_found_err

	.write_error:
		call print_error
		call print_newline
		call exit
