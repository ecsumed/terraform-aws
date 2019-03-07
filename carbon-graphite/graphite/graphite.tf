variable "ssh_pub_key_id" {}
variable "ssh_conn_priv_key" {}
variable "ssh_conn_user" {}
variable "image_id" {}

resource "aws_instance" "instance-1" {
  ami           = "${var.image_id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-graphite-1"
  }

  key_name = "${var.ssh_pub_key_id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'remote provisioner' > terraform_remote_provisioner",
    ]

    connection {
      type        = "ssh"
      user        = "${var.ssh_conn_user}"
      private_key = "${file(var.ssh_conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

output public_ip {
  value = "${aws_instance.instance-1.public_ip}"
}
