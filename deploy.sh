#!/bin/bash

echo -e "\n\nCleanup\n\n"
bosh_name="$(bosh env --json | jq -r '.Tables[0].Rows[0].name')"
credhub delete -p "/${bosh_name}/sap-bosh-841" || true
bosh -n -d sap-bosh-841 delete-deployment --force || true

echo -e "\n\nCreating initial deploy\n\n"
bosh -n deploy -d sap-bosh-841 ./manifest.yml

echo -e "\n\nIntroducing a new variable with a failing deploy\n\n"
bosh -n deploy -d sap-bosh-841 -o introduce-variable.yml ./manifest.yml || true

echo -e "\n\nTrying to recreate the instace\n\n"
bosh -n -d sap-bosh-841 recreate debug/0 --no-converge
