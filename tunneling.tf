resource "aws_instance" "tunneling" {
  iam_instance_profile        = aws_iam_instance_profile.tunneling.name
  subnet_id                   = aws_subnet.tunnel.id
  associate_public_ip_address = true
  availability_zone           = local.availability_zone_a
  instance_type               = "t2.nano"
  ami                         = local.tunneling_ami
  tags = {
    Name = local.tunneling_name
  }
}

resource "aws_iam_instance_profile" "tunneling" {
  name = local.tunneling_name
  role = aws_iam_role.tunneling.name
}

resource "aws_iam_role" "tunneling" {
  assume_role_policy = data.aws_iam_policy_document.tunneling_assume.json

  inline_policy {
    name   = "SSM"
    policy = data.aws_iam_policy.ssm.policy
  }
}

data "aws_iam_policy" "ssm" {
  arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_subnet" "tunnel" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.tunneling_cidr_block
  availability_zone = local.availability_zone_a

  tags = {
    Name = local.tunneling_name
  }
}

resource "aws_route_table" "tunneling" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = local.tunneling_name
  }
}

resource "aws_route_table_association" "tunneling" {
  route_table_id = aws_route_table.tunneling.id
  subnet_id      = aws_subnet.tunnel.id
}
