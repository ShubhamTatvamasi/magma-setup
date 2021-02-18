# setup access gateway

add `magma` user and add to sudo group:
```bash
sudo adduser magma
sudo usermod -aG sudo magma
```
> password: `magma`


```
ansible-playbook
```


Setup env variables:
```bash
export MAGMA_USER="magma"
export AGW_INSTALL_CONFIG="/etc/systemd/system/multi-user.target.wants/agw_installation.service"
export AGW_SCRIPT_PATH="/root/agw_install.sh"
export DEPLOY_PATH="/home/$MAGMA_USER/magma/lte/gateway/deploy"
export SUCCESS_MESSAGE="ok"
export NEED_REBOOT=0
export WHOAMI=$(whoami)
export KVERS=$(uname -r)
export MAGMA_VERSION="${MAGMA_VERSION:-v1.3}"
export GIT_URL="${GIT_URL:-https://github.com/magma/magma.git}"
```

