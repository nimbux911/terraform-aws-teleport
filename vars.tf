// Region is AWS region, the region should support EFS
variable "region" {
  type = string
}

// Teleport cluster name to set up
variable "cluster_name" {
  type = string
}

// AMI name to use
variable "ami_name" {
  type = string
}

// DNS and Let's Encrypt integration variables
// Zone name to host DNS record, e.g. example.com
variable "route53_zone" {
  type = string
}

// Domain name to use for Teleport proxy,
// e.g. proxy.example.com
variable "route53_domain" {
  type = string
}

// Whether to add a wildcard entry *.proxy.example.com for application access
variable "add_wildcard_route53_record" {
  type = bool
}

// whether to enable the mongodb listener
// adds security group setting, maps load balancer to port, and adds to teleport config
variable "enable_mongodb_listener" {
  type    = bool
  default = false
}

// whether to enable the mysql listener
// adds security group setting, maps load balancer to port, and adds to teleport config
variable "enable_mysql_listener" {
  type    = bool
  default = false
}

// whether to enable the postgres listener
// adds security group setting, maps load balancer to port, and adds to teleport config
variable "enable_postgres_listener" {
  type    = bool
  default = false
}

// S3 Bucket to create for encrypted Let's Encrypt certificates
variable "s3_bucket_name" {
  type = string
}

// Email for Let's Encrypt domain registration
variable "email" {
  type = string
}

// Whether to use Let's Encrypt-issued certificates
variable "use_letsencrypt" {
  type = bool
}

// Whether to use Amazon-issued certificates via ACM or not
// This must be set to true for any use of ACM whatsoever, regardless of whether Terraform generates/approves the cert
variable "use_acm" {
  type = bool
}

// CIDR blocks allowed to connect to the SSH port
variable "allowed_ssh_ingress_cidr_blocks" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

// CIDR blocks allowed for ingress for all Teleport ports
variable "allowed_ingress_cidr_blocks" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

// CIDR blocks allowed for egress from Teleport
variable "allowed_egress_cidr_blocks" {
  type    = list(any)
  default = ["0.0.0.0/0"]
}

variable "kms_alias_name" {
  type    = string
  default = "alias/aws/ssm"
}

// Instance type for cluster
variable "cluster_instance_type" {
  type    = string
  default = "t3.nano"
}

variable "environment" {
  
}

variable "subnet_id" {
    type = string
}

variable "subnets_ids" {
    type = list(string)
}

variable "vpc_id" {
    type = string
}

variable "certificate_arn" {
    description = "ACM certificate for Load Balancer"
    type        = string
}