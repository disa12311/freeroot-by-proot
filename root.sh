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

# Download with retry
download_file() {
  url=$1
  output=$2
  description=$3
  
  log_info "Downloading ${description}..."
  
  if wget --tries=$MAX_RETRIES --timeout=$TIMEOUT --no-hsts -q --show-progress -O "$output" "$url"; then
    log_success "Downloaded ${description}"
    return 0
  else
    log_error "Failed to download ${description}"
    return 1
  fi
}

# Main installation process
if [ ! -e "$ROOTFS_DIR/.installed" ]; then
  clear
  printf "${CYAN}╔════════════════════════════════════════════════╗${RESET}\n"
  printf "${CYAN}║${RESET}     Ubuntu Rootfs Installation Script       ${CYAN}║${RESET}\n"
  printf "${CYAN}╚════════════════════════════════════════════════╝${RESET}\n"
  printf "\n"
  
  # Ask user for installation
  printf "${CYAN}?${RESET} Install Ubuntu 20.04 rootfs? [Y/n]: "
  read -r install_ubuntu
  install_ubuntu=${install_ubuntu:-YES}
  
  case "$install_ubuntu" in
    [yY]|[yY][eE][sS]|"")
      log_info "Starting Ubuntu 20.04 installation for ${ARCH_ALT}..."
      
      if download_file \
        "http://cdimage.ubuntu.com/ubuntu-base/releases/20.04/release/ubuntu-base-20.04.4-base-${ARCH_ALT}.tar.gz" \
        "/tmp/rootfs.tar.gz" \
        "Ubuntu base"; then
        
        log_info "Extracting rootfs..."
        if tar -xf /tmp/rootfs.tar.gz -C "$ROOTFS_DIR" 2>/dev/null; then
          log_success "Rootfs extracted successfully"
          rm -f /tmp/rootfs.tar.gz
        else
          log_error "Failed to extract rootfs"
          exit 1
        fi
      else
        exit 1
      fi
      ;;
    *)
      log_warn "Skipping Ubuntu installation"
      ;;
  esac
  
  # Setup proot
  log_info "Setting up proot..."
  mkdir -p "$ROOTFS_DIR/usr/local/bin"
  
  # Determine proot binary based on architecture
  case "$ARCH" in
    x86_64)
      proot_file="proot-v5.3.0-x86_64"
      ;;
    aarch64)
      proot_file="proot-v5.3.0-aarch64"
      ;;
  esac
  
  proot_url="https://raw.githubusercontent.com/disa12311/freeroot-by-proot/main/${proot_file}"
  proot_path="$ROOTFS_DIR/usr/local/bin/proot"
  
  attempt=0
  while [ $attempt -lt $MAX_RETRIES ]; do
    rm -f "$proot_path"
    
    if wget --tries=3 --timeout=$TIMEOUT --no-hsts -q -O "$proot_path" "$proot_url" && [ -s "$proot_path" ]; then
      chmod 755 "$proot_path"
      log_success "Proot installed successfully"
      break
    fi
    
    attempt=$((attempt + 1))
    [ $attempt -lt $MAX_RETRIES ] && log_warn "Retry downloading proot ($attempt/$MAX_RETRIES)..."
    sleep 1
  done
  
  if [ ! -s "$proot_path" ]; then
    log_error "Failed to download proot after $MAX_RETRIES attempts"
    exit 1
  fi
  
  # Configure DNS
  log_info "Configuring DNS..."
  printf "nameserver 1.1.1.1\nnameserver 1.0.0.1\n" > "${ROOTFS_DIR}/etc/resolv.conf"
  
  # Cleanup and mark as installed
  rm -rf /tmp/rootfs.tar.gz /tmp/sbin
  touch "$ROOTFS_DIR/.installed"
  
  printf "\n"
  printf "${GREEN}╔════════════════════════════════════════════════╗${RESET}\n"
  printf "${GREEN}║${RESET}          Installation Completed! ✓           ${GREEN}║${RESET}\n"
  printf "${GREEN}╚════════════════════════════════════════════════╝${RESET}\n"
  printf "\n"
  
  sleep 2
fi

# Launch proot environment
clear
printf "${CYAN}Starting Ubuntu environment...${RESET}\n"
printf "\n"

exec "$ROOTFS_DIR/usr/local/bin/proot" \
  --rootfs="${ROOTFS_DIR}" \
  -0 -w "/root" \
  -b /dev -b /sys -b /proc -b /etc/resolv.conf \
  --kill-on-exit