## Requirements
* [Wireguard](https://www.wireguard.com/install/)
* [Terraform](https://www.terraform.io/downloads.html) (>0.12)
* AWS access key/secret

## Usage

First, setup `local_settings.tfvars` inside the `aws/wireguard` directory:

```bash
aws_access_key_id = "<key>"
aws_secret_access_key = "<secret>"
region = "<region>"
```

### Provision:
```bash
cd aws/wireguard
./setup.py
```

### Destroy:
```bash
cd aws/wireguard
sudo terraform destroy -var-file="local_settings.tfvars" -auto-approve
```

###### Wireguard interface commands:
```bash 
# up
sudo wg-quick up wg0-client
# down
sudo wg-quick down wg0-client
```