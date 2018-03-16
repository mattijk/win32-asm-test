@echo off

set name=helloworld

if %1x==x goto end
goto %1

:release
nasm -f win32 %name%.asm
gcc -o %name%.exe %name%.obj c:\Windows\System32\user32.dll c:\Windows\System32\kernel32.dll -nostdlib -s
goto end

:debug
nasm -f win32 -g %name%.asm
gcc -o %name%.exe %name%.obj c:\Windows\System32\user32.dll c:\Windows\System32\kernel32.dll -nostdlib
goto end

:clean
del %name%.exe
del %name%.obj
goto end

:end
