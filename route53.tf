/*
Route53 is used to configure SSL for this cluster. A
Route53 hosted zone must exist in the AWS account for
this automation to work.
*/

// Create A record to instance IP
resource "aws_route53_record" "cluster_ip" {
  count   = var.use_acm ? 0 : 1
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = var.route53_domain
  type    = "A"
  ttl     = 300
  records = [aws_instance.cluster.public_ip]
}

// Create alias record to load balancer 
resource "aws_route53_record" "proxy_acm" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = var.route53_domain
  type    = "A"
  count   = var.use_acm ? 1 : 0

  alias {
    name                   = module.alb_teleport[0].lb_dns_name
    zone_id                = module.alb_teleport[0].lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cluster_ip_wildcard" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "*.${var.route53_domain}"
  type    = "A"
  count   = var.add_wildcard_route53_record && !var.use_acm ? 1 : 0

  alias {
    name                   = module.alb_teleport[0].lb_dns_name
    zone_id                = module.alb_teleport[0].lb_zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "cluster_alb_wildcard" {
  zone_id = data.aws_route53_zone.cluster.zone_id
  name    = "*.${var.route53_domain}"
  type    = "A"
  count   = var.add_wildcard_route53_record && var.use_acm ? 1 : 0

  alias {
    name                   = module.alb_teleport[0].lb_dns_name
    zone_id                = module.alb_teleport[0].lb_zone_id
    evaluate_target_health = true
  }
}