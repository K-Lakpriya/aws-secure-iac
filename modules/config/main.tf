resource "random_id" "config_suffix" {
  byte_length = 4
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "config_bucket" {
  bucket = "${var.environment}-aws-config-${var.product_name}-${random_id.config_suffix.hex}"

  force_destroy = true

  tags = {
    Name = "${var.environment}-aws-config-bucket-${var.product_name}"
  }
}

resource "aws_s3_bucket_policy" "config" {
  bucket = aws_s3_bucket.config_bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSConfigBucketPermissionsCheck",
        Effect    = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action   = "s3:GetBucketAcl",
        Resource = "arn:aws:s3:::${aws_s3_bucket.config_bucket.bucket}"
      },
      {
        Sid       = "AWSConfigBucketDelivery",
        Effect    = "Allow",
        Principal = {
          Service = "config.amazonaws.com"
        },
        Action   = "s3:PutObject",
        Resource = "arn:aws:s3:::${aws_s3_bucket.config_bucket.bucket}/AWSLogs/${data.aws_caller_identity.current.account_id}/*",
        Condition = {
          StringEquals = {
            "s3:x-amz-acl" = "bucket-owner-full-control"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role" "config_role" {
  name = "${var.environment}-aws-config-role-${var.product_name}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "config.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# resource "aws_iam_role_policy_attachment" "config_attach" {
#   role       = aws_iam_role.config_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
# }

resource "aws_iam_role_policy" "config_inline_policy" {
  name = "${var.environment}-aws-config-inline-policy-${var.product_name}"
  role = aws_iam_role.config_role.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect   = "Allow",
        Action   = [
          "s3:PutObject",
          "s3:GetBucketAcl",
          "config:Put*",
          "config:Get*",
          "config:Describe*"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_config_configuration_recorder" "this" {
  name     = "default"
  role_arn = aws_iam_role.config_role.arn

  recording_group {
    all_supported = true
    include_global_resource_types = true
  }
}

resource "aws_config_delivery_channel" "this" {
  name           = "default"
  s3_bucket_name = aws_s3_bucket.config_bucket.bucket

  depends_on = [aws_config_configuration_recorder.this]
}

resource "aws_config_config_rule" "s3_bucket_public_read_prohibited" {
  name = "${var.environment}-s3-bucket-public-read-prohibited-${var.product_name}"

  source {
    owner             = "AWS"
    source_identifier = "S3_BUCKET_PUBLIC_READ_PROHIBITED"
  }

  depends_on = [
    aws_config_configuration_recorder.this,
    aws_config_delivery_channel.this
  ]
}

resource "aws_config_config_rule" "ec2_instance_no_public_ip" {
  name = "${var.environment}-ec2-instance-no-public-ip-${var.product_name}"

  source {
    owner             = "AWS"
    source_identifier = "EC2_INSTANCE_NO_PUBLIC_IP"
  }

  depends_on = [
    aws_config_configuration_recorder.this,
    aws_config_delivery_channel.this
  ]
}
