module "kms" {
  source                = "git::https://github.com/Coalfire-CF/terraform-aws-kms.git?ref=v1.1.1"
  resource_prefix       = var.resource_prefix
  kms_key_resource_type = "ebs"
  key_policy            = data.aws_iam_policy_document.ebs_kms_policy.json
}