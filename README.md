# 🐧 Ubuntu Rootfs Installation Script

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Shell Script](https://img.shields.io/badge/Shell-Bash-green.svg)](https://www.gnu.org/software/bash/)
[![Ubuntu](https://img.shields.io/badge/Ubuntu-20.04-orange.svg)](https://ubuntu.com/)

A lightweight and automated Ubuntu 20.04 rootfs installation script using [Proot v5.3.0](https://proot-me.github.io/), designed for containerized environments without requiring root privileges.

## ✨ Features

- 🚀 **Zero Root Required** - Uses Proot for unprivileged containers
- 🤖 **Automated Installation** - Non-interactive mode for CI/CD pipelines
- 💻 **Multi-Architecture** - Supports both x86_64 and ARM64
- 🎨 **Beautiful CLI** - Colored output with progress indicators
- 📦 **Minimal Dependencies** - Only requires wget and tar
- ⚡ **Fast Setup** - Optimized download with retry mechanism

## 📋 Prerequisites

- **Shell**: Bash or POSIX-compliant shell (sh)
- **Network**: Active internet connection
- **Tools**: `wget`, `tar` (pre-installed on most systems)
- **Architecture**: x86_64 (amd64) or aarch64 (arm64)

## 🚀 Quick Start

### 1️⃣ Clone the Repository

```bash
git clone https://github.com/disa12311/freeroot-by-proot.git
cd freeroot-by-proot
```

### 2️⃣ Choose Your Installation Method

#### 🤖 Non-Interactive Mode (Recommended for Automation)

Perfect for scripts, CI/CD, Docker builds, or remote execution:

```bash
chmod +x noninteractive.sh
./noninteractive.sh
```

**Use cases:**
- Automated deployments
- CI/CD pipelines
- Docker/Container builds
- Batch installations
- Remote SSH execution

#### 👤 Interactive Mode (Manual Installation)

With user confirmation prompt:

```bash
bash root.sh
```

**Features:**
- Asks for user confirmation before installation
- Suitable for manual setup and testing

## 🏗️ What Gets Installed?

The script automatically:

1. ✅ Downloads Ubuntu 20.04 base rootfs (~40MB)
2. ✅ Extracts the rootfs to current directory
3. ✅ Installs Proot v5.3.0 binary (architecture-specific)
4. ✅ Configures DNS (Cloudflare 1.1.1.1)
5. ✅ Sets up isolated environment with `/dev`, `/sys`, `/proc` mounts
6. ✅ Launches Ubuntu shell as root user

## 🖥️ Supported Architectures

| Architecture | Binary Used | Platform |
|--------------|-------------|----------|
| **x86_64** | `proot-v5.3.0-x86_64` | PC, Laptop, Desktop |
| **aarch64** | `proot-v5.3.0-aarch64` | Android, ARM servers, Raspberry Pi |

## 📁 Directory Structure

```
freeroot-by-proot/
├── noninteractive.sh          # Auto-install script
├── root.sh                    # Interactive install script
├── proot-v5.3.0-x86_64       # Proot binary for x86_64
├── proot-v5.3.0-aarch64      # Proot binary for ARM64
├── README.md                  # This file
└── LICENSE                    # MIT License
```

After installation:
```
freeroot-by-proot/
├── bin/                       # Ubuntu binaries
├── etc/                       # Configuration files
├── usr/                       # User programs
├── var/                       # Variable data
├── .installed                 # Installation marker
└── ...                        # Full Ubuntu filesystem
```

## 🔧 Advanced Usage

### Running Commands Inside Rootfs

```bash
# After installation, you're automatically in Ubuntu environment
apt update
apt install -y python3 nodejs git
```

### Custom Proot Options

Edit the script and modify the proot execution line:

```bash
exec "$ROOTFS_DIR/usr/local/bin/proot" \
  --rootfs="${ROOTFS_DIR}" \
  -0 -w "/root" \
  -b /dev -b /sys -b /proc \
  -b /sdcard:/sdcard \  # Mount Android storage (add this)
  --kill-on-exit
```

### Re-entering the Environment

```bash
# Run the script again to re-enter
./noninteractive.sh
# or
bash root.sh
```

## 🐛 Troubleshooting

### Issue: `wget: command not found`

```bash
# Android/Termux
pkg install wget

# Debian/Ubuntu
apt install wget

# Alpine
apk add wget
```

### Issue: `Permission denied`

```bash
chmod +x noninteractive.sh root.sh
```

### Issue: Download fails or timeouts

The script automatically retries up to 50 times. If it still fails:
- Check your internet connection
- Verify firewall settings
- Try using a VPN

### Issue: Architecture not supported

```bash
# Check your architecture
uname -m

# Supported: x86_64, aarch64
# Not supported: armv7l, i686, etc.
```

## 📝 Script Comparison

| Feature | noninteractive.sh | root.sh |
|---------|-------------------|---------|
| User prompt | ❌ No | ✅ Yes |
| Auto-install | ✅ Yes | ❌ No |
| Execution | `./noninteractive.sh` | `bash root.sh` |
| Use case | Automation | Manual setup |
| Shell | POSIX sh | Bash |

## 🌟 Examples

### CI/CD Pipeline (GitHub Actions)

```yaml
- name: Setup Ubuntu Rootfs
  run: |
    git clone https://github.com/disa12311/freeroot-by-proot.git
    cd freeroot-by-proot
    chmod +x noninteractive.sh
    ./noninteractive.sh
```

### Docker Build

```dockerfile
FROM alpine:latest
RUN apk add --no-cache wget tar bash
WORKDIR /rootfs
COPY noninteractive.sh .
RUN chmod +x noninteractive.sh && ./noninteractive.sh
```

### Android/Termux

```bash
pkg update && pkg install wget git
git clone https://github.com/disa12311/freeroot-by-proot.git
cd freeroot-by-proot
chmod +x noninteractive.sh
./noninteractive.sh
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the [MIT License](LICENSE) - see the LICENSE file for details.

## ⚠️ Disclaimer

This script is provided for **educational and experimental purposes only**. 

- Use at your own risk
- No warranty or support guaranteed
- Not affiliated with Ubuntu or Canonical
- Proot may have limitations compared to full virtualization

## 🔗 Resources

- [Proot Official Documentation](https://proot-me.github.io/)
- [Ubuntu Base Images](http://cdimage.ubuntu.com/ubuntu-base/releases/)
- [Issue Tracker](https://github.com/disa12311/freeroot-by-proot/issues)

## 📧 Support

If you encounter issues:
1. Check the [Troubleshooting](#-troubleshooting) section
2. Search existing [Issues](https://github.com/disa12311/freeroot-by-proot/issues)
3. Open a new issue with detailed information

---

<div align="center">

**Made with ❤️ for the Linux community**

⭐ Star this repo if you find it useful!

</div>
