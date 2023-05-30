terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = " ~> 4.0"
    }
  }

  #  backend "s3" {
  #    # Note that terraform doesn't support variable that can be applied to the terraform.backend.s3.*
  #    bucket         = "may-be-clean"
  #    key            = "may-be-clean"
  #    region         = "ap-northeast-2"
  #    dynamodb_table = "may-be-clean-tf"
  #    profile = "hwangonjang"
  #  }
}

provider "aws" {
  region  = local.region
  profile = "hwangonjang"
}