%macro colon 2

%2:
	%ifdef dlink
		dq dlink
	%else 
		dq 0
	%endif
	
	db %1, 0
	
	%define dlink %2
%endmacro
