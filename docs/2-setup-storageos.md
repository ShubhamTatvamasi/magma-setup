# Setup StorageOS

Add etcd and storageOS repo
```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add storageos https://charts.storageos.com
helm repo update
```

Setup volume for etcd:
```bash
kubectl apply -f - << EOF
apiVersion: v1
kind: PersistentVolume
metadata:
  name: etcd
spec:
  storageClassName: manual
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 5Gi
  hostPath:
    path: "/opt/etcd"
EOF
```

Run the follwoing command on the node for giving volume permission to the pod:
```bash
chown 1001:1001 /opt/etcd
```

Install etcd:
```bash
kubectl create namespace etcd

helm install etcd bitnami/etcd \
  --namespace etcd \
  --set persistence.storageClass=manual \
  --set persistence.size=5Gi \
  --set auth.rbac.enabled=false \
  --version=5.5.2
```
---

Install StorageOS:
```bash
kubectl create namespace storageos-operator

helm upgrade -i storageos storageos/storageos-operator \
  --namespace storageos-operator \
  --set cluster.kvBackend.address=etcd.etcd.svc:2379 \
  --set cluster.admin.password=storageos \
  --version=0.4.4
```

Make storageOS default class:
```bash
kubectl patch storageclass fast \
  --patch='{
    "metadata": {
      "annotations": {
        "storageclass.kubernetes.io/is-default-class": "true"
      }
    }
  }'
```
