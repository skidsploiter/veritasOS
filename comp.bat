@echo off
setlocal enabledelayedexpansion

:: ==== Tools ====
set NASM=nasm
set QEMU=qemu-system-i386

:: ==== File names ====
set BOOTLOADER=bootloader.asm
set KERNEL=kernel.asm
set BOOTBIN=bootloader.bin
set KERNELBIN=kernel.bin
set IMAGE=floppy.img
set PADDING=pad.bin

:: ==== Image size ====
set FLOPPY_SIZE=1474560

:: ==== Cleanup ====
echo [*] Cleaning old files...
del %BOOTBIN% 2>nul
del %KERNELBIN% 2>nul
del %IMAGE% 2>nul
del %PADDING% 2>nul

:: ==== Assemble bootloader ====
echo [*] Assembling bootloader...
%NASM% -f bin %BOOTLOADER% -o %BOOTBIN%
if errorlevel 1 goto error

:: ==== Assemble kernel ====
echo [*] Assembling kernel...
%NASM% -f bin %KERNEL% -o %KERNELBIN%
if errorlevel 1 goto error

:: ==== Create floppy image ====
echo [*] Creating floppy image...
copy /b %BOOTBIN%+%KERNELBIN% %IMAGE% >nul

:: Pad image to 1.44MB
fsutil file createnew %PADDING% %FLOPPY_SIZE%
copy /b %IMAGE%+%PADDING% padded.img >nul
move /y padded.img %IMAGE% >nul
del %PADDING%

:: ==== Boot with QEMU ====
echo [*] Booting in QEMU...
%QEMU% -fda %IMAGE% -boot a -m 64

goto end

:error
echo [✘] Build failed!
pause
goto end

:end
endlocal
