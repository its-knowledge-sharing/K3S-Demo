#!/bin/bash

SRC_FILE=.env
DST_FILE=addons/initial-secrets.yaml
SECRET=initial-secret
TMP_FILE=/tmp/${SECRET}.tmp

cat <<END > "${TMP_FILE}"
apiVersion: v1
kind: Secret
metadata:
  name: ${SECRET}
type: Opaque
data:
END

cat ${SRC_FILE} | while read line
do
  regex="^(.+?)=(.+)$"
  if [[ $line =~ $regex ]]; then
    KEY=${BASH_REMATCH[1]}
    VALUE=${BASH_REMATCH[2]}

    echo "  ${KEY}: $(echo -n "${VALUE}" | base64 -w0)" >> ${TMP_FILE}
  fi
done

cp ${TMP_FILE} ${DST_FILE} 