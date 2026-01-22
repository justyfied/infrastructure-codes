terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = ">= 5.0" }
  }
}

# Base provider uses management credentials
provider "aws" {
  alias   = "mgmt"
  region  = var.region
  profile = var.management_profile

  assume_role {
    role_arn = "arn:aws:iam::${var.log_archive_account_id}:role/${var.org_access_role_name}"
  }
}
