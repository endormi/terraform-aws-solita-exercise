# Creates a random password for db
resource "random_password" "exercise_password" {
  length           = 18
  special          = true
  override_special = "_%@"
}

resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "db-subnet"
  description = "Solita exercise db subnet group"
  subnet_ids  = "${data.aws_subnet.priv_subnet.*.id}"
}

resource "aws_db_instance" "rds_db" {
  identifier             = "exercise-rds-db"
  allocated_storage      = "${var.db_allocated_storage}"
  engine                 = "${var.engine}"
  engine_version         = "${var.engine_version}"
  instance_class         = "${var.instance_class}"
  name                   = "exercise"
  username               = "root"
  password               = random_password.exercise_password.result
  parameter_group_name   = "${var.parameter_group_name}"
  skip_final_snapshot    = true
  publicly_accessible    = false
  storage_encrypted      = true
  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.exercise_db_sg.id]
  multi_az               = true

  tags = {
    Name      = "${var.name}_db"
    Project   = "${var.name}_${var.application}"
    Encrypted = true
  }
}
