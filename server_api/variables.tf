variable "environment" {
  type        = string
  description = "Name of this environment"
}

variable "project_name" {
  type        = string
  description = "Name Of this project"
}

variable "backend_domain" {
  type        = string
  description = "Project api domain"
}

variable "backend_port" {
  type        = number
  description = "Project api port"
}

variable "region" {
  type        = string
  description = "Region of the AWS services"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID used by this environment"
}

variable "public-subnet-ids" {
  type        = list(string)
  description = "Public subnet ids for ELB"
}

variable "private_cidr" {
  type        = list(string)
  description = "CIDR used by private subnet of this environment"
}

variable "nat-a-id" {
  type        = string
  description = "NAT ID for zone a"
}

variable "nat-c-id" {
  type        = string
  description = "NAT ID for zone c"
}

variable "backend_route53_zone_id" {
  type        = string
  description = "Project Route 53 Zone ID "
}

variable "application_name" {
  type        = string
  description = "Elastic BeanStalk application name used by this environment"
}

variable "deployment_policy" {
  type        = string
  description = "Deployment type for updating new version"
}

variable "certificate_arn" {
  type        = string
  description = "ACM ARN"
}

variable "web_instance_profile" {
  type        = string
  description = "ARN of instance profile used by ec2 instance running web server"
}

variable "tunnel_instance_ip" {
  type        = string
  description = "Ip of instance used by ssh tunneling"
}

variable "backend_instance" {
  type        = string
  description = "name of backend server instance"
}

variable "load_balancer_auto_scaling_min_size" {
  type        = string
  description = "min size of auto scaling instances"
}

variable "load_balancer_auto_scaling_max_size" {
  type        = string
  description = "max size of auto scaling instances"
}

variable "load_balancer_health_check_path" {
  type        = string
  description = "relative path to test health"
}
