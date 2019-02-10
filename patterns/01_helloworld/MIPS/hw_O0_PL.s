$LC0:
	.ascii	"Hello, world!\012\000"
main:
; prolog f-cji
; odłożyć RA (\$31) i FP na stos:
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
; ustawić FP (stack frame pointer):
	move	$fp,$sp
; ustawić GP:
	lui	$28,%hi(__gnu_local_gp)
	addiu	$28,$28,%lo(__gnu_local_gp)
; załadować adres linii tekstowej:
	lui	$2,%hi($LC0)
	addiu	$4,$2,%lo($LC0)
; załadować adres f-cji puts() korzystając z GP:
	lw	$2,%call16(puts)($28)
	nop
; wywołać puts():
	move	$25,$2
	jalr	$25
	nop  ; branch delay slot

; przywrócić GP ze stosu lokalnego:
	lw	$28,16($fp)
; ustawić rejestr \$2 (\$V0) na zero:
	move	$2,$0
; epilog funkcji.
; przywrócić SP:
	move	$sp,$fp
; przywrócić RA:
	lw	$31,28($sp)
; przywrócić FP:
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
; przejście do RA:
	j	$31
	nop  ; branch delay slot
