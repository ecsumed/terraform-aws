## Requirements
* [Wireguard](https://www.wireguard.com/install/)
* [Terraform](https://www.terraform.io/downloads.html) (>0.12)
* AWS access key/secret

## Setup
- Install Wireguard if not already done so
```bash
 # Wireguard Install(https://www.wireguard.com/install/)
sudo add-apt-repository ppa:wireguard/wireguard -y
sudo apt-get update
sudo apt-get install wireguard -y
```

- Install terraform
```bash
# Terraform Install (https://www.terraform.io/downloads.html)
sudo wget -q https://releases.hashicorp.com/terraform/0.12.18/terraform_0.12.18_linux_amd64.zip \
      -O /tmp/terraform.zip && \
    unzip /tmp/terraform.zip -d /tmp/ && \
    mv /tmp/terraform /usr/local/bin/

```


- Configure `local_settings.tfvars` inside the `aws/wireguard` directory:

```bash
aws_access_key_id = "<key>"
aws_secret_access_key = "<secret>"
region = "<region>"
```

### Provision
```bash
cd aws/wireguard
./setup.py
# The ouput of this script will show commands to configure the wireguard-client config file
# Run those commands with sudo 
# Example
cat>>/etc/wireguard/wg0-client.conf<<EOF
[Interface]
Address = 10.100.100.2/32
PrivateKey = <sample-priv-key>

[Peer]
PublicKey = <sample-pub-key>
Endpoint = <IP>:51820
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 21
EOF

sudo wg-quick up wg0-client
```

### Destroy
```bash
cd aws/wireguard
terraform destroy -var-file="local_settings.tfvars" -auto-approve
```

#### Wireguard interface commands
```bash 
# activate
sudo wg-quick up wg0-client
# deactivate
sudo wg-quick down wg0-client
```
