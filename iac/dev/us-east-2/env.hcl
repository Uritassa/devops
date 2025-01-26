locals {
  environment = "dev"
  region = "us-east-2"
  k8s_cluster_name = "myproject_development"
  account_id = get_env("ACCOUNT_ID")
  org_github_token = get_env("ORG_GITHUB_TOKEN")
  argocd_password = get_env("ARGOCD_PASSWORD")
  hosted_zone = "873JFGSHS102PHD"
}