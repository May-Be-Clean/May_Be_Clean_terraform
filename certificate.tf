#resource "aws_acm_certificate" "backend" {
#  domain_name       = "*.${aws_route53_zone.backend.name}"
#  validation_method = "DNS"
#}
#
#resource "aws_route53_record" "backend_each" {
#  for_each = {
#    for dvo in aws_acm_certificate.backend.domain_validation_options : dvo.domain_name => {
#      name   = dvo.resource_record_name
#      type   = dvo.resource_record_type
#      record = dvo.resource_record_value
#    }
#  }
#
#  allow_overwrite = true
#  name            = each.value.name
#  records         = [each.value.record]
#  ttl             = 60
#  type            = each.value.type
#  zone_id         = aws_route53_zone.backend.zone_id
#}
#
#resource "aws_acm_certificate_validation" "backend" {
#  certificate_arn         = aws_acm_certificate.backend.arn
#  validation_record_fqdns = [for record in aws_route53_record.backend_each : record.fqdn]
#}
