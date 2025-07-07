@echo off
setlocal enabledelayedexpansion

:: === WARNING: Giga Nerd Zone ===
:: proceed only if you have at least 2 brain cells and a dream

:: ==== Tools ====
set NASM=nasm              :: the almighty assembler
set QEMU=qemu-system-i386  :: qemu i386 emulator

:: ==== File names ====
set BOOTLOADER=bootloader.asm  :: BIOS says hi
set KERNEL=kernel.asm          :: the meat of the sandwich
set BOOTBIN=bootloader.bin     :: bootloader but it's binary now
set KERNELBIN=kernel.bin       :: kernel.exe but ancient
set IMAGE=floppy.img           :: because we like pain and nostalgia
set PADDING=pad.bin            :: pure zeroes, like my attention span

:: ==== Image size ====
set FLOPPY_SIZE=1474560        :: 1.44MB of raw 90s power
:: make it 1.44MB cuz it aint 1994 without them
:: basically just vibes and tiny storage

:: ==== Cleanup ====
echo [*] Cleaning old files...
:: basically remove the shit i spilled
del %BOOTBIN% 2>nul            :: bye bootloader
del %KERNELBIN% 2>nul          :: bye kernel
del %IMAGE% 2>nul              :: bye floppy
del %PADDING% 2>nul            :: bye zeroes

:: ==== Assemble bootloader ====
echo [*] Assembling bootloader...
%NASM% -f bin %BOOTLOADER% -o %BOOTBIN%
if errorlevel 1 goto error     :: if NASM cries, we die

:: ==== Assemble kernel ====
echo [*] Assembling kernel...
%NASM% -f bin %KERNEL% -o %KERNELBIN%
if errorlevel 1 goto error     :: same deal, don't mess it up

:: ==== Create floppy image ====
echo [*] Creating floppy image...
copy /b %BOOTBIN%+%KERNELBIN% %IMAGE% >nul  		:: i have no idea what this does but ok

:: Pad image to 1.44MB
fsutil file createnew %PADDING% %FLOPPY_SIZE% :: generate pure zeros from the void
copy /b %IMAGE%+%PADDING% padded.img >nul     :: fatten the floppy
move /y padded.img %IMAGE% >nul              :: overwrite original like a savage
del %PADDING%                                :: burn the evidence

:: ==== Boot with QEMU ====
echo [*] Booting in QEMU...
%QEMU% -fda %IMAGE% -boot a -m 64             :: slap it into QEMU, pray for BIOS

goto end

:error
echo [✘] Build failed!
echo [ts pmo icl gng] Congratulations, you got cooked!
pause
goto end

:end
endlocal
