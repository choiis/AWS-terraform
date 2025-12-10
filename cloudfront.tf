
resource "aws_cloudfront_origin_access_control" "s3_cloudfront_control" {
  name                              = "static-s3-oac"
  description                       = "OAC for S3 static bucket"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  enabled             = true
  comment             = "CloudFront distribution for static S3 bucket"
  default_root_object = "index.html"

  origin {
    domain_name              = aws_s3_bucket.s3_controller.bucket_regional_domain_name
    origin_id                = "s3-static-origin"
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_cloudfront_control.id
  }

  default_cache_behavior {
    target_origin_id       = "s3-static-origin"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]

    compress = true

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  tags = {
    Name = "s3-static-cloudfront"
  }
}

resource "aws_s3_bucket_policy" "s3_controller_policy" {
  bucket = aws_s3_bucket.s3_controller.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "AllowCloudFrontRead"
        Effect    = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action = [
          "s3:GetObject"
        ]
        Resource = "${aws_s3_bucket.s3_controller.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = aws_cloudfront_distribution.s3_distribution.arn
          }
        }
      }
    ]
  })
}
