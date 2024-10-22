variable "aws_region" {
  description = "AWS region"
  type        = string
  # default     = "us-west-2"
}

variable "vpc_cidr_block" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_count" {
  description = "no. of subnets to launch"
  type        = number
  default     = 3
}

variable "container_port" {
  description = "Container port to be exposed and mapped to host"
  type        = number
  default     = 80
}

variable "resource_tags" {
  description = "Deployment Environment (prod, dev, test, sandbox, etc.)"
  type        = map(string)
  default = {
    Terraform = "true",
    Name      = "mountains",
    Env       = "dev"
  }

  # Load balancer names must be no more than 32 characters long, and can only contain a limited set of characters.
  validation {
    condition     = length(var.resource_tags["Name"]) <= 16 && length(regexall("[^a-zA-Z0-9-]", var.resource_tags["Name"])) == 0
    error_message = "The project tag must be no more than 16 characters, and only contain letters, numbers, and hyphens."
  }

  validation {
    condition     = length(var.resource_tags["Env"]) <= 8 && length(regexall("[^a-zA-Z0-9-]", var.resource_tags["Env"])) == 0
    error_message = "The environment tag must be no more than 8 characters, and only contain letters, numbers, and hyphens."
  }
}

variable "db_username" {
  description = "RDS DB User name"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "RDS DB User password"
  type        = string
  sensitive   = true
}

variable "db_database" {
  description = "RDS default database for application"
  type        = string
  sensitive   = true
}
