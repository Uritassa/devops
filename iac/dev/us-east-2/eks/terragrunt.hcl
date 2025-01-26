terraform {
  source = "tfr:///terraform-aws-modules/eks/aws?version=20.29.0"
}
include "root" {
  path = find_in_parent_folders()
}
include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}
dependency "vpc" {
  config_path = "../vpc"
}
locals {

  k8s_cluster_name = "${include.env.locals.k8s_cluster_name}"
  k8s_version = "1.30"
  kms_admins = "arn:aws:iam::${include.env.locals.account_id}:role/github-actions"
  uri = "arn:aws:iam::${include.env.locals.account_id}:user/Uri"
  github_actions_role = "arn:aws:iam::${include.env.locals.account_id}:role/github-actions"
  karpenter_node_policy = "arn:aws:iam::${include.env.locals.account_id}:policy/eks-node-policy-${include.env.locals.environment}"
  tags = {
    Terraform   = "true"
    "Environment" = include.env.locals.environment
    "Name" = local.k8s_cluster_name
  }
}

inputs = {
  cluster_name                   = local.k8s_cluster_name
  cluster_version                = local.k8s_version
  cluster_endpoint_public_access = true
  subnet_ids                     = dependency.vpc.outputs.private_subnets
  enable_irsa                    = true
  vpc_id                         = dependency.vpc.outputs.vpc_id
  cluster_addons = {
    aws-ebs-csi-driver = {
      most_recent = true
    }
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent = true
    }
    eks-pod-identity-agent = {
      most_recent = true
    }
  }
  create_cloudwatch_log_group = false
  /// kms encryption ///
  create_kms_key                   = true
  attach_cluster_encryption_policy = true
  kms_key_administrators           = [local.kms_admins]
  /// EKS manage node group ///
  node_security_group_tags = {
    "karpenter.sh/discovery" = local.k8s_cluster_name
  }
  eks_managed_node_groups = {
    eks-node = {
      iam_role_additional_policies = {
        node_policy = local.karpenter_node_policy
      }
      capacity_type  = "SPOT"
      instance_types = ["t3.medium"]
      desired_size   = 1
      min_size       = 1
      max_size       = 10
      tags = {
        Name = "eks-${local.k8s_cluster_name}-node"
      }
    }
  }
  /// access entry ///
  enable_cluster_creator_admin_permissions = true
  authentication_mode                      = "API"
  access_entries = {
    cluster-admin = {
      principal_arn = local.uri
      policy_associations = {
        cluster-policy = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }
  tags = local.tags
}

