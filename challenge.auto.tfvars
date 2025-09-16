# AWS CLI profile
profile = "default"

# CLI profile & region
aws_region      = "us-east-1"
resource_prefix = "cf-challenge-nwolk-202509"


# deploy_aws_nfw = true

# EC2
instance_name        = "rhel_sub2_stand_alone"
instance_volume_size = "20"
ec2_instance_type    = "t2.micro"

# VPC settings
vpc_cidr = "10.1.0.0/16"
# mgmt_vpc_cidr = "10.1.0.0/16"

# 4 subnets spread evenly across two AZs
# sub1 & sub2: public (internet accessible)
# sub3 & sub4: private (no direct internet)
subnets = [
  {
    custom_name       = "sub1-public-us-east-1a"
    cidr              = "10.1.0.0/24"
    type              = "public"
    availability_zone = "us-east-1a"
  },
  {
    custom_name       = "sub2-public-us-east-1b"
    cidr              = "10.1.1.0/24"
    type              = "public"
    availability_zone = "us-east-1b"
  },
  {
    custom_name       = "sub3-private-us-east-1a"
    cidr              = "10.1.2.0/24"
    type              = "private"
    availability_zone = "us-east-1a"
  },
  {
    custom_name       = "sub4-private-us-east-1b"
    cidr              = "10.1.3.0/24"
    type              = "private"
    availability_zone = "us-east-1b"
  }
]

# Enable AWS Network Firewall
deploy_aws_nfw = true

key_name = "cf_key"