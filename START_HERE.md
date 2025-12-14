# 🚀 Code-Server Setup - Ready to Use!

## Quick Start

### Step 1: Start Code-Server

Open PowerShell in this directory and run:
```powershell
.\start_code_server.ps1
```

**OR** run directly:
```powershell
npx --yes code-server@latest --bind-addr 0.0.0.0:8080 --auth password
```

### Step 2: Note the Password

When code-server starts, it will display a password in the terminal. **Save this password!**

### Step 3: Configure Firewall (If Needed)

If you can't access from mobile, run this in **Administrator PowerShell**:
```powershell
New-NetFirewallRule -Name "code-server" -DisplayName "Code-Server (8080)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080
```

### Step 4: Access from Mobile

1. Make sure your phone is on the **same Wi-Fi network** as your computer
2. Open your mobile browser
3. Go to: **http://192.168.3.27:8080**
4. Enter the password from Step 2
5. Start coding! 🎉

## Your Connection Details

- **IP Address:** 192.168.3.27
- **Port:** 8080
- **URL:** http://192.168.3.27:8080
- **Username:** Palamoni_Akhil (for SSH, if you set that up)

## What You Have

✅ `start_code_server.ps1` - Quick launcher for code-server  
✅ `setup_code_server.ps1` - Setup script (mostly informational now)  
✅ `CODE_SERVER_SETUP.md` - Detailed documentation  
✅ `MOBILE_SETUP.md` - Complete mobile access guide  

## Troubleshooting

**Can't connect?**
- Check if code-server is running (you should see output in terminal)
- Verify firewall allows port 8080
- Make sure both devices are on same Wi-Fi network
- Try accessing from another device on the same network first

**Port already in use?**
- Change port in the command: `--bind-addr 0.0.0.0:8081` (use 8081 instead)

**Want SSH access too?**
- Run `.\setup_ssh.ps1` as Administrator (see MOBILE_SETUP.md)

## Next Steps

1. **Start code-server** using the command above
2. **Open on mobile** at http://192.168.3.27:8080
3. **Start coding!** You'll have full VS Code in your browser

---

**Ready?** Just run `.\start_code_server.ps1` and follow the steps above!

