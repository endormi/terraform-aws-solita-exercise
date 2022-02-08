locals {
  pub_subnet_cidr_block  = ["10.0.1.0/24", "10.0.2.0/24"]
  priv_subnet_cidr_block = ["10.0.3.0/24", "10.0.4.0/24"]
  available_zones        = ["eu-north-1a", "eu-north-1b"]
}

resource "aws_vpc" "vpc" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name    = "solita_exercise_vpc"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "solita_exercise_igw"
    Project = "solita_exercise_flask_application"
  }
}

# For EC2 Instances
resource "aws_subnet" "pub_subnet" {
  count             = "${length(local.pub_subnet_cidr_block)}"

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${local.pub_subnet_cidr_block[count.index]}"
  availability_zone = "${local.available_zones[count.index]}"

  tags = {
    Name    = "solita_exercise_public_subnet"
    Project = "solita_exercise_flask_application"
  }
}

# For DB
resource "aws_subnet" "priv_subnet" {
  count                   = "${length(local.priv_subnet_cidr_block)}"

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${local.priv_subnet_cidr_block[count.index]}"
  availability_zone       = "${local.available_zones[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name    = "solita_exercise_private_subnet"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "solita_exercise_route_table"
    Project = "solita_exercise_flask_application"
  }
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta" {
  count          = "${length(local.pub_subnet_cidr_block)}"

  subnet_id      = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.table.id
}
