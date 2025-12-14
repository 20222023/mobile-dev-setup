# Code-Server Setup Complete! 🎉

## Your Access Information

- **URL:** http://192.168.3.27:8080
- **IP Address:** 192.168.3.27
- **Port:** 8080

## How to Start Code-Server

Simply run:
```powershell
.\start_code_server.ps1
```

This will:
1. Start code-server on port 8080
2. Show you a password in the terminal
3. Make it accessible from your mobile device

## Access from Mobile

1. **Open your mobile browser** (Chrome, Safari, etc.)
2. **Navigate to:** `http://192.168.3.27:8080`
3. **Enter the password** shown in the terminal
4. **Start coding!** 🚀

## Firewall Configuration

If you can't access from mobile, you may need to allow port 8080 in Windows Firewall.

**Run this in Administrator PowerShell:**
```powershell
New-NetFirewallRule -Name "code-server" -DisplayName "Code-Server (8080)" -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 8080
```

## Features

- Full VS Code experience in your browser
- Works on any device (phone, tablet, another computer)
- Access your files and projects
- Install extensions
- Run terminal commands
- Git integration

## Stopping Code-Server

Press `Ctrl+C` in the terminal where code-server is running.

## Troubleshooting

### Can't connect from mobile?
1. Make sure both devices are on the same Wi-Fi network
2. Check Windows Firewall allows port 8080
3. Verify code-server is running (check the terminal)

### Port already in use?
Change the port in `start_code_server.ps1`:
```powershell
npx --yes code-server@latest --bind-addr 0.0.0.0:8081 --auth password
```

### Want to access from outside your network?
- Use a VPN (recommended)
- Or use ngrok: `ngrok http 8080`

## Alternative: Use npx directly

You can also run code-server directly without the script:
```powershell
npx --yes code-server@latest --bind-addr 0.0.0.0:8080 --auth password
```

