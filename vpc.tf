locals {
  available_zones = ["${var.region}a", "${var.region}b"]
}

resource "aws_vpc" "vpc" {
  cidr_block       = "${var.vpc_cidr_block}"
  instance_tenancy = "default"

  tags = {
    Name    = "${var.name}_vpc"
    Project = "${var.name}_${var.application}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.name}_igw"
    Project = "${var.name}_${var.application}"
  }
}

# For EC2 Instances
resource "aws_subnet" "pub_subnet" {
  count             = "${length(var.pub_subnet_cidr_block)}"

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "${var.pub_subnet_cidr_block[count.index]}"
  availability_zone = "${local.available_zones[count.index]}"

  tags = {
    Name    = "${var.name}_public_subnet"
    Project = "${var.name}_${var.application}"
  }
}

# For DB
resource "aws_subnet" "priv_subnet" {
  count                   = "${length(var.priv_subnet_cidr_block)}"

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = "${var.priv_subnet_cidr_block[count.index]}"
  availability_zone       = "${local.available_zones[count.index]}"
  map_public_ip_on_launch = false

  tags = {
    Name    = "${var.name}_private_subnet"
    Project = "${var.name}_${var.application}"
  }
}

resource "aws_route_table" "table" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name    = "${var.name}_route_table"
    Project = "${var.name}_${var.application}"
  }
}

resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta" {
  count          = "${length(var.pub_subnet_cidr_block)}"

  subnet_id      = "${element(aws_subnet.pub_subnet.*.id, count.index)}"
  route_table_id = aws_route_table.table.id
}
