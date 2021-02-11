# Setup Magma

create new namespace:
```bash
kubectl create namespace magma
```

Install postgresql
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update

helm install postgresql bitnami/postgresql \
  --namespace magma \
  --set postgresqlPassword=postgres \
  --set postgresqlDatabase=magma \
  --set fullnameOverride=postgresql \
  --version=10.2.6
```

Install mariadb:
```bash
helm install mariadb bitnami/mariadb \
  --namespace magma \
  --set auth.database=magma \
  --set auth.username=magma \
  --set auth.password=password
```

setup repo:
```bash
export MAGMA_ROOT=/home/shubham/git/magma  # or add to path
export PUBLISH=${MAGMA_ROOT}/orc8r/tools/docker/publish.sh  # or add to path
export REGISTRY=shubhamtatvamasi  # or desired registry
export MAGMA_TAG=latest  # 1.3.3-master  # or desired tag
# export REGISTRY=registry.hub.docker.com  # or desired registry

# export USERNAME=shubhamtatvamasi  # or desired tag
# export PASSFILE=/tmp/docker-pass  # or desired tag

# save the docker password on a file
echo -n "docker-password" > /tmp/docker-pass   

# echo ${MAGMA_ROOT}
cd $MAGMA_ROOT
git fetch origin
git checkout tags/v1.3.3 -b $MAGMA_TAG
```

build images:
```bash
cd ${MAGMA_ROOT}/orc8r/cloud/docker
./build.py --all

# push controller and nginx
for image in controller nginx ; do ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG} ; done

# push magmalte image
COMPOSE_PROJECT_NAME=magmalte ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}
```

Assemble Certificates:
```bash
mkdir -p ~/secrets/certs
cd ~/secrets/certs

${MAGMA_ROOT}/orc8r/cloud/deploy/scripts/self_sign_certs.sh rancher.shubhamtatvamasi.com
${MAGMA_ROOT}/orc8r/cloud/deploy/scripts/create_application_certs.sh rancher.shubhamtatvamasi.com

# password = password
openssl pkcs12 -export -inkey admin_operator.key.pem -in admin_operator.pem -out admin_operator.pfx


cp -r ../../../../.cache/test_certs/* charts/secrets/.secrets/certs/.
```

Install magma:
```bash
helm install magma .
```


helm repo add magma-charts --username shubhamtatvamasi --password github-password-or-token \
      'https://raw.githubusercontent.com/shubhamtatvamasi/magma-charts/master/'
helm repo update && helm repo list  # should list the GITHUB_REPO repository
helm search repo magma-charts  # should list the GITHUB_REPO chart


helm fetch --untar magma-charts/orc8r

helm template magma . \

helm install orc8r . \
  --namespace magma \
  --set nms.magmalte.image.repository=shubhamtatvamasi/magmalte \
  --set nms.magmalte.image.tag=1.3.3-master \
  --set nms.secret.certs=orc8r-secrets-certs \
  --set nginx.image.repository=shubhamtatvamasi/nginx \
  --set nginx.image.tag=1.3.3-master \
  --set controller.image.repository=shubhamtatvamasi/controller \
  --set controller.image.tag=1.3.3-master \
  --set nginx.spec.hostname=nginx.rancher.shubhamtatvamasi.com \
  --set metrics.enabled=false \
  --set secrets.create=true \
  --set secrets.secret.certs.enabled=true \
  --set secrets.docker.registry=docker.io \
  --set secrets.docker.username=shubhamtatvamasi \
  --set secrets.docker.password=xxxxxxxxxxx-xxxxxxx-xxxxxxxxxxx \
  --set-file secrets.secret.certs.files."rootCA\.pem"=../secretstemp/rootCA.pem \
  --set-file secrets.secret.certs.files."rootCA\.key"=../secretstemp/rootCA.key \
  --set-file secrets.secret.certs.files."controller\.crt"=../secretstemp/controller.crt \
  --set-file secrets.secret.certs.files."controller\.key"=../secretstemp/controller.key \
  --set-file secrets.secret.certs.files."admin_operator\.pem"=../secretstemp/admin_operator.pem \
  --set-file secrets.secret.certs.files."admin_operator\.key\.pem"=../secretstemp/admin_operator.key.pem \
  --set-file secrets.secret.certs.files."fluentd\.pem"=../secretstemp/fluentd.pem \
  --set-file secrets.secret.certs.files."fluentd\.key"=../secretstemp/fluentd.key \
  --set-file secrets.secret.certs.files."certifier\.pem"=../secretstemp/certifier.pem \
  --set-file secrets.secret.certs.files."certifier\.key"=../secretstemp/certifier.key \
  --set-file secrets.secret.certs.files."bootstrapper\.key"=../secretstemp/bootstrapper.key \
  --set-file secrets.secret.certs.files."nms_nginx\.pem"=../secretstemp/nms_nginx.pem \
  --set-file secrets.secret.certs.files."nms_nginx\.key\.pem"=../secretstemp/nms_nginx.key.pem
  

  nms_nginx.pem
  nms_nginx.key.pem

  --set metrics.prometheus.create=false \
  --set metrics.prometheusConfigurer.create=false \
  --set metrics.grafana.create=false \
  --set metrics.userGrafana.create=false \
  --set metrics.alertmanager.create=false \

   \
  --set-file secrets.secret.certs.files."rootCA\.pem"=../secretstemp/rootCA.pem \
  --set-file secrets.secret.certs.files."rootCA\.pem"=../secretstemp/rootCA.pem \


  bootstrapper.key
  
           
      certifier.key            






  --set-file secrets.secret.certs.files.rootCA-pem=../secretstemp/rootCA.pem \
  --set-file secrets.secret.certs.files.controller-crt=../secretstemp/controller.crt \
  --set-file secrets.secret.certs.files.controller-key=../secretstemp/controller.key \
  --set-file secrets.secret.certs.files."admin_operator.pem"=../secretstemp/admin_operator.pem \
  --set-file secrets.secret.certs.files."admin_operator.key.pem"=../secretstemp/admin_operator.key.pem \
  --set-file secrets.secret.certs.files."fluentd.pem"=../secretstemp/fluentd.pem \
  --set-file secrets.secret.certs.files."fluentd.key"=../secretstemp/fluentd.key



  --set-file secrets.secret.certs.files."rootCA.pem"=../secretstemp/rootCA.pem \
  --set-file secrets.secret.certs.files."controller.crt"=../secretstemp/controller.crt \
  --set-file secrets.secret.certs.files."controller.key"=../secretstemp/controller.key \
  --set-file secrets.secret.certs.files."admin_operator.pem"=../secretstemp/admin_operator.pem \
  --set-file secrets.secret.certs.files."admin_operator.key.pem"=../secretstemp/admin_operator.key.pem \
  --set-file secrets.secret.certs.files."fluentd.pem"=../secretstemp/fluentd.pem \
  --set-file secrets.secret.certs.files."fluentd.key"=../secretstemp/fluentd.key



  --set secrets.secret.certs.files.rootCA="`cat ../secretstemp/rootCA.pem`"




magma-secrets-registry

mkdir ../secretstemp


  --set metrics.metrics.volumes.prometheusConfig.volumeSpec.emptyDir={} \
  
  .dashboards.emptyDir={} \
  --set metrics.userGrafana.volumes.datasources.emptyDir={} \
  --set metrics.userGrafana.volumes.dashboardproviders.emptyDir={} \
  --set metrics.userGrafana.volumes.grafanaData.emptyDir={}


  --set metrics.grafana.image.repository=grafana/grafana \
  --set metrics.grafana.image.tag=latest


  --set metrics.metrics.volumes.prometheusConfig.volumeSpec=emptyDir \

    volumes:
  - name: cache-volume
    emptyDir: {}


   \


/home/shubham/git/magma/orc8r/cloud/deploy/scripts/ 

../../deploy/scripts/self_sign_certs.sh rancher.shubhamtatvamasi.com
../../deploy/scripts/create_application_certs.sh rancher.shubhamtatvamasi.com


./self_sign_certs.sh rancher.shubhamtatvamasi.com
./create_application_certs.sh rancher.shubhamtatvamasi.com


kubectl create secret generic orc8r-secrets-certs \
kubectl create secret generic orc8r-secrets-configs-orc8r \

kubectl create secret generic orc8r-secrets-envdir \
  --from-file=bootstrapper.key \
  --from-file=admin_operator.key.pem \
  --from-file=admin_operator.pem \
  --from-file=certifier.pem \
  --from-file=certifier.key \
  --from-file=controller.key \
  --from-file=controller.crt \
  --from-file=fluentd.key \
  --from-file=fluentd.pem \
  --from-file=rootCA.key \
  --from-file=rootCA.pem


       controller.key               fluentd.key  rootCA.key 
admin_operator.pem      certifier.key     controller.crt  fluentd.pem  rootCA.pem

