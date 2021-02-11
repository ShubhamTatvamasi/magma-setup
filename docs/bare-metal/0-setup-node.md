# bare-metal

This setup is done on Ubuntu 20.04.1 LTS

Upgrade all the packages:
```bash
sudo apt update
sudo apt upgrade -y

# Install prerequisites
sudo apt install apt-transport-https software-properties-common gnupg2 curl -y

# Setup key for helm
curl https://baltocdn.com/helm/signing.asc | sudo apt-key add -
echo "deb https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list

# Setup key for kubectl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list

# Setup ansible repo
sudo apt-add-repository --yes --update ppa:ansible/ansible

# Install dependencies
sudo apt install ansible git helm kubectl python-netaddr -y

pip install Jinja2
```

download magma code:
```bash
git clone https://github.com/magma/magma.git

cd /root/magma/orc8r/cloud/deploy/bare-metal
```

update IP in `deploy.sh` file:
```bash
declare -a IPS=(23.82.137.71)
```

deploy cluster:
```bash
bash ${PWD}/deploy.sh
```

```bash
cat << EOF > orc8r_settings
export namespace="magma"
export metallb_addresses="10.22.87.65/26"
export storage_class="nfs"
export img_repo="shubhamtatvamasi"
export controller_tag="1.3.3-master"
export nms_tag="1.3.3-master"
export nginx_tag="1.3.3-master"
export db_root_password=password
export orc8r_db_host=mariadb.mariadb
export orc8r_db_pass=password
export orc8r_db_user=orc8r
export nms_db_host=mariadb.mariadb
export nms_db_pass=password
export nms_db_user=nms
export dns_domain=magma.shubhamtatvamasi.com
export admin_email=admin
export admin_password=admin
EOF
```

Update your helm repo:
```bash
sed -i 's/github-repo/magma-charts/g' deploy_charts.sh
```

setup namespaces:
```bash
kubectl create ns mariadb || :
kubectl create ns infra || :
kubectl create ns magma || :
```

make volumes for magma:
```bash
./make_magma_pvcs.sh magma nfs
```

deploy magma:
```bash
./deploy_charts.sh
```

to delete all volume claims:
```bash
kdl pvc -n magma grafanadashboards grafanadata grafanadatasources grafanaproviders openvpn promcfg promdata
```
