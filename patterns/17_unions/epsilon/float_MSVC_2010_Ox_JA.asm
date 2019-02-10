tv130 = 8	
_v$ = 8		
_start$ = 8	
_calculate_machine_epsilon PROC
	fld	DWORD PTR _start$[esp-4]
	fst	DWORD PTR _v$[esp-4]     ; この命令は冗長
	inc	DWORD PTR _v$[esp-4]
	fsubr	DWORD PTR _v$[esp-4]
	fstp	DWORD PTR tv130[esp-4]   ; \verb|\ この命令ペアも冗長|
	fld	DWORD PTR tv130[esp-4]   ; \verb|/                   |
	ret	0
_calculate_machine_epsilon ENDP
