# Mobile Development Setup

This repository contains scripts and guides to help you access your development environment from your mobile device.

## Quick Start

### Option 1: SSH Access (Terminal) - Easiest

1. **Run the SSH setup script (as Administrator):**
   ```powershell
   .\setup_ssh.ps1
   ```

2. **Install a mobile SSH app:**
   - **Termius** (iOS/Android) - Recommended
   - **JuiceSSH** (Android) - Free alternative
   - **Blink Shell** (iOS) - Premium option

3. **Connect using the IP and username shown by the script**

### Option 2: Code-Server (Full IDE in Browser) - Best Experience

1. **Run the code-server setup script:**
   ```powershell
   .\setup_code_server.ps1
   ```

2. **Start code-server:**
   ```powershell
   .\start_code_server.ps1
   ```

3. **Open the URL shown in your mobile browser**

## Files

- `MOBILE_SETUP.md` - Complete guide with all options
- `setup_ssh.ps1` - Automated SSH server setup
- `setup_code_server.ps1` - Automated code-server setup
- `start_code_server.ps1` - Quick launcher for code-server

## Requirements

- Windows 10/11
- Administrator privileges (for initial setup)
- Mobile device on the same network (or VPN)

## Security Notes

⚠️ **Important:** These setups make your computer accessible from your network. 

- Use strong passwords
- Only enable when needed
- Consider using a VPN for remote access
- Don't expose ports to the internet without proper security

## Troubleshooting

See `MOBILE_SETUP.md` for detailed troubleshooting steps.

