// network acl public subnets
resource "aws_network_acl" "public_net_acl" {
  vpc_id = aws_vpc.vpc.id
  subnet_ids = [
    aws_subnet.public_subnet_1a.id,
    aws_subnet.public_subnet_1b.id
  ]

}

resource "aws_network_acl_rule" "public_ingress80" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 100
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "public_egress80" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 100
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "public_ingress443" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "public_egress443" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 110
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}

resource "aws_network_acl_rule" "public_ingress22" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 120
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 22
  to_port = 22
}

resource "aws_network_acl_rule" "public_egress22" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 120
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = aws_vpc.vpc.cidr_block
  from_port = 22
  to_port = 22
}

resource "aws_network_acl_rule" "public_ingress_ephemeral" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 140
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "public_egress_ephemeral" {
  network_acl_id = aws_network_acl.public_net_acl.id
  rule_number = 140
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

// network acl private subnets
resource "aws_network_acl" "private_net_acl" {
  vpc_id      = aws_vpc.vpc.id
  subnet_ids = [
    aws_subnet.private_subnet_1a.id
  ]

}

resource "aws_network_acl_rule" "private_ingress_vpc" {
  network_acl_id = aws_network_acl.private_net_acl.id
  rule_number = 100
  rule_action = "allow"
  egress = false
  protocol = -1
  cidr_block = aws_vpc.vpc.cidr_block
  from_port = 0
  to_port = 0
}

resource "aws_network_acl_rule" "private_net_acl_egress_vpc" {
  network_acl_id = aws_network_acl.private_net_acl.id
  rule_number = 100
  rule_action = "allow"
  egress = true
  protocol = -1
  cidr_block = aws_vpc.vpc.cidr_block
  from_port = 0
  to_port = 0
}

resource "aws_network_acl_rule" "private_net_acl_ingress_nat" {
  network_acl_id = aws_network_acl.private_net_acl.id
  rule_number = 110
  rule_action = "allow"
  egress = false
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 1024
  to_port = 65535
}

resource "aws_network_acl_rule" "private_net_acl_egress80" {
  network_acl_id = aws_network_acl.private_net_acl.id
  rule_number = 120
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 80
  to_port = 80
}

resource "aws_network_acl_rule" "private_net_acl_egress443" {
  network_acl_id = aws_network_acl.private_net_acl.id
  rule_number = 130
  rule_action = "allow"
  egress = true
  protocol = "tcp"
  cidr_block = "0.0.0.0/0"
  from_port = 443
  to_port = 443
}