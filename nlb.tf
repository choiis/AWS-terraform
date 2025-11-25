
resource "aws_lb" "app_nlb" {
  name               = "app-nlb"
  load_balancer_type = "network"
  internal           = false

  subnets = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1b.id
  ]

  enable_deletion_protection = false

  tags = {
    Name = "app-nlb"
  }
}


resource "aws_lb_target_group" "app_nlb_tg" {
  name        = "app-nlb-tg-80"
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.vpc.id

  health_check {
    protocol            = "TCP"
    port                = "traffic-port"
    healthy_threshold   = 3
    unhealthy_threshold = 3
    interval            = 30
  }

  tags = {
    Name = "app-nlb-tg-80"
  }
}


resource "aws_lb_listener" "nlb_80" {
  load_balancer_arn = aws_lb.app_nlb.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  }
}

resource "aws_lb_listener" "nlb_tls_443" {
  load_balancer_arn = aws_lb.app_nlb.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"

  certificate_arn = aws_acm_certificate_validation.nlb_cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  }
}

resource "aws_lb_listener" "nlb_8080" {
  load_balancer_arn = aws_lb.app_nlb.arn
  port              = 8080
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  }
}

resource "aws_lb_target_group_attachment" "nlb_attach_aws_linux" {
  target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  target_id        = aws_instance.ec2_private_aws_linux.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "nlb_attach_redhat" {
  target_group_arn = aws_lb_target_group.app_nlb_tg.arn
  target_id        = aws_instance.ec2_private_redhat.id
  port             = 80
}
