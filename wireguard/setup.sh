#! /bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

# Generate Keys
SERV_PRIV_KEY=$(wg genkey)
SERV_PUB_KEY=$(echo ${SERV_PRIV_KEY} | wg pubkey)
CLIENT_PRIV_KEY=$(wg genkey)
CLIENT_PUB_KEY=$(echo ${CLIENT_PRIV_KEY} | wg pubkey)

export TF_VAR_serv_priv_key=${SERV_PRIV_KEY}
export TF_VAR_serv_pub_key=${SERV_PUB_KEY}
export TF_VAR_client_priv_key=${CLIENT_PRIV_KEY}
export TF_VAR_client_pub_key=${CLIENT_PUB_KEY}

# Setup SSH Keys
test -f "${DIR}/sshkey" && rm "${DIR}/sshkey" && rm "${DIR}/sshkey.pub" 
ssh-keygen -b 2048 -t rsa -f "${DIR}/sshkey" -q -N ""

export TF_VAR_conn_user=admin
export TF_VAR_conn_priv_key=sshkey
export TF_VAR_conn_pub_key=sshkey.pub

# Provision server
terraform init
terraform apply -auto-approve -var-file="local_settings.tfvars"
