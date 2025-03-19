; Autor reseni: ales urbanek xurbana00

; Projekt 2 - INP 2024
; Vigenerova sifra na architekture MIPS64

; DATA SEGMENT
                .data
msg:            .asciiz "alesurbanek" ; sem doplnte vase "jmenoprijmeni"
cipher:         .space  31 ; misto pro zapis zasifrovaneho textu
; zde si muzete nadefinovat vlastni promenne ci konstanty,
; napr. hodnoty posuvu pro jednotlive znaky sifrovacho klice

params_sys5:    .space  8 ; misto pro ulozeni adresy pocatku
                          ; retezce pro vypis pomoci syscall 5
                          ; (viz nize "funkce" print_string)

; CODE SEGMENT
                .text

main:           ; ZDE NAHRADTE KOD VASIM RESENIM
                addi    r1, r0, 1                 ; Registr pro porovnavani 2. posunu
                addi    r2, r0, 2                 ; Registr pro porovnavani 3. posunu

                addi    r5, r0, 21                ; Posun pro 'u' (ASCII - 117)
                addi    r6, r0, 18                ; Posun pro 'r' (ASCII - 114)
                addi    r7, r0, 2                 ; Posun pro 'b' (ASCII - 98)

                addi    r8, r0, 3                 ; Delka klice (3 - "urb")

shift_loop:
                lb      r17, msg(r3)              ; Nacteni znaku zpravy
                ; Kontrola konce zpravy
                beqz    r17, end                  ; Pokud r17 == 0, skoci na end

                beq     r14, r0, set_U            ; Pokud r14 == 0, pouzij posun pro U
                beq     r14, r1, set_R            ; Pokud r14 == 1, pouzij posun pro R
                beq     r14, r2, set_B            ; Pokud r14 == 2, pouzij posun pro B

set_U:
                beqz    r16, shift_U_pos          ; Pokud r16 == 0, pouzij pozitivni posun
                sub     r17, r17, r5              ; Negativni posun
                j       check_underflow
shift_U_pos:
                add     r17, r17, r5              ; Pozitivni posun
                j       check_overflow

set_R:
                beqz    r16, shift_R_pos          ; Pokud r16 == 0, pouzij pozitivni posun
                sub     r17, r17, r6              ; Negativni posun
                j       check_underflow
shift_R_pos:
                add     r17, r17, r6              ; Pozitivni posun
                j       check_overflow

set_B:
                beqz    r16, shift_B_pos          ; Pokud r16 == 0, pouzij pozitivni posun
                sub     r17, r17, r7              ; Negativni posun
                j       check_underflow
shift_B_pos:
                add     r17, r17, r7              ; Pozitivni posun
                j       check_overflow

check_overflow:
                ; Kontrola preteceni
                addi    r20, r0, 122
                slt     r20, r17, r20     
                bnez    r20, continue_processing  ; Pokud r17 < 122, pokracuj
                addi    r17, r17, -26             ; Korekce preteceni
                j       continue_processing

check_underflow:
                ; Kontrola podteceni
                slti    r20, r17, 97
                beqz    r20, continue_processing  ; Pokud r17 > 97, pokracuj
                addi    r17, r17, 26              ; Korekce podteceni
                j       continue_processing

continue_processing:
                sb      r17, cipher(r3)           ; Uloz posunuty znak
                addi    r3, r3, 1                 ; Prejdi na dalsi znak (posun indexu zpravy)

                addi    r14, r14, 1               ; Prejdi na dalsi posun
                div     r14, r8                   ; (aktualni iterace cyklu) r14 / (pocet znaku klice) r8
                mfhi    r14                       ; Zbytek z predchoziho deleni (r14 % r8 = (0,1,2), pro urceni posunu
                xori    r16, r16, 1               ; Invertuj smer +/- posunu
                j       shift_loop          

end:
                daddi   r4, r0, cipher            ; vozrovy vypis: adresa msg do r4
                jal     print_string              ; vypis pomoci print_string - viz nize


; NASLEDUJICI KOD NEMODIFIKUJTE!

                syscall 0   ; halt

print_string:   ; adresa retezce se ocekava v r4
                sw      r4, params_sys5(r0)
                daddi   r14, r0, params_sys5    ; adr pro syscall 5 musi do r14
                syscall 5   ; systemova procedura - vypis retezce na terminal
                jr      r31 ; return - r31 je urcen na return address
