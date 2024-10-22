data "aws_availability_zones" "available" {}

locals {
  region         = var.aws_region
  name           = "${var.resource_tags.Name}-${var.resource_tags.Env}"
  vpc_cidr       = var.vpc_cidr_block
  azs            = slice(data.aws_availability_zones.available.names, 0, var.vpc_subnets_count)
  container_name = "mntain" #module.alb.target_groups.name_prefix has to be six chars max
  container_port = var.container_port
  instance_type  = "t3.micro"
  db_parameters = {
    ###############
    # SecureString
    ###############
    "db_username" = {
      type        = "SecureString"
      data_type   = "text"
      value       = var.db_username
      tier        = "Standard"
      description = "RDS DB user"
    }

    "db_password" = {
      type        = "SecureString"
      data_type   = "text"
      value       = var.db_password
      tier        = "Standard"
      description = "RDS DB user password"
    }

    "db_database" = {
      type        = "SecureString"
      data_type   = "text"
      value       = var.db_database
      tier        = "Standard"
      description = "RDS default database"
    }
  }
  tags = var.resource_tags
}
