variable "ssh_pub_key_id" {}
variable "ssh_conn_priv_key" {}
variable "ssh_conn_user" {}
variable "image_id" {}
variable "carbon_hosts" {type = "map"}

resource "template_file" "bootstrap" {
  count = "${length(keys(var.carbon_hosts))}"

  template = "${file("${path.module}/bootstrap.tmpl")}"
  vars {
    carbon_ch = "${element(keys(var.carbon_hosts), count.index)}"
  }
}

resource "aws_instance" "instance" {
  count = "${length(keys(var.carbon_hosts))}"

  ami           = "${var.image_id}"
  instance_type = "c5.xlarge"

  tags {
    Name = "fhd-terra-${element(values(var.carbon_hosts), count.index)}"
  }

  root_block_device {
    volume_size = 100
  }

  key_name = "${var.ssh_pub_key_id}"

  provisioner "remote-exec" {
    inline = "sudo ${element(template_file.bootstrap.*.rendered, count.index)}"

    connection {
      type        = "ssh"
      user        = "${var.ssh_conn_user}"
      private_key = "${file(var.ssh_conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

output public_ips {
  value = "${aws_instance.instance.*.public_ip}"
}
