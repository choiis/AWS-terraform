
resource "aws_s3_bucket" "terraform-bucket-insung1207" {
  bucket = "terraform-bucket-insung1207"
  acl    = "public-read-write"

  tags = {
    Name        = "terraform-bucket"
    Environment = "Dev"
  }
}
