#!/bin/sh

# Configuration
ROOTFS_DIR=$(pwd)
export PATH=$PATH:~/.local/usr/bin
MAX_RETRIES=50
TIMEOUT=1
ARCH=$(uname -m)

# Colors
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Determine architecture
case "$ARCH" in
  x86_64)
    ARCH_ALT=amd64
    ;;
  aarch64)
    ARCH_ALT=arm64
    ;;
  *)
    printf "${RED}[ERROR]${RESET} Unsupported CPU architecture: ${ARCH}\n"
    exit 1
    ;;
esac

# Logging functions
log_info() {
  printf "${CYAN}[INFO]${RESET} %s\n" "$1"
}

log_success() {
  printf "${GREEN}[SUCCESS]${RESET} %s\n" "$1"
}

log_error() {
  printf "${RED}[ERROR]${RESET} %s\n" "$1"
}

log_warn() {
  printf "${YELLOW}[WARN]${RESET} %s\n" "$1"
}

# Main installation process
if [ ! -e "$ROOTFS_DIR/.proot_installed" ]; then
  clear
  printf "${CYAN}╔════════════════════════════════════════════════╗${RESET}\n"
  printf "${CYAN}║${RESET}        Proot Lightweight Setup Script        ${CYAN}║${RESET}\n"
  printf "${CYAN}╚════════════════════════════════════════════════╝${RESET}\n"
  printf "\n"
  
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
  
  printf "\n"
  printf "${GREEN}╔════════════════════════════════════════════════╗${RESET}\n"
  printf "${GREEN}║${RESET}          Installation Completed! ✓           ${GREEN}║${RESET}\n"
  printf "${GREEN}╚════════════════════════════════════════════════╝${RESET}\n"
  printf "\n"
  
  sleep 1
fi

# Launch proot environment with current system
clear
printf "${CYAN}Starting lightweight proot environment...${RESET}\n"
printf "\n"

# Use system's root filesystem instead of downloading Ubuntu
exec "$ROOTFS_DIR/usr/local/bin/proot" \
  -0 \
  -w "$(pwd)" \
  -b /dev -b /sys -b /proc \
  /bin/sh
