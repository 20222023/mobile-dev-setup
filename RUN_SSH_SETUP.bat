@echo off
:: This batch file will request Administrator privileges and run the SSH setup
:: Just double-click this file!

echo Requesting Administrator privileges...
powershell -Command "Start-Process powershell -ArgumentList '-ExecutionPolicy Bypass -File \"%~dp0setup_ssh.ps1\"' -Verb RunAs"
pause

