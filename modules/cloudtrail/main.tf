resource "random_id" "suffix" {
  byte_length = 4
}

# Get the current AWS account ID for use in CloudTrail S3 bucket policy
data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "trail_bucket" {
  bucket = "${var.environment}-cloudtrail-logs-${var.product_name}-${random_id.suffix.hex}"

  force_destroy = true

  tags = {
    Name = "${var.environment}-cloudtrail-logs-${var.product_name}"
  }
}

resource "aws_s3_bucket_policy" "cloudtrail" {
  bucket = aws_s3_bucket.trail_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSCloudTrailAclCheck20150319",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::${aws_s3_bucket.trail_bucket.bucket}"
      },
      {
        Sid       = "AWSCloudTrailWrite20150319",
        Effect    = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.trail_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_cloudtrail" "this" {
  name                          = "cloudtrail"
  s3_bucket_name                = aws_s3_bucket.trail_bucket.id
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  enable_logging                = true

  event_selector {
    read_write_type           = "All"
    include_management_events = true

    data_resource {
      type   = "AWS::S3::Object"
      values = ["arn:aws:s3:::"]

      # Optional: If you want to add more resources
    }
  }

  depends_on = [aws_s3_bucket.trail_bucket]
}
