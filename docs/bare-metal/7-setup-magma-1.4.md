# setup magma helm 1.4


```bash
export dns_domain=magma.shubhamtatvamasi.com
export magma_root=/home/shubham/git/magma
export scripts=$magma_root/orc8r/cloud/deploy/scripts
export db_root_password=password
export postgresql_password=postgres
export namespace=orc8r
export magma_secrets=~/magma-secrets/certs
export db_setup=~/magma-secrets
export nms_db_user=magma
export nms_db_pass=password
export orc8r_db_user=orc8r
export orc8r_db_pass=password

$ mkdir $magma_secrets && \
    cp -r <secrets>/* $magma_secrets/

mkdir -p ~/magma-secrets/certs
mkdir -p ~/magma-secrets/yaml

eval $scripts/self_sign_certs.sh $dns_domain
eval $scripts/create_application_certs.sh $dns_domain
```

Install postgresql:
```bash
helm install postgresql bitnami/postgresql \
  --namespace $namespace \
  --set postgresqlPassword=$postgresql_password \
  --set postgresqlDatabase=magma \
  --set fullnameOverride=postgresql
```

Install mariadb:
```bash
helm install mariadb bitnami/mariadb \
  --namespace $namespace \
  --version 7.3.14 \
  --set image.tag=10.3.22-debian-10-r27 \
  --set master.extraFlags="--sql-mode=ANSI_QUOTES" \
  --set rootUser.password=$db_root_password
```

Setup mariadb:
```bash
curl -sL https://github.com/magma/magma/raw/master/orc8r/cloud/deploy/bare-metal/db_setup.sql.tpl | \
  envsubst > $db_setup/db_setup.sql

kubectl exec -it mariadb-master-0 \
  --namespace $namespace \
  -- mysql -u root --password=$db_root_password < $db_setup/db_setup.sql
```

```bash
helm install orc8r shubhamtatvamasi/orc8r \
  --version 1.5.12 \
  --namespace $namespace \
  --set metrics.enabled=false \
  --set nms.magmalte.image.repository=shubhamtatvamasi/magmalte \
  --set nms.magmalte.image.tag=v1.4 \
  --set nms.nginx.service.type=LoadBalancer \
  --set nms.secret.certs=orc8r-secrets-certs \
  --set nms.magmalte.env.mysql_host=mariadb.orc8r.svc.cluster.local \
  --set nms.magmalte.env.api_host=api.magma.shubhamtatvamasi.com \
  --set nginx.image.repository=shubhamtatvamasi/nginx \
  --set nginx.image.tag=v1.4 \
  --set nginx.spec.hostname=controller.magma.shubhamtatvamasi.com \
  --set nginx.service.type=LoadBalancer \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4 \
  --set controller.spec.service_registry.mode=k8s \
  --set secrets.create=true \
  --set secrets.secret.certs.enabled=true \
  --set-file secrets.secret.certs.files."rootCA\.pem"=$magma_secrets/rootCA.pem \
  --set-file secrets.secret.certs.files."rootCA\.key"=$magma_secrets/rootCA.key \
  --set-file secrets.secret.certs.files."controller\.crt"=$magma_secrets/controller.crt \
  --set-file secrets.secret.certs.files."controller\.key"=$magma_secrets/controller.key \
  --set-file secrets.secret.certs.files."admin_operator\.pem"=$magma_secrets/admin_operator.pem \
  --set-file secrets.secret.certs.files."admin_operator\.key\.pem"=$magma_secrets/admin_operator.key.pem \
  --set-file secrets.secret.certs.files."fluentd\.pem"=$magma_secrets/fluentd.pem \
  --set-file secrets.secret.certs.files."fluentd\.key"=$magma_secrets/fluentd.key \
  --set-file secrets.secret.certs.files."bootstrapper\.key"=$magma_secrets/bootstrapper.key \
  --set-file secrets.secret.certs.files."certifier\.key"=$magma_secrets/certifier.key \
  --set-file secrets.secret.certs.files."certifier\.pem"=$magma_secrets/certifier.pem \
  --set-file secrets.secret.certs.files."nms_nginx\.key\.pem"=$magma_secrets/nms_nginx.key.pem \
  --set-file secrets.secret.certs.files."nms_nginx\.pem"=$magma_secrets/nms_nginx.pem \
  --set secrets.docker.registry=docker.io \
  --set secrets.docker.username=shubhamtatvamasi \
  --set secrets.docker.password=password
```

Updated the env:
```bash
# Update env PROXY_BACKENDS
# orc8r-nginx-proxy.magma.svc.cluster.local
kubectl edit deploy orc8r-nginx
```

Install lte-orc8r:
```bash
helm install lte-orc8r shubhamtatvamasi/lte-orc8r \
  --namespace $namespace \
  --set controller.spec.service_registry.mode=k8s \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4
```

Install feg-orc8r:
```bash
helm install feg-orc8r shubhamtatvamasi/feg-orc8r \
  --namespace $namespace \
  --set controller.spec.service_registry.mode=k8s \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4
```

Install fbinternal-orc8r:
```bash
helm install fbinternal-orc8r shubhamtatvamasi/fbinternal-orc8r \
  --namespace $namespace \
  --set controller.spec.service_registry.mode=k8s \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4
```

Install wifi-orc8r:
```
helm install wifi-orc8r shubhamtatvamasi/wifi-orc8r \
  --namespace $namespace \
  --set controller.spec.service_registry.mode=k8s \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4
```

Install: cwf-orc8r
```
helm install cwf-orc8r shubhamtatvamasi/cwf-orc8r \
  --namespace $namespace \
  --set controller.spec.service_registry.mode=k8s \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=v1.4
```

Setup admin user:
```bash
export ORC_POD=$(kubectl -n $namespace get pod -l app.kubernetes.io/component=orchestrator -o jsonpath='{.items[0].metadata.name}')
export NMS_POD=$(kubectl -n $namespace get pod -l app.kubernetes.io/component=magmalte -o jsonpath='{.items[0].metadata.name}')

kubectl -n $namespace exec -it ${ORC_POD} -- envdir /var/opt/magma/envdir /var/opt/magma/bin/accessc add-existing -admin -cert /var/opt/magma/certs/admin_operator.pem admin_operator
kubectl -n $namespace exec -it ${NMS_POD} -- yarn setAdminPassword master admin admin
```
