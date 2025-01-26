terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=5.16.0"
}
include "root" {
  path = find_in_parent_folders()
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}
locals {
  name = "prod"
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
  public_subnets = ["10.0.2.0/24", "10.0.3.0/24"]
  cidr_block = "10.0.0.0/16"
  k8s_cluster_name = include.env.locals.k8s_cluster_name
  tags = {
    Terraform   = "true"
    Environment = include.env.locals.environment
    Name        = local.name
  }
}

inputs = {
  name                          = local.name
  cidr                          = local.cidr_block
  azs                           = ["${include.env.locals.region}a", "${include.env.locals.region}b", "${include.env.locals.region}c"]
  enable_nat_gateway            = true
  single_nat_gateway            = true
  enable_dns_hostnames          = true
  enable_dns_support            = true
  manage_default_security_group = false
  map_public_ip_on_launch       = false
  private_subnets               = local.private_subnets
  private_subnet_tags = {
    Name                                                           = "${local.name}-private_subnet"
    "kubernetes.io/role/internal-elb"                              = "1"
    "kubernetes.io/cluster/${local.k8s_cluster_name}" = "owned"
    "karpenter.sh/discovery"                                       = local.k8s_cluster_name
  }
  public_subnets = local.public_subnets
  public_subnet_tags = {
    Name                                                           = "${local.name}-public_subnet"
    "kubernetes.io/role/elb"                                       = "1"
    "kubernetes.io/cluster/${local.k8s_cluster_name}" = "owned"

  }
  tags = local.tags
}