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
  vars = {
    serv_priv_key = "${var.serv_priv_key}"
    client_pub_key = "${var.client_pub_key}"
  }
}

resource "aws_instance" "instance" {
  count = "${length(keys(var.wg_hosts))}"

  ami           = "${var.image_id}"
  instance_type = "t2.micro"

  tags = {
    Name = "fhd-terra-${element(values(var.wg_hosts), count.index)}"
  }

  root_block_device {
    volume_size = 10
  }

  key_name = "${var.ssh_pub_key_id}"

  provisioner "remote-exec" {
    inline = ["sudo ${template_file.bootstrap.rendered}"]

    connection {
      host = self.public_ip
      type        = "ssh"
      user        = "${var.ssh_conn_user}"
      private_key = "${file(var.ssh_conn_priv_key)}"
      timeout     = "30s"
    }
  }
  provisioner "local-exec" {
    command = <<EOT
        cat>>/etc/wireguard/wg0-client.conf<<EOF
        [Interface]
        Address = 10.100.100.2/32
        PrivateKey = ${var.client_priv_key} 

        [Peer]
        PublicKey = ${var.serv_pub_key}
        Endpoint = ${aws_instance.instance[0].public_ip}:51820
        AllowedIPs = 0.0.0.0/0
        PersistentKeepalive = 21
        EOF
  EOT
  }
}

resource "template_file" "bootstrap-client" {
  template = "${file("${path.module}/bootstrap-client.tmpl")}"
  vars = {
    serv_pub_key = "${var.serv_pub_key}"
    client_priv_key = "${var.client_priv_key}"
    server_ip = "${aws_instance.instance[0].public_ip}"
  }
}

output config {
  value = "${template_file.bootstrap-client.rendered}"
}
