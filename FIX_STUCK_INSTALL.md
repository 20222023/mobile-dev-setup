# Fix: SSH Setup Stuck on Installation

## The Issue
The OpenSSH Server installation can get stuck or take a very long time (5-10+ minutes).

## Quick Fix Options

### Option 1: Wait (Recommended First)
- The installation can take **5-10 minutes** or more
- Don't close the window
- It may appear frozen but is actually working
- Wait at least 10 minutes before trying other options

### Option 2: Cancel and Try Manual Installation
If it's been stuck for more than 10 minutes:

1. **Press Ctrl+C** to cancel
2. **Try installing via Windows Settings instead:**
   - Open Settings (Windows + I)
   - Go to: Apps → Optional Features
   - Click "View features"
   - Search for "OpenSSH Server"
   - Install it
3. **Then run these commands** (in Admin PowerShell):
   ```powershell
   Start-Service sshd
   Set-Service -Name sshd -StartupType 'Automatic'
   New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
   ```

### Option 3: Use Alternative Method
If installation keeps failing, use Windows Features:

1. **Open Windows Features:**
   - Press Windows + R
   - Type: `optionalfeatures`
   - Press Enter

2. **Find and check:**
   - "OpenSSH Server" (check the box)
   - Click OK
   - Wait for installation

3. **Then run** (in Admin PowerShell):
   ```powershell
   Start-Service sshd
   Set-Service -Name sshd -StartupType 'Automatic'
   New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
   ```

### Option 4: Check if Already Installed
Run this to check:
```powershell
Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
```

If it shows "State: Installed", you can skip installation and just run:
```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

## Recommended Action
**Wait 10 minutes first** - Windows feature installations can be slow. If still stuck after 10 minutes, try Option 2 or 3.

