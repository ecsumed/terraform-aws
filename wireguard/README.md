## Usage

`terraform plan -var-file="local_settings.tfvars"`

### local_settings.tfvars
```
aws_access_key_id = "<key>"
aws_secret_access_key = "<secret>"
region = "<region>"
conn_user = "<image ssh user>"
conn_pub_key = "<pub key path>"
conn_priv_key = "<private key path>"

# wg genkey | tee >(wg pubkey)
serv_priv_key = ""
serv_pub_key = ""
client_priv_key = ""
client_pub_key = ""
```