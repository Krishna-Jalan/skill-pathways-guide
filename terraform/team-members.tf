# IAM Users for team collaboration

# Krishna Jalan
resource "aws_iam_user" "krishna_jalan" {
  name = "krishna-jalan"
  path = "/team/"

  tags = {
    Name        = "Krishna Jalan"
    Project     = "SkillPathways"
    Role        = "Developer"
    Environment = var.environment
  }
}

resource "aws_iam_user_login_profile" "krishna_jalan" {
  user = aws_iam_user.krishna_jalan.name
}

# Hathim Mohammed
resource "aws_iam_user" "hathim_mohammed" {
  name = "hathim-mohammed"
  path = "/team/"

  tags = {
    Name        = "Hathim Mohammed"
    Project     = "SkillPathways"
    Role        = "Developer"
    Environment = var.environment
  }
}

resource "aws_iam_user_login_profile" "hathim_mohammed" {
  user = aws_iam_user.hathim_mohammed.name
}

# Developer policy - can manage S3, CloudFront, and view other resources
resource "aws_iam_policy" "developer_access" {
  name        = "skill-pathways-developer-access"
  description = "Developer access for Skill Pathways project"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "S3FullAccess"
        Effect = "Allow"
        Action = [
          "s3:*"
        ]
        Resource = [
          aws_s3_bucket.website.arn,
          "${aws_s3_bucket.website.arn}/*"
        ]
      },
      {
        Sid    = "CloudFrontManagement"
        Effect = "Allow"
        Action = [
          "cloudfront:Get*",
          "cloudfront:List*",
          "cloudfront:CreateInvalidation"
        ]
        Resource = aws_cloudfront_distribution.website.arn
      },
      {
        Sid    = "ReadOnlyAccess"
        Effect = "Allow"
        Action = [
          "cloudfront:Describe*",
          "cloudfront:Get*",
          "cloudfront:List*",
          "s3:List*",
          "s3:Get*",
          "iam:GetUser",
          "iam:GetUserPolicy",
          "iam:ListUserPolicies"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach developer policy to Krishna
resource "aws_iam_user_policy_attachment" "krishna_developer" {
  user       = aws_iam_user.krishna_jalan.name
  policy_arn = aws_iam_policy.developer_access.arn
}

# Attach developer policy to Hathim
resource "aws_iam_user_policy_attachment" "hathim_developer" {
  user       = aws_iam_user.hathim_mohammed.name
  policy_arn = aws_iam_policy.developer_access.arn
}

# Outputs for team member credentials
output "krishna_jalan_username" {
  value       = aws_iam_user.krishna_jalan.name
  description = "IAM username for Krishna Jalan"
}

output "hathim_mohammed_username" {
  value       = aws_iam_user.hathim_mohammed.name
  description = "IAM username for Hathim Mohammed"
}

output "console_login_url" {
  value       = "https://console.aws.amazon.com/"
  description = "AWS Console login URL for team members"
}
