# Manual Fix: Enable SSH Key Authentication

## Quick Manual Steps (2 minutes)

### Option 1: Use the Batch File
**Double-click:** `ENABLE_SSH_KEYS.bat`
- It will request admin privileges automatically
- Then run the fix script

### Option 2: Manual Edit (If batch file doesn't work)

1. **Open PowerShell as Administrator:**
   - Press `Windows + X`
   - Select "Terminal (Admin)" or "PowerShell (Admin)"

2. **Edit SSH config:**
   ```powershell
   notepad C:\ProgramData\ssh\sshd_config
   ```

3. **Find this line:**
   ```
   #PubkeyAuthentication yes
   ```

4. **Change it to (remove the #):**
   ```
   PubkeyAuthentication yes
   ```

5. **Save the file**

6. **Restart SSH service:**
   ```powershell
   Restart-Service sshd
   ```

### Option 3: One-Line Command (Run as Admin)

```powershell
(Get-Content C:\ProgramData\ssh\sshd_config) -replace '#PubkeyAuthentication yes', 'PubkeyAuthentication yes' | Set-Content C:\ProgramData\ssh\sshd_config; Restart-Service sshd
```

## After Enabling

1. **Make sure in Termius:**
   - Key is added in Settings → SSH Keys
   - When connecting, Authentication = "Key" (not Password)

2. **Try connecting again** - should work without password!

## Verify It Worked

Run this to check:
```powershell
Get-Content C:\ProgramData\ssh\sshd_config | Select-String "PubkeyAuthentication"
```

Should show: `PubkeyAuthentication yes` (without the #)

