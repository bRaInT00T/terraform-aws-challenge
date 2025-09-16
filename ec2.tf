module "ec2" {
  source = "git::https://github.com/Coalfire-CF/terraform-aws-ec2.git?ref=main"

  name              = var.instance_name
  ami               = data.aws_ami.rhel.id
  ec2_instance_type = var.ec2_instance_type
  instance_count    = 1

  vpc_id     = module.vpc_nfw.vpc_id
  subnet_ids = [module.vpc_nfw.subnets["sub2-public-us-east-1b"].id]

  ec2_key_pair = var.key_name
  global_tags  = local.internal_tags

  ebs_kms_key_arn  = module.kms.kms_key_arn
  root_volume_size = var.instance_volume_size

  ebs_optimized = false

  iam_profile = aws_iam_instance_profile.ec2_logging_profile.name

  user_data                  = file("${path.module}/userdata/ec2_apache_setup.sh")
  associate_public_ip        = true
  additional_security_groups = [module.ec2_sg.id]
}

module "ec2_sg" {
  source         = "git::https://github.com/Coalfire-CF/terraform-aws-securitygroup.git?ref=v1.0.2"
  name           = "${var.resource_prefix}-ec2-sg"
  sg_name_prefix = "${var.resource_prefix}-ec2-"
  vpc_id         = module.vpc_nfw.vpc_id
  ingress_rules = {
    allow_ssh = {
      from_port   = 22
      to_port     = 22
      ip_protocol = "tcp"
      cidr_ipv4   = var.ssh_cidr
    }
  }
}

