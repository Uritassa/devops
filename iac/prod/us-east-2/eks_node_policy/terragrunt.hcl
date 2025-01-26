terraform {
  source = "../../../../../aws_modules/iam/policy-role"
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
  name = "eks-node-policy-${include.env.locals.environment}"
  region1 = "us-east-1"
  region2 = "us-east-2"
  tags = {
    Terraform = true
    Environment = include.env.locals.environment
    Name        = local.name
  }
}

inputs = {
  create_policy      = true
  create_role        = false
  policy_name        = local.name
  policy_description = "Custom IAM policy for ${local.name}"
  policy_document    = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetAuthorizationToken",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "ec2:DescribeVolumes",
        "ec2:DescribeVolumeStatus",
        "ec2:DescribeTags",
        "ec2:AttachVolume",
        "ec2:AssociateAddress",
        "ec2:DisassociateAddress",
        "ec2:DescribeAddresses",
        "ec2:DetachVolume",
        "ec2:DescribeAvailabilityZones",
        "ec2:CreateSnapshot",
        "ec2:DeleteSnapshot",
        "ec2:DescribeSnapshots",
        "ec2:DescribeSnapshotAttribute",
        "ec2:ModifySnapshotAttribute"
      ],
      "Resource": [
        "arn:aws:ec2:${local.region1}:${include.env.locals.account_id}:volume/*",
        "arn:aws:ec2:${local.region1}:${include.env.locals.account_id}:snapshot/*",
        "arn:aws:ec2:${local.region2}:${include.env.locals.account_id}:volume/*",
        "arn:aws:ec2:${local.region2}:${include.env.locals.account_id}:snapshot/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "kms:GenerateDataKey",
        "kms:Decrypt"
      ],
      "Resource": [
        "arn:aws:kms:${local.region1}:${include.env.locals.account_id}:key/*",
        "arn:aws:kms:${local.region2}:${include.env.locals.account_id}:key/*"
      ]
    }
  ]
}
EOF

  policy_tag = local.tags
}