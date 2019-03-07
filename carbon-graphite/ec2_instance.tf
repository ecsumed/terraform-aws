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

data "aws_ami" "debian" {
  most_recent = true

  filter {
    name   = "name"
    values = ["debian-stretch-hvm-x86_64-gp2-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["379101102735"]
}

resource "aws_key_pair" "fhd-key" {
  key_name   = "fhd-key"
  public_key = "${file(var.conn_pub_key)}"
}

resource "aws_instance" "fhd-instance-1" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-carbon-1"
  }

  key_name = "${aws_key_pair.fhd-key.id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'remote provisioner' > terraform_remote_provisioner",
    ]

    connection {
      type        = "ssh"
      user        = "${var.conn_user}"
      private_key = "${file(var.conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

resource "aws_instance" "fhd-instance-2" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-carbon-2"
  }

  key_name = "${aws_key_pair.fhd-key.id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'remote provisioner' > terraform_remote_provisioner",
    ]

    connection {
      type        = "ssh"
      user        = "${var.conn_user}"
      private_key = "${file(var.conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

resource "aws_instance" "fhd-instance-3" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-lb-1"
  }

  key_name = "${aws_key_pair.fhd-key.id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'remote provisioner' > terraform_remote_provisioner",
    ]

    connection {
      type        = "ssh"
      user        = "${var.conn_user}"
      private_key = "${file(var.conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

resource "aws_instance" "fhd-instance-4" {
  ami           = "${data.aws_ami.debian.id}"
  instance_type = "t2.micro"

  tags {
    Name = "fhd-terraform-created-graphite-1"
  }

  key_name = "${aws_key_pair.fhd-key.id}"

  provisioner "remote-exec" {
    inline = [
      "echo 'remote provisioner' > terraform_remote_provisioner",
    ]

    connection {
      type        = "ssh"
      user        = "${var.conn_user}"
      private_key = "${file(var.conn_priv_key)}"
      timeout     = "30s"
    }
  }
}

output ip {
  value = "carbon 1 ${aws_instance.fhd-instance-1.public_ip}"
}
output ip2 {
  value = "carbon 2 ${aws_instance.fhd-instance-2.public_ip}"
}
output ip3 {
  value = "load balancer ${aws_instance.fhd-instance-3.public_ip}"
}

output ip4 {
  value = "graphite web ${aws_instance.fhd-instance-4.public_ip}"
}
