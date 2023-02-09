resource "aws_route53_zone" "frontend" {
  name = local.frontend_domain
}

resource "aws_route53_zone" "backend" {
  name = local.backend_domain
}

# root -> subdomain propagation
#resource "aws_route53_record" "frontend" {
#  name    = aws_route53_zone.frontend.name
#  type    = "NS"
#  zone_id = data.aws_route53_zone.root.zone_id
#  ttl     = 172800
#  records = aws_route53_zone.frontend.name_servers
#}

# frontend subdomain -> backend subdomain propagation
resource "aws_route53_record" "backend" {
  name    = aws_route53_zone.backend.name
  type    = "NS"
  zone_id = aws_route53_zone.frontend.zone_id
  ttl     = 172800
  records = aws_route53_zone.backend.name_servers
}
