# piloto.tcl - un jugador sencillo para The Seal of Hades: la barra (el disparo) 2 cuadros de cada 6; la palanca
# arriba casi siempre (por encima de la Y 0x78 la pantalla avanza) y, cada 40 cuadros, un rato a un lado (al azar,
# hacia el centro si esta cerca de un borde); si un enemigo (0xE380) baja cerca por encima, se aparta.
proc m {a} { return [debug read memory $a] }
expr {srand(7)}
set ::lado 0
proc piloto {n} {
    if {$n % 6 == 0} { keymatrixdown 8 0x01 }
    if {$n % 6 == 2} { keymatrixup 8 0x01 }
    if {$n % 40 == 0} {
        set x [m 0xE321]
        set r [expr {rand()}]
        if {$x < 0x30} { set ::lado 2 } elseif {$x > 0x80} { set ::lado 1 } elseif {$r < 0.4} { set ::lado 1 } elseif {$r < 0.8} { set ::lado 2 } else { set ::lado 0 }
    }
    keymatrixup 8 0xF0
    set y [m 0xE320]
    if {$y > 0x70} { keymatrixdown 8 0x20 } elseif {$y < 0x60} { keymatrixdown 8 0x40 }
    if {$n % 40 < 16} {
        if {$::lado == 1} { keymatrixdown 8 0x10 }
        if {$::lado == 2} { keymatrixdown 8 0x80 }
    }
}
