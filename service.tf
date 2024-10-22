module "ecs_service" {
  source = "terraform-aws-modules/ecs/aws//modules/service"

  name        = "${local.name}-svc"
  cluster_arn = module.ecs_cluster.arn
  cpu         = 512
  memory      = 512

  requires_compatibilities = ["EC2"]
  capacity_provider_strategy = {
    # On-demand instances
    ex_1 = {
      capacity_provider = module.ecs_cluster.autoscaling_capacity_providers["ex_1"].name
      weight            = 1
      base              = 1
    }
  }

  # Container definition(s)
  container_definitions = {
    (local.container_name) = {
      image = "${module.ecr.repository_url}:latest"
      port_mappings = [
        {
          name          = local.container_name
          containerPort = local.container_port
          protocol      = "tcp"
        }
      ]
      environment = [
        { name = "DB_USER", value = "${module.multiple.db_username.secure_value}" },
        { name = "DB_PWD", value = "${module.multiple.db_password.secure_value}" },
        { name = "DB_HOST", value = "${aws_db_instance.mountains.address}" },
        { name = "DB_DATABASE", value = "${module.multiple.db_database.secure_value}" }
      ]

      readonly_root_filesystem = true

      enable_cloudwatch_logging              = true
      create_cloudwatch_log_group            = true
      cloudwatch_log_group_name              = "/aws/ecs/${local.name}/${local.container_name}"
      cloudwatch_log_group_retention_in_days = 7

      log_configuration = {
        logDriver = "awslogs"
      }
    }
  }

  load_balancer = {
    service = {
      target_group_arn = module.alb.target_groups["ex_ecs"].arn
      container_name   = local.container_name
      container_port   = local.container_port
    }
  }

  subnet_ids          = module.vpc.private_subnets
  security_group_name = "${local.name}-lb-to-ecs-container-port"
  security_group_rules = {
    alb_http_ingress = {
      type                     = "ingress"
      from_port                = local.container_port
      to_port                  = local.container_port
      protocol                 = "tcp"
      description              = "Service port"
      source_security_group_id = module.alb.security_group_id
    }
  }
  security_group_ids = [aws_security_group.ecs.id]

  tags = local.tags
}
