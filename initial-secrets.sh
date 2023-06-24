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

    KEY=$(echo -e "$line" | perl -0777 -ne 'print $1 if /^(.+?)=(.+)$/')
    VALUE=$(echo -e "$line" | perl -0777 -ne 'print $2 if /^(.+?)=(.+)$/')

    echo "  ${KEY}: $(echo -n "${VALUE}" | base64 -w0)" >> ${TMP_FILE}
  fi
done

cp ${TMP_FILE} ${DST_FILE}
