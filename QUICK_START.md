# Quick Start - Mobile Access Setup

## Your Computer IP Address: **192.168.3.27**

## Option 1: SSH Setup (Run as Administrator)

1. **Right-click on PowerShell** and select **"Run as Administrator"**
2. Navigate to this folder:
   ```powershell
   cd D:\CURSORAITEST
   ```
3. Run the setup script:
   ```powershell
   .\setup_ssh.ps1
   ```

## Option 2: Manual SSH Setup

If the script doesn't work, follow these steps in **Administrator PowerShell**:

### Step 1: Install OpenSSH Server
```powershell
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
```

### Step 2: Start SSH Service
```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```

### Step 3: Configure Firewall
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### Step 4: Connect from Mobile
- **Host:** 192.168.3.27
- **Port:** 22
- **Username:** Your Windows username
- **Password:** Your Windows password

## Mobile Apps to Install

- **Termius** (iOS/Android) - Best overall
- **JuiceSSH** (Android) - Free alternative
- **Blink Shell** (iOS) - Premium option

## Option 3: Code-Server (Full IDE in Browser)

If you want a full VS Code experience in your mobile browser:

1. Run (as Administrator):
   ```powershell
   .\setup_code_server.ps1
   ```

2. Start code-server:
   ```powershell
   .\start_code_server.ps1
   ```

3. Open in mobile browser: `http://192.168.3.27:8080`

