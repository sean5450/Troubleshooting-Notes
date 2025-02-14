@echo off
echo Installing Wazuh Agent...
msiexec /i "\\site-file\Share\installers\wazuh-agent-4.10.1-1.msi /q WAZUH_MANAGER="172.16.3.30"

if %errorlevel% neq 0 (
    echo Installation failed with error code %errorlevel%.
    exit /b %errorlevel%
)

echo Starting Wazuh service...
NET START wazuh

if %errorlevel% neq 0 (
    echo Failed to start Wazuh service with error code %errorlevel%.
    exit /b %errorlevel%
)

echo Wazuh Agent installed and service started successfully.
pause
