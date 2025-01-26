terraform {
  source = "tfr:///terraform-aws-modules/eks/aws//modules/karpenter?version=20.30.1"
}

include "root" {
  path = find_in_parent_folders()
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}
dependency "eks" {
  config_path = "../../eks"
}

locals {
  name = "eks-karpenter-controller-${include.env.locals.environment}"
  karpenter_node_role = "eks-karpenter"
  karpenter_node_policy = "arn:aws:iam::${include.env.locals.account_id}:policy/eks-node-policy-${include.env.locals.environment}"
  tags = {
    Terraform = true
    Environment = include.env.locals.environment
    Name        = local.name
  }
}

inputs = {
  cluster_name                      = dependency.eks.outputs.cluster_name
  iam_role_use_name_prefix          = false
  node_iam_role_use_name_prefix     = false
  enable_pod_identity               = true
  create_pod_identity_association   = true
  enable_v1_permissions             = true
  iam_policy_name                   = local.name
  iam_role_name                     = local.name
  node_iam_role_name                = local.karpenter_node_role
  node_iam_role_additional_policies = {
    custom_karpenter_policy         = local.karpenter_node_policy
  } 
  tags = local.tags
}
