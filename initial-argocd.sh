#!/bin/bash

export $(xargs <.env)

SRC_FILE=00-configs/addons-argocd-tpl.yaml
DST_FILE=addons/addons-argocd.yaml

cp ${SRC_FILE} ${DST_FILE}

sed -i "s#<<ENV>>#${ENV}#g" ${DST_FILE}
