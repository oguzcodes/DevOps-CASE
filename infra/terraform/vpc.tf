data "aws_availability_zones" "available" {}

locals {
  name     = "mern-case-vpc"
  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = local.name
  cidr = local.vpc_cidr

  azs                  = local.azs
  # Sadece Public Subnet kullanıyoruz (NAT Gateway maliyetinden kaçınmak için)
  public_subnets       = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  
  enable_nat_gateway   = false
  single_nat_gateway   = false
  enable_dns_hostnames = true

  # Worker node'ların dışarı çıkabilmesi ve ALB Ingress'in çalışabilmesi için şart
  map_public_ip_on_launch = true

  public_subnet_tags = {
    "kubernetes.io/cluster/mern-case-cluster" = "shared"
    "kubernetes.io/role/elb"                  = 1
  }
}