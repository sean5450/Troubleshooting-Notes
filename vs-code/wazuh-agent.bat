@echo off
echo Installing Wazuh Agent...
msiexec /i "\\petro-hq-dc\SYSVOL\wazuh-agent-4.9.0-1.msi" /q WAZUH_MANAGER="<X.X.X.X>"

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