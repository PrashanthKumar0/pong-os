@echo off

nasm -f bin ./pong-os.asm
qemu-system-x86_64.exe -full-screen ./pong-os