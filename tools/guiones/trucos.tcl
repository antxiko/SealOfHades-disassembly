# TAB y CAPS sostenidas al acabar la presentacion de CASIO (0xE03A = 2: el aire no mata; 0xE039 = 2: LEON sin
# fin) y una partida larga con el piloto. 30000 cuadros.
source [file join [file dirname [info script]] piloto.tcl]
proc toca {fila bit} {
    keymatrixdown $fila $bit
    after time 0.08 "keymatrixup $fila $bit"
}
proc guion {n} {
    if {$n < 280} { keymatrixdown 7 0x08; keymatrixdown 6 0x08 } elseif {$n == 280} { keymatrixup 7 0x08; keymatrixup 6 0x08 }
    if {[m 0xE000] == 0} {
        keymatrixup 8 0xF1
        if {$n == 300} { toca 8 0x01 }
        return [expr {$n >= 30000}]
    }
    piloto $n
    return [expr {$n >= 30000}]
}
