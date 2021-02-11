# Setup Node

This setup is done on Ubuntu 20.04.1 LTS

Upgrade all the packages:
```bash
sudo apt update && sudo apt upgrade -y
```

Disable swap:
```bash
sudo swapoff -a
```

Install docker for rancher:
```bash
curl https://releases.rancher.com/install-docker/19.03.sh | sh
```
