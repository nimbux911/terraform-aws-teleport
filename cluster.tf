resource "aws_key_pair" "this" {
  key_name   = "${var.environment}-teleport"
  public_key = base64decode(aws_ssm_parameter.public_key.value)
}

resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_ssm_parameter" "public_key" {
  name  = "${var.environment}-teleport-public-ssh-key"
  type  = "SecureString"
  value = base64encode(tls_private_key.this.public_key_openssh)
}

resource "aws_ssm_parameter" "private_key" {
  name  = "${var.environment}-teleport-private-ssh-key"
  type  = "SecureString"
  tier  = "Advanced"
  value = base64encode(tls_private_key.this.private_key_pem)
}


// Auth, node, proxy (aka Teleport Cluster) on single AWS instance
resource "aws_instance" "cluster" {
  key_name                    = aws_key_pair.this.key_name
  ami                         = data.aws_ami.base.id
  instance_type               = var.cluster_instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.cluster.id]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_role.cluster.id

  user_data = templatefile(
    "${path.module}/data.tpl",
    {
      region                   = var.region
      cluster_name             = var.cluster_name
      email                    = var.email
      domain_name              = var.route53_domain
      dynamo_table_name        = aws_dynamodb_table.teleport.name
      dynamo_events_table_name = aws_dynamodb_table.teleport_events.name
      locks_table_name         = aws_dynamodb_table.teleport_locks.name
      s3_bucket                = var.s3_bucket_name
      enable_mongodb_listener  = var.enable_mongodb_listener
      enable_mysql_listener    = var.enable_mysql_listener
      enable_postgres_listener = var.enable_postgres_listener
      use_acm                  = var.use_acm
      use_letsencrypt          = var.use_letsencrypt
    }
  )

  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "${var.environment}-teleport"
  }
}