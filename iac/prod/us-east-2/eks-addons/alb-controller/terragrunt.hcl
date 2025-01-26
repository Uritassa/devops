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
locals {
  name = "eks-alb-controller-${include.env.locals.environment}"
}

inputs = {
  name                            = local.name
  attach_aws_lb_controller_policy = true
  association_defaults = {
    namespace       = "kube-system"
    service_account = "aws-load-balancer-controller"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}