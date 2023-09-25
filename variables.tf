variable "vpc_name" {
  type        = string
  description = "VPC Name"
}

variable "vpc_azs" {
  type        = list(string)
  description = "VPC AZs"
}

variable "region" {
  type        = string
  description = "Region"
}

variable "private_subnets" {
  type        = list(string)
  description = "Private Subnet ranges"
}


variable "public_subnets" {
  type        = list(string)
  description = "Public Subnet ranges"
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR range"
}

variable "app_name" {
  type        = string
  description = "Appstream App Name"
}

variable "sagemaker_domain_name" {
  type        = string
  description = "Name of SageMaker Domain to create"
}

variable "sagemaker_auth_mode" {
  type        = string
  description = "SageMaker authentication mode - either IAM or SSO"
  default     = "IAM"
}
