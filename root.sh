#!/bin/bash

# Configuration
ROOTFS_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
MAX_RETRIES=50
TIMEOUT=1
ARCH=$(uname -m)

# Colors
CYAN='\e[0;36m'
GREEN='\e[0;32m'
RED='\e[0;31m'
YELLOW='\e[1;33m'
RESET='\e[0m'

# Determine architecture
case "$ARCH" in
  x86_64)
    ARCH_ALT=amd64
    ;;
  aarch64)
    ARCH_ALT=arm64
    ;;
  *)
    echo -e "${RED}[ERROR]${RESET} Unsupported CPU architecture: ${ARCH}"
    exit 1
    ;;
esac

# Logging functions
log_info() {
  echo -e "${CYAN}[INFO]${RESET} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${RESET} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${RESET} $1"
}

log_warn() {
  echo -e "${YELLOW}[WARN]${RESET} $1"
}

# Main installation process
if [ ! -e "$ROOTFS_DIR/.proot_installed" ]; then
  clear
  echo -e "${CYAN}╔════════════════════════════════════════════════╗${RESET}"
  echo -e "${CYAN}║${RESET}        Proot Lightweight Setup Script        ${CYAN}║${RESET}"
  echo -e "${CYAN}╚════════════════════════════════════════════════╝${RESET}"
  echo ""
  
  # Ask user for installation
  printf "${CYAN}?${RESET} Install Proot v5.3.0? [Y/n]: "
  read -r install_proot
  install_proot=${install_proot:-YES}
  
  case "$install_proot" in
    [yY]|[yY][eE][sS]|"")
      # Setup proot
      log_info "Setting up proot v5.3.0..."
      mkdir -p "$ROOTFS_DIR/usr/local/bin"
      
      # Determine proot binary based on architecture
      case "$ARCH" in
        x86_64)
          proot_file="proot-v5.3.0-x86_64"
          log_info "Detected architecture: x86_64 (PC/Desktop)"
          ;;
        aarch64)
          proot_file="proot-v5.3.0-aarch64"
          log_info "Detected architecture: ARM64 (Android/ARM)"
          ;;
      esac
      
      proot_url="https://raw.githubusercontent.com/disa12311/freeroot-by-proot/main/${proot_file}"
      proot_path="$ROOTFS_DIR/usr/local/bin/proot"
      
      log_info "Downloading ${proot_file}..."
      
      attempt=0
      while [ $attempt -lt $MAX_RETRIES ]; do
        rm -f "$proot_path"
        
        if wget --tries=3 --timeout=$TIMEOUT --no-hsts -q -O "$proot_path" "$proot_url" 2>/dev/null && [ -s "$proot_path" ]; then
          chmod 755 "$proot_path"
          log_success "Proot installed successfully"
          break
        fi
        
        attempt=$((attempt + 1))
        if [ $attempt -lt $MAX_RETRIES ]; then
          log_warn "Retry downloading proot ($attempt/$MAX_RETRIES)..."
          sleep 1
        fi
      done
      
      if [ ! -s "$proot_path" ]; then
        log_error "Failed to download proot after $MAX_RETRIES attempts"
        exit 1
      fi
      
      # Mark as installed
      touch "$ROOTFS_DIR/.proot_installed"
      
      echo ""
      echo -e "${GREEN}╔════════════════════════════════════════════════╗${RESET}"
      echo -e "${GREEN}║${RESET}          Installation Completed! ✓           ${GREEN}║${RESET}"
      echo -e "${GREEN}╚════════════════════════════════════════════════╝${RESET}"
      echo ""
      
      sleep 1
      ;;
    *)
      log_warn "Installation cancelled by user"
      exit 0
      ;;
  esac
fi

# Launch proot environment with current system
clear
echo -e "${CYAN}Starting lightweight proot environment...${RESET}"
echo ""

# Use system's root filesystem instead of downloading Ubuntu
exec "$ROOTFS_DIR/usr/local/bin/proot" \
  -0 \
  -w "$(pwd)" \
  -b /dev -b /sys -b /proc \
  /bin/sh
