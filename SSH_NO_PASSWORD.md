# SSH Connection Without Password - Setup Guide

## Problem
You have a Windows PIN but no password, and SSH requires a password.

## Solution: SSH Key Authentication ✅

SSH keys are more secure than passwords and work without a Windows password!

## Quick Setup (3 Steps)

### Step 1: Generate SSH Key on Your Computer

Run this script:
```powershell
.\setup_ssh_keys.ps1
```

**OR** manually run these commands:

```powershell
# Generate SSH key (press Enter twice when asked for passphrase)
ssh-keygen -t rsa -b 4096 -f $env:USERPROFILE\.ssh\id_rsa -N '""'

# Add public key to authorized_keys
type $env:USERPROFILE\.ssh\id_rsa.pub >> $env:USERPROFILE\.ssh\authorized_keys

# Set correct permissions
icacls $env:USERPROFILE\.ssh\authorized_keys /inheritance:r
icacls $env:USERPROFILE\.ssh\authorized_keys /grant ${env:USERNAME}:F
```

### Step 2: Copy Your Public Key

After running the script, it will show your public key. It looks like:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQ... Palamoni_Akhil@COMPUTERNAME
```

**Copy this entire line** - you'll need it for your phone.

### Step 3: Add Key to Termius App

1. **Open Termius** on your phone
2. **Go to Settings** → **SSH Keys** (or **Keys**)
3. **Tap "+"** to add new key
4. **Paste your public key** (the long line from Step 2)
5. **Save** the key
6. **Add new host:**
   - Hostname: `192.168.3.27`
   - Port: `22`
   - Username: `Palamoni_Akhil`
   - **Authentication:** Select "Use Key" → Choose the key you just added
7. **Connect!** (No password needed!)

## Alternative: Set a Windows Password

If you prefer to use password authentication:

1. **Press Windows + I** → **Accounts** → **Sign-in options**
2. Under **"Password"**, click **"Add"** or **"Change"**
3. Create a password
4. Use this password for SSH connection

## Which Method is Better?

**SSH Keys** are:
- ✅ More secure
- ✅ No password needed
- ✅ Works with PIN-only accounts
- ✅ Recommended for regular use

**Password** is:
- ✅ Simpler setup
- ❌ Less secure
- ❌ Requires Windows password

## Troubleshooting

### Key Not Working?
- Make sure you copied the **public key** (starts with `ssh-rsa`)
- Verify authorized_keys file exists: `$env:USERPROFILE\.ssh\authorized_keys`
- Check permissions on authorized_keys file

### Still Can't Connect?
- Make sure both devices are on same Wi-Fi network
- Verify SSH service is running: `Get-Service sshd`
- Check firewall allows port 22

## Quick Command Reference

```powershell
# View your public key
Get-Content $env:USERPROFILE\.ssh\id_rsa.pub

# Test SSH connection locally
ssh $env:USERNAME@localhost

# Check if authorized_keys exists
Test-Path $env:USERPROFILE\.ssh\authorized_keys
```

