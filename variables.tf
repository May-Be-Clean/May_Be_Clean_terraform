variable "project_name" { default = "yourssu-project" }
variable "environment" { default = "develop" }
variable "key_name" { default = "yourssu-key" }

# VPC
variable "cidr_vpc" { default = "10.0.0.0/16" }
variable "cidr_public1" { default = "10.0.0.0/24" }
variable "cidr_public2" { default = "10.0.1.0/24" }

# public
variable "public_ami" { default = "ami-0f0646a5f59758444" }
variable "public_instance_type" { default = "t2.micro" }
variable "public_key_name" { default = "yourssu-key" }
variable "public_volume_size" { default = 8 }