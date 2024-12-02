@echo off
set /p "Sure=Are you sure you want to continue (y/N)? "
if /I "[%Sure%]" == "[y]" goto :START_PROCESS
goto :EOF

:START_PROCESS
echo Please wait...
sc stop sppsvc
reg add HKCU\SYSTEMM\WPA /ve /f
REG SAVE HKCU\SYSTEMM "%TEMP%\SYSTEM.HIV" /y >NUL 2>&1
REG RESTORE HKLM\SYSTEM "%TEMP%\SYSTEM.HIV" >NUL 2>&1
reg delete HKCU\SYSTEMM /f
del "%TEMP%\SYSTEM.HIV" >NUL 2>&1

for /f %%i in ('reg query HKLM\SYSTEM\WPA') do reg delete "%%i" /f

::Windows 10
if exist "%systemdrive%\Windows\System32\spp\store\2.0\cache" (
    attrib -s -h "%systemdrive%\Windows\System32\spp\store\2.0\cache"
    rmdir /q /s "%systemdrive%\Windows\System32\spp\store\2.0\cache"
)
if exist "%systemdrive%\Windows\System32\spp\store\2.0\data.dat" (
    attrib -s -h "%systemdrive%\Windows\System32\spp\store\2.0\data.dat"
    del "%systemdrive%\Windows\System32\spp\store\2.0\data.dat"
)
if exist "%systemdrive%\Windows\System32\spp\store\2.0\tokens.dat" (
    attrib -s -h "%systemdrive%\Windows\System32\spp\store\2.0\tokens.dat"
    del "%systemdrive%\Windows\System32\spp\store\2.0\tokens.dat"
)

::Windows 7
if exist "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\tokens.dat" (
    attrib -s -h "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\tokens.dat"
    del "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\tokens.dat"
)
if exist "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\cache" (
    attrib -s -h "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\cache"
    rmdir /q /s "%systemdrive%\Windows\ServiceProfiles\NetworkService\AppData\Roaming\Microsoft\SoftwareProtectionPlatform\cache"
)

shutdown -r -t 0
goto :EOF

:EOF