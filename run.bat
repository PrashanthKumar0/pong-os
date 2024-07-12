@echo off

nasm -f bin ./jump-os.asm
qemu-system-x86_64.exe -full-screen ./jump-os