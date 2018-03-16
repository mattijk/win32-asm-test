    global  main
    extern  _GetStdHandle
    extern  _ReadConsoleA
    extern  _WriteConsoleA
    extern  _MessageBoxA
    extern  _ExitProcess

    NULL                equ 0

    STD_INPUT_HANDLE    equ -10
    STD_OUTPUT_HANDLE   equ -11
    STD_ERROR_HANDLE    equ -12

    MB_OK               equ 0x00000000
    MB_YESNO            equ 0x00000004
    MB_ICONEXCLAMATION  equ 0x00000030
    MB_ICONINFORMATION  equ 0x00000040
    MB_ICONQUESTION     equ 0x00000020
    MB_ICONSTOP         equ 0x00000010
    IDOK                equ 01
    IDCANCEL            equ 02
    IDABORT             equ 03
    IDRETRY             equ 04
    IDIGNORE            equ 05
    IDYES               equ 06
    IDNO                equ 07
    IDTRYAGAIN          equ 10
    IDCONTINUE          equ 11

    section .text

main:
    mov     ebp, esp
    sub     esp, 4                  ; reserve a place for a local variable from the stack

    push    STD_INPUT_HANDLE
    call    _GetStdHandle
    push    NULL
    lea     ebx, [ebp-4]
    push    ebx
    push    128
    push    buffer
    push    eax
    call    _ReadConsoleA

    push    STD_OUTPUT_HANDLE
    call    _GetStdHandle
    push    NULL
    lea     ebx, [ebp-4]
    push    ebx
    push    DWORD [ebp-4]
    push    buffer
    push    eax
    call    _WriteConsoleA

    mov     eax, [ebp-4]            ; get a value from the local variable
    mov     BYTE [buffer+eax], 0

    push    DWORD MB_OK
    push    DWORD caption
    push    DWORD buffer
    push    DWORD NULL
    call    _MessageBoxA

    add     esp, 4                  ; "free" the local variable

    push    0
    call    _ExitProcess

    section .data

caption:
    db      'Hello, World!', 0

    section .bss

buffer:
    resb    128

; Building a release binary:
;   nasm -f win32 helloworld.asm
;   gcc -o helloworld.exe helloworld.obj c:\Windows\System32\user32.dll c:\Windows\System32\kernel32.dll -nostdlib -s
;
; Building a debug binary:
;   nasm -f win32 -g test.asm
;   gcc -o test.exe test.obj C:\Windows\System32\kernel32.dll -nostdlib
;
; gdb tips:
;   "gdb test.exe"
;   "set disassembly-flavor intel" sets Intel format for assembly code
;   "set disassemble-next-line on" orders gdb to show assembly language line, when stepping the code
;   "disas main" list disassembled main function
;   "b main" or "b *0x0040100c" sets a breakpoint to the beginning of the main function or to the specified address
;   "run"
;   "i r" shows register contents
;   "x/8xb 0x402000" shows memory contents at given address, 8bytes in hexadecimal format
