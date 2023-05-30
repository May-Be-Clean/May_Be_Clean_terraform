locals {
  common_project_name = "may-be-clean"

  # Domain name
  root_domain    = "maybeclean.link"
  backend_domain = "api.${local.root_domain}" # FIXME
  backend_port   = 8080

  # CIDR blocks
  vpc_cidr_block       = "10.0.0.0/16"
  public_a_cidr_block  = "10.0.0.0/24"
  public_c_cidr_block  = "10.0.1.0/24"
  tunneling_cidr_block = "10.0.2.0/24"

  # Main VPC
  vpc_name              = "${local.common_project_name}-vpc"
  internet_gateway_name = "${local.common_project_name}-internet-gateway"
  route_table_name      = "${local.common_project_name}-route-table"
  nat_gateway_a_name    = "${local.common_project_name}-nat-gateway-a"
  nat_gateway_c_name    = "${local.common_project_name}-nat-gateway-c"

  # CIDR blocks
  server_api_develop_cidr_block       = ["10.0.4.0/24", "10.0.5.0/24"]
  database_primary_develop_cidr_block = ["10.0.8.0/24", "10.0.9.0/24"]

  # AWS base configuration
  region              = "ap-northeast-2"
  availability_zone_a = "${local.region}a"
  availability_zone_c = "${local.region}c"
  account_id          = "admin"
  profile             = "hwangonjang"

  # SSH tunneling
  tunneling_name = "${local.common_project_name}-ssh-tunneling"
  tunneling_ami  = "ami-0e4a9ad2eb120e054"

  # Environment configurations
  database_engine = "mysql"
  database_dbname = replace(local.common_project_name, "-", "_")
  database_port   = "3306"
  cache_port      = 6379


  # Health check
  load_balancer_health_check_path = "/"
}
