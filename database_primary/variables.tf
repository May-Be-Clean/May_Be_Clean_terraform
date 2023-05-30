variable "environment" {
  type        = string
  description = "Name of this environment"
}

variable "project_name" {
  type        = string
  description = "Name Of this project"
}

variable "region" {
  type        = string
  description = "Region of the AWS services"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID used by this environment"
}

variable "private_cidr" {
  type        = list(string)
  description = "CIDR used by private subnet of this environment"
}

variable "database_accessible_cidr" {
  type        = list(string)
  description = "CIDR that can access to database"
}

variable "database_engine" {
  type        = string
  description = "Backend database configuration"
}

variable "database_dbname" {
  type        = string
  description = "Backend database configuration"
}

variable "database_port" {
  type        = string
  description = "Backend database configuration"
}

variable "tunnel_instance_ip" {
  type        = string
  description = "Ip of instance used by ssh tunneling"
}
