terraform {
  source = "tfr:///terraform-aws-modules/ecr/aws?version=2.3.0"
}
include "root" {
  path = find_in_parent_folders()
}

include "env" {
  path = find_in_parent_folders("env.hcl")
  expose = true
}

inputs = {
  repository_name  = "kube-cert-acm"
  repository_type = "private"
  repository_image_tag_mutability = "MUTABLE"
  repository_image_scan_on_push = true
  create_lifecycle_policy = false
  tags = {
    Environment = include.env.locals.environment
  }
}
