# GRABACION FORZADA, con TAB y CAPS (sin morir y LEON sin fin): en el 1000, la escena 3 (0xE003 = 3) y F1 (el
# protagonista cae y la escena empieza otra vez: ya la 3); en el 2500, la 4; en el 4000, la 5; en el 5500, la escena
# 5 dada por acabada (0xE184 = 1): el final. El piloto juega entre medias. Hasta 9000 cuadros.
source [file join [file dirname [info script]] piloto.tcl]
proc pon {a v} { debug write memory $a $v }
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.08 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {$n < 280} { keymatrixdown 7 0x08; keymatrixdown 6 0x08 } elseif {$n == 280} { keymatrixup 7 0x08; keymatrixup 6 0x08 }
    if {$n == 300} { toca 8 0x01 }
    if {$n == 1000} { pon 0xE003 3; toca 6 0x20 }
    if {$n == 2500} { pon 0xE003 4; toca 6 0x20 }
    if {$n == 4000} { pon 0xE003 5; toca 6 0x20 }
    if {$n == 5500} { pon 0xE184 1 }
    if {[m 0xE000] == 1 && $n < 5500} { piloto $n }
    return [expr {$n >= 9000}]
}
