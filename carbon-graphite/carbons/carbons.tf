variable "ssh_pub_key_id" {}
variable "ssh_conn_priv_key" {}
variable "ssh_conn_user" {}
variable "image_id" {}

resource "template_file" "bootstrap" {
  template = "${file("${path.module}/bootstrap.tmpl")}"
}

resource "aws_instance" "instance-1" {
  ami           = "${var.image_id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-carbon-1"
  }

  root_block_device {
    volume_size = 100
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

resource "aws_instance" "instance-2" {
  ami           = "${var.image_id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-carbon-2"
  }
  
  root_block_device {
    volume_size = 100
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

output carbon1_public_ip {
  value = "${aws_instance.instance-1.public_ip}"
}

output carbon2_public_ip {
  value = "${aws_instance.instance-2.public_ip}"
}
