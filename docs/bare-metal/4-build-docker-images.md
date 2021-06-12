# build docker images

setup parameters:
```bash
export MAGMA_ROOT=$PWD
export PUBLISH=$MAGMA_ROOT/orc8r/tools/docker/publish.sh
export REGISTRY=magmacore
export MAGMA_TAG=1.5.1
```
> comment the docker login part in publish.sh

build and push nginx and controller docker image:
```bash
cd $MAGMA_ROOT/orc8r/cloud/docker
./build.py -a
for image in controller nginx fluentd test ; \
  do ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG} ; done
```

build and push magmalte docker image:
```bash
cd $MAGMA_ROOT/nms/app/packages/magmalte
docker-compose build magmalte
COMPOSE_PROJECT_NAME=magmalte ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}
```

Build and push Federation Gateway images:
```bash
cd $MAGMA_ROOT/feg/gateway/docker
docker-compose build --parallel
for image in gateway_python gateway_go gateway_go_base ; \
  do ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG} ; done
```

Build and push CWF images:
```bash
cd $MAGMA_ROOT/cwf/gateway/docker
docker-compose build --parallel
for image in cwag_go gateway_pipelined gateway_sessiond ; \
  do ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG} ; done
```

build operator image:
```bash
cd $MAGMA_ROOT/cwf/k8s/cwf_operator/docker
docker-compose build
COMPOSE_PROJECT_NAME=operator ${PUBLISH} -r ${REGISTRY} -i operator -v ${MAGMA_TAG}
```


