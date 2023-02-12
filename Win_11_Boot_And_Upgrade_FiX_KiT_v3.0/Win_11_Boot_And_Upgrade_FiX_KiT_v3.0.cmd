@echo off

REM change wording if needed..
TITLE Admin Check...
echo Checking for admin...

if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b)

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
cls
::Options to set by dev
SET "Version=v3.0"
SET "UFWS_version=v1.4"
::Options to set by the user
SET "EI_CFG_ADD=1"
SET "Boot_WIM_Opt=1"
SET "DPaA=1"

TITLE Win 11 Boot ^& Upgrade FiX KiT %version% By Enthousiast ^@MDL...

::Detect OS Architecture
reg Query "HKLM\Hardware\Description\System\CentralProcessor\0" | find /i "x86" > NUL && ( set "arch=x86" ) || ( set "arch=x64" )

if %arch%==x86 (
  set "_wimlib=bin\wimlib-imagex.exe"
  set "xOS=x86"
) else (
  set "_wimlib=bin\bin64\wimlib-imagex.exe"
  set "xOS=amd64"
)

:Preparing
if exist "Work" rmdir /q /s "WORK"
if exist "TEMP" rmdir /q /s "TEMP"

md "WORK"
md "TEMP"

echo.
echo ============================================================
echo Win 11 Boot ^& Upgrade FiX KiT %version% By Enthousiast ^@MDL...
echo ============================================================
echo.

:Loop
SET "FiX="
echo.
echo=================================================================================
ECHO Select the desired FiX...
echo=================================================================================
echo.
ECHO [ 1 ] This option mainly utilizes UFWS %UFWS_version% (recommended option).
ECHO.
ECHO - It circumvents all Win 11 minimum requirements (CPU-RAM-Disksize-TPM-Secureboot).
ECHO - This works for clean installs and upgrade scenarios using standard setup.
IF /I "%DPaA%" NEQ "1" (
    ECHO - You have chosen to NOT integrate the Diskpart ^& Apply Image script ^(v1.3.1^).
) ELSE (
    ECHO - Integrates the Diskpart ^& Apply Image script ^(v1.3.1^).
)
IF /I "%EI_CFG_ADD%" NEQ "1" (
    ECHO - You have chosen to NOT copy the generic EI.CFG file.
) ELSE (
    ECHO - A generic EI.CFG file will be copied to the sources folder.
)
ECHO.
echo=================================================================================
ECHO.
ECHO [ 2 ] - This option modifies boot.wim registry to skip the SB, RAM, DiskSize and
ECHO  TPM 2.0 check and replaces ^"appraiserres.dll^" with one from Win 10
ECHO  ^(You can insert your own in the Files folder, by default it's one from a 15063 ISO^).
IF /I "%DPaA%" NEQ "1" (
    ECHO - You have chosen to NOT integrate the Diskpart ^& Apply Image script ^(v1.3.1^).
) ELSE (
    ECHO - Integrates the Diskpart ^& Apply Image script ^(v1.3.1^).
)
IF /I "%EI_CFG_ADD%" NEQ "1" (
    ECHO - You have chosen to NOT copy the generic EI.CFG file.
) ELSE (
    ECHO - A generic EI.CFG file will be copied to the sources folder.
)
ECHO.
ECHO This method enables you to:
echo.
ECHO - Use the standard Win 11 setup for clean installs on devices without:
ECHO Secure Boot, TPM 2.0, DiskSize ^<52GB ^& RAM ^<8GB.
ECHO - Use the alternative Diskpart ^& Apply Image installation script for clean installs.
ECHO - Circumvent ^"TPM 2.0 is required^" error when ^(inplace^) upgrading.
ECHO - Enables to install on LegacyBIOS^/MBR only systems.
ECHO - Circumvents the 64GB ^(52GB^) minimum disk size check.
ECHO.
echo=================================================================================
ECHO.
ECHO [ 3 ] - This option combines option 1 and option 2.
ECHO.
echo=================================================================================
ECHO.
ECHO This only applies to Option 1, 2 and 3!!!
echo.
ECHO - For when public release (all Win 7/8/10) to DEV channel release ISO upgrades fails,
ECHO i've put in a cmd called "Upgrade_Fail_Fix.cmd", run this as admin,
ECHO after rebooting you can simply run standard setup.
ECHO.
echo=================================================================================
ECHO.
ECHO [ 4 ] - Puts the Win 11 install.wim/esd in a Win 10 ISO.
ECHO (Provide a Win 10 ISO in the "Source_ISO\W10\" Folder).
ECHO.
ECHO - This method is useful for clean installs from boot, using the standard W10 setup.
IF /I "%EI_CFG_ADD%" NEQ "1" (
    ECHO - You have chosen to NOT copy the generic EI.CFG file.
) ELSE (
    ECHO - A generic EI.CFG file will be copied to the sources folder.
)
ECHO.
echo=================================================================================
ECHO.
SET "CHOICE="
SET /P CHOICE="* Type your option and press Enter: "
IF /I '%CHOICE%'=='1' SET "FiX=1"
IF /I '%CHOICE%'=='2' SET "FiX=2"
IF /I '%CHOICE%'=='3' SET "FiX=3"
IF /I '%CHOICE%'=='4' SET "FiX=4"

IF NOT DEFINED FiX GOTO :Loop

if not exist "Source_ISO\W11\*.iso" (
echo.
ECHO==========================================================
echo No iso file detected in Source_ISO^\W11 dir...
ECHO==========================================================
echo.
GOTO :cleanup
)

IF /I "%FiX%" NEQ "4" GOTO :RESUME1

if not exist "Source_ISO\W10\*.iso" (
echo.
ECHO==========================================================
echo No iso file detected in Source_ISO^\W10 dir...
ECHO==========================================================
echo.
GOTO :cleanup
)

:RESUME1

for /f "delims=" %%i in ('dir /b Source_ISO\W11\*.iso') do bin\7z.exe e -y -oTEMP "Source_ISO\W11\%%i" sources\setup.exe >nul
bin\7z.exe l .\TEMP\setup.exe >.\TEMP\version.txt 2>&1
for /f "tokens=4 delims=. " %%i in ('findstr /i /b FileVersion .\TEMP\version.txt') do set vermajor=%%i

bin\7z.exe l .\Files\appraiserres.dll >.\TEMP\version2.txt 2>&1
for /f "tokens=4 delims=. " %%i in ('findstr /i /b FileVersion .\TEMP\version2.txt') do set Appraiserres_Version=%%i

for /f "tokens=4,5 delims=. " %%i in ('findstr /i /b FileVersion .\TEMP\version.txt') do (set majorbuildnr=%%i&set deltabuildnr=%%j)

IF NOT DEFINED vermajor (
if exist "TEMP" rmdir /q /s "TEMP"
echo.
ECHO==========================================================
echo Detecting setup.exe version failed...
ECHO==========================================================
echo.
pause
exit /b
)

SET "Winver="

IF %vermajor% GEQ 19041 SET "Winver=10"
IF %vermajor% GEQ 21996 SET "Winver=11"


IF NOT DEFINED Winver (
if exist "TEMP" rmdir /q /s "TEMP"
echo.
ECHO==========================================================
echo Unsupported iso version...
ECHO==========================================================
echo.
pause
exit /b
)

IF %vermajor% GEQ 21996 SET "BUILD=22000"

IF NOT DEFINED BUILD (
echo.
ECHO==========================================================
echo Unsupported Win10 build...
ECHO==========================================================
echo.
pause
exit /b
)

If /I "%FiX%"=="4" GOTO :FiX4

echo.
ECHO==========================================================
echo Extracting Source ISO...
ECHO==========================================================
echo.
bin\7z x -y -oWork\ Source_ISO\W11\
echo.
Goto :RESUME2

:FiX4
echo.
echo ============================================================
echo Extracting Win 10 Source ISO...
echo ============================================================
echo.
bin\7z x -y -oWork\ Source_ISO\W10\ -x!sources\install.*
echo.
echo ============================================================
echo Extracting Win 11 install.wim^/esd to work dir...
echo ============================================================
echo.
for /f %%i in ('dir /b Source_ISO\W11\*.iso') do bin\7z.exe e -y -o"WORK\Sources" "Source_ISO\W11\%%i" sources\install.* >nul
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO You have chosen to NOT copy the generic EI.CFG file.
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.
IF /I "%EI_CFG_ADD%" NEQ "1" echo ^(If exists, the original file will remain on the ISO^)
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.

IF /I "%EI_CFG_ADD%" NEQ "1" GOTO :RESUME2
echo.
echo ============================================================
echo Copying the generic ei.cfg to the work dir...
echo ^(If exists, the original file will be renamed to EI.CFG.Ori^)
echo ============================================================
echo.
IF EXIST "WORK\Sources\EI.CFG" ren "WORK\Sources\EI.CFG" "EI.CFG.Ori"
COPY /Y "Files\EI.CFG" "WORK\Sources\"
echo.

:RESUME2

if exist "Work\sources\install.wim" set WIMFILE=install.wim
if exist "Work\sources\install.esd" set WIMFILE=install.esd

if exist "Work\sources\install.swm" (
echo ============================================================
echo Install.swm file is not supported...
echo ============================================================
echo.
goto :cleanup
)

REM detect wim arch
: detectwimarch
for /f "tokens=2 delims=: " %%# in ('dism.exe /english /get-wiminfo /wimfile:"Work\sources\%WIMFILE%" /index:1 ^| find /i "Architecture"') do set warch=%%#

for /f "tokens=3 delims=: " %%m in ('dism.exe /english /Get-WimInfo /wimfile:"Work\sources\%WIMFILE%" /Index:1 ^| findstr /i Build') do set b2=%%m

:Win11Lang
REM detect extracted win11 iso language
set "IsoLang=ar-SA,bg-BG,cs-CZ,da-DK,de-DE,el-GR,en-GB,en-US,es-ES,es-MX,et-EE,fi-FI,fr-CA,fr-FR,he-IL,hr-HR,hu-HU,it-IT,ja-JP,ko-KR,lt-LT,lv-LV,nb-NO,nl-NL,pl-PL,pt-BR,pt-PT,ro-RO,ru-RU,sk-SK,sl-SI,sr-RS,sv-SE,th-TH,tr-TR,uk-UA,zh-CN,zh-TW"
for %%i in (%IsoLang%) do if exist "Work\sources\%%i\*.mui" set %%i=1

REM set ISO label lang
for %%i in (%IsoLang%) do if defined %%i (
SET "LabelLang=%%i"
)

If /I "%FiX%"=="4" GOTO :ISO_FiX4
IF /I "%FiX%"=="2" GOTO :FIX2

:FiX1
echo.
echo ============================================================
Echo Applying UFWS %UFWS_version% to circumvent CPU-RAM-Disksize-TPM-Secureboot checks to %WIMFILE%
echo ============================================================
for /f "tokens=3 delims=: " %%i in ('%_wimlib% info Work\sources\%WIMFILE% ^| findstr /c:"Image Count"') do set images=%%i
for /L %%i in (1,1,%images%) do (
  %_wimlib% info "Work\sources\%WIMFILE%" %%i --image-property WINDOWS/INSTALLATIONTYPE=Server >nul
)
echo.
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO You have chosen to NOT copy the generic EI.CFG file.
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.
IF /I "%EI_CFG_ADD%" NEQ "1" echo ^(If exists, the original file will remain on the ISO^)
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.

IF /I "%EI_CFG_ADD%" NEQ "1" GOTO :Continue1
echo.
echo ============================================================
echo Copying the generic ei.cfg to the work dir...
echo ^(If exists, the original file will be renamed to EI.CFG.Ori^)
echo ============================================================
echo.
IF EXIST "WORK\Sources\EI.CFG" ren "WORK\Sources\EI.CFG" "EI.CFG.Ori"
COPY /Y "Files\EI.CFG" "WORK\Sources\"
echo.
:Continue1
If /I "%FiX%"=="3" GOTO :FiX2
Goto :ISO_FiX123

:FIX2
echo.
echo ============================================================
echo Modding Boot.wim to disable Secure Boot, RAM, DiskSize and TPM 2.0 check...
echo ============================================================
echo.
::if exist "TEMP" rmdir /q /s "TEMP"

%_wimlib% extract "WORK\sources\boot.wim" 2 \Windows\System32\config\SYSTEM --no-acls --no-attributes --dest-dir="TEMP"

Reg.exe load HKLM\MDL_Test "TEMP\SYSTEM"
Reg.exe add "HKLM\MDL_Test\Setup\LabConfig" /v "BypassTPMCheck" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\MDL_Test\Setup\LabConfig" /v "BypassSecureBootCheck" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\MDL_Test\Setup\LabConfig" /v "BypassRAMCheck" /t REG_DWORD /d "1" /f
Reg.exe add "HKLM\MDL_Test\Setup\LabConfig" /v "BypassStorageCheck" /t REG_DWORD /d "1" /f
Reg.exe unload HKLM\MDL_Test

%_wimlib% update "WORK\sources\boot.wim" 2 --command="add 'TEMP\SYSTEM' '\Windows\System32\config\SYSTEM'"
echo.
echo ============================================================
echo Replacing the Win 11 appraiserres.dll with one from a %Appraiserres_Version% ISO...
echo ^(The original file will be renamed to appraiserres.dll.bak^)
echo ============================================================
echo.
ren "WORK\sources\appraiserres.dll" "appraiserres.dll.bak"
copy /Y "Files\appraiserres.dll" "WORK\Sources"
If /I "%FiX%"=="3" GOTO :ISO_FiX123
echo.
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO You have chosen to NOT copy the generic EI.CFG file.
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.
IF /I "%EI_CFG_ADD%" NEQ "1" echo ^(If exists, the original file will remain on the ISO^)
IF /I "%EI_CFG_ADD%" NEQ "1" echo ============================================================
IF /I "%EI_CFG_ADD%" NEQ "1" ECHO.

IF /I "%EI_CFG_ADD%" NEQ "1" GOTO :ISO_FiX123
echo.
echo ============================================================
echo Copying the generic ei.cfg to the work dir...
echo ^(If exists, the original file will be renamed to EI.CFG.Ori^)
echo ============================================================
echo.
IF EXIST "WORK\Sources\EI.CFG" ren "WORK\Sources\EI.CFG" "EI.CFG.Ori"
COPY /Y "Files\EI.CFG" "WORK\Sources\"

:ISO_FiX123
IF /I "%DPaA%" NEQ "1" GOTO :RESUME3
echo.
echo ============================================================
echo Adding Murphy78 Diskpart and Apply Image Script 1.3.1 To Boot.wim...
echo ============================================================
echo.
%_wimlib% update Work\sources\boot.wim 2 --command "add 'Files\murphy78-DiskPart-Apply-v1.3.1\%warch%\' '\'"
:RESUME3
echo.
echo ============================================================
echo Copying Upgrade_Fail_Fix.cmd to work dir...
echo ============================================================
echo.
COPY /Y "Files\Upgrade_Fail_Fix.cmd" "WORK\"
echo.
IF /I "%Boot_WIM_Opt%" NEQ "1" GOTO :SKIP_2
echo ============================================================
echo Optimizing boot.wim...
echo ============================================================
echo.
%_wimlib% optimize "WORK\Sources\boot.wim" --recompress
:SKIP_2
echo.
ECHO==========================================================
echo Creating %WARCH% ISO...
ECHO==========================================================
echo.
for /f %%# in ('powershell "get-date -format _yyyy_MM_dd"') do set "isodate=%%#"
echo.
for /f "delims=" %%i in ('dir /b Source_ISO\W11\*.iso') do set "isoname=%%i"
set "isoname=%isoname:~0,-4%_FIXED%isodate%.iso"
bin\cdimage.exe -bootdata:2#p0,e,b"Work\boot\etfsboot.com"#pEF,e,b"Work\efi\Microsoft\boot\efisys.bin" -o -m -u2 -udfver102 -lWin_%Winver%_%vermajor%_%warch%_%LabelLang% "work" "%isoname%"
Goto :cleanup

:ISO_FiX4
IF /I "%Boot_WIM_Opt%" NEQ "1" GOTO :SKIP_3
echo ============================================================
echo Optimizing boot.wim...
echo ============================================================
echo.
%_wimlib% optimize "WORK\Sources\boot.wim" --recompress
:SKIP_3
echo.
ECHO==========================================================
echo Creating %WARCH% ISO...
ECHO==========================================================
echo.
for /f %%# in ('powershell "get-date -format _yyyy_MM_dd"') do set "isodate=%%#"
echo.
bin\cdimage.exe -bootdata:2#p0,e,b"Work\boot\etfsboot.com"#pEF,e,b"Work\efi\Microsoft\boot\efisys.bin" -o -m -u2 -udfver102 -lWin_%Winver%_%vermajor%_%warch%_%LabelLang% "Work" Win_10_ISO_With_%majorbuildnr%.%b2%_%wARCH%_%LabelLang%_%WIMFILE%_FiXED%isodate%.iso

:cleanup
if exist "TEMP" rmdir /q /s "TEMP"
if exist "Work" rmdir /q /s "WORK"

pause
exit /b