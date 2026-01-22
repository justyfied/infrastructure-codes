locals {
  tags = merge(var.tags, { Stack = "log-archive" })
}

data "terraform_remote_state" "mgmt" {
  backend = "s3"
  config = {
    bucket         = var.tf_state_bucket
    key            = "stacks/management/terraform.tfstate"
    region         = var.tf_state_region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region  = var.region
  profile = var.management_profile

  assume_role {
    role_arn = "arn:aws:iam::${data.terraform_remote_state.mgmt.outputs.account_ids["log_archive"]}:role/${var.org_access_role_name}"
  }
}

module "log_bucket" {
  source = "../../modules/log-archive-bucket"

  bucket_name           = var.log_bucket_name
  org_id                = data.terraform_remote_state.mgmt.outputs.org_id
  management_account_id = var.management_account_id
  kms_alias             = "log-archive"
  tags                  = local.tags
}

