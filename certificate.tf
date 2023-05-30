resource "aws_acm_certificate" "server_api" {
  domain_name       = "*.${aws_route53_zone.server_api.name}"
  validation_method = "DNS"
}

resource "aws_route53_record" "server_api_each" {
  for_each = {
    for dvo in aws_acm_certificate.server_api.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = aws_route53_zone.server_api.zone_id
}

resource "aws_acm_certificate_validation" "server_api" {
  certificate_arn         = aws_acm_certificate.server_api.arn
  validation_record_fqdns = [for record in aws_route53_record.server_api_each : record.fqdn]
}