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
  kms_arn = ["arn:aws:kms:${include.env.locals.region}:${include.env.locals.account_id}:key/*"]
}

inputs = {
  name                          = "ebs-csi-controller"
  attach_aws_ebs_csi_policy = true
  aws_ebs_csi_kms_arns      = local.kms_arn
  association_defaults = {
    namespace       = "kube-system"
    service_account = "ebs-csi-controller-sa"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}