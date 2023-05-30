module "database_primary_develop" {
  source = "./database_primary"

  environment     = "develop" # FIXME
  project_name    = local.common_project_name
  database_engine = local.database_engine
  database_dbname = local.database_dbname
  database_port   = local.database_port
  database_accessible_cidr = local.server_api_develop_cidr_block
  region             = local.region
  vpc_id             = aws_vpc.main.id
  private_cidr       = local.database_primary_develop_cidr_block
  tunnel_instance_ip = aws_instance.tunneling.private_ip
}