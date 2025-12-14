# Code-Server Solution - Windows Compatibility Issue

## The Problem

Code-server's latest version has a postinstall script that requires `sh` (Unix shell), which isn't available on Windows by default. This causes the installation to fail.

## Working Solutions

### Option 1: Use SSH (Most Reliable) ⭐ RECOMMENDED

SSH works perfectly on Windows and gives you full terminal access:

1. **Run as Administrator:**
   ```powershell
   .\setup_ssh.ps1
   ```

2. **Install Termius on your phone** (iOS/Android)

3. **Connect with:**
   - Host: `192.168.3.27`
   - Port: `22`
   - Username: `Palamoni_Akhil`
   - Password: Your Windows password

4. **You'll have full terminal access!**

### Option 2: Install Git Bash (Then Code-Server Works)

Git Bash provides the `sh` command that code-server needs:

1. **Download and install Git for Windows:**
   - https://git-scm.com/download/win
   - During installation, make sure "Git Bash" is selected

2. **Restart PowerShell** after installation

3. **Then try code-server again:**
   ```powershell
   .\start_code_server.ps1
   ```

### Option 3: Download Pre-built Windows Binary

1. **Go to:** https://github.com/coder/code-server/releases
2. **Download:** `code-server-x.x.x-windows-amd64.zip` (latest version)
3. **Extract** the zip file
4. **Run:**
   ```powershell
   .\code-server.exe --bind-addr 0.0.0.0:8080 --auth password
   ```

### Option 4: Use Docker (If You Have Docker)

```powershell
docker run -it -p 8080:8080 -v "${PWD}:/home/coder/project" codercom/code-server:latest --bind-addr 0.0.0.0:8080 --auth password
```

## My Recommendation

**Use SSH** - It's:
- ✅ More reliable on Windows
- ✅ No installation issues
- ✅ Full terminal access
- ✅ Works with Termius app (great mobile experience)
- ✅ Can run any command, edit files, etc.

Just run `.\setup_ssh.ps1` as Administrator and you're good to go!

## Quick SSH Setup

```powershell
# In Administrator PowerShell:
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

Then connect from mobile with Termius app using:
- IP: `192.168.3.27`
- Port: `22`
- Username: `Palamoni_Akhil`

