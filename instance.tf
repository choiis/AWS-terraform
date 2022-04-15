resource "aws_instance" "ec2_bastion_ubuntu" {
  ami = "ami-0ed11f3863410c386"
  instance_type = "t2.micro"
  tags = {
        Name = "bastion ubuntu"
  }
  key_name = "terraform_key"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.public_security.id]
}

resource "aws_instance" "ec2_private_aws_linux" {
  ami = "ami-02de72c5dc79358c9"
  instance_type = "t2.micro"
  tags = {
        Name = "aws linux server private"
  }
  key_name = "terraform_key"
  subnet_id = aws_subnet.private_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.private_security.id]
}

resource "aws_instance" "ec2_private_redhat" {
  ami = "ami-0eb218869d3d2d7e7"
  instance_type = "t2.micro"
  tags = {
        Name = "redhat server private"
  }
  key_name = "terraform_key"
  subnet_id = aws_subnet.private_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.private_security.id]
}
