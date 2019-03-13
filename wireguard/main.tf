variable "aws_access_key_id" {}
variable "aws_secret_access_key" {}
variable "region" {}
variable "conn_user" {}
variable "conn_pub_key" {}
variable "conn_priv_key" {}

variable "serv_priv_key" {}
variable "serv_pub_key" {}
variable "client_priv_key" {}
variable "client_pub_key" {}

variable "wg_hosts" {
  default = {
    "a" = "wg-1"
  }
}

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

module "wireguards" {
  source = "./wireguards"

  ssh_pub_key_id = "${module.key_pairs.ssh_key_id}"
  ssh_conn_user = "${var.conn_user}"
  ssh_conn_priv_key = "${var.conn_priv_key}"
  image_id = "${module.images.id}"
  wg_hosts = "${var.wg_hosts}"
  serv_priv_key = "${var.serv_priv_key}"
  serv_pub_key = "${var.serv_pub_key}"
  client_pub_key = "${var.client_pub_key}"
  client_priv_key = "${var.client_priv_key}"
}

output wireguards {
  value = "${module.wireguards.config}"
}
