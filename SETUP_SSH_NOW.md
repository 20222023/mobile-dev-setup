# SSH Setup - Quick Steps

## Your Connection Info (After Setup)
- **IP:** 192.168.3.27
- **Port:** 22
- **Username:** Palamoni_Akhil

## Setup Steps (2 minutes)

### Step 1: Open Administrator PowerShell
1. Press `Windows Key + X`
2. Click **"Windows PowerShell (Admin)"** or **"Terminal (Admin)"**
3. Navigate to this folder:
   ```powershell
   cd D:\CURSORAITEST
   ```

### Step 2: Run Setup Script
```powershell
.\setup_ssh.ps1
```

**OR** copy-paste these commands one by one:

```powershell
# Install OpenSSH Server
Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0

# Start SSH Service
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

# Configure Firewall
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

### Step 3: Install Termius on Your Phone
- **iOS:** App Store → Search "Termius"
- **Android:** Google Play → Search "Termius"

### Step 4: Connect from Phone
1. Open Termius
2. Tap **"+"** to add new host
3. Enter:
   - **Label:** My Computer
   - **Hostname:** 192.168.3.27
   - **Port:** 22
   - **Username:** Palamoni_Akhil
   - **Password:** Your Windows password
4. Tap **"Save"** then **"Connect"**

## That's It! 🎉

You'll now have full terminal access to your computer from your phone!

## Test Connection

After setup, test from another device on the same network:
```bash
ssh Palamoni_Akhil@192.168.3.27
```

## Troubleshooting

**Can't connect?**
- Make sure both devices are on the same Wi-Fi network
- Check Windows Firewall allows port 22
- Verify SSH service is running: `Get-Service sshd`

**Service not starting?**
- Make sure OpenSSH Server is installed
- Check: `Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'`

