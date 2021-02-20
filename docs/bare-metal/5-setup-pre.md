# Setup Pre

Things to install:

- nfs
- metallb-system
- cert-manager


Install the following package on node:
```bash
sudo apt install -y nfs-common
```

Namespace for mariadb and magma
```bash
kubectl create ns mariadb
kubectl create ns magma
```

Setup Variables:
```bash
export dns_domain=magma.shubhamtatvamasi.com
export magma_root=/home/shubham/git/magma
export scripts=$magma_root/orc8r/cloud/deploy/scripts
export namespace=magma
export magma_secrets=~/magma-secrets
export db_root_password=password
export nms_db_user=nms
export nms_db_pass=password
export orc8r_db_user=orc8r
export orc8r_db_pass=password
export db_root_password=password
```

Generate certificates:
```bash
mkdir -p ~/magma-secrets/certs
mkdir -p ~/magma-secrets/yaml

cd ~/magma-secrets/certs

eval $scripts/self_sign_certs.sh $dns_domain
eval $scripts/create_application_certs.sh $dns_domain
```

Generate Secrets:
```bash
kubectl -n $namespace create secret generic orc8r-certs \
  --from-file rootCA.pem \
  --from-file controller.key \
  --from-file controller.crt \
  --from-file certifier.key \
  --from-file certifier.pem \
  --from-file bootstrapper.key \
  --from-file admin_operator.pem \
  --dry-run=client  \
  -o yaml > $magma_secrets/yaml/orc8r-certs.yaml

kubectl -n $namespace create secret generic fluentd-certs \
  --from-file fluentd.key \
  --from-file fluentd.pem \
  --from-file certifier.pem \
  --dry-run=client \
  -o yaml > $magma_secrets/yaml/fluentd-certs.yaml

kubectl -n $namespace create secret generic nms-certs \
  --from-file admin_operator.pem \
  --from-file admin_operator.key.pem \
  --from-file controller.key \
  --from-file controller.crt \
  --dry-run=client \
  -o yaml > $magma_secrets/yaml/nms-certs.yaml
```

Add secrets on cluster:
```bash
kubectl apply -n magma -f $magma_secrets/yaml/

kubectl apply -n magma \
  -f https://github.com/magma/magma/raw/master/orc8r/cloud/deploy/bare-metal/secrets/orc8r-configs.yaml

kubectl apply -n magma \
  -f https://github.com/magma/magma/raw/master/orc8r/cloud/deploy/bare-metal/secrets/orc8r-envdir.yaml
```

Install mariadb:
```bash
# OLD: used on magma scrip
helm install mariadb bitnami/mariadb \
  --namespace mariadb \
  --version 7.3.14 \
  --set image.tag=10.3.22-debian-10-r27 \
  --set master.extraFlags="--sql-mode=ANSI_QUOTES" \
  --set rootUser.password=$db_root_password \
  --wait

# NEW: for testing
# helm install mariadb bitnami/mariadb \
#   --namespace mariadb \
#   --version 9.3.1 \
#   --set auth.rootPassword=$db_root_password \
#   --wait
```

Setup databases:
```bash
curl -sL https://github.com/magma/magma/raw/master/orc8r/cloud/deploy/bare-metal/db_setup.sql.tpl | \
  envsubst > $magma_secrets/db_setup.sql

kubectl exec -it mariadb-master-0 \
  -n mariadb \
  -- mysql -u root --password=$db_root_password < $magma_secrets/db_setup.sql

# SSH to POD
# kubectl exec -it mariadb-master-0 -n mariadb -- mysql -u root --password=$db_root_password
# Run the following commands on database:
# SELECT @@sql_mode;
# SET sql_mode = 'ANSI_QUOTES';
# SET GLOBAL sql_mode = 'ANSI_QUOTES';
```


```bash
helm -n $namespace upgrade --install fluentd stable/fluentd -f charts/fluentd.yaml
helm -n $namespace upgrade --install elasticsearch stable/elasticsearch -f charts/elasticsearch.yaml
helm -n $namespace upgrade --install elasticsearch-curator stable/elasticsearch-curator -f charts/elasticsearch-curator.yaml
helm -n $namespace upgrade --install kibana stable/kibana -f charts/kibana.yaml
```

Setup PVC:
```bash
./make_magma_pvcs.sh magma nfs
```

Run this command on your node to increase nodemon access:
```bash
sysctl -w fs.inotify.max_user_watches=524288
```

Install magma:
```bash
helm install orc8r magma-charts/orc8r \
  --namespace $namespace \
  --version=1.4.36 \
  -f charts/orc8r.yaml \
  --wait
```

Create key for API access and upload `admin_operator.pfx` to your chrome
```bash
openssl pkcs12 -export -inkey admin_operator.key.pem -in admin_operator.pem -out admin_operator.pfx
```
Pass: `password`
Import this file:
Chrome settings (Settings > Manage certificates > Your Certificates > Import)
https://api.magma.shubhamtatvamasi.com/apidocs/v1/

Test API
```bash
MAGMA_CERTS="/home/shubham/magma-secrets/certs"

curl -k \
  --cert $MAGMA_CERTS/admin_operator.pem \
  --key $MAGMA_CERTS/admin_operator.key.pem \
  https://api.magma.shubhamtatvamasi.com
```

Setup admin user:
```bash
export ORC_POD=$(kubectl -n magma get pod -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')
export NMS_POD=$(kubectl -n magma get pod -l app.kubernetes.io/component=magmalte -o jsonpath='{.items[0].metadata.name}')

kubectl -n magma exec -it ${ORC_POD} -- envdir /var/opt/magma/envdir /var/opt/magma/bin/accessc add-existing -admin -cert /var/opt/magma/certs/admin_operator.pem admin_operator
kubectl -n magma exec -it ${NMS_POD} -- yarn setAdminPassword master admin admin
```
