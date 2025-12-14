# Termius SSH Key Setup - Step by Step

## The Problem
Termius is still asking for a password even though we set up SSH keys.

## Solution: Properly Configure Key in Termius

### Step 1: Enable Key Authentication on Server (Run as Administrator)

Run this script:
```powershell
.\enable_ssh_keys.ps1
```

**OR** manually edit SSH config:
1. Open `C:\ProgramData\ssh\sshd_config` as Administrator
2. Find the line: `#PubkeyAuthentication yes`
3. Change it to: `PubkeyAuthentication yes` (remove the #)
4. Restart SSH service: `Restart-Service sshd`

### Step 2: Add Key to Termius (Important!)

1. **Open Termius app** on your phone
2. **Go to Settings** (gear icon)
3. **Tap "SSH Keys"** or **"Keys"**
4. **Tap the "+" button** to add new key
5. **Choose "Import"** or **"Add Key"**
6. **Paste your public key:**
   ```
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpgb7RCQkFd+gKqrpmKNR0aju8YfdtXcuZPkVTjEYeLWURb05P8XtH7vC2la1mlHMloEBn1FdXnRyZqwuGhhP6Uaajupk0nZS6HzLW4NYYRx3637JA9WIoFT4757nTRBncmwticLiZpPW3AozuWjNp7tK+x2Qc97n+WPshGcIX/QawcyL9T2RQ9kllu46oeCkZbOildNk1p2k/L8TXADCZ0YCWKnWCIeArLXjk+hAkwEXbHPAvINe4ZeXyKQOlS+DFb5GyNX0WyhyW4x1Z9k/EYBapBhXJQS3oStEfbSp1O2SUCYIMwSLso03ofY5R5w755PSSk8u0dk/9YBYDfWnIpHlh4M84JX7zu15PCqDWtyyO9FDD6b/9qcBrUCY71jJN/obZ8EHedauw5GlTHICDzjRMHiDyEjby0pRCHaDkFHPZlRulFamv769aDZb2OLvsq6XTe+xMaUayeO8NmCwWiPLTmKd8evm+v2Ed/W7//FQfc92zt/2uBvL8Mkjq0/OIBMlm9ge+Y9ulT1dAt3qqFZQwg3crYnD93O0DDAQQtmquezHn4+ZCxSdxWtxiDWegX4QzWiZGG+QMpXX9F0PkDeJZuG/8kULBwCJHJfUjvgb8HdOpEvkUSpga98E0DSP5gUyHACZ2fasxsPjM/VQCVTY1mRLmBlQg6zSjkUWiCQ== Palamoni_Akhil@Akhil_LOQ
   ```
7. **Name it:** "My Computer" or "Windows PC"
8. **Save**

### Step 3: Configure Host to Use Key

1. **In Termius, add/edit your host:**
   - Hostname: `192.168.3.27`
   - Port: `22`
   - Username: `Palamoni_Akhil`

2. **IMPORTANT - Set Authentication:**
   - Scroll down to **"Authentication"** section
   - **Tap "Authentication"** or **"Use Key"**
   - **Select the key** you just added (e.g., "My Computer")
   - **DO NOT** select "Password" - select "Key" or "SSH Key"

3. **Save the host**

### Step 4: Connect

- Tap the host to connect
- It should connect **without asking for password**

## Common Mistakes

❌ **Wrong:** Leaving Authentication as "Password"  
✅ **Right:** Setting Authentication to "Key" and selecting your key

❌ **Wrong:** Not adding the key to Termius Settings first  
✅ **Right:** Add key to Settings → SSH Keys, then select it when adding host

❌ **Wrong:** Using the private key instead of public key  
✅ **Right:** Use the public key (starts with `ssh-rsa`)

## Still Not Working?

1. **Verify key is in authorized_keys:**
   ```powershell
   Get-Content $env:USERPROFILE\.ssh\authorized_keys
   ```

2. **Check SSH service is running:**
   ```powershell
   Get-Service sshd
   ```

3. **Restart SSH service** (as Administrator):
   ```powershell
   Restart-Service sshd
   ```

4. **Check Termius logs** - Some versions show connection errors

## Alternative: Set a Windows Password

If keys still don't work, you can set a Windows password:

1. **Press Windows + I** → **Accounts** → **Sign-in options**
2. Under **"Password"**, click **"Add"**
3. Create a password
4. Use this password in Termius (select "Password" authentication)

