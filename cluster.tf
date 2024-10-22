module "ecs_cluster" {
  source = "terraform-aws-modules/ecs/aws//modules/cluster"

  cluster_name                          = local.name
  default_capacity_provider_use_fargate = false
  # Capacity provider - autoscaling group (ASG)
  autoscaling_capacity_providers = {
    ex_1 = {
      auto_scaling_group_arn         = module.autoscaling.autoscaling_group_arn
      managed_termination_protection = "DISABLED"

      managed_scaling = {
        maximum_scaling_step_size = 1
        minimum_scaling_step_size = 1
        status                    = "ENABLED"
        target_capacity           = 100
      }

      default_capacity_provider_strategy = {
        weight = 100
        base   = 1
      }
    }
  }
  tags = local.tags
}
