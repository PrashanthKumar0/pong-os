@echo off

nasm -i include -f bin ./src/pong-os.asm -o pong-os.bin
qemu-system-x86_64.exe -full-screen ./pong-os.bin