output "ec2_instance_id" {
  value = module.ec2.instance_id
}

output "vpc_id" {
  value = module.vpc_nfw.vpc_id
}

output "public_subnets" {
  value = [
    for s in var.subnets : module.vpc_nfw.subnets[s.custom_name].id
    if s.type == "public"
  ]
}

output "ebs_kms_key_arn" {
  value       = module.kms.kms_key_arn
  description = "ARN of the customer-managed KMS key for EBS encryption"
}

output "ec2_public_ip" {
  value       = try(data.aws_instance.standalone[0].public_ip, null)
  description = "Public IP of the standalone EC2 (if exists)"
}

output "ec2_public_dns" {
  value       = try(data.aws_instance.standalone[0].public_dns, null)
  description = "Public DNS of the standalone EC2 (if exists)"
}