variable "ssh_pub_key_id" {}
variable "ssh_conn_priv_key" {}
variable "ssh_conn_user" {}
variable "image_id" {}
variable "wg_hosts" {type = "map"}

variable "serv_priv_key" {}
variable "serv_pub_key" {}
variable "client_priv_key" {}
variable "client_pub_key" {}


resource "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.tmpl")}"
  vars {
    serv_priv_key = "${var.serv_priv_key}"
    client_pub_key = "${var.client_pub_key}"
  }
}

resource "template_file" "bootstrap-client" {
  template = "${file("${path.module}/bootstrap-client.tmpl")}"
  vars {
    serv_pub_key = "${var.serv_pub_key}"
    client_priv_key = "${var.client_priv_key}"
  }
}

resource "aws_instance" "instance" {
  count = "${length(keys(var.wg_hosts))}"

  ami           = "${var.image_id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terra-${element(values(var.wg_hosts), count.index)}"
  }

  root_block_device {
    volume_size = 10
  }

  key_name = "${var.ssh_pub_key_id}"

  provisioner "remote-exec" {
    inline = "sudo ${template_file.bootstrap.rendered}"

    connection {
      type        = "ssh"
      user        = "${var.ssh_conn_user}"
      private_key = "${file(var.ssh_conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

output config {
  value = "${template_file.bootstrap-client.rendered}"
}
