#!/bin/bash

export $(xargs <.env)

SRC_FILE=00-configs/addons-argocd-tpl.yaml
TMP_FILE=addons-argocd-tpl.yaml
DST_FILE=addons/addons-argocd.yaml

cp ${SRC_FILE} ${TMP_FILE}
sed -i "s#<<ENV>>#${ENV}#g" ${TMP_FILE}
cp ${TMP_FILE} ${DST_FILE}
