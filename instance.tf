resource "aws_instance" "ec2_one" {
  ami = "ami-0ed11f3863410c386"
  instance_type = "t2.micro"
  tags = {
        Name = "ubuntu server"
  }
  key_name = "terraform_key"
  associate_public_ip_address = true
  subnet_id = aws_subnet.public_subnet_1a.id
  vpc_security_group_ids = [aws_security_group.terra_security.id]
}
