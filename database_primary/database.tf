module "database_primary" {
  source  = "terraform-aws-modules/rds-aurora/aws"
  version = "6.0.0"

  name           = local.name_prefix
  engine         = "aurora-mysql"
  engine_mode    = "serverless"
  database_name  = var.database_dbname
  engine_version = "3.02.3"

  vpc_id = var.vpc_id
  subnets = [
    aws_subnet.private-a.id,
    aws_subnet.private-c.id,
  ]
  allowed_cidr_blocks = [
    aws_subnet.private-a.cidr_block,
    aws_subnet.private-c.cidr_block,
    "121.135.170.180/32"
  ]

  scaling_configuration = {
    // Auto pause only in development environment
    auto_pause   = !local.is_main
    min_capacity = 1
    max_capacity = 2
  }

  vpc_security_group_ids = [aws_security_group.database.id]

  deletion_protection = local.is_main

  random_password_length = 32
  create_random_password = true
}