# setup magma

Install magma:
```bash
helm upgrade --install orc8r magma-charts/orc8r \
  --version 1.4.36 \
  --namespace magma \
  -f charts/orc8r.yaml --wait
```

export ORC_POD=$(kubectl -n magma get pod -l app.kubernetes.io/component=controller -o jsonpath='{.items[0].metadata.name}')
export NMS_POD=$(kubectl -n magma get pod -l app.kubernetes.io/component=magmalte -o jsonpath='{.items[0].metadata.name}')

kubectl -n magma exec -it ${ORC_POD} -- envdir /var/opt/magma/envdir /var/opt/magma/bin/accessc add-existing -admin -cert /var/opt/magma/certs/admin_operator.pem admin_operator || :
kubectl -n magma exec -it ${NMS_POD} -- yarn setAdminPassword master info@shubhamtatvamasi.com password

yarn setAdminPassword master admin admin


verify user was created successfully:
```bash
kubectl exec ${ORC_POD} -- envdir /var/opt/magma/envdir /var/opt/magma/bin/accessc list-certs
```

kubectl create ns mariadb || :
helm -n mariadb upgrade --install mariadb bitnami/mariadb --version 7.3.14 -f charts/mariadb.yaml --wait

