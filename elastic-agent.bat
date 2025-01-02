@echo off
set AGENT_PATH=.\elastic-agent.exe <-----This changes
set URL=https://6.42.78.26:8220 <-----This changes
set TOKEN=M1lidm9wQUJtQkw2YUt6TTgyeVY6NXhSZ21hWHVTQ2FjLUdqNlh5VnFSdw== <-----This changes

echo Installing Elastic Agent...
"%AGENT_PATH%" install --url=%URL% --enrollment-token=%TOKEN%

echo Installation complete.
Pause