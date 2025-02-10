terraform { 
  source = "../../../../../modules/iam/policy-role" 
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
  create_policy = true 
  create_role = false 
  policy_name        = "kube-cert-acm"
  policy_description = "Custom IAM policy for cert-acm" 
  policy_document = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Action": "sts:AssumeRole",
          "Effect": "Allow",
          "Resource": "*",
          "Sid": ""
      },
      {
          "Action": "acm:ListCertificates",
          "Effect": "Allow",
          "Resource": "*",
          "Sid": ""
      },
      {
          "Action": [
              "acm:UpdateCertificateOptions",
              "acm:ListTagsForCertificate",
              "acm:ImportCertificate",
              "acm:GetCertificate",
              "acm:ExportCertificate",
              "acm:DescribeCertificate",
              "acm:AddTagsToCertificate"
          ],
          "Effect": "Allow",
          "Resource": "arn:aws:acm:${include.env.locals.region}:${include.env.locals.account_id}:certificate/*",
          "Sid": ""
      }
  ]
}
EOF

  policy_tag = { 
    Environment = include.env.locals.environment
    Terraform = "true" 
  } 
}