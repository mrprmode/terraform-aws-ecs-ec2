module "db_params" {
  source = "terraform-aws-modules/ssm-parameter/aws"

  for_each = local.db_parameters

  name        = try(each.value.name, each.key)
  value       = try(each.value.value, null)
  type        = try(each.value.type, null)
  description = try(each.value.description, null)
  tier        = try(each.value.tier, null)
  data_type   = try(each.value.data_type, null)
}
