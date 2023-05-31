resource "aws_security_group" "database" {
  name_prefix = local.name_prefix
  vpc_id      = var.vpc_id

  ingress {
    from_port = var.database_port
    to_port   = var.database_port
    protocol  = "tcp"
    cidr_blocks = concat(
      var.database_accessible_cidr,
      var.private_cidr,
      ["${var.tunnel_instance_ip}/32"],
    )
  }

  tags = {
    Name = local.name_prefix
  }
}
