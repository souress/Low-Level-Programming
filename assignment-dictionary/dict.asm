extern string_equals
extern string_length

global find_word

;Принимает указатель на нуль-терминированную строку (rdi)
;						и указатель на начало словаря (rsi)
;Если слово найдено, вернёт адрес, иначе вернёт 0

find_word:
	test	rsi, rsi
	je		.not_found
	
	.loop:
		push	rdi
		push	rsi
		add		rsi, 8
		call	string_equals
		pop		rsi
		pop		rdi
		
		test	rax, rax
		jnz		.found
		mov		rsi, [rsi]
		test 	rsi, rsi
		je		.not_found
		jmp		.loop
	
	.found:
		call	string_length
		add		rsi, 9
		add 	rax, rsi
		ret
	
	.not_found:
		xor 	rax, rax
		ret
