module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name               = "${var.resource_prefix}-alb"
  load_balancer_type = "application"

  vpc_id                     = module.vpc_nfw.vpc_id
  subnets                    = [for s in var.subnets : module.vpc_nfw.subnets[s.custom_name].id if s.type == "public"]
  security_groups            = [module.alb_sg.id]
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "asg_tg" {
  name        = "${var.resource_prefix}-asg-tg"
  port        = 443
  protocol    = "HTTPS"
  vpc_id      = module.vpc_nfw.vpc_id
  target_type = "instance"

  health_check {
    path     = "/"
    protocol = "HTTPS"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = module.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.asg_tg.arn
  }
}

module "alb_sg" {
  source         = "git::https://github.com/Coalfire-CF/terraform-aws-securitygroup.git?ref=v1.0.2"
  name           = "${var.resource_prefix}-alb-sg"
  sg_name_prefix = "${var.resource_prefix}-alb-"
  vpc_id         = module.vpc_nfw.vpc_id
  ingress_rules = {
    http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  egress_rules = {
    https = {
      ip_protocol = "-1"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
}