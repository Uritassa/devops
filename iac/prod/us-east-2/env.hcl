locals {
  environment = "prod"
  region = "us-east-2"
  k8s_cluster_name = "myproject_production"
  account_id = get_env("ACCOUNT_ID")
  org_github_token = get_env("ORG_GITHUB_TOKEN")
  argocd_password = get_env("ARGOCD_PASSWORD")
  hosted_zone = "FDSFS434A89CU"
}