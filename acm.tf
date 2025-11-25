variable "nlb_record_fqdn" {
  description = "Full domain name for NLB/ACM"
  type        = string
  default     = "api.insung-terraform.com"
}

resource "aws_acm_certificate" "nlb_cert" {
  domain_name       = var.nlb_record_fqdn
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "nlb-cert-${var.nlb_record_fqdn}"
  }
}

resource "aws_route53_record" "nlb_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.nlb_cert.domain_validation_options :
    dvo.domain_name => {
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      record = dvo.resource_record_value
    }
  }

  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 60
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "nlb_cert" {
  certificate_arn         = aws_acm_certificate.nlb_cert.arn
  validation_record_fqdns = [for r in aws_route53_record.nlb_cert_validation : r.fqdn]
}
