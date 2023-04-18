variable "region" {
  default     = "eu-west-1"
  description = "AWS Region"
  type        = string
}

variable "environment" {
  default     = "dev"
  description = "AWS Environment (used for resource tags)"
  type        = string
}

variable "deploy_id" {
  default     = "tallercicd"
  description = "Deployment unique identifier"
  type        = string
}

variable "root_domain" {
  default     = "xalcloud.com"
  description = "Root domain for website url"
  type        = string
}
