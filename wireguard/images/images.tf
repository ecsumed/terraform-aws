
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

output id {
  value = "${data.aws_ami.debian.id}"
}
