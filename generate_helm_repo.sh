#!/usr/bin/env bash

set -e

MAGMA_ROOT=/tmp/charts/magma
CHARTS_REPO=/tmp/charts/charts

declare -A orc8r_helm_charts

orc8r_helm_charts=( 
  [orc8r]="orc8r/cloud/helm/orc8r"
  [lte-orc8r]="lte/cloud/helm/lte-orc8r"
  [feg-orc8r]="feg/cloud/helm/feg-orc8r"
  [cwf-orc8r]="cwf/cloud/helm/cwf-orc8r"
  [wifi-orc8r]="wifi/cloud/helm/wifi-orc8r"
  [fbinternal-orc8r]="fbinternal/cloud/helm/fbinternal-orc8r"
)

for orc8r_chart in "${orc8r_helm_charts[@]}"
do
  cp -r ${MAGMA_ROOT}/${orc8r_chart} ${CHARTS_REPO}
done
