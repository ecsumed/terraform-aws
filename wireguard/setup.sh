#! /bin/bash

# Wireguard Install(https://www.wireguard.com/install/)
add-apt-repository ppa:wireguard/wireguard
apt-get update
apt-get install wireguard


# Terraform Install (https://www.terraform.io/downloads.html)
wget -q https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip \
    -P /tmp/ \
    -O terraform.zip && \
  unzip /tmp/terraform.zip -d /tmp/ && \
  mv /tmp/terraform /usr/local/bin/

# Generate Keys
SERV_PRIV_KEY=$(wg genkey)
SERV_PUB_KEY=$(echo ${SERV_PRIV_KEY} | wg pubkey)

CLIENT_PRIV_KEY=$(wg genkey)
CLIENT_PUB_KEY=$(echo ${SERV_PRIV_KEY} | wg pubkey)

export TF_VAR_serv_priv_key=${SERV_PRIV_KEY}
export TF_VAR_serv_pub_key=${SERV_PUB_KEY}
export TF_VAR_client_priv_key=${CLIENT_PRIV_KEY}
export TF_VAR_client_pub_key=${CLIENT_PUB_KEY}

# Provision server
terraform apply -auto-approve -var-file="local_settings.tfvars"
