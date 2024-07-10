@echo off
echo.
echo StartAllBack CleanUp by iandiv
echo This script will clean up the registry keys
echo.
echo CAUTION!! Use this script at your own risk.
echo I am not responsible for any damage that may occur as a result of running this script.
echo.
set /p x=Do you want to begin? [Y/N]: 
if /i not "%x%"=="Y" if /i not "%x%"=="y" (
    echo Cancelled by user!
    exit /b
)

echo.

REM Get the registry keys and filter them using PowerShell
for /f "delims=" %%i in ('powershell -command "Get-Item -Path Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\* | Select-Object -ExpandProperty Name | Where-Object { $_ -cmatch ''\{[a-z0-9]{8}-([a-z0-9]{4}-){3}[a-z0-9]{8}.*$'' }"') do (
    REM Check for subkeys
    for /f "delims=" %%j in ('powershell -command "(Get-Item -Path Registry::%%i\*).Name"') do (
        set "subkey_found=true"
        goto :continue
    )
    set "subkey_found="
    :continue
    if defined subkey_found (
        REM Skip the key if subkeys are found
        continue
    ) else (
        echo.
        echo Cleaning..:
        echo.
        REM Remove the registry key
        powershell -command "Remove-Item -Path Registry::%%i"
    )
)

echo Cleaned Successfully!
echo.
echo Restarting explorer...
taskkill /f /im explorer.exe
start explorer.exe
echo.
echo All DONE
echo.
pause

REM Close the script window
powershell -command "[System.Windows.Forms.SendKeys]::SendWait('%{F4}')"
