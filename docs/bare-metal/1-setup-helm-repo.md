# setup helm repo

https://github.com/settings/tokens

clone magma project:
```bash
git clone https://github.com/magma/magma.git
```

https://github.com/magma/magma/tree/a7580153a6685a3e3035ad25f494daa3f4362214

Switch to specific version of Magma:
```bash
export MAGMA_ROOT=/tmp/magma
export MAGMA_VERSION=v1.3.3
cd ${MAGMA_ROOT}
git fetch origin

git checkout a7580153 # Use this for stable release
git checkout ${MAGMA_VERSION}
```

get all dependencies for helm packaging:
```bash
cd ${MAGMA_ROOT}/orc8r/cloud/helm/orc8r/
helm dependency update
```

package the orc8r:
```bash
# Only for the first time
mkdir ~/magma-charts && cd ~/magma-charts
git init
################

helm package ${MAGMA_ROOT}/orc8r/cloud/helm/orc8r/ && helm repo index .
```

Add private magma helm repo:
```bash
export GITHUB_REPO=magma-charts
export GITHUB_USERNAME=shubhamtatvamasi
export GITHUB_ACCESS_TOKEN=f2f8104acd63b022400d05ea4fbcdd89e4c62c76

helm repo add ${GITHUB_REPO} \
  --username ${GITHUB_USERNAME} \
  --password ${GITHUB_ACCESS_TOKEN} \
  "https://raw.githubusercontent.com/${GITHUB_USERNAME}/${GITHUB_REPO}/master/"
```

update helm repo and 
```bash
helm repo update
helm search repo ${GITHUB_REPO}
```
