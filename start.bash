#!/bin/bash

./initial-argocd.sh
./initial-secrets.sh

sudo docker-compose up -d
