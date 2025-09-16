resource "aws_iam_policy" "ec2_write_logs" {
  name        = "${var.resource_prefix}-ec2-write-logs"
  description = "Allow EC2s to write to Logs bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject", "s3:PutObjectAcl"]
        Resource = "arn:aws:s3:::${module.s3_logs.id}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "standalone_attach_write_logs" {
  role       = aws_iam_role.ec2_logging_role.name
  policy_arn = aws_iam_policy.ec2_write_logs.arn
}

resource "aws_iam_role_policy_attachment" "asg_attach_write_logs" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.ec2_write_logs.arn
}

# IAM role, policy, and instance profile for EC2 logging to VPC flow log S3 bucket
resource "aws_iam_role" "ec2_logging_role" {
  name = "${var.resource_prefix}-ec2-logging-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "ec2_logging_policy" {
  name        = "${var.resource_prefix}-ec2-logging-policy"
  description = "Policy to allow EC2s to write logs to S3 log bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${module.s3_logs.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_logging_attach" {
  role       = aws_iam_role.ec2_logging_role.name
  policy_arn = aws_iam_policy.ec2_logging_policy.arn
}

resource "aws_iam_instance_profile" "ec2_logging_profile" {
  name = "${var.resource_prefix}-ec2-logging-profile"
  role = aws_iam_role.ec2_logging_role.name
}

resource "aws_iam_role" "asg_role" {
  name = "${var.resource_prefix}-asg-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "asg_read_images" {
  name = "${var.resource_prefix}-asg-read-images"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:GetObject"]
        Resource = "${module.s3_images.arn}/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "asg_attach_read_images" {
  role       = aws_iam_role.asg_role.name
  policy_arn = aws_iam_policy.asg_read_images.arn
}

resource "aws_iam_instance_profile" "asg_profile" {
  name = "${var.resource_prefix}-asg-profile"
  role = aws_iam_role.asg_role.name
}
