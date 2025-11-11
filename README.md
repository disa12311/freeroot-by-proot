# Ubuntu Rootfs Installation Script

## Overview

This shell script is designed to automate the installation of  a lightweight Ubuntu environment using Proot.

## Prerequisites

- Bash shell environment
- Internet connectivity
- Wget installed
- Supported CPU architecture: x86_64 (amd64) or aarch64 (arm64)

## Installation

1. Clone the repository:

    ```sh
    git clone https://github.com/disa12311/freeroot-by-proot.git
    cd freeroot-by-proot
    ```

2. Run the installer script:

 For non-interactive users (automatic installation)

    ```sh
    bash noninteractive.sh
    ```

    or

 For root users (with prompt)

    ```sh
    bash root.sh
    ```

## Supported Architectures

- x86_64 (amd64)
- aarch64 (arm64)

## License

This Ubuntu Rootfs Installation Script script is released under the [MIT License](LICENSE).

---

**Note:** This script is intended for educational and experimental purposes. Use it responsibly and at your own risk.
