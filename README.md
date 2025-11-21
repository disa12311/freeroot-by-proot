# 🚀 Lightweight Proot Setup Script

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell Script](https://img.shields.io/badge/Shell-POSIX-green.svg)](https://www.gnu.org/software/bash/)
[![Proot](https://img.shields.io/badge/Proot-v5.3.0-orange.svg)](https://proot-me.github.io/)

Ultra-lightweight proot installation script for running commands with root-like privileges without requiring actual root access. Perfect for restricted environments like Android/Termux.

## ✨ Features

- 🚀 **Zero Root Required** - Uses Proot for unprivileged execution
- 🪶 **Ultra Lightweight** - Only downloads proot binary (~500KB)
- 🤖 **Fully Automated** - Non-interactive mode for CI/CD
- 💻 **Multi-Architecture** - Supports x86_64 and ARM64
- ⚡ **Instant Setup** - No heavy rootfs download needed
- 📦 **Minimal Dependencies** - Only requires wget
- 🎨 **Beautiful CLI** - Colored output with progress indicators

## 🆚 Why This Over Full Ubuntu Rootfs?

| Feature | This Script | Traditional Rootfs |
|---------|-------------|-------------------|
| Download Size | ~500KB | ~40MB |
| Setup Time | <10 seconds | 2-5 minutes |
| Disk Space | Minimal | ~200MB+ |
| Use System Bins | ✅ Yes | ❌ No |
| Speed | ⚡ Fast | 🐢 Slow |

## 📋 Prerequisites

- **Shell**: Any POSIX-compliant shell (sh, bash, zsh)
- **Network**: Active internet connection
- **Tool**: `wget` (pre-installed on most systems)
- **Architecture**: x86_64 (amd64) or aarch64 (arm64)

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/disa12311/freeroot-by-proot.git
cd freeroot-by-proot
```

### 2️⃣ Choose Your Installation Method

#### 🤖 Non-Interactive Mode (Recommended)

Automatic installation without prompts:

```bash
chmod +x noninteractive.sh
./noninteractive.sh
```

**Perfect for:**
- 🔄 Automated scripts
- 🏗️ CI/CD pipelines
- 🐳 Docker/Container builds
- 📦 Batch installations
- 🌐 Remote SSH execution

#### 👤 Interactive Mode

Manual installation with confirmation:

```bash
bash root.sh
```

**Features:**
- ✅ User confirmation prompt
- 📊 Detailed progress information
- 🎯 Better for first-time users

## 🏗️ What Gets Installed?

The script performs these lightweight operations:

1. ✅ Detects your system architecture
2. ✅ Downloads Proot v5.3.0 binary (~500KB)
3. ✅ Sets executable permissions
4. ✅ Creates installation marker
5. ✅ Launches proot shell with root privileges

**Total time:** ~5-10 seconds  
**Total download:** ~500KB  
**No rootfs needed!**

## 🖥️ Supported Architectures

| Architecture | Binary | Platforms |
|--------------|--------|-----------|
| **x86_64** | `proot-v5.3.0-x86_64` | PC, Laptop, Desktop, Servers |
| **aarch64** | `proot-v5.3.0-aarch64` | Android, Termux, ARM devices, Raspberry Pi |

## 💡 How It Works

Unlike traditional proot setups that download entire Ubuntu rootfs:

```
❌ Traditional Method:
Download Ubuntu (40MB) → Extract (200MB) → Setup Proot → Launch
Total: 2-5 minutes, 200MB+ disk space

✅ This Script:
Download Proot (500KB) → Launch with system binaries
Total: <10 seconds, minimal disk space
```

This script uses your **existing system binaries** instead of downloading a full Linux distribution!

## 📁 Directory Structure

```
freeroot-by-proot/
├── noninteractive.sh          # Auto-install script
├── root.sh                    # Interactive install script
├── proot-v5.3.0-x86_64       # Proot binary for x86_64
├── proot-v5.3.0-aarch64      # Proot binary for ARM64
├── .proot_installed          # Installation marker (after setup)
├── README.md                 # This file
└── LICENSE                   # MIT License
```

## 🔧 Usage Examples

### Basic Usage

```bash
# After installation, you're in a proot shell with root-like access
./noninteractive.sh

# Now you can run commands as if you had root
whoami  # Returns: root
id -u   # Returns: 0
```

### Install Packages (Termux Example)

```bash
# Run the proot setup
./noninteractive.sh

# Install packages without root
pkg install python nodejs git
```

### Run Root-Required Commands

```bash
# Commands that normally need root will work
./noninteractive.sh

# Example: Change file ownership (simulated)
chown root:root file.txt
chmod 755 script.sh
```

## 🐛 Troubleshooting

### Issue: `wget: command not found`

```bash
# Android/Termux
pkg install wget

# Debian/Ubuntu
apt install wget

# Alpine Linux
apk add wget

# Arch Linux
pacman -S wget
```

### Issue: `Permission denied`

```bash
chmod +x noninteractive.sh root.sh
```

### Issue: Download fails

The script automatically retries 50 times, but if it still fails:

```bash
# Check internet connection
ping -c 3 github.com

# Try manual download
wget https://raw.githubusercontent.com/disa12311/freeroot-by-proot/main/proot-v5.3.0-aarch64
```

### Issue: Architecture not supported

```bash
# Check your architecture
uname -m

# Supported: x86_64, aarch64
# Not supported: armv7l, i686, i386
```

### Issue: Proot doesn't work

```bash
# Verify proot is executable
ls -la usr/local/bin/proot

# Test proot directly
./usr/local/bin/proot --help

# Reinstall
rm .proot_installed
./noninteractive.sh
```

## 📝 Script Comparison

| Feature | noninteractive.sh | root.sh |
|---------|-------------------|---------|
| **Shell** | POSIX sh | Bash |
| **User Prompt** | ❌ No | ✅ Yes |
| **Auto-Install** | ✅ Yes | ❌ No |
| **Execution** | `./noninteractive.sh` | `bash root.sh` |
| **Best For** | Automation, Scripts | Manual testing |
| **Speed** | ⚡ Fastest | 🐢 Slower (waits for input) |

## 🌟 Real-World Examples

### Android/Termux Setup

```bash
# Install prerequisites
pkg update && pkg upgrade
pkg install wget git

# Clone and run
git clone https://github.com/disa12311/freeroot-by-proot.git
cd freeroot-by-proot
chmod +x noninteractive.sh
./noninteractive.sh

# Now you have root-like access!
```

### CI/CD Pipeline (GitHub Actions)

```yaml
name: Setup Proot
on: [push]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v3
      
      - name: Setup Proot
        run: |
          git clone https://github.com/disa12311/freeroot-by-proot.git
          cd freeroot-by-proot
          chmod +x noninteractive.sh
          ./noninteractive.sh
```

### Docker Container

```dockerfile
FROM alpine:latest

# Install dependencies
RUN apk add --no-cache wget bash

# Setup proot
WORKDIR /app
COPY noninteractive.sh .
RUN chmod +x noninteractive.sh && ./noninteractive.sh

# Use proot in your commands
CMD ["/app/usr/local/bin/proot", "-0", "/bin/sh"]
```

### Automated Deployment Script

```bash
#!/bin/bash
# deploy.sh

# Setup environment with proot
cd /opt/myapp
git clone https://github.com/disa12311/freeroot-by-proot.git proot-setup
cd proot-setup
chmod +x noninteractive.sh
./noninteractive.sh

# Run your app with root privileges
./usr/local/bin/proot -0 /path/to/your/app
```

## 🎯 Use Cases

- 📱 **Android/Termux Development** - Run Linux tools on Android
- 🧪 **Testing Without Root** - Test scripts that need root
- 🏗️ **CI/CD Pipelines** - Automated testing environments
- 🐳 **Container Builds** - Lightweight container setups
- 🎓 **Educational** - Learn Linux without affecting host system
- 🔒 **Restricted Environments** - Work around permission limitations

## ⚙️ Advanced Configuration

### Custom Proot Options

Edit the scripts and modify the proot execution:

```bash
# Default
exec "$ROOTFS_DIR/usr/local/bin/proot" \
  -0 \
  -w "$(pwd)" \
  -b /dev -b /sys -b /proc \
  /bin/sh

# With custom bindings
exec "$ROOTFS_DIR/usr/local/bin/proot" \
  -0 \
  -w "$(pwd)" \
  -b /dev -b /sys -b /proc \
  -b /sdcard:/sdcard \        # Mount Android storage
  -b /data:/data \            # Mount data partition
  --rootfs=/custom/rootfs \   # Use custom rootfs
  /bin/bash                   # Use bash instead of sh
```

### Environment Variables

```bash
# Set custom path for proot
export PROOT_PATH=/custom/path/to/proot

# Set custom working directory
export PROOT_WORKDIR=/custom/workdir

# Run script with custom settings
PROOT_PATH=/usr/bin/proot ./noninteractive.sh
```

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. 🍴 Fork the repository
2. 🌿 Create a feature branch (`git checkout -b feature/amazing`)
3. 💾 Commit your changes (`git commit -m 'Add amazing feature'`)
4. 📤 Push to the branch (`git push origin feature/amazing`)
5. 🎉 Open a Pull Request

### Areas for Contribution

- 🏗️ Additional architecture support
- 🐛 Bug fixes and improvements
- 📚 Documentation improvements
- 🧪 More example use cases
- ⚡ Performance optimizations

## 📜 License

This project is licensed under the [MIT License](LICENSE).

```
MIT License - you can:
✅ Use commercially
✅ Modify
✅ Distribute
✅ Private use

Requirements:
- Include license and copyright notice
```

## ⚠️ Disclaimer

**Important Notice:**

- 🎓 **Educational Purpose** - This tool is for learning and development
- ⚡ **Use Responsibly** - Don't use for malicious purposes
- 🔒 **No Guarantees** - Provided "as-is" without warranty
- 🚫 **Not a Security Tool** - Proot is NOT a security boundary
- ⚖️ **Legal Compliance** - Ensure compliance with local laws and terms of service

## 🔗 Resources

- [Proot Official Site](https://proot-me.github.io/)
- [Proot GitHub](https://github.com/proot-me/proot)
- [Termux Wiki](https://wiki.termux.com/)
- [Issue Tracker](https://github.com/disa12311/freeroot-by-proot/issues)

## 📧 Support

Need help? Here's what to do:

1. 📖 Read the [Troubleshooting](#-troubleshooting) section
2. 🔍 Search [existing issues](https://github.com/disa12311/freeroot-by-proot/issues)
3. 💬 Open a new issue with:
   - Your system architecture (`uname -m`)
   - Error messages (full output)
   - Steps to reproduce
   - What you've already tried

## 🎉 Acknowledgments

- 🙏 Thanks to the [Proot](https://proot-me.github.io/) development team
- 💪 Inspired by the Termux community
- ❤️ Built for developers who need lightweight solutions

---

<div align="center">

**⚡ Lightning-fast proot setup for everyone! ⚡**

🌟 **Star this repo if you find it useful!** 🌟

[Report Bug](https://github.com/disa12311/freeroot-by-proot/issues) · [Request Feature](https://github.com/disa12311/freeroot-by-proot/issues) · [Documentation](https://github.com/disa12311/freeroot-by-proot)

</div>
