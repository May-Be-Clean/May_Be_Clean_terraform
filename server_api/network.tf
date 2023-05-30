// Subnets
resource "aws_subnet" "private-a" {
  cidr_block        = var.private_cidr[0]
  vpc_id            = var.vpc_id
  availability_zone = "${var.region}a"

  tags = { Name = "${local.name_prefix}-private-a" }
}

resource "aws_subnet" "private-c" {
  cidr_block        = var.private_cidr[1]
  vpc_id            = var.vpc_id
  availability_zone = "${var.region}c"

  tags = { Name = "${local.name_prefix}-private-c" }
}

// Routing Tables
resource "aws_route_table" "private-a" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat-a-id
  }
}

resource "aws_route_table" "private-c" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat-c-id
  }
}

resource "aws_route_table_association" "private-a" {
  route_table_id = aws_route_table.private-a.id
  subnet_id      = aws_subnet.private-a.id
}

resource "aws_route_table_association" "private-c" {
  route_table_id = aws_route_table.private-c.id
  subnet_id      = aws_subnet.private-c.id
}
