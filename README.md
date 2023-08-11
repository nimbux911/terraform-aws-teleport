# AWS Teleport Terraform module

Terraform module which creates a Teleport EC2 instance in AWS. You have two options to deploy this:

- Using ACM. This will create an Application Load Balancer in which you could attach the correct ACM.
- Using Let's Encrypt. This will point directly to the EC2 instance.

## Usage

#### Terraform required version >= 0.14.8

## OpenVPN Service

```hcl
module "teleport" {
    source                      = "github.com/nimbux911/terraform-aws-teleport.git?ref=main"
    region                      = "us-east-1"
    vpc_id                      = "vpc-04fdf81f6998d2d48"
    subnet_id                   = "subnet-01a3f5a6b3231570f"
    subnets_ids                 = ["subnet-01a3f5a6b3231570f", "subnet-03310ccc0e2c89072", "subnet-02acbaf7116d9c1a9"]
    environment                 = "ops"
    cluster_name                = "teleport"
    ami_name                    = "gravitational-teleport-ami-oss-13.3.0"
    route53_zone                = "ops.example.com.ar"
    route53_domain              = "teleport.ops.example.com.ar"
    add_wildcard_route53_record = true
    enable_mongodb_listener     = true 
    enable_mysql_listener       = true 
    enable_postgres_listener    = true
    s3_bucket_name              = "ops-teleport-assets"
    email                       = "john.doe@test.com"
    use_letsencrypt             = false
    use_acm                     = true
    certificate_arn             = "arn:aws:acm:REGION:ACCOUNTID:certificate/abcd4b19-6819-acbd-8e43-erty9fd6cfd2"
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| region | AWS region where instance will be deployed | `string` | `""` | yes |
| vpc\_id | VPC ID where OpenVPN will be deployed. | `string` | `""` | yes |
| subnet\_id | Public subnet id from the designed VPC. | `string` | `""` | yes |
| subnet\_ids | Public subnet ids from the designed VPC. | `list[string]` | `[]` | yes |
| environment | Environment name of the resources. | `string` | `""` | yes |
| cluster\_name | Name of the cluster. | `string` | `""` | yes |
| ami\_name | AMI name to use for the Teleport EC2 instance. | `string` | `""` | yes |
| route53\_zone | Name of the route53 zone where the EC2 instance will be deployed. | `string` | `""` | yes |
| route53\_domain | Name that will be used to the route53 record. | `string` | `""` | yes |
| add\_wildcard\_route53\_record | Choose to create wildward for the route53 record | `string` | `""` | yes |
| enable\_mongodb\_listener | Enable adding MongoDB listeners in Teleport proxy, load balancer ports, and security groups. | `string` | `""` | yes |
| enable\_postgres\_listener | Enable adding Postgres listeners in Teleport proxy, load balancer ports, and security groups. | `string` | `""` | yes |
| s3\_bucket\_name | Bucket name to store encrypted Let's Encrypt certificates. | `string` | `""` | yes |
| email | Email to be used for Let's Encrypt certificate registration process. | `string` | `""` | yes |
| use\_letsencrypt | Set to true to use Let's Encrypt to provision certificates | `string` | `""` | yes |
| use\_acm | Set to true to use ACM certificate | `string` | `""` | yes |
| certificate\_arn | ACM arn to be used in the application load balancer | `string` | `""` | when "use_acm" is in true |

## Outputs

| Name | Description |
|------|-------------|
| security\_group\_id | The ID of the security group. |