locals {
  tags = merge(var.tags, {
    Project = var.project
    Stack   = "management"
  })
}

# STEP 1
module "org" {
  source   = "../../modules/organizations"
  ous      = var.ous
  accounts = var.accounts
  tags     = local.tags
}

# Read outputs from log-archive stack (once it exists).
# This removes copy/paste and keeps stacks loosely coupled.
data "terraform_remote_state" "log_archive" {
  backend = "s3"
  config = {
    bucket         = var.tf_state_bucket
    key            = "stacks/log-archive/terraform.tfstate"
    region         = var.tf_state_region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


# Optional: enable GuardDuty delegated admin (Security account)

module "guardduty_org" {
  source = "../../modules/guardduty-org-config"

  #delegated_admin_account_id = module.org.account_ids["security"]
  tags = local.tags
}

# Create org CloudTrail only after you have log bucket + kms
# Create org trail only if log-archive state exists.
# When log-archive hasn't been applied yet, this data source will fail.
# So: apply management once to create accounts, then apply log-archive, then apply management again.
module "org_trail" {
  source = "../../modules/org-cloudtrail"

  trail_name     = "${var.project}-org-trail"
  s3_bucket_name = data.terraform_remote_state.log_archive.outputs.log_bucket_name
  s3_key_prefix  = "cloudtrail"
  kms_key_id     = data.terraform_remote_state.log_archive.outputs.log_kms_key_arn
  tags           = local.tags
}