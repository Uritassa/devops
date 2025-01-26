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
  name                          = "eks-cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = include.env.locals.hosted_zone
  association_defaults = {
    namespace       = "kube-system"
    service_account = "cert-manager"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}