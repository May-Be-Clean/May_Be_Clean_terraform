resource "aws_route53_zone" "server_api" {
  name = local.backend_domain
}

# root -> server subdomain propagation
resource "aws_route53_record" "server_api" {
  name    = aws_route53_zone.server_api.name
  type    = "NS"
  zone_id = data.aws_route53_zone.root.zone_id
  ttl     = 172800
  records = aws_route53_zone.server_api.name_servers
}