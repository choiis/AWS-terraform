
variable "root_domain_name" {
  description = "Root domain name for Route53 Hosted Zone"
  type        = string
  default     = "insung-terraform.com"
}

resource "aws_route53_zone" "main" {
  name = var.root_domain_name

  tags = {
    Name = var.root_domain_name
  }
}

resource "aws_route53_record" "nlb_alias" {
  zone_id = aws_route53_zone.main.zone_id

  # "api" 라고 쓰면 Route53이 "api.insung-terraform.com" 으로 만듦
  name = "api"
  type = "A"

  alias {
    name                   = aws_lb.app_nlb.dns_name
    zone_id                = aws_lb.app_nlb.zone_id
    evaluate_target_health = true
  }
}
