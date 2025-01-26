
resource "aws_iam_policy" "this" {
  count       = var.create_policy ? 1 : 0
  name        = var.policy_name
  description = var.policy_description
  policy      = var.policy_document
  tags        = var.policy_tags
}

resource "aws_iam_role" "this" {
  count               = var.create_role ? 1 : 0
  name                = var.role_name
  assume_role_policy  = var.assume_role_policy != null ? var.assume_role_policy : jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
  tags = var.role_tags
}

resource "aws_iam_role_policy_attachment" "this" {
  count      = var.create_policy && var.create_role ? 1 : 0
  policy_arn = aws_iam_policy.this[0].arn
  role       = aws_iam_role.this[0].name
}