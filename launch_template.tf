resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = "ami-02de72c5dc79358c9"   # aws linux AMI (기존 ec2_private_aws_linux)
  instance_type = "t2.micro"

  key_name = "terraform_key"

  vpc_security_group_ids = [
    aws_security_group.private_security.id
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app-auto-ec2"
      Role = "app"
    }
  }

}