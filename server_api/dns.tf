data "aws_elastic_beanstalk_hosted_zone" "current" {}

resource "aws_route53_record" "record" {
  name    = "${var.environment}.${var.backend_domain}"
  type    = "A"
  zone_id = var.backend_route53_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_elastic_beanstalk_environment.api.cname
    zone_id                = data.aws_elastic_beanstalk_hosted_zone.current.id
  }
}

resource "aws_route53_health_check" "backend_root" {
  fqdn              = "${var.environment}.${var.backend_domain}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/"
  failure_threshold = "3"
  request_interval  = "30"

  tags = {
    Name = "${var.project_name}-api-${var.environment}"
  }
}
