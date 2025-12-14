# Termius Key Import Guide - Fix "Unknown Format" Error

## The Problem
Termius says "unknown format" when trying to save the SSH key.

## Solution: Use the Correct Import Method

### Method 1: Import from File (Easiest) ✅

1. **Run this script:**
   ```powershell
   .\create_termius_key_file.ps1
   ```
   This creates `termius_key.txt` with properly formatted key

2. **In Termius:**
   - Settings → SSH Keys → Add
   - Tap **"Import"** or **"Import Key"**
   - Select **"From File"** or **"Choose File"**
   - Select `termius_key.txt` from your computer
   - Name it: "My Computer"
   - Save

### Method 2: Copy-Paste (If Method 1 doesn't work)

1. **Get the key:**
   ```powershell
   .\get_termius_key.ps1
   ```

2. **Copy the ENTIRE key** (all on one line, no breaks)

3. **In Termius:**
   - Settings → SSH Keys → Add
   - Tap **"Import"**
   - Select **"From Clipboard"** or **"Paste"**
   - Paste the key
   - Name it and save

### Method 3: Manual Entry (Most Reliable)

1. **Get your public key:**
   ```powershell
   Get-Content $env:USERPROFILE\.ssh\id_rsa.pub
   ```

2. **Copy the ENTIRE line** (should look like):
   ```
   ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC...very long...== username@hostname
   ```

3. **In Termius:**
   - Settings → SSH Keys → Add
   - Tap **"Create New"** or **"Manual Entry"**
   - In the **"Public Key"** field, paste the key
   - **Name:** "My Computer"
   - **Save**

## Common Mistakes

❌ **Copying private key** (`id_rsa`) instead of public key (`id_rsa.pub`)  
✅ **Use public key** (ends with `.pub`)

❌ **Copying with line breaks**  
✅ **Copy entire key as one continuous line**

❌ **Missing parts of the key**  
✅ **Copy from `ssh-rsa` to the end (including `@hostname`)**

❌ **Using "Add Key" instead of "Import"**  
✅ **Use "Import" option first**

## Verify Your Key Format

Your key should:
- Start with: `ssh-rsa` (or `ssh-ed25519`, `ecdsa-sha2-nistp256`, etc.)
- Be all on ONE line
- End with: `username@hostname` (e.g., `@Akhil_LOQ`)
- Be very long (hundreds of characters)

Example format:
```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpgb7RCQkFd+gKqrpmKNR0aju8YfdtXcuZPkVTjEYeLWURb05P8XtH7vC2la1mlHMloEBn1FdXnRyZqwuGhhP6Uaajupk0nZS6HzLW4NYYRx3637JA9WIoFT4757nTRBncmwticLiZpPW3AozuWjNp7tK+x2Qc97n+WPshGcIX/QawcyL9T2RQ9kllu46oeCkZbOildNk1p2k/L8TXADCZ0YCWKnWCIeArLXjk+hAkwEXbHPAvINe4ZeXyKQOlS+DFb5GyNX0WyhyW4x1Z9k/EYBapBhXJQS3oStEfbSp1O2SUCYIMwSLso03ofY5R5w755PSSk8u0dk/9YBYDfWnIpHlh4M84JX7zu15PCqDWtyyO9FDD6b/9qcBrUCY71jJN/obZ8EHedauw5GlTHICDzjRMHiDyEjby0pRCHaDkFHPZlRulFamv769aDZb2OLvsq6XTe+xMaUayeO8NmCwWiPLTmKd8evm+v2Ed/W7//FQfc92zt/2uBvL8Mkjq0/OIBMlm9ge+Y9ulT1dAt3qqFZQwg3crYnD93O0DDAQQtmquezHn4+ZCxSdxWtxiDWegX4QzWiZGG+QMpXX9F0PkDeJZuG/8kULBwCJHJfUjvgb8HdOpEvkUSpga98E0DSP5gUyHACZ2fasxsPjM/VQCVTY1mRLmBlQg6zSjkUWiCQ== Palamoni_Akhil@Akhil_LOQ
```

## Still Not Working?

1. **Try generating a new key:**
   ```powershell
   ssh-keygen -t ed25519 -f $env:USERPROFILE\.ssh\id_ed25519 -N '""' -C "$env:USERNAME@$(hostname)"
   Get-Content $env:USERPROFILE\.ssh\id_ed25519.pub
   ```
   (ED25519 keys are sometimes better supported)

2. **Check Termius version** - Update the app

3. **Try a different SSH client** temporarily to verify the key works:
   - JuiceSSH (Android)
   - Blink Shell (iOS)

