variable "profile" {
  description = "The AWS profile aligned with the AWS environment to deploy to"
  type        = string
}

variable "resource_prefix" {
  description = "A prefix that should be attached to the names of resources"
  type        = string
}

variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR range of the VPC"
  type        = string
}

# variable "cidrs_for_remote_access" {
#   description = "List of IPv4 CIDR ranges to access all admins remote access"
#   type        = list(string)
# }

variable "delete_protection" {
  description = "Whether or not to enable deletion protection of NFW"
  type        = bool
  default     = true
}

variable "deploy_aws_nfw" {
  description = "enable nfw true/false"
  type        = bool
  default     = false
}

variable "create_vpc_endpoints" {
  description = "enable vpc endpoints true/false"
  type        = bool
  default     = false
}

variable "ec2_instance_type" {
  description = "The size of the instance"
  type        = string
}

variable "instance_name" {
  description = "The name of the instance"
  type        = string
}

variable "instance_volume_size" {
  description = "The size of the instance volume"
  type        = string
}

# variable "subnets" {
#   type = list(object({
#     cidr              = string
#     type              = string
#     availability_zone = string
#   }))
# }

variable "key_name" {
  description = "The name of the key pair"
  type        = string
}

# variable "ebs_kms_key_arn" {
#   description = "The ARN of the KMS key to use for EBS encryption"
#   type        = string
# }

variable "subnets" {
  description = "Subnet definitions per Coalfire module schema"
  type = list(object({
    tag               = optional(string)
    cidr              = string
    type              = string # 'public' or 'private'
    availability_zone = string
    custom_name       = optional(string)
  }))
}

variable "ssh_cidr" {
  description = "CIDR block allowed to access SSH"
  type        = string
}