module "autoscaling_sg" { #port 80 at ASG EC2 from ALB-sg
  source = "terraform-aws-modules/security-group/aws"

  name        = "${local.name}-lb-asg-ec2-http"
  description = "Autoscaling group security group"
  vpc_id      = module.vpc.vpc_id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "http-80-tcp"
      source_security_group_id = module.alb.security_group_id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
  egress_rules                                             = ["all-all"]
  tags                                                     = local.tags
}

resource "aws_security_group" "rds" {
  name        = "${local.name}_inbound_rds_from_ecs"
  description = "Allow MySQL inbound traffic at RDS from ECS svc"
  vpc_id      = module.vpc.vpc_id
}

resource "aws_security_group" "ecs" {
  name        = "${local.name}_outboud_ecs_to_rds"
  description = "Allow MySQL outbound traffic at ECS svc to RDS"
  vpc_id      = module.vpc.vpc_id
}

module "rds_inbound_from_ecs" { #inbound mysql at RDS from ECS-sg
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = aws_security_group.rds.id
  computed_ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = aws_security_group.ecs.id
    }
  ]
  number_of_computed_ingress_with_source_security_group_id = 1
}

module "ecs_outbound_to_rds" { #outbound mysql at ECS to RDS-sg
  source            = "terraform-aws-modules/security-group/aws"
  create_sg         = false
  security_group_id = aws_security_group.ecs.id
  computed_egress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = aws_security_group.rds.id
    }
  ]
  number_of_computed_egress_with_source_security_group_id = 1
}
