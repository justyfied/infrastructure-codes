locals {
  tags = merge(var.tags, {
    Project = var.project
    Stack   = "security"
  })
}

# Read management remote state to get org/account ids
data "terraform_remote_state" "management" {
  backend = "s3"
  config = {
    bucket         = var.tf_state_bucket
    key            = "stacks/management/terraform.tfstate"
    region         = var.tf_state_region
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}

# GuardDuty delegated admin = Security account
resource "aws_guardduty_organization_admin_account" "delegated" {
  provider         = aws.mgmt
  admin_account_id = data.terraform_remote_state.management.outputs.account_ids["security"]
}

# Security Hub delegated admin = Security account
resource "aws_securityhub_organization_admin_account" "delegated" {
  provider         = aws.mgmt
  admin_account_id = data.terraform_remote_state.management.outputs.account_ids["security"]
}


module "securityhub" {
  providers = { aws = aws.sec }
  source    = "../../modules/securityhub-org-config"

  auto_enable = var.securityhub_auto_enable
  tags        = local.tags

  depends_on = [aws_securityhub_organization_admin_account.delegated]
}


module "securityhub_agg" {
  providers = { aws = aws.sec }
  source    = "../../modules/securityhub-aggregation"
  linking_mode = "ALL_REGIONS"
  tags = local.tags
  depends_on = [module.securityhub_org]
}

module "securityhub_members" {
  providers = { aws = aws.sec }
  source    = "../../modules/securityhub-member-enroll"

  members = var.member_accounts
  tags    = local.tags

  depends_on = [module.securityhub]
}



module "guardduty" {
  providers = { aws = aws.sec }
  source    = "../../modules/guardduty-org-config"

  auto_enable = var.guardduty_auto_enable
  tags        = local.tags

  depends_on = [aws_guardduty_organization_admin_account.delegated]
}

module "guardduty_members" {
  providers = { aws = aws.sec }
  source    = "../../modules/guardduty-member-enroll"

  detector_id = module.guardduty.detector_id
  members     = var.member_accounts
  tags        = local.tags

  depends_on = [module.guardduty]
}




##Accept GuardDuty Invite
resource "aws_guardduty_detector" "this" {
  #provider = aws.prod
  enable   = true
  tags     = local.tags
}

resource "aws_guardduty_invite_accepter" "this" {
  #provider          = aws.prod
  detector_id       = aws_guardduty_detector.this.id
  master_account_id = var.security_account_id

  depends_on = [module.guardduty_members]
}


# Slack alerts for Security Hub findings (HIGH/CRITICAL)
module "securityhub_slack" {
  providers = { aws = aws.sec }
  source    = "../../modules/securityhub-alerting-slack"

  name              = "${var.project}-securityhub-slack"
  slack_webhook_url = var.slack_webhook_url
  severity_labels   = ["HIGH", "CRITICAL"]
  slack_channel     = "#security-alerts"
  tags              = local.tags

  depends_on = [module.securityhub_org]
}

output "security_account_id" { value = var.security_account_id }