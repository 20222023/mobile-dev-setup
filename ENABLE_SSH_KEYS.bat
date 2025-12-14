@echo off
echo Requesting Administrator privileges...
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0enable_ssh_keys.ps1\"' -Verb RunAs"
pause

