variable "conn_pub_key" {}

resource "aws_key_pair" "fhd-key" {
  key_name   = "fhd-wg-key"
  public_key = "${file(var.conn_pub_key)}"
}

output ssh_key_id {
  value = "${aws_key_pair.fhd-key.id}"
}
