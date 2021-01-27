# magma-setup

This setup is done on Ubuntu 20.04.1 LTS

Upgrade all the packages:
```bash
sudo apt update && sudo apt upgrade -y
```

Install docker:
```bash
# install prerequisites:
sudo apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg-agent \
  software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

