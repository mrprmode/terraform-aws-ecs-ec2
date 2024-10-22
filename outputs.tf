output "module_alb_dns_name" {
  value = module.alb.dns_name
}

output "ecr_repo_url" {
  value = module.ecr.repository_url
}
