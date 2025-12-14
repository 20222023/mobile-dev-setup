# GitHub Setup Guide

Your code is ready to push to GitHub! Follow these steps:

## Step 1: Create a GitHub Repository

1. Go to [GitHub.com](https://github.com) and sign in
2. Click the **+** icon in the top right corner
3. Select **"New repository"**
4. Choose a repository name (e.g., `mobile-dev-setup` or `code-server-setup`)
5. Choose **Public** or **Private** (your choice)
6. **DO NOT** initialize with README, .gitignore, or license (we already have these)
7. Click **"Create repository"**

## Step 2: Connect Your Local Repository to GitHub

After creating the repository, GitHub will show you commands. Use these commands (replace `YOUR_USERNAME` and `YOUR_REPO_NAME` with your actual values):

```powershell
# Add the remote repository
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

# Rename the default branch to main (if needed)
git branch -M main

# Push your code to GitHub
git push -u origin main
```

## Alternative: Using SSH (if you have SSH keys set up)

If you prefer SSH instead of HTTPS:

```powershell
git remote add origin git@github.com:YOUR_USERNAME/YOUR_REPO_NAME.git
git branch -M main
git push -u origin main
```

## Quick Command Reference

Once you have your repository URL, run these commands in PowerShell:

```powershell
cd d:\CURSORAITEST
git remote add origin YOUR_REPOSITORY_URL_HERE
git branch -M main
git push -u origin main
```

## Authentication

- **HTTPS**: You'll be prompted for your GitHub username and a Personal Access Token (not your password)
- **SSH**: Works automatically if you have SSH keys configured with GitHub

## Need Help?

- [GitHub Docs: Creating a new repository](https://docs.github.com/en/get-started/quickstart/create-a-repo)
- [GitHub Docs: Pushing to a remote](https://docs.github.com/en/get-started/getting-started-with-git/pushing-commits-to-a-remote-repository)
