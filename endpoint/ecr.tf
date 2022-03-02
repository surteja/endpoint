resource "aws_ecr_repository" "endpoint" {
  name                 = "endpoint"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

