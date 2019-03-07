variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "region" {}
variable "conn_user" {}
variable "conn_pub_key" {}
variable "conn_priv_key" {}

provider "aws" {
  region = "${var.region}"
  access_key = "${var.aws_access_key_id}"
  secret_key = "${var.aws_secret_access_key}"
}

module "images" {
  source = "./images"
}

module "key_pairs" {
  source = "./key_pairs"

  conn_pub_key = "${var.conn_pub_key}"

}

module "carbons" {
  source = "./carbons"

  ssh_pub_key_id = "${module.key_pairs.ssh_key_id}"
  ssh_conn_user = "${var.conn_user}"
  ssh_conn_priv_key = "${var.conn_priv_key}"
  image_id = "${module.images.id}"
}

module "lb_relay" {
  source = "./lb_relay"

  ssh_pub_key_id = "${module.key_pairs.ssh_key_id}"
  ssh_conn_user = "${var.conn_user}"
  ssh_conn_priv_key = "${var.conn_priv_key}"
  image_id = "${module.images.id}"

  carbons = "${module.carbons.carbon1_public_ip}:2004:a, ${module.carbons.carbon2_public_ip}:2004:b"
}

module "graphite" {
  source = "./graphite"

  ssh_pub_key_id = "${module.key_pairs.ssh_key_id}"
  ssh_conn_user = "${var.conn_user}"
  ssh_conn_priv_key = "${var.conn_priv_key}"
  image_id = "${module.images.id}"
  
  carbons = "\"${module.carbons.carbon1_public_ip}\", \"${module.carbons.carbon2_public_ip}\""
}

output carbon1 {
  value = "${module.carbons.carbon1_public_ip}"
}

output carbon2 {
  value = "${module.carbons.carbon2_public_ip}"
}

output lb_relay {
  value = "${module.lb_relay.public_ip}"
}

output graphite {
  value = "${module.graphite.public_ip}"
}
