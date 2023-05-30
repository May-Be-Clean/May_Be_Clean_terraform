data "aws_route53_zone" "root" {
  name = local.root_domain
}