# Troubleshooting Code-Server Issues

## Problem: Code-Server Crashes or Won't Start

### Issue: Postinstall Script Fails
Code-server's postinstall script requires `sh` (shell) which isn't available on Windows by default.

### Solutions:

#### Solution 1: Use Fixed Script (Recommended)
```powershell
.\start_code_server_fixed.ps1
```
This uses `--ignore-scripts` to skip the problematic postinstall step.

#### Solution 2: Install Git Bash (Provides sh)
1. Install Git for Windows (includes Git Bash)
2. Add Git Bash to PATH
3. Then try running code-server again

#### Solution 3: Use Docker (If Available)
```powershell
docker run -it --name code-server -p 8080:8080 -v "$PWD:/home/coder/project" codercom/code-server:latest --bind-addr 0.0.0.0:8080 --auth password
```

#### Solution 4: Use SSH Instead (Most Reliable on Windows)
SSH is more reliable on Windows. Set it up:
```powershell
# Run as Administrator
.\setup_ssh.ps1
```

Then use Termius or JuiceSSH on your mobile device.

#### Solution 5: Download Windows Binary Directly
1. Go to: https://github.com/coder/code-server/releases
2. Download `code-server-x.x.x-windows-amd64.zip`
3. Extract and run `code-server.exe`

### Alternative: Use VS Code Remote via SSH

If code-server continues to have issues, SSH is the most reliable option:

1. **Set up SSH** (run as Administrator):
   ```powershell
   .\setup_ssh.ps1
   ```

2. **On mobile**, use:
   - **Termius** app
   - Connect to: `192.168.3.27:22`
   - Username: `Palamoni_Akhil`
   - Password: Your Windows password

3. **You'll have full terminal access** to your computer!

### Current Status

- **IP Address:** 192.168.3.27
- **SSH Port:** 22 (if set up)
- **Code-Server Port:** 8080 (if working)

### Recommended Next Steps

1. Try `.\start_code_server_fixed.ps1` first
2. If that doesn't work, set up SSH with `.\setup_ssh.ps1` (as Administrator)
3. SSH is more reliable and gives you full terminal access

