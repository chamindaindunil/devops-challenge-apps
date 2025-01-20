resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_subnet" "public_subnet" {
  count                   = length(var.public_subnets)
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.az_set[count.index]
  map_public_ip_on_launch = true
  vpc_id                  = aws_vpc.main.id

  tags = {
    "Name" = "public-subnet"
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public_route.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rta_public" {
  count          = length(var.public_subnets)
  subnet_id      = aws_subnet.public_subnet.*.id[count.index]
  route_table_id = aws_route_table.public_route.id
}

