data "aws_subnet" "pub_subnet" {
  count = "${length(local.pub_subnet_cidr_block)}"
  id    = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
}

data "aws_subnet" "priv_subnet" {
  count = "${length(local.priv_subnet_cidr_block)}"
  id    = "${element(aws_subnet.priv_subnet.*.id, count.index)}"
}

data "template_file" "userdata" {
  template = file("user-data")

  vars = {
    db_host     = aws_db_instance.rds_db.address
    db_user     = aws_db_instance.rds_db.username
    db_password = aws_db_instance.rds_db.password
    db_name     = aws_db_instance.rds_db.name
  }
}
