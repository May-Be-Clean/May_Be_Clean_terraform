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