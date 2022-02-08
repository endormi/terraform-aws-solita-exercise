resource "aws_security_group" "exercise_ec2_sg" {
  name        = "exercise-ec2-security-group"
  description = "HTTP, HTTPS and SSH access"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    # SSM should be used here instead
    # but just for this exercise I used SSH
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # This is very bad practice and very insecure
    # You should use a specific IP or range of IPs
    # A VPN for example
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP only"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    description = "Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "solita_exercise_ec2_sg"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_security_group" "exercise_db_sg" {
  name        = "exercise-db-security-group"
  description = "MySQL access"
  vpc_id      = aws_vpc.vpc.id
  depends_on  = [aws_vpc.vpc]

  ingress {
    description = "MySQL access"
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.vpc.cidr_block]
  }

  egress {
    description = "Outgoing traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name    = "solita_exercise_db_sg"
    Project = "solita_exercise_flask_application"
  }
}
