@echo off
setlocal enabledelayedexpansion

:: CAUTION!! Use this script at your own risk.
:: I am not responsible for any damage that may occur as a result of running this script.

echo StartAllBack CleanUp by iandiv
echo This script will clean up the registry keys
echo.
echo CAUTION!! Use this script at your own risk.
echo I am not responsible for any damage that may occur as a result of running this script.
echo.
echo Do you want to begin?
set /p x= [Y/N]
if /i not "%x%"=="Y" goto :eof

echo.

:: Get registry keys
set "reg_key=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID"
for /f "tokens=*" %%k in ('reg query "%reg_key%" /s') do (
    set "key=%%~k"
    set "subkeys="
    for /f "tokens=*" %%s in ('reg query "%key%\*" /s') do (
        set "subkeys=!subkeys! %%~s"
    )
    if "!subkeys!"=="" (
        echo Cleaning..: !key!
        reg delete "!key!" /f
    )
)

echo Cleaned Successfully!
echo.
echo Restarting explorer...
taskkill /im explorer.exe /f
echo.
echo Starting explorer back up
start explorer.exe
echo.
echo All DONE
echo.
pause
exit