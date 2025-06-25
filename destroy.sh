#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Destroy all challenges unconditionally
for CHALLENGE in challenges/*; do
  if [ -d "$CHALLENGE" ]; then
    echo "[!] Destroying $CHALLENGE..."
    cd "$CHALLENGE"
    terraform destroy -auto-approve -var-file=../../terraform.tfvars || true
    cd - > /dev/null
  fi
done

# Destroy common infra
cd common
terraform destroy -auto-approve -var-file=../terraform.tfvars
