@echo off
echo Requesting Administrator privileges for SSH setup...
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0complete_ssh_setup.ps1\"' -Verb RunAs"
pause

