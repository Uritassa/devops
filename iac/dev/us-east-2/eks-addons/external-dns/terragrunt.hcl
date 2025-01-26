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
  name                          = "eks-external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = include.env.locals.hosted_zone
  association_defaults = {
    namespace       = "kube-system"
    service_account = "external-dns"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}