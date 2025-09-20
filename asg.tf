resource "aws_autoscaling_group" "app_asg" {
  name              = "${var.resource_prefix}-asg"
  desired_capacity  = 2
  min_size          = 2
  max_size          = 6
  health_check_type = "EC2"
  vpc_zone_identifier = [
    module.vpc_nfw.subnets["sub3-private-us-east-1a"].id,
    module.vpc_nfw.subnets["sub4-private-us-east-1b"].id
  ]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.asg_tg.arn]

  tag {
    key                 = "Name"
    value               = "${var.resource_prefix}-asg"
    propagate_at_launch = true
  }
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.resource_prefix}-lt"
  image_id      = data.aws_ami.rhel.id
  instance_type = var.ec2_instance_type
  key_name      = var.key_name

  vpc_security_group_ids = [module.asg_sg.id]
  iam_instance_profile {
    name = aws_iam_instance_profile.asg_profile.name
  }

  block_device_mappings {
    device_name = "/dev/sda1"
    ebs {
      volume_size = 20
      volume_type = "gp3"
      encrypted   = true
    }
  }
  user_data = filebase64("${path.module}/userdata/asg_apache_ssl_setup.sh")
}

module "asg_sg" {
  source         = "git::https://github.com/Coalfire-CF/terraform-aws-securitygroup.git?ref=v1.0.2"
  name           = "${var.resource_prefix}-asg-sg"
  sg_name_prefix = "${var.resource_prefix}-asg-"
  vpc_id         = module.vpc_nfw.vpc_id
  ingress_rules = {
    https = {
      from_port                    = 443
      to_port                      = 443
      ip_protocol                  = "tcp"
      referenced_security_group_id = module.alb_sg.id
    }
  }
  egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}
