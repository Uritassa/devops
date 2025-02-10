terraform {
  source = "tfr:///terraform-aws-modules/eks-pod-identity/aws?version=1.7.0"
}

include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path           = find_in_parent_folders("env.hcl")
  expose         = true
  merge_strategy = "no_merge"
}

inputs = {
  name                          = "aws-node"
  attach_aws_vpc_cni_policy = true
  aws_vpc_cni_enable_ipv4   = true
  association_defaults = {
    namespace       = "kube-system"
    service_account = "aws-node"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}