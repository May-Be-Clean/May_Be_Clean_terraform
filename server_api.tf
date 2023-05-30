module "server_api_develop" {
  source = "./server_api"

  environment                         = "develop"
  project_name                        = local.common_project_name
  backend_domain                      = aws_route53_zone.server_api.name
  backend_port                        = local.backend_port
  region                              = local.region
  vpc_id                              = aws_vpc.main.id
  public-subnet-ids                   = [aws_subnet.public-a.id, aws_subnet.public-c.id]
  private_cidr                        = local.server_api_develop_cidr_block # FIXME
  nat-a-id                            = aws_nat_gateway.public-a.id
  nat-c-id                            = aws_nat_gateway.public-c.id
  backend_route53_zone_id             = aws_route53_zone.server_api.zone_id
  application_name                    = aws_elastic_beanstalk_application.server_api.name
  deployment_policy                   = "RollingWithAdditionalBatch"
  certificate_arn                     = aws_acm_certificate_validation.server_api.certificate_arn
  web_instance_profile                = aws_iam_instance_profile.elastic_beanstalk_instance.name
  backend_instance                    = "t2.small"
  load_balancer_auto_scaling_min_size = "1"
  load_balancer_auto_scaling_max_size = "2"
  load_balancer_health_check_path     = local.load_balancer_health_check_path
  tunnel_instance_ip                  = aws_instance.tunneling.private_ip
}