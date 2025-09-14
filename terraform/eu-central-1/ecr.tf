resource "aws_ecr_repository" "swayatt_ecr_repo" {
  name                 = var.swayatt_ecr_repo_name
  image_tag_mutability = "MUTABLE"

  encryption_configuration {
    encryption_type = "KMS"
  }

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = merge(
    { "Name" = var.swayatt_ecr_repo_name },
    var.tags
  )
}