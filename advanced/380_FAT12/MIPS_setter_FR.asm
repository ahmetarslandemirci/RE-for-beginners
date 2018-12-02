put_to_array:
; $4=idx
; $5=val
        srl     $2,$4,1
; $2 = $4>>1 = idx>>1
        lui     $28,%hi(__gnu_local_gp)
        sll     $3,$2,1
; $3 = $2<<1 = (idx>>1)<<1 = idx&(~1)
        andi    $4,$4,0x1
; $4 = $4&1 = idx&1
        addiu   $28,$28,%lo(__gnu_local_gp)
; sauter si $4=idx&1 n'est pas §zéro§ (i.e., si idx est impair):
        bne     $4,$0,$L11
        addu    $2,$3,$2 ;§ slot de délai de branchement, cette instruction est exécutée avant BNE§
; $2 = $3+$2 = idx&(~1) + idx>>1 = idx*1.5

; idx est pair, continuer
        lw      $3,%got(array)($28)
; $3 = array
        addiu   $4,$2,1
; $4 = $2+1 = idx*1.5+1, i.e., offset de l'octet du milieu dans array
        srl     $6,$5,4
; $6 = $5>>4 = val>>4
        addu    $2,$3,$2
; $2 = $3+$2 = array + idx*1.5 (offset de l'octet de gauche)
; stocker $6 (val>>4) comme octet de gauche:
        sb      $6,0($2)
        addu    $2,$3,$4
; $2 = $3+$4 = array + idx*1.5 + 1 (adresse absolue de l'octet du milieu)
; charger l'octet du milieu en $2+0 = array + idx*1.5 + 1
        lbu     $3,0($2)
; $3 = octet du milieu
        andi    $5,$5,0xf
; $5 = $5&0xF = val&0xF
        andi    $3,$3,0xf
; $3 = $3&0xF = middle_byte&0xF
        sll     $5,$5,4
; $5 = $5<<4 = (val&0xF)<<4
        or      $5,$3,$5
; $5 = $3|$5 = middle_byte&0xF | (val&0xF)<<4 (nouvelle version de l'octet du milieu)
        j       $31
; stocker $5 (nouvel octet du milieu) en $2 (array + idx*1.5 + 1)
        sb      $5,0($2) ;§ slot de délai de branchement, cette instruction est exécutée avant J§

$L11:
; idx est impair, continuer
        lw      $4,%got(array)($28)
; $4 = array
        addiu   $3,$2,1
; $3 = $2+1 = idx*1.5+1 (offset de l'octet du milieu)
        addu    $3,$4,$3
; $3 = $4+$3 = array + idx*1.5+1
; charger l'octet du milieu en $3 (array + idx*1.5+1)
        lbu     $6,0($3)
; $6 = octet du milieu
        srl     $7,$5,8
; $7 = $5>>8 = val>>8
        andi    $6,$6,0xf0
; $6 = $6&0xF0 = middle_byte&0xF0
        or      $6,$6,$7
; $6 = $6|$7 = middle_byte&0xF0 | val>>8
        addu    $2,$4,$2
; stocker l'octet du milieu mis §à§ jour en $3 (array + idx*1.5+1)
        sb      $6,0($3)
        j       $31
; stocker les 8 bits bas de val en $2+2=idx*1.5+2 (emplacement de l'octet de droite)
        sb      $5,2($2) ;§ slot de délai de branchement, cette instruction est exécutée avant J§

