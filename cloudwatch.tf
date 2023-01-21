resource "aws_cloudwatch_log_group" "terraform" {
  name = "terraform"
  retention_in_days = 14
  tags = {
    Environment = "dev"
  }
}