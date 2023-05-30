resource "aws_vpc" "main" {
  cidr_block = local.vpc_cidr_block
  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = local.internet_gateway_name
  }
}

resource "aws_eip" "nat-a" {
  tags = {
    Name = "${local.common_project_name}-eip-nat-gateway-a"
  }
}

resource "aws_eip" "nat-c" {
  tags = {
    Name = "${local.common_project_name}-eip-nat-gateway-c"
  }
}

resource "aws_subnet" "public-a" {
  cidr_block        = local.public_a_cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_a
  tags = {
    Name = "${local.common_project_name}-subnet-public-a"
  }
}

resource "aws_subnet" "public-c" {
  cidr_block        = local.public_c_cidr_block
  vpc_id            = aws_vpc.main.id
  availability_zone = local.availability_zone_c
  tags = {
    Name = "${local.common_project_name}-subnet-public-c"
  }
}

resource "aws_nat_gateway" "public-a" {
  allocation_id     = aws_eip.nat-a.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-a.id
  tags = {
    Name = local.nat_gateway_a_name
  }
}

resource "aws_nat_gateway" "public-c" {
  allocation_id     = aws_eip.nat-c.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-c.id
  tags = {
    Name = local.nat_gateway_c_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = local.route_table_name
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "public-a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-a.id
}

resource "aws_route_table_association" "public-c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public-c.id
}