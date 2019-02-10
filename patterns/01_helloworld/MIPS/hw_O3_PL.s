$LC0:
; \textbackslash{}000 to zero w systemie ósemkowym:
	.ascii	"Hello, world!\012\000"
main:
; prolog funkcji
; ustawić GP:
	lui	$28,%hi(__gnu_local_gp)
	addiu	$sp,$sp,-32
	addiu	$28,$28,%lo(__gnu_local_gp)
; odłożyć RA na stos lokalny:
	sw	$31,28($sp)
; załadować adres f-cji puts() z GP do \$25:
	lw	$25,%call16(puts)($28)
; załadować adres linii tekstowej do \$4 (\$a0):
	lui	$4,%hi($LC0)
; przejść do puts(), zapisując adres powrotu do link-rejestru:
	jalr	$25
	addiu	$4,$4,%lo($LC0) ; branch delay slot
; przywrócić RA:
	lw	$31,28($sp)
; skopiować 0 z \$zero do \$v0:
	move	$2,$0
; zwrócić zarządzanie robiąc przejście pod adres zawarty w RA:
	j	$31
; epilog funkcji:
	addiu	$sp,$sp,32 ; branch delay slot + zwolnić stos od zmiennych lokalnych

