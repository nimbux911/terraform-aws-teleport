// Application load balancer for proxy server web interface (using ACM)
module "security_group_public_alb" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.16.2"

  name        = "${var.environment}-public-alb"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["https-443-tcp", "http-80-tcp"]
  egress_rules        = ["all-all"]
}

module "alb_teleport" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.2.0"

  name               = "${var.environment}-${var.cluster_name}-public"
  vpc_id             = var.vpc_id
  internal           = false
  subnets            = var.subnets_ids
  load_balancer_type = "application"
  security_groups    = [module.security_group_public_alb.security_group_id]
  enable_cross_zone_load_balancing = true
  count              = var.use_acm ? 1 : 0

  target_groups = [
    {
      name             = "${var.environment}-teleport-public"
      backend_protocol = "HTTPS"
      backend_port     = 3080
      target_type      = "instance"
      targets = {
        my_target = {
          target_id = aws_instance.cluster.id
        }
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/web/login"
        port                = "traffic-port"
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTPS"
        matcher             = "200,404"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  ]

  https_listeners = [
    {
      certificate_arn    = var.certificate_arn
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
    }
  ]
}