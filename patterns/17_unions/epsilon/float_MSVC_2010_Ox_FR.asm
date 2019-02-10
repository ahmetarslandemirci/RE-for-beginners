tv130 = 8
_v$ = 8
_start$ = 8
_calculate_machine_epsilon PROC
	fld	DWORD PTR _start$[esp-4]
	fst	DWORD PTR _v$[esp-4]     ; cette instruction est redondante
	inc	DWORD PTR _v$[esp-4]
	fsubr	DWORD PTR _v$[esp-4]
	fstp	DWORD PTR tv130[esp-4]   ; \verb|\ cette paire d'instructions est aussi redondante|
	fld	DWORD PTR tv130[esp-4]   ; \verb|/                                                |
	ret	0
_calculate_machine_epsilon ENDP
