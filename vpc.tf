module "vpc_nfw" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-vpc-nfw.git?ref=v3.0.4"

  vpc_name                  = "${var.resource_prefix}-vpc"
  cidr                      = var.vpc_cidr
  azs                       = [data.aws_availability_zones.available.names[0], data.aws_availability_zones.available.names[1]]
  subnets                   = var.subnets
  flow_log_destination_type = "cloud-watch-logs"
  map_public_ip_on_launch   = true

  tags = {
    Project = var.resource_prefix
    Owner   = "NickWolk"
  }
}

