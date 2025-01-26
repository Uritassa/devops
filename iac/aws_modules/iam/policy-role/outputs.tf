
output "policy_arn" {
  description = "ARN of the created IAM policy"
  value       = var.create_policy ? aws_iam_policy.this[0].arn : null
}

output "role_arn" {
  description = "ARN of the created IAM role"
  value       = var.create_role ? aws_iam_role.this[0].name : null
}