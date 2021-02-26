# build docker images


setup parameters:
```bash
export MAGMA_ROOT=/tmp/magma-new/magma
export PUBLISH=$MAGMA_ROOT/orc8r/tools/docker/publish.sh
export REGISTRY=shubhamtatvamasi
export MAGMA_TAG=1.4.0-beta.1
```
> comment the docker login part in publish.sh

build and push nginx and controller docker image:
```bash
cd $MAGMA_ROOT/orc8r/cloud/docker
./build.py -a
for image in controller nginx ; do ${PUBLISH} -r ${REGISTRY} -i ${image} -v ${MAGMA_TAG} ; done
```

build and push magmalte docker image:
```bash
cd $MAGMA_ROOT/nms/app/packages/magmalte
docker-compose build magmalte
COMPOSE_PROJECT_NAME=magmalte ${PUBLISH} -r ${REGISTRY} -i magmalte -v ${MAGMA_TAG}
```
