#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$SCRIPT_DIR"

# Run common setup
cd common
terraform init
terraform apply -auto-approve -var-file=../terraform.tfvars
FOLDER_ID=$(terraform output -raw ctf_folder_id)
cd ..

# Normalize input: e.g., `challenge01` → `challenges/challenge01`
if [ "$#" -gt 0 ]; then
  CHALLENGES=()
  for ARG in "$@"; do
    CHALLENGES+=("challenges/$ARG")
  done
else
  CHALLENGES=(challenges/*)
fi

# Deploy each challenge
for CHALLENGE in "${CHALLENGES[@]}"; do
  if [ -d "$CHALLENGE" ]; then
    echo "[+] Deploying $CHALLENGE..."
    cd "$CHALLENGE"
    terraform init
    terraform apply -auto-approve \
      -var-file=../../terraform.tfvars \
      -var="ctf_folder_id=$FOLDER_ID"
    cd - > /dev/null
  else
    echo "[!] Skipping: $CHALLENGE is not a directory"
  fi
done
