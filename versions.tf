terraform {
  required_version = ">= 0.13.0, < 0.14.0"

  required_providers {
    local  = "~> 1.2"
    random = "~> 2.2"
    aws    = ">= 2.0, < 4.0"
  }
}
