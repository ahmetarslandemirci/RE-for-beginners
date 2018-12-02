get_from_array:
; $4 = idx
        srl     $2,$4,1
; $2 = $4>>1 = idx>>1
        lui     $28,%hi(__gnu_local_gp)
        sll     $3,$2,1
; $3 = $2<<1 = (idx>>1)<<1 = idx&(~1)
        andi    $4,$4,0x1
; $4 = $4&1 = idx&1
        addiu   $28,$28,%lo(__gnu_local_gp)

; sauter si $4 (idx&1) n'est pas §zéro§ (si idx est impair):
        bne     $4,$0,$L6
; $2 = $3+$2 = idx>>1 + idx&(~1) = idx*1.5
        addu    $2,$3,$2 ; §slot de délai de branchement - cette instruction est exécutée avant BNE§

; idx est pair, continuer
        lw      $3,%got(array)($28)
; $3 = array
        nop
        addu    $2,$3,$2
; $2 = $3+$2 = array + idx*1.5
; charger l'octet en $2+0 = array + idx*1.5 (octet de gauche)
        lbu     $3,0($2)
; $3 = octet de gauche
; charger l'octet en $2+1 = array + idx*1.5+1 (octet du milieu):
        lbu     $2,1($2)
; $2 = octet du milieu
        sll     $3,$3,4
; $3 = $3<<4 = left_byte<<4
        srl     $2,$2,4
; $2 = $2>>4 = middle_byte>>4
        j       $31
        or      $2,$2,$3 ; §slot de délai de branchement - cette instruction est exécutée avant J§
; $2 = $2|$3 = middle_byte>>4 | left_byte<<4
; $2=§résultat renvoyé§

$L6:
; idx est impair, continuer:
        lw      $3,%got(array)($28)
; $3 = array
        nop
        addu    $2,$3,$2
; $2 = $3+$2 = array + idx*1.5
; charger l'octet en $2+1 = array + idx*1.5 + 1 (octet du milieu)
        lbu     $4,1($2)
; $4 = octet du milieu
; charger l'octet en $2+1 = array + idx*1.5 + 2 (octet de droite)
        lbu     $3,2($2)
; $3 = octet de droite
        andi    $2,$4,0xf
; $2 = $4&0xF = middle_byte&0xF
        sll     $2,$2,8
; $2 = $2<<8 = middle_byte&0xF << 8
        j       $31
        or      $2,$2,$3 ; §slot de délai de branchement - cette instruction est exécutée avant J§
; $2 = $2|$3 = middle_byte&0xF << 8 | right byte
; $2=§résultat renvoyé§
