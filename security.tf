resource "aws_security_group" "terra_security" {
    name        = "terra_security"
    description = "security group by terraform"
    vpc_id      = aws_vpc.vpc.id

    ingress {
        from_port   = 0
        to_port     = 65535
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
