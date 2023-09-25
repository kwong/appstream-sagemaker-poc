data "aws_region" "current" {}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.vpc_name
  cidr = var.vpc_cidr
  azs  = var.vpc_azs

  enable_nat_gateway = true
  public_subnets     = var.public_subnets
  private_subnets    = var.private_subnets

}

# s3 gateway

resource "aws_vpc_endpoint" "s3" {
  vpc_id            = module.vpc.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "s3_vpce_route_table_association" {
  route_table_id  = module.vpc.private_route_table_ids[0].id
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}


# vpc endpoints

resource "aws_vpc_endpoint" "interface_endpoints" {
  for_each = toset([
    "com.amazonaws.${data.aws_region.current.name}.sagemaker.api",
    "com.amazonaws.${data.aws_region.current.name}.sagemaker.runtime",
    "com.amazonaws.${data.aws_region.current.name}.sagemaker.featurestore-runtime",
    "com.amazonaws.${data.aws_region.current.name}.servicecatalog"
  ])

  vpc_id              = module.vpc.vpc_id
  service_name        = each.key
  vpc_endpoint_type   = "Interface"
  subnet_ids          = module.vpc.private_subnets
  private_dns_enabled = true

  security_group_ids = [
    aws_security_group.vpc_endpoint_sg.id
  ]
}

# SGs


resource "aws_security_group" "sagemaker_sg" {
  name        = "sagemaker_sg"
  description = "Allow certain NFS and TCP inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "NFS traffic over TCP on port 2049 between the domain and EFS volume"
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    self        = true
  }

  ingress {
    description = "TCP traffic between JupyterServer app and the KernelGateway apps"
    from_port   = 8192
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "SageMaker sg"
  }
}

resource "aws_security_group" "vpc_endpoint_sg" {
  name        = "vpc_endpoint_sg"
  description = "Allow incoming connections on port 443 from VPC"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Allow incoming connections on port 443 from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "VPC endpoint sg"
  }
}

