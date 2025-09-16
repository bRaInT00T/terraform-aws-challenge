data "aws_instance" "standalone" {
  count       = length(module.ec2.instance_id) > 0 ? 1 : 0
  instance_id = module.ec2.instance_id[0]
}


data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "rhel" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL-9.*_HVM-*x86_64*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["309956199498"] # Red Hat's official AWS account
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "ebs_kms_policy" {
  statement {
    sid       = "source-account-full-access"
    effect    = "Allow"
    actions   = ["kms:*"]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }

  statement {
    sid    = "target-account-allow-grant"
    effect = "Allow"
    actions = [
      "kms:CreateGrant",
      "kms:DescribeKey",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }
  }
  statement {
    sid    = "allow-ec2-roles-use-ebs-key"
    effect = "Allow"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.asg_role.arn,
        aws_iam_role.ec2_logging_role.arn
      ]
    }
  }
}