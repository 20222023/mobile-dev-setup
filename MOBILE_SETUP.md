# Mobile Development Setup Guide

This guide helps you access your development environment from your mobile device.

## Option 1: SSH Server (Terminal Access) ⭐ Recommended

### Windows SSH Setup

1. **Enable OpenSSH Server on Windows:**
   - Open Settings → Apps → Optional Features
   - Click "Add a feature"
   - Search for "OpenSSH Server" and install it
   - Or use PowerShell (as Administrator):
     ```powershell
     Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0
     ```

2. **Start SSH Service:**
   ```powershell
   Start-Service sshd
   Set-Service -Name sshd -StartupType 'Automatic'
   ```

3. **Configure Firewall:**
   ```powershell
   New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
   ```

4. **Find Your IP Address:**
   ```powershell
   ipconfig
   ```
   Look for IPv4 Address (e.g., 192.168.1.100)

5. **Mobile Apps for SSH:**
   - **Termius** (iOS/Android) - Best overall
   - **JuiceSSH** (Android) - Free, feature-rich
   - **Blink Shell** (iOS) - Premium but excellent
   - **Prompt** (iOS) - Simple and clean

6. **Connect from Mobile:**
   - Host: Your computer's IP address
   - Port: 22
   - Username: Your Windows username
   - Password: Your Windows password

## Option 2: Code-Server (Web-Based VS Code) 🌐 Best for Full IDE

### Installation

1. **Download code-server:**
   ```powershell
   # Using winget
   winget install coder.code-server
   
   # Or download from: https://github.com/coder/code-server/releases
   ```

2. **Run code-server:**
   ```powershell
   code-server --bind-addr 0.0.0.0:8080 --auth password
   ```
   It will generate a password - save it!

3. **Access from Mobile Browser:**
   - Open browser on your phone
   - Go to: `http://YOUR_IP:8080`
   - Enter the password shown in terminal

4. **Make it accessible from outside your network:**
   - Use a VPN (recommended)
   - Or use ngrok for temporary access:
     ```powershell
     ngrok http 8080
     ```

## Option 3: Remote Desktop (Full Desktop Access)

### Windows Remote Desktop

1. **Enable Remote Desktop:**
   - Settings → System → Remote Desktop
   - Turn on "Enable Remote Desktop"

2. **Mobile Apps:**
   - **Microsoft Remote Desktop** (iOS/Android) - Official
   - **Chrome Remote Desktop** (iOS/Android) - Easy setup
   - **TeamViewer** (iOS/Android) - Cross-platform

3. **For Chrome Remote Desktop:**
   - Install Chrome Remote Desktop on your PC
   - Set up remote access
   - Install app on mobile
   - Connect using the access code

## Option 4: VS Code Remote (If you have a server)

If you have a remote server or cloud instance:
- Use VS Code's Remote SSH extension
- Access via mobile SSH client
- Or use GitHub Codespaces (cloud-based)

## Security Recommendations 🔒

1. **Use Strong Passwords**
2. **Enable Firewall Rules** (only allow specific IPs if possible)
3. **Use VPN** for remote access outside your network
4. **Change Default SSH Port** (optional but recommended)
5. **Use SSH Keys** instead of passwords (more secure)

## Quick Start Commands

### Check if SSH is running:
```powershell
Get-Service sshd
```

### Check your IP:
```powershell
ipconfig | findstr IPv4
```

### Test SSH connection (from another device):
```powershell
ssh YOUR_USERNAME@YOUR_IP
```

## Troubleshooting

### SSH Connection Refused
- Check if SSH service is running: `Get-Service sshd`
- Check firewall: `Get-NetFirewallRule -Name sshd`
- Verify port 22 is open

### Can't Access from Outside Network
- Your router may block incoming connections
- Use VPN or port forwarding (advanced)
- Consider using ngrok for temporary access

### Code-Server Not Accessible
- Check firewall allows port 8080
- Verify bind address is 0.0.0.0 (not 127.0.0.1)
- Check Windows Firewall rules

## Recommended Setup for Your Use Case

For **AI/ML development** from mobile:
1. **SSH + Terminal** - For quick commands and monitoring
2. **Code-Server** - For full IDE experience with code editing
3. **Remote Desktop** - As backup for complex tasks

Start with SSH, then add code-server if you need full IDE features!

