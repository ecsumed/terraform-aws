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
```


### load tester
```while true; do  clear; echo "`date`----------------START" ; time ./data-sender.py 90000 8 1000 10000; echo "`date`----------STOP" ; sleep 150; done;```
