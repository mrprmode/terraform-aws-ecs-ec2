module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name                 = local.tags.Name
  repository_image_tag_mutability = "MUTABLE"
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })
  # Registry Scanning Configuration
  manage_registry_scanning_configuration = true
  registry_scan_type                     = "BASIC"
  repository_force_delete                = true

  tags = local.tags
}
