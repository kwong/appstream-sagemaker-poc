region          = "ap-southeast-1"
vpc_azs         = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
vpc_name        = "kw-test-vpc"
vpc_cidr        = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]


# appstream

app_name = "kw-test-app"


# sagemaker
sagemaker_domain_name = "kw-sagemaker-domain"
sagemaker_auth_mode   = "IAM"
