provider "aws" {
  version             = "~> 2.0"
  region              = var.aws_region
  assume_role {
    role_arn = var.aws_assume_role_arn
  }
}
