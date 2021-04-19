#!/bin/bash

echo -e "\n\nCleanup\n\n"
bosh_name="$(bosh env --json | jq -r '.Tables[0].Rows[0].name')"
credhub delete -p "/${bosh_name}/sap-bosh-841" || true
bosh -n -d sap-bosh-841 delete-deployment --force || true

echo -e "\n\nCreating initial deploy\n\n"
bosh -n deploy -d sap-bosh-841 ./manifest.yml

echo -e "\n\nIntroducing a new variable with a failing deploy\n\n"
bosh -n deploy -d sap-bosh-841 -o introduce-variable.yml ./manifest.yml || true

echo -e "\n\nDisable resurrection\n\n"
bosh -n -d sap-bosh-841 update-resurrection off

echo -e "\n\nDelete instance\n\n"
vm_cid="$(bosh -d sap-bosh-841 instances --details --json | jq -r '.Tables[0].Rows[0].vm_cid')"
bosh -n -d sap-bosh-841 delete-vm ${vm_cid}

echo -e "\n\nCloud Check to recreate_vm (fails with template error)\n\n"
bosh -n -d sap-bosh-841 cck --resolution=recreate_vm


