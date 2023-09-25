data "aws_caller_identity" "current" {}

resource "aws_sagemaker_domain" "main" {
  domain_name = var.sagemaker_domain_name
  auth_mode   = var.sagemaker_auth_mode
  vpc_id      = module.vpc.vpc_id
  subnet_ids  = module.vpc.private_subnets

  default_user_settings {
    execution_role = aws_iam_role.default_sagemaker.arn
  }

  default_space_settings {
    execution_role = aws_iam_role.default_sagemaker.arn
  }
}


resource "aws_iam_role" "default_sagemaker" {
  name = "default-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      },
    ]
  })
}


# kms

resource "aws_kms_key" "sagemaker_efs_kms_key" {
  description         = "KMS key for encrypting Studio EFS volume"
  enable_key_rotation = true
}

resource "aws_kms_key_policy" "sagemaker_efs_kms_key_policy" {
  key_id = aws_kms_key.sagemaker_efs_kms_key.key_id
  policy = jsonencode({
    Id = "sagemaker-efs-kms-key"
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = [data.aws_caller_identity.current.account_id]
        }

        Resource = "*"
        Sid      = "Allow KMS Operations"
      },
    ]
    Version = "2012-10-17"
  })
}
