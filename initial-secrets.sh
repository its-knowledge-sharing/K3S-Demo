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

export $(xargs <.env)

SRC_FILE=00-configs/konga-users.cfg
CFG_FILE=konga-users.cfg
cp ${SRC_FILE} ${CFG_FILE}
sed -i "s#<<KONGA_ADMIN_USER>>#${KONGA_ADMIN_USER}#g" ${CFG_FILE}
sed -i "s#<<KONGA_ADMIN_PASSWD>>#${KONGA_ADMIN_PASSWD}#g" ${CFG_FILE}
echo "  KONGA_USERS_CONFIG: $(cat "${CFG_FILE}" | base64 -w0)" >> ${TMP_FILE}

SRC_FILE=00-configs/konga-nodes.cfg
CFG_FILE=konga-nodes.cfg
cp ${SRC_FILE} ${CFG_FILE}
echo "  KONGA_NODES_CONFIG: $(cat "${CFG_FILE}" | base64 -w0)" >> ${TMP_FILE}

KEY_FILE=.gar-sa.json
echo "  GAR_PASSWORD: $(cat "${KEY_FILE}" | base64 -w0)" >> ${TMP_FILE}

SETTING_FILE=.appsetting-promrub-scb.json
echo "  APP_SETTING_SCB: $(cat "${SETTING_FILE}" | base64 -w0)" >> ${TMP_FILE}

SETTING_FILE=.appsetting-promjodd-carpark.json
echo "  APP_SETTING_CARPARK_API: $(cat "${SETTING_FILE}" | base64 -w0)" >> ${TMP_FILE}

cp ${TMP_FILE} ${DST_FILE}
