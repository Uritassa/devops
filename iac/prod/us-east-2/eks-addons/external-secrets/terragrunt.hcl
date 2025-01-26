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
  external_secrets_kms_key_arns = ["arn:aws:kms:${include.env.locals.region}:${include.env.locals.account_id}:key/*"]
}

inputs = {
  name                                  = "eks-external-secrets"
  attach_external_secrets_policy        = true
  external_secrets_create_permission    = true
  external_secrets_secrets_manager_arns = ["arn:aws:secretsmanager:${include.env.locals.region}:${include.env.locals.account_id}:secret:*"]
  external_secrets_kms_key_arns         = local.external_secrets_kms_key_arns
  association_defaults = {
    namespace       = "kube-system"
    service_account = "external-secrets"
  }
  associations = {
    cluster = {
      cluster_name = include.env.locals.k8s_cluster_name
    }
  }
}