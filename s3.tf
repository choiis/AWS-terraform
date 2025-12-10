
variable "cdn_s3_bucket" {
  description = "S3 with CloudFront"
  type        = string
  default     = "insung-terraform-static-bucket"
}

resource "aws_s3_bucket" "s3_controller" {
  bucket        = var.cdn_s3_bucket
  force_destroy = true  
  tags = {
    Name = "static-site-bucket"
  }
}

resource "aws_s3_bucket_ownership_controls" "s3_controller" {
  bucket = aws_s3_bucket.s3_controller.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# Block all public access (we will allow only CloudFront via OAC)
resource "aws_s3_bucket_public_access_block" "s3_controller" {
  bucket = aws_s3_bucket.s3_controller.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
