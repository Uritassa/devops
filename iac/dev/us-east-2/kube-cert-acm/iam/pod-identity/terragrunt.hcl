terraform {
  source = "tfr:///terraform-aws-modules/eks-pod-identity/aws?version=1.4.0"
}
dependency "policy" {
  config_path = "../policy"
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
  name = "kube-cert-acm"
  additional_policy_arns = {
    "cert-acm_policy" = dependency.policy.outputs.policy_arn
  }

  association_defaults = {
    namespace       = "tools"
    service_account = "kube-cert-acm"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
  tags = {
    Environment = include.env.locals.environment
  }
}