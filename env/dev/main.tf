terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " ~> 4.0"
    }
  }

  backend "s3" {
    # Note that terraform doesn't support variable that can be applied to the terraform.backend.s3.*
    bucket         = "${local.common_project_name}-bucket"
    key            = "${local.common_project_name}-key" # FIXME: 권장사항: smart-doctor-${local.project_name}
    region         = "ap-northeast-2"
    dynamodb_table = "${local.common_project_name}-tf"
    profile        = local.common_project_name
  }
}

provider "aws" {
  region  = "ap-northeast-2"
  profile = "hwangonjang"
}

module "develop" {
  source = ""

  # prj
  project_name = var.project_name
  environment  = var.environment
  key_name     = var.key_name

  # VPC
  cidr_vpc      = var.cidr_vpc
  cidr_public1  = var.cidr_public1

  # Public EC2
  public_ami           = var.public_ami
  public_instance_type = var.public_instance_type
  public_key_name      = var.public_key_name
  public_volume_size   = var.public_volume_size
}